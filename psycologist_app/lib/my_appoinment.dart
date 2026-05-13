import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:psycologist_app/view_parent.dart';
import 'package:psycologist_app/consultation.dart';
import 'package:psycologist_app/addtask.dart';
import 'package:psycologist_app/viewsubmission.dart';

class MyAppointment extends StatefulWidget {
  const MyAppointment({super.key});

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment>
    with SingleTickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;

  late TabController _tabController;

  // Colors
  final Color bgBlack = const Color(0xFF0D0D0D);
  final Color surfaceDark = const Color(0xFF1A1A1A);

  final Color primaryGreen = const Color(0xFF1DB954);
  final Color errorRed = const Color(0xFFFF5252);
  final Color accentAmber = const Color(0xFFFFB300);
  final Color paymentBlue = const Color(0xFF2196F3);
  final Color softPurple = const Color(0xFFCE93D8);

  List<Map<String, dynamic>> appointments = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) return;

      final response = await supabase
          .from('tbl_appointment')
          .select('''
            *,
            tbl_parent (
              parent_id,
              parent_name,
              parent_photo,
              parent_contact
            ),
            tbl_child (
              child_name
            )
          ''')
          .eq('psychologist_id', user.id)
          .order('appointment_date', ascending: false);

      if (mounted) {
        setState(() {
          appointments = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching appointments: $e");

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateAppointmentStatus(
      int appointmentId, int status) async {
    try {
      await supabase
          .from('tbl_appointment')
          .update({
            'appointment_status': status,
          })
          .eq('appointment_id', appointmentId);

      await fetchAppointments();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor:
                status == 2 ? errorRed : primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Text(
              _statusMessage(status),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
    }
  }

  String _statusMessage(int status) {
    switch (status) {
      case 1:
        return "Appointment Accepted";

      case 2:
        return "Appointment Rejected";

      case 3:
        return "Consultation Added";

      case 4:
        return "Consultation Fee Paid";

      default:
        return "Status Updated";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        backgroundColor: bgBlack,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Appointments",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryGreen,
          labelColor: primaryGreen,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Requests"),
            Tab(text: "History"),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryGreen,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildFilteredList("0"),
                _buildFilteredList(null),
              ],
            ),
    );
  }

  Widget _buildFilteredList(String? statusFilter) {
    final filtered = statusFilter == null
        ? appointments
        : appointments
            .where(
              (a) =>
                  a['appointment_status'].toString() ==
                  statusFilter,
            )
            .toList();

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: primaryGreen,
      onRefresh: fetchAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return _buildAppointmentCard(filtered[index]);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
      Map<String, dynamic> data) {
    final parent = data['tbl_parent'];

    final child = data['tbl_child'];

    final String status =
        data['appointment_status'].toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewParent(
                    appointmentid:
                        data['appointment_id'],
                    parentid:
                        data['parent_id'].toString(),
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[800],
              backgroundImage:
                  parent != null &&
                          parent['parent_photo'] !=
                              null
                      ? NetworkImage(
                          parent['parent_photo'])
                      : null,
              child:
                  parent == null ||
                          parent['parent_photo'] ==
                              null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                        )
                      : null,
            ),
            title: Text(
              child?['child_name'] ?? "Guest",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding:
                  const EdgeInsets.only(top: 4),
              child: Text(
                "${data['appointment_date']} • ${data['appointment_time']}",
                style: TextStyle(
                  color:
                      Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
            ),
            trailing: _getStatusChip(status),
          ),

          const Divider(
            color: Colors.white10,
            height: 1,
          ),

          _buildActionButtons(data, status),
        ],
      ),
    );
  }

  Widget _getStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case "1":
        color = primaryGreen;
        label = "Accepted";
        break;

      case "2":
        color = errorRed;
        label = "Rejected";
        break;

      case "3":
        color = accentAmber;
        label = "Consultation Added";
        break;

      case "4":
        color = paymentBlue;
        label = "Fee Paid";
        break;

      default:
        color = accentAmber;
        label = "Pending";
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.5),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      Map<String, dynamic> data,
      String status) {
    final int id = data['appointment_id'];

    // Pending
    if (status == "0") {
      return Row(
        children: [
          Expanded(
            child: _actionBtn(
              "ACCEPT",
              primaryGreen,
              Icons.check_circle_outline,
              () {
                updateAppointmentStatus(id, 1);
              },
            ),
          ),

          Container(
            width: 1,
            height: 30,
            color: Colors.white10,
          ),

          Expanded(
            child: _actionBtn(
              "REJECT",
              errorRed,
              Icons.highlight_off,
              () {
                updateAppointmentStatus(id, 2);
              },
            ),
          ),
        ],
      );
    }

    // Accepted
    if (status == "1") {
      return _actionBtn(
        "ADD CONSULTATION",
        accentAmber,
        Icons.edit_note,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Consultation(
                appointmentId: id.toString(),
              ),
            ),
          ).then((_) async {
            // Update status after consultation added
            await updateAppointmentStatus(id, 3);
          });
        },
      );
    }

    // Consultation Added
    if (status == "3") {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        child: Text(
          "Waiting for consultation fee payment",
          style: TextStyle(
            color: paymentBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    // Consultation Fee Paid
    if (status == "4") {
      return Row(
        children: [
          Expanded(
            child: _actionBtn(
              "TASK",
              primaryGreen,
              Icons.add_task,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addtask(
                      appointmentId:
                          id.toString(),
                      childName: data[
                                  'tbl_child']
                              ?['child_name'] ??
                          '',
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            width: 1,
            height: 30,
            color: Colors.white10,
          ),

          Expanded(
            child: _actionBtn(
              "SUBMISSIONS",
              softPurple,
              Icons.folder_shared,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewSubmissionPage(
                      appointmentId:
                          id.toString(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _actionBtn(
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: onTap,
      icon: Icon(
        icon,
        color: color,
        size: 18,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color:
                Colors.white.withOpacity(0.05),
          ),

          const SizedBox(height: 16),

          Text(
            "No appointments found",
            style: TextStyle(
              color:
                  Colors.white.withOpacity(0.2),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:psycologist_app/add_payment.dart';
import 'package:psycologist_app/main.dart';


class ViewParent extends StatefulWidget {
  const ViewParent({
    super.key,
    required this.appointmentid,
    required this.parentid,
  });

  final int appointmentid;
  final String parentid;

  @override
  State<ViewParent> createState() => _ViewParentState();
}

class _ViewParentState extends State<ViewParent> {
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
    // Note: previousAppointment logic is preserved but fetchAppointments 
    // handles the current viewing state.
    previousAppointment(); 
  }

  String getAppointmentStatusText(dynamic type) {
    if (type == 2 || type == "2") {
      return "Accepted";
    } else if (type == 1 || type == "1") {
      return "Rejected";
    } else {
      return "Not-Confirmed";
    }
  }

  // ---------------- UPDATE STATUS ----------------
  Future<void> updateAppointmentStatus(dynamic appointment_id, int status) async {
    try {
      await supabase
          .from('tbl_appointment')
          .update({'appointment_status': status})
          .eq('appointment_id', appointment_id);

      // Refresh data to update UI buttons
      await fetchAppointments();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == 2 ? "Appointment Accepted" : "Appointment Rejected",
            ),
            backgroundColor: status == 2 ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
    }
  }

  // ---------------- PREVIOUS APPOINTMENTS ----------------
  Future<void> previousAppointment() async {
    try {
      final response = await supabase
          .from('tbl_appointment')
          .select('''
        *,
        tbl_parent(
          parent_id,
          parent_name,
          parent_photo,
          parent_email,
          parent_contact
        ),
        tbl_child(
          child_name,
          child_dob,
          child_notes
        )
      ''').eq('parent_id', widget.parentid);

      setState(() {
        // You might want a separate list for history, but keeping your logic:
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching previous appointments: $e");
      setState(() => isLoading = false);
    }
  }

  // ---------------- CURRENT APPOINTMENT ----------------
  Future<void> fetchAppointments() async {
    try {
      final response = await supabase.from('tbl_appointment').select('''
        *,
        tbl_parent(
          parent_name,
          parent_photo,
          parent_email,
          parent_contact
        ),
        tbl_child(
          child_name,
          child_dob,
          child_notes
        )
      ''').eq('appointment_id', widget.appointmentid);

      setState(() {
        appointments = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching appointments: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = appointments.isNotEmpty ? appointments[0] : null;
    final parent = data?['tbl_parent'];
    final child = data?['tbl_child'];
    
    // Logic to determine which buttons to show
    final currentStatus = data?['appointment_status']?.toString() ?? "0";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Parent Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 95, 22),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 39, 96, 39), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ---------------- PARENT HEADER ----------------
                    SizedBox(
                      height: 130,
                      width: 410,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: parent != null && parent['parent_photo'] != null
                                  ? NetworkImage(parent['parent_photo'])
                                  : null,
                              child: parent == null || parent['parent_photo'] == null
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Text(
                                parent?['parent_name'] ?? "Parent Name",
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ---------------- CONTACT & CHILD DETAILS CARD ----------------
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white.withOpacity(0.1),
                        child: Container(
                          width: 380,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Contact Info",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Divider(color: Colors.white24),
                              Text("Email: ${parent?['parent_email'] ?? ''}",
                                  style: const TextStyle(color: Colors.white)),
                              const SizedBox(height: 10),
                              Text("Contact: ${parent?['parent_contact'] ?? ''}",
                                  style: const TextStyle(color: Colors.white)),
                              const SizedBox(height: 30),
                              const Text(
                                "Child Details",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Divider(color: Colors.white24),
                              Text("Name: ${child?['child_name'] ?? ''}",
                                  style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 8),
                              Text("DOB: ${child?['child_dob'] ?? ''}",
                                  style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 8),
                              Text("Notes: ${child?['child_notes'] ?? ''}",
                                  style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ---------------- APPOINTMENT INFO ----------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Appointment Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Divider(color: Colors.white24),
                          Text("Date: ${data?['availability_date'] ?? ''}",
                              style: const TextStyle(color: Colors.white, fontSize: 15)),
                          const SizedBox(height: 10),
                          Text("Time: ${data?['appointment_time'] ?? ''}",
                              style: const TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ---------------- CONDITIONAL BUTTONS ----------------
                 

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}
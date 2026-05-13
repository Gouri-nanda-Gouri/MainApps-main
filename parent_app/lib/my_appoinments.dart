import 'package:flutter/material.dart';
import 'package:parent_app/payment.dart';
import 'package:parent_app/viewtask.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyAppointmentParents extends StatefulWidget {
  const MyAppointmentParents({super.key});

  @override
  State<MyAppointmentParents> createState() => _MyAppointmentParentsState();
}

class _MyAppointmentParentsState extends State<MyAppointmentParents> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> appointments = [];

  bool isLoading = true;

  // Theme Colors
  static const Color darkBg = Color(0xFF0D0D0D);
  static const Color surfaceColor = Color(0xFF1A1A1A);

  static const Color accentGreen = Color(0xFF1DB954);

  static const Color paymentBlue = Color(0xFF2196F3);

  static const Color textSecondary = Color(0xFFB3B3B3);

  static const Color errorRed = Color(0xFFFF5252);

  static const Color amberColor = Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();

    fetchAppointments();
  }

  // STATUS
  // 0 -> Pending
  // 1 -> Accepted
  // 2 -> Rejected
  // 3 -> Consultation Added
  // 4 -> Consultation Fee Paid

  String getStatusText(dynamic status) {
    int s = int.tryParse(status.toString()) ?? 0;

    switch (s) {
      case 1:
        return "Accepted";

      case 2:
        return "Rejected";

      case 3:
        return "Consultation Added";

      case 4:
        return "Consultation Fee Paid";

      default:
        return "Pending";
    }
  }

  Color getStatusColor(dynamic status) {
    int s = int.tryParse(status.toString()) ?? 0;

    switch (s) {
      case 1:
        return accentGreen;

      case 2:
        return errorRed;

      case 3:
        return amberColor;

      case 4:
        return paymentBlue;

      default:
        return Colors.orangeAccent;
    }
  }

  Future<void> fetchAppointments() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) return;

      final response = await supabase
          .from('tbl_appointment')
          .select('''
      *,
      tbl_psycologist(
        psycologist_id,
        psycologist_name,
        psycologist_photo
      ),
      tbl_child(
        child_name
      ),
      tbl_consultation(
        consultation_fee
      )
    ''')
          .eq('parent_id', user.id)
          .order('appointment_date', ascending: false);
      setState(() {
        appointments = List<Map<String, dynamic>>.from(response);

        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching appointments: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "MY SESSIONS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: accentGreen))
          : appointments.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final data = appointments[index];

                final psy = data['tbl_psychologist'];

                final child = data['tbl_child'];

                final currentStatus = data['appointment_status'].toString();

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            _buildAvatar(psy),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    psy?['psycologist_name'] ?? "Psychologist",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "Child: ${child?['child_name'] ?? 'N/A'}",
                                    style: const TextStyle(
                                      color: textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _buildStatusChip(data['appointment_status']),
                          ],
                        ),
                      ),

                      _buildDetailsBar(data),

                      _buildActionButtons(data, currentStatus),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDetailsBar(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.black.withOpacity(0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoTile(Icons.calendar_today, data['appointment_date'] ?? ""),

          _buildInfoTile(Icons.access_time, data['appointment_time'] ?? ""),

          if (data['token_number'] != null)
            Text(
              "Token: ${data['token_number']}",
              style: const TextStyle(
                color: accentGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> data, String status) {
    List<Widget> actions = [];

    // Accepted
    if (status == "1") {
      actions.add(
        _bottomButton(
          "WAITING FOR CONSULTATION",
          amberColor,
          Icons.pending_actions,
          () {},
        ),
      );
    }

    if (status == "3") {
      actions.add(
        _bottomButton("PROCEED TO PAYMENT", accentGreen, Icons.payment, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentGatewayScreen(
                id: data['appointment_id'],
            amt: data['tbl_consultation'] != null &&
        data['tbl_consultation'].isNotEmpty
    ? data['tbl_consultation'][0]['consultation_fee'] ?? 0
    : 0,
              ),
            ),
          ).then((_) {
            fetchAppointments();
          });
        }),
      );
    }

    // Fee Paid
    if (status == "4") {
      actions.add(
        Column(
          children: [
            _bottomButton(
              "PAYMENT COMPLETED",
              paymentBlue,
              Icons.verified,
              () {},
            ),

            Row(
              children: [
                Expanded(
                  child: _bottomButton(
                    "MY TASKS",
                    Colors.purpleAccent,
                    Icons.assignment,
                    () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewTasksList(
                          appointmentId: data['appointment_id'],
                        ),
                      ),
                    );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(children: actions);
  }
  void _showRatingDialog(
  BuildContext context,
  String appointmentId,
  String psychologistId,
) {
  int rating = 0;

  final TextEditingController reviewController =
      TextEditingController();

  showDialog(
    context: context,

    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor:
                const Color(0xFF1A1A1A),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(24),
            ),

            child: Padding(
              padding:
                  const EdgeInsets.all(22),

              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  Container(
                    height: 75,
                    width: 75,

                    decoration: BoxDecoration(
                      color: accentGreen
                          .withOpacity(0.12),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.star_rounded,
                      color: accentGreen,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Rate Your Session",

                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Share your experience",

                    style: TextStyle(
                      color: Colors.white
                          .withOpacity(0.5),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: List.generate(
                      5,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              rating =
                                  index + 1;
                            });
                          },

                          child: Padding(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 4,
                            ),

                            child: Icon(
                              rating >
                                      index
                                  ? Icons.star
                                  : Icons
                                      .star_border,

                              color: rating >
                                      index
                                  ? Colors.amber
                                  : Colors.white
                                      .withOpacity(
                                      0.2,
                                    ),

                              size: 38,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller:
                        reviewController,

                    maxLines: 4,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      hintText:
                          "Write your review...",

                      hintStyle:
                          TextStyle(
                        color: Colors.white
                            .withOpacity(
                          0.3,
                        ),
                      ),

                      filled: true,

                      fillColor:
                          darkBg,

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),

                        borderSide:
                            BorderSide(
                          color: Colors
                              .white
                              .withOpacity(
                            0.04,
                          ),
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),

                        borderSide:
                            const BorderSide(
                          color:
                              accentGreen,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child:
                            OutlinedButton(
                          style:
                              OutlinedButton
                                  .styleFrom(
                            side:
                                BorderSide(
                              color: Colors
                                  .white
                                  .withOpacity(
                                0.08,
                              ),
                            ),

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 15,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                16,
                              ),
                            ),
                          ),

                          onPressed: () {
                            Navigator.pop(
                                context);
                          },

                          child: const Text(
                            "Cancel",

                            style: TextStyle(
                              color:
                                  Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child:
                            ElevatedButton(
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                accentGreen,

                            foregroundColor:
                                Colors.white,

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 15,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                16,
                              ),
                            ),
                          ),

                          onPressed:
                              () async {
                            if (rating ==
                                0) {
                              return;
                            }

                            await supabase
                                .from(
                                    'tbl_rating')
                                .insert({
                              'appointment_id':
                                  int.parse(
                                appointmentId,
                              ),

                              'psychologist_id':
                                  psychologistId,

                              'rating':
                                  rating,

                              'review':
                                  reviewController
                                      .text
                                      .trim(),
                            });

                            if (mounted) {
                              Navigator.pop(
                                  context);

                              ScaffoldMessenger
                                      .of(
                                          context)
                                  .showSnackBar(
                                const SnackBar(
                                  backgroundColor:
                                      accentGreen,

                                  content: Text(
                                    "Review submitted successfully",
                                  ),
                                ),
                              );
                            }
                          },

                          child: const Text(
                            "Submit",

                            style: TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

  Widget _bottomButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),

            const SizedBox(width: 8),

            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AVATAR
  Widget _buildAvatar(dynamic psy) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white10,
      backgroundImage: psy?['psycologist_photo'] != null
          ? NetworkImage(psy['psycologist_photo'])
          : null,
      child: psy?['psycologist_photo'] == null
          ? const Icon(Icons.person, color: accentGreen)
          : null,
    );
  }

  // STATUS CHIP
  Widget _buildStatusChip(dynamic status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: getStatusColor(status).withOpacity(0.5)),
      ),
      child: Text(
        getStatusText(status).toUpperCase(),
        style: TextStyle(
          color: getStatusColor(status),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: textSecondary),

        const SizedBox(width: 4),

        Text(text, style: const TextStyle(color: textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            size: 64,
            color: Colors.white.withOpacity(0.1),
          ),

          const SizedBox(height: 16),

          const Text(
            "No appointments yet",
            style: TextStyle(color: textSecondary),
          ),
        ],
      ),
    );
  }
}

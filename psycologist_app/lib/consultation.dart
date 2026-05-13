import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Consultation extends StatefulWidget {
  final String appointmentId;

  const Consultation({super.key, required this.appointmentId});

  @override
  State<Consultation> createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
  final _formKey = GlobalKey<FormState>();
  final remarksController = TextEditingController();
  final feeController = TextEditingController(); 
  DateTime? nextVisitDate;

  final supabase = Supabase.instance.client;

  // Premium Dark Theme Colors
  final Color bgBlack = const Color(0xFF0D0D0D);
  final Color surfaceDark = const Color(0xFF1A1A1A);
  final Color primaryGreen = const Color(0xFF1DB954);
  final Color textSecondary = const Color(0xFFB3B3B3);

  /// MODERN DATE FIELD (Dark Mode)
  Widget _modernDateField({
    required String label,
    required IconData icon,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryGreen),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                date == null
                    ? label
                    : DateFormat('dd MMM yyyy').format(date),
                style: TextStyle(
                  color: date == null ? textSecondary : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Usually next visit isn't in the past
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: primaryGreen,
              onPrimary: Colors.black,
              surface: surfaceDark,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => nextVisitDate = picked);
    }
  }
Future<void> saveConsultation() async {
    if (!_formKey.currentState!.validate()) return;

    if (nextVisitDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select next visit date")),
      );
      return;
    }

    try {
      // 1. Insert the Consultation record
      await supabase.from('tbl_consultation').insert({
        "consultation_remarks": remarksController.text,
        "consultation_nextdate": nextVisitDate!.toIso8601String(),
        "consultation_fee": double.parse(feeController.text),
        "consultation_status": "active",
        "appointment_id": widget.appointmentId,
        "payment_status": "pending",
      });

      // 2. Update the Appointment status to 3
      await supabase
          .from('tbl_appointment')
          .update({'appointment_status': 3})
          .eq('appointment_id', widget.appointmentId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Consultation Saved & Status Updated"),
            backgroundColor: primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // Optional: Navigate back or clear fields
        remarksController.clear();
        feeController.clear();
        setState(() => nextVisitDate = null);
        
        // If you want the previous screen to refresh, use:
        // Navigator.pop(context); 
      }
    } catch (e) {
      debugPrint("Error saving consultation: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save consultation")),
        );
      }
    }
  }

  @override
  void dispose() {
    remarksController.dispose();
    feeController.dispose();
    super.dispose();
  }

  Stream<List<Map<String, dynamic>>> getConsultations() {
    return supabase
        .from('tbl_consultation')
        .stream(primaryKey: ['consultation_id'])
        .eq('appointment_id', widget.appointmentId)
        .order('consultation_nextdate', ascending: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Consultation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// FORM CONTAINER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _modernDateField(
                      label: "Next Visit Date",
                      icon: Icons.calendar_month_rounded,
                      date: nextVisitDate,
                      onTap: pickDate,
                    ),
                    const SizedBox(height: 15),
                    _buildDarkTextField(
                      controller: feeController,
                      hint: "Consultation Fee",
                      icon: Icons.currency_rupee,
                      isNumber: true,
                    ),
                    const SizedBox(height: 15),
                    _buildDarkTextField(
                      controller: remarksController,
                      hint: "Doctor remarks...",
                      icon: Icons.edit_note_rounded,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: saveConsultation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        child: const Text(
                          "SAVE CONSULTATION",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Text("History", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Icon(Icons.history, color: textSecondary, size: 20),
              ],
            ),
            const SizedBox(height: 15),
            /// CONSULTATION LIST
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: getConsultations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: primaryGreen));
                  }
                  final consultations = snapshot.data ?? [];
                  if (consultations.isEmpty) {
                    return Center(child: Text("No history available", style: TextStyle(color: textSecondary)));
                  }

                  return ListView.builder(
                    itemCount: consultations.length,
                    itemBuilder: (context, index) {
                      final item = consultations[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.03)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: primaryGreen.withOpacity(0.1), shape: BoxShape.circle),
                              child: Icon(Icons.description_outlined, color: primaryGreen, size: 20),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Next: ${DateFormat('dd MMM yyyy').format(DateTime.parse(item["consultation_nextdate"]))}",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item["consultation_remarks"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: textSecondary, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "₹${item["consultation_fee"]}",
                              style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      validator: (val) => val == null || val.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textSecondary),
        prefixIcon: Icon(icon, color: primaryGreen, size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
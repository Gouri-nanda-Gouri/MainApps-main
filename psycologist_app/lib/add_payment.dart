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
  final feeController = TextEditingController(); // ✅ NEW
  DateTime? nextVisitDate;

  final supabase = Supabase.instance.client;

  /// DATE FIELD
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
          color: const Color(0xFFFFE4EC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFF48FB1)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                date == null
                    ? label
                    : DateFormat('dd MMM yyyy').format(date),
                style: TextStyle(
                  color: date == null ? Colors.grey : Colors.black,
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
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => nextVisitDate = picked);
    }
  }

  /// SAVE CONSULTATION
  Future<void> saveConsultation() async {
    if (!_formKey.currentState!.validate()) return;

    if (nextVisitDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select next visit date")),
      );
      return;
    }

    try {
      await supabase.from('tbl_consultation').insert({
        "consultation_remarks": remarksController.text,
        "consultation_nextdate": nextVisitDate!.toIso8601String(),
        "consultation_fee": double.parse(feeController.text), 
        "consultation_status": "active",
        "appointment_id": widget.appointmentId,
        "payment_status": "pending",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Consultation Saved Successfully")),
      );

      remarksController.clear();
      feeController.clear(); // ✅ NEW
      setState(() => nextVisitDate = null);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    remarksController.dispose();
    feeController.dispose(); // ✅ NEW
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
      backgroundColor: const Color(0xFFFAD1E6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Consultation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// FORM
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),

              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    _modernDateField(
                      label: "Next Visit Date",
                      icon: Icons.event_repeat_rounded,
                      date: nextVisitDate,
                      onTap: pickDate,
                    ),

                    const SizedBox(height: 15),

                    /// 💰 FEES FIELD (NEW)
                    TextFormField(
                      controller: feeController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Enter consultation fee"
                              : null,
                      decoration: InputDecoration(
                        hintText: "Consultation Fee",
                        prefixIcon: const Icon(
                          Icons.currency_rupee,
                          color: Color(0xFFF48FB1),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFE4EC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// REMARKS
                    TextFormField(
                      controller: remarksController,
                      maxLines: 3,
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Please enter remarks"
                              : null,
                      decoration: InputDecoration(
                        hintText: "Doctor remarks...",
                        prefixIcon: const Icon(
                          Icons.edit_note_rounded,
                          color: Color(0xFFF48FB1),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFE4EC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: InkWell(
                        onTap: saveConsultation,
                        borderRadius: BorderRadius.circular(25),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF48FB1), Color(0xFFE91E63)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              "Save Consultation",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CONSULTATION LIST
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: getConsultations(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final consultations = snapshot.data!;

                  if (consultations.isEmpty) {
                    return const Center(
                      child: Text("No consultations yet 💕",
                          style: TextStyle(color: Colors.white)),
                    );
                  }

                  return ListView.builder(
                    itemCount: consultations.length,
                    itemBuilder: (context, index) {
                      final item = consultations[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Next Visit: ${DateFormat('dd MMM yyyy').format(DateTime.parse(item["consultation_nextdate"]))}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text("Fee: ₹ ${item["consultation_fee"] ?? 0}"),
                            const SizedBox(height: 5),
                            Text("Remarks: ${item["consultation_remarks"]}"),
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
}
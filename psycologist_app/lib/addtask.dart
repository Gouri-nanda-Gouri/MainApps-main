import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Addtask extends StatefulWidget {
  final String appointmentId;
  final String childName;

  const Addtask({
    super.key,
    required this.appointmentId,
    required this.childName,
  });

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  final supabase = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // CONTROLLERS
  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _detailsController =
      TextEditingController();

  final TextEditingController _startDateController =
      TextEditingController();

  final TextEditingController _endDateController =
      TextEditingController();

  // COLORS
  static const Color bgBlack = Color(0xFF0D0D0D);

  static const Color surfaceDark = Color(0xFF1A1A1A);

  static const Color primaryGreen = Color(0xFF1DB954);

  static const Color accentGreen = Color(0xFF25D366);

  @override
  void dispose() {
    _titleController.dispose();

    _detailsController.dispose();

    _startDateController.dispose();

    _endDateController.dispose();

    super.dispose();
  }

  // DATE PICKER
  Future<void> _selectDate(
      TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime.now(),

      lastDate: DateTime(2100),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  // CREATE TASK
  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        isLoading = true;
      });

      await supabase.from('tbl_task').insert({
        'appointment_id': widget.appointmentId,
        'task_title': _titleController.text.trim(),
        'task_details': _detailsController.text.trim(),
        'task_startdate':
            _startDateController.text.trim(),
        'task_enddate':
            _endDateController.text.trim(),
        'task_status': 0,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text(
            "Task Assigned Successfully",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error creating task: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text("Error: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
        iconTheme:
            const IconThemeData(color: Colors.white),
        title: const Text(
          "Assign Task",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              // TOP CARD
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: surfaceDark,

                  borderRadius:
                      BorderRadius.circular(22),

                  border: Border.all(
                    color:
                        Colors.white.withOpacity(0.05),
                  ),
                ),

                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,

                      backgroundColor:
                          primaryGreen.withOpacity(
                        0.15,
                      ),

                      child: const Icon(
                        Icons.assignment_rounded,
                        color: primaryGreen,
                        size: 34,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      widget.childName,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Create therapy activity task",

                      style: TextStyle(
                        color:
                            Colors.white.withOpacity(
                          0.5,
                        ),

                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // FORM CARD
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: surfaceDark,

                  borderRadius:
                      BorderRadius.circular(22),

                  border: Border.all(
                    color:
                        Colors.white.withOpacity(0.05),
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Task Details",

                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildCustomField(
                      controller: _titleController,
                      label: "Task Title",
                      icon: Icons.title,
                      hint: "Enter task title",
                    ),

                    const SizedBox(height: 18),

                    _buildCustomField(
                      controller: _detailsController,
                      label: "Instructions",
                      icon: Icons.notes,
                      hint:
                          "Enter task instructions",
                      maxLines: 4,
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Timeline",

                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: _buildCustomField(
                            controller:
                                _startDateController,

                            label: "Start Date",

                            icon:
                                Icons.calendar_today,

                            readOnly: true,

                            onTap: () =>
                                _selectDate(
                              _startDateController,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: _buildCustomField(
                            controller:
                                _endDateController,

                            label: "End Date",

                            icon: Icons.event,

                            readOnly: true,

                            onTap: () =>
                                _selectDate(
                              _endDateController,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              primaryGreen,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),

                        onPressed: isLoading
                            ? null
                            : _createTask,

                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Create Task",

                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CUSTOM FIELD
  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,

      maxLines: maxLines,

      readOnly: readOnly,

      onTap: onTap,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required";
        }

        return null;
      },

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.3),
        ),

        labelText: label,

        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
        ),

        prefixIcon: Icon(
          icon,
          color: primaryGreen,
        ),

        filled: true,

        fillColor: bgBlack,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),

          borderSide: const BorderSide(
            color: primaryGreen,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),

          borderSide: BorderSide(
            color:
                Colors.white.withOpacity(0.04),
          ),
        ),
      ),
    );
  }
}
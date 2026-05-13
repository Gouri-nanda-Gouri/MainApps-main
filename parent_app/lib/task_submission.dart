import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';

class TaskSubmissionPage extends StatefulWidget {
  final String taskId;
  final String appointmentId;

  const TaskSubmissionPage({
    super.key,
    required this.taskId,
    required this.appointmentId,
  });

  @override
  State<TaskSubmissionPage> createState() => _TaskSubmissionPageState();
}

class _TaskSubmissionPageState extends State<TaskSubmissionPage> {
  final supabase = Supabase.instance.client;

  final TextEditingController _descriptionController = TextEditingController();

  PlatformFile? _pickedFile;

  bool isLoading = false;

  late Future<List<Map<String, dynamic>>> _submissionsFuture;

  @override
  void initState() {
    super.initState();
    _submissionsFuture = getSubmissions();
  }

  Future<List<Map<String, dynamic>>> getSubmissions() async {
    try {
      final response = await supabase
          .from('tbl_task_submission')
          .select()
          .eq('appointment_id', widget.appointmentId)
          .order('submitted_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Fetch submission error: $e");
      return [];
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'mp3', 'wav', 'm4a'],
        withData: true,
      );

      if (result != null) {
        setState(() {
          _pickedFile = result.files.first;
        });
      }
    } catch (e) {
      debugPrint("Picker error: $e");
    }
  }

  Future<void> submitTask() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a description")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = supabase.auth.currentUser;

      String? publicUrl;

      /// Upload File
      if (_pickedFile != null) {
        final fileExt = _pickedFile!.extension ?? 'bin';
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

        final path = 'task_proofs/$fileName';

        String contentType = 'application/octet-stream';

        if (['jpg', 'jpeg', 'png'].contains(fileExt)) {
          contentType = 'image/$fileExt';
        }

        if (['mp4', 'mov'].contains(fileExt)) {
          contentType = 'video/$fileExt';
        }

        if (['mp3', 'wav', 'm4a'].contains(fileExt)) {
          contentType = 'audio/$fileExt';
        }

        if (kIsWeb) {
          await supabase.storage.from('Task').uploadBinary(
                path,
                _pickedFile!.bytes!,
                fileOptions: FileOptions(contentType: contentType),
              );
        } else {
          await supabase.storage.from('Task').upload(
                path,
                File(_pickedFile!.path!),
                fileOptions: FileOptions(contentType: contentType),
              );
        }

        publicUrl = supabase.storage.from('Task').getPublicUrl(path);
      }

      /// Insert Submission
     await supabase.from('tbl_task_submission').insert({
  "task_id": int.parse(widget.taskId),
  "appointment_id": int.parse(widget.appointmentId),
  "parent_id": user?.id,
  "submission_text": _descriptionController.text,
  "submission_file": publicUrl,
  "status": "pending",
});

      _descriptionController.clear();

      setState(() {
        _pickedFile = null;
        _submissionsFuture = getSubmissions();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task submitted successfully!")),
        );
      }
    } catch (e) {
      debugPrint("Error submitting task: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget submittedTasksList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _submissionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final submissions = snapshot.data ?? [];

        if (submissions.isEmpty) {
          return const Text("No submissions yet.");
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: submissions.length,
          itemBuilder: (context, index) {
            final submission = submissions[index];

            return Container(
  margin: const EdgeInsets.only(bottom: 14),

  decoration: BoxDecoration(
    color: const Color(0xFF1A1A1A),

    borderRadius: BorderRadius.circular(20),

    border: Border.all(
      color: Colors.white.withOpacity(0.05),
    ),
  ),

  child: ListTile(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 10,
    ),

    leading: Container(
      height: 48,
      width: 48,

      decoration: BoxDecoration(
        color: const Color(
          0xFF1DB954,
        ).withOpacity(0.12),

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: const Icon(
        Icons.assignment_turned_in,
        color: Color(0xFF1DB954),
      ),
    ),

    title: Text(
      submission['submission_text'] ?? "",

      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),

    subtitle: Padding(
      padding: const EdgeInsets.only(top: 8),

      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),

            decoration: BoxDecoration(
              color: const Color(
                0xFF1DB954,
              ).withOpacity(0.12),

              borderRadius:
                  BorderRadius.circular(8),
            ),

            child: Text(
              submission['status'] ?? "pending",

              style: const TextStyle(
                color: Color(0xFF1DB954),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),

    trailing: submission['points'] != null
        ? Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),

            decoration: BoxDecoration(
              color: Colors.orange
                  .withOpacity(0.12),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Text(
              "${submission['points']} pts",

              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Icon(
            Icons.arrow_forward_ios,
            color:
                Colors.white.withOpacity(0.3),
            size: 16,
          ),
  ),
);
          },
        );
      },
    );
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF0D0D0D),

    appBar: AppBar(
      backgroundColor: const Color(0xFF0D0D0D),
      elevation: 0,
      centerTitle: true,
      iconTheme:
          const IconThemeData(color: Colors.white),

      title: const Text(
        "Submit Task",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),

    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // HEADER CARD
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),

              borderRadius:
                  BorderRadius.circular(24),

              border: Border.all(
                color:
                    Colors.white.withOpacity(0.05),
              ),
            ),

            child: Column(
              children: [
                Container(
                  height: 75,
                  width: 75,

                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1DB954,
                    ).withOpacity(0.15),

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.assignment_turned_in,
                    color: Color(0xFF1DB954),
                    size: 38,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Upload Completed Task",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Submit activity proof and progress details",

                  textAlign: TextAlign.center,

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

          // DESCRIPTION CARD
          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),

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
                  "Task Description",

                  style: TextStyle(
                    color: Color(0xFF1DB954),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller:
                      _descriptionController,

                  maxLines: 5,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText:
                        "Describe your progress...",

                    hintStyle: TextStyle(
                      color: Colors.white
                          .withOpacity(0.3),
                    ),

                    filled: true,

                    fillColor:
                        const Color(0xFF0D0D0D),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),

                      borderSide:
                          BorderSide.none,
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),

                      borderSide: BorderSide(
                        color: Colors.white
                            .withOpacity(0.04),
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),

                      borderSide:
                          const BorderSide(
                        color:
                            Color(0xFF1DB954),
                      ),
                    ),

                    contentPadding:
                        const EdgeInsets.all(
                      18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // FILE UPLOAD CARD
          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),

              borderRadius:
                  BorderRadius.circular(22),

              border: Border.all(
                color:
                    Colors.white.withOpacity(0.05),
              ),
            ),

            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF1DB954,
                        ).withOpacity(0.12),

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.attach_file,
                        color: Color(0xFF1DB954),
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Text(
                        "Upload Proof",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton.icon(
                    onPressed:
                        isLoading ? null : _pickFile,

                    icon: const Icon(
                      Icons.upload_file,
                      color: Colors.white,
                    ),

                    label: Text(
                      _pickedFile == null
                          ? "Select File"
                          : "Change File",

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF1DB954,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                  ),
                ),

                if (_pickedFile != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 16,
                    ),

                    child: Container(
                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(
                        14,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF1DB954,
                        ).withOpacity(0.08),

                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),

                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color:
                                Color(0xFF1DB954),
                            size: 20,
                          ),

                          const SizedBox(
                              width: 10),

                          Expanded(
                            child: Text(
                              _pickedFile!.name,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // SUBMIT BUTTON
          SizedBox(
            width: double.infinity,
            height: 58,

            child: ElevatedButton(
              onPressed:
                  isLoading ? null : submitTask,

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1DB954),

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
              ),

              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child:
                          CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "SUBMIT TASK",

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 35),

          // SUBMISSIONS TITLE
          const Text(
            "Recent Submissions",

            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          submittedTasksList(),
        ],
      ),
    ),
  );
}
}
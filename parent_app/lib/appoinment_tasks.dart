import 'package:flutter/material.dart';
import 'package:parent_app/task_submission.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Make sure this matches your file name for the submission page

class AppointmentTasksScreen extends StatelessWidget {
  final String appointmentId;
  const AppointmentTasksScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Consistent theme
      appBar: AppBar(
        title: const Text("Assigned Tasks", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // Streaming tasks for this specific appointment
        stream: supabase
            .from('tbl_task')
            .stream(primaryKey: ['task_id'])
            .eq('appointment_id', appointmentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late_outlined, size: 60, color: Colors.pink[200]),
                  const SizedBox(height: 10),
                  const Text("No tasks assigned yet.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final isDone = task['is_completed'] ?? false;
              final taskId = task['task_id'].toString();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: isDone ? Colors.green[100] : Colors.pink[50],
                    child: Icon(
                      isDone ? Icons.check : Icons.pending_actions,
                      color: isDone ? Colors.green : Colors.pink,
                    ),
                  ),
                  title: Text(
                    task['task_title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: isDone ? Colors.grey : Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text("Due: ${task['task_enddate'] ?? 'No date'}"),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    // Navigate to TaskSubmissionPage to upload photo/video/audio
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskSubmissionPage(
                          taskId: taskId,
                          appointmentId: appointmentId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
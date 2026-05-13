import 'package:flutter/material.dart';
import 'package:parent_app/task_submission.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewTasksList extends StatefulWidget {
  final int appointmentId;

  const ViewTasksList({
    super.key,
    required this.appointmentId,
  });

  @override
  State<ViewTasksList> createState() =>
      _ViewTasksListState();
}

class _ViewTasksListState
    extends State<ViewTasksList> {
  final supabase = Supabase.instance.client;

  // COLORS
  static const Color bgBlack = Color(0xFF0D0D0D);

  static const Color surfaceDark =
      Color(0xFF1A1A1A);

  static const Color primaryGreen =
      Color(0xFF1DB954);

  Stream<List<Map<String, dynamic>>>
      _getTasksStream() {
    return supabase
        .from('tbl_task')
        .stream(primaryKey: ['task_id'])
        .eq(
          'appointment_id',
          widget.appointmentId,
        )
        .order(
          'task_startdate',
          ascending: true,
        );
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
          "Assigned Tasks",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<
          List<Map<String, dynamic>>>(
        stream: _getTasksStream(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryGreen,
              ),
            );
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return _buildEmptyState();
          }

          final completedCount = tasks
              .where(
                (t) =>
                    t['is_completed'] == true,
              )
              .length;

          final double progress =
              tasks.isEmpty
                  ? 0
                  : completedCount /
                      tasks.length;

          return Column(
            children: [
              _buildProgressHeader(
                completedCount,
                tasks.length,
                progress,
              ),

              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.all(16),

                  itemCount: tasks.length,

                  itemBuilder:
                      (context, index) {
                    final task = tasks[index];

                    final bool isCompleted =
                        task['is_completed'] ??
                            false;

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      decoration: BoxDecoration(
                        color: surfaceDark,

                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),

                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.05),
                        ),
                      ),

                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),

                        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaskSubmissionPage(
        taskId: task['id'].toString(),
        appointmentId:
            widget.appointmentId.toString(),
      ),
    ),
  );
},

                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            18,
                          ),

                          child: Row(
                            children: [
                              Container(
                                height: 55,
                                width: 55,

                                decoration:
                                    BoxDecoration(
                                  color: isCompleted
                                      ? primaryGreen
                                          .withOpacity(
                                          0.15,
                                        )
                                      : Colors.blue
                                          .withOpacity(
                                          0.15,
                                        ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    18,
                                  ),
                                ),

                                child: Icon(
                                  isCompleted
                                      ? Icons
                                          .check_circle
                                      : Icons
                                          .assignment_outlined,

                                  color:
                                      isCompleted
                                          ? primaryGreen
                                          : Colors
                                              .blue,

                                  size: 28,
                                ),
                              ),

                              const SizedBox(
                                  width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    Text(
                                      task['task_title'] ??
                                          "Untitled Task",

                                      style:
                                          TextStyle(
                                        color:
                                            isCompleted
                                                ? Colors
                                                    .grey
                                                : Colors
                                                    .white,

                                        fontSize:
                                            16,

                                        fontWeight:
                                            FontWeight
                                                .bold,

                                        decoration:
                                            isCompleted
                                                ? TextDecoration
                                                    .lineThrough
                                                : null,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            8),

                                    Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .calendar_today,
                                          color: Colors
                                              .white
                                              .withOpacity(
                                            0.4,
                                          ),
                                          size: 14,
                                        ),

                                        const SizedBox(
                                            width:
                                                6),

                                        Text(
                                          "Due: ${task['task_enddate'] ?? 'N/A'}",

                                          style:
                                              TextStyle(
                                            color: Colors
                                                .white
                                                .withOpacity(
                                              0.5,
                                            ),

                                            fontSize:
                                                12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                  width: 10),

                              Icon(
                                Icons
                                    .arrow_forward_ios,
                                color: Colors.white
                                    .withOpacity(
                                  0.3,
                                ),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader(
    int completed,
    int total,
    double progress,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: surfaceDark,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                "Task Completion",

                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              Text(
                "$completed / $total Done",

                style: TextStyle(
                  color: Colors.white
                      .withOpacity(0.5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),

            child: LinearProgressIndicator(
              value: progress,

              backgroundColor:
                  Colors.white.withOpacity(0.08),

              color: primaryGreen,

              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Container(
            height: 90,
            width: 90,

            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.03),

              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.assignment_outlined,
              size: 42,
              color:
                  Colors.white.withOpacity(0.15),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "No tasks assigned yet",

            style: TextStyle(
              color:
                  Colors.white.withOpacity(0.3),

              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
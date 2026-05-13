import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

final supabase = Supabase.instance.client;

class ViewSubmissionPage extends StatefulWidget {
  final String appointmentId;

  const ViewSubmissionPage({
    super.key,
    required this.appointmentId,
  });

  @override
  State<ViewSubmissionPage> createState() =>
      _ViewSubmissionPageState();
}

class _ViewSubmissionPageState
    extends State<ViewSubmissionPage> {
  late Future<List<Map<String, dynamic>>>
      _submissionsFuture;

  @override
  void initState() {
    super.initState();

    _submissionsFuture = getSubmissions();
  }

  Future<List<Map<String, dynamic>>>
      getSubmissions() async {
    try {
      final int parsedId =
          int.parse(widget.appointmentId);

      final response = await supabase
          .from('tbl_task_submission')
          .select('*, tbl_task (task_title)')
          .eq('appointment_id', parsedId)
          .order(
            'submitted_at',
            ascending: false,
          );

      return List<Map<String, dynamic>>.from(
        response,
      );
    } catch (e) {
      debugPrint("Fetch Error: $e");
      return [];
    }
  }

  void refreshSubmissions() {
    setState(() {
      _submissionsFuture = getSubmissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0D0D0D),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0D0D0D),

        elevation: 0,
        centerTitle: true,

        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),

        title: const Text(
          "Task Submissions",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<
          List<Map<String, dynamic>>>(
        future: _submissionsFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color: Color(0xFF1DB954),
              ),
            );
          }

          final submissions =
              snapshot.data ?? [];

          if (submissions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Container(
                    height: 90,
                    width: 90,

                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.03),

                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.assignment_outlined,
                      size: 40,
                      color: Colors.white
                          .withOpacity(0.15),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "No submissions found",

                    style: TextStyle(
                      color: Colors.white
                          .withOpacity(0.3),

                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(16),

            itemCount: submissions.length,

            itemBuilder: (context, index) {
              return SubmissionCard(
                submission:
                    submissions[index],

                onUpdate:
                    refreshSubmissions,
              );
            },
          );
        },
      ),
    );
  }
}

class SubmissionCard
    extends StatefulWidget {
  final Map<String, dynamic> submission;

  final VoidCallback onUpdate;

  const SubmissionCard({
    super.key,
    required this.submission,
    required this.onUpdate,
  });

  @override
  State<SubmissionCard> createState() =>
      _SubmissionCardState();
}

class _SubmissionCardState
    extends State<SubmissionCard> {
  late TextEditingController
      feedbackController;

  late TextEditingController
      pointsController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    feedbackController =
        TextEditingController(
      text:
          widget.submission['feedback'] ??
              "",
    );

    pointsController =
        TextEditingController(
      text: widget.submission['points']
              ?.toString() ??
          "",
    );
  }

  @override
  void dispose() {
    feedbackController.dispose();

    pointsController.dispose();

    super.dispose();
  }

  void _showFullFile(
    String url,
    bool isImage,
  ) {
    showDialog(
      context: context,

      barrierDismissible: true,

      builder: (context) => Dialog(
        backgroundColor: Colors.black,

        insetPadding:
            const EdgeInsets.all(10),

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Align(
              alignment: Alignment.topRight,

              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),

                onPressed: () =>
                    Navigator.pop(context),
              ),
            ),

            Flexible(
              child: isImage
                  ? InteractiveViewer(
                      child: Image.network(
                        url,
                        fit: BoxFit.contain,
                      ),
                    )
                  : ConstrainedBox(
                      constraints:
                          BoxConstraints(
                        maxHeight:
                            MediaQuery.of(
                                      context,
                                    ).size.height *
                                0.6,
                      ),

                      child:
                          VideoPopupPlayer(
                        url: url,
                      ),
                    ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(
      String? fileUrl) {
    if (fileUrl == null ||
        fileUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    final extension = fileUrl
        .split('.')
        .last
        .toLowerCase();

    bool isImage = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp'
    ].contains(extension);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          "Proof Attachment",

          style: TextStyle(
            color:
                Colors.white.withOpacity(
              0.5,
            ),

            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: () => _showFullFile(
            fileUrl,
            isImage,
          ),

          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(18),

            child: Container(
              width: double.infinity,
              height: 180,

              color:
                  const Color(0xFF0D0D0D),

              child: isImage
                  ? Image.network(
                      fileUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.black,

                      child: const Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [
                          Icon(
                            Icons
                                .play_circle_fill,
                            size: 60,
                            color: Color(
                              0xFF1DB954,
                            ),
                          ),

                          SizedBox(height: 12),

                          Text(
                            "Tap to Play Video",

                            style: TextStyle(
                              color: Color(
                                0xFF1DB954,
                              ),
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final submission =
        widget.submission;

    return Container(
      margin:
          const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color:
              Colors.white.withOpacity(0.05),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Container(
                  height: 55,
                  width: 55,

                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1DB954,
                    ).withOpacity(0.12),

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: const Icon(
                    Icons.assignment_turned_in,
                    color: Color(0xFF1DB954),
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Text(
                        submission['tbl_task']
                                ?[
                                'task_title'] ??
                            "Task",

                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                          height: 6),

                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration:
                            BoxDecoration(
                          color: const Color(
                            0xFF1DB954,
                          ).withOpacity(
                            0.10,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),
                        ),

                        child: Text(
                          submission[
                                  'status'] ??
                              "pending",

                          style:
                              const TextStyle(
                            color: Color(
                              0xFF1DB954,
                            ),
                            fontSize: 11,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildFilePreview(
              submission['submission_file'],
            ),

            Text(
              "Parent's Note",

              style: TextStyle(
                color: Colors.white
                    .withOpacity(0.5),

                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color:
                    const Color(0xFF0D0D0D),

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: Text(
                submission[
                        'submission_text'] ??
                    "No note provided.",

                style: const TextStyle(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  feedbackController,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(
                labelText: "Feedback",

                labelStyle: TextStyle(
                  color: Colors.white
                      .withOpacity(0.6),
                ),

                hintText:
                    "Add comment for parent...",

                hintStyle: TextStyle(
                  color: Colors.white
                      .withOpacity(0.3),
                ),

                filled: true,

                fillColor:
                    const Color(0xFF0D0D0D),

                border:
                    OutlineInputBorder(
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

                  borderSide:
                      BorderSide(
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
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  pointsController,

              keyboardType:
                  TextInputType.number,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(
                labelText:
                    "Development Points",

                labelStyle: TextStyle(
                  color: Colors.white
                      .withOpacity(0.6),
                ),

                hintText:
                    "Enter points (1 - 10)",

                hintStyle: TextStyle(
                  color: Colors.white
                      .withOpacity(0.3),
                ),

                filled: true,

                fillColor:
                    const Color(0xFF0D0D0D),

                border:
                    OutlineInputBorder(
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

                  borderSide:
                      BorderSide(
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
              ),
            ),

            const SizedBox(height: 22),

            isSaving
                ? const Center(
                    child:
                        CircularProgressIndicator(
                      color:
                          Color(0xFF1DB954),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child:
                            ElevatedButton(
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                const Color(
                              0xFF1DB954,
                            ),

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

                          onPressed: () =>
                              _updateStatus(
                            "approved",
                          ),

                          child: const Text(
                            "Approve",

                            style: TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
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
                                Colors.orange,

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

                          onPressed: () =>
                              _updateStatus(
                            "reviewed",
                          ),

                          child: const Text(
                            "Reviewed",

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
  }

  Future<void> _updateStatus(
      String status) async {
    setState(() => isSaving = true);

    try {
      await supabase
          .from('tbl_task_submission')
          .update({
            "status": status,
            "feedback":
                feedbackController.text,
            "points": int.tryParse(
                    pointsController.text) ??
                0
          }).eq(
              'submission_id',
              widget.submission[
                  'submission_id']);

      widget.onUpdate();

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            backgroundColor:
                const Color(0xFF1DB954),

            content: Text(
              "Submission marked as $status",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }
}

class VideoPopupPlayer
    extends StatefulWidget {
  final String url;

  const VideoPopupPlayer({
    super.key,
    required this.url,
  });

  @override
  State<VideoPopupPlayer> createState() =>
      _VideoPopupPlayerState();
}

class _VideoPopupPlayerState
    extends State<VideoPopupPlayer> {
  late VideoPlayerController
      _videoPlayerController;

  ChewieController?
      _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );

    _videoPlayerController
        .initialize()
        .then((_) {
      if (mounted) {
        setState(() {
          _chewieController =
              ChewieController(
            videoPlayerController:
                _videoPlayerController,
            autoPlay: true,
            aspectRatio:
                _videoPlayerController
                    .value
                    .aspectRatio,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();

    _chewieController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null &&
        _chewieController!
            .videoPlayerController
            .value
            .isInitialized) {
      return AspectRatio(
        aspectRatio:
            _videoPlayerController
                .value
                .aspectRatio,

        child: Chewie(
          controller:
              _chewieController!,
        ),
      );
    }

    return const SizedBox(
      height: 200,

      child: Center(
        child:
            CircularProgressIndicator(
          color: Color(0xFF1DB954),
        ),
      ),
    );
  }
}
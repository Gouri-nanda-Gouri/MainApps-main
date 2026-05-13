import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String? receiverPhoto;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
    this.receiverPhoto,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _isRecording = false;
  String? _replyToId;
  Map<String, dynamic>? _replyingToMessage;

  late final RealtimeChannel _chatChannel;

  // ── Pink Rose Palette ──────────────────────────────────────────────────────
  static const Color deepRose = Color(0xFF880E4F); // For dark accents
  static const Color primaryPink = Color(0xFFE91E63); // For primary buttons/bubbles
  static const Color mediumPink = Color(0xFFF06292); // For gradients
  static const Color softPink = Color(0xFFFCE4EC); // For "Them" bubbles
  static const Color background = Color(0xFFFFF1F5); // Overall background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inkMuted = Color(0xFFAD1457);
  static const Color rule = Color(0xFFF8BBD0);
  static const Color danger = Color(0xFFD32F2F);
  // ────────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _subscribeToMessages();
    _markAsRead();
    _messageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    supabase.removeChannel(_chatChannel);
    super.dispose();
  }

  void _subscribeToMessages() {
    final myId = supabase.auth.currentUser!.id;
    _chatChannel = supabase
        .channel('public:tbl_chat')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tbl_chat',
          callback: (payload) {
            if (payload.eventType == PostgresChangeEvent.insert) {
              final newMessage = payload.newRecord;
              bool isRelevant = (newMessage['from_psychologistid'] == myId && newMessage['to_parentid'] == widget.receiverId) ||
                                (newMessage['from_parentid'] == widget.receiverId && newMessage['to_psychologistid'] == myId);

              if (isRelevant) {
                setState(() => _messages.insert(0, newMessage));
                if (newMessage['from_parentid'] == widget.receiverId) _markAsRead();
              }
            } else if (payload.eventType == PostgresChangeEvent.delete) {
              setState(() => _messages.removeWhere((m) => m['chat_id'] == payload.oldRecord['chat_id']));
            }
          },
        )
        .subscribe();
  }

  Future<void> _fetchMessages() async {
    final myId = supabase.auth.currentUser!.id;
    try {
      final response = await supabase
          .from('tbl_chat')
          .select()
          .or('and(from_psychologistid.eq.$myId,to_parentid.eq.${widget.receiverId}),and(from_parentid.eq.${widget.receiverId},to_psychologistid.eq.$myId)')
          .order('created_at', ascending: false);

      setState(() {
        _messages = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching messages: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead() async {
    try {
      final myId = supabase.auth.currentUser!.id;
      await supabase.from('tbl_chat').update({'chat_isread': true})
          .eq('from_parentid', widget.receiverId)
          .eq('to_psychologistid', myId)
          .eq('chat_isread', false);
    } catch (e) { debugPrint("Error: $e"); }
  }

  @override
  Widget build(BuildContext context) {
    final initials = widget.receiverName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryPink, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: softPink,
              backgroundImage: widget.receiverPhoto != null ? NetworkImage(widget.receiverPhoto!) : null,
              child: widget.receiverPhoto == null ? Text(initials, style: const TextStyle(fontSize: 12, color: primaryPink, fontWeight: FontWeight.bold)) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.receiverName, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: deepRose)),
                  const Text("Online", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call_outlined, color: primaryPink), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: primaryPink))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg['from_psychologistid'] != null;
                      return _buildMessageBubble(msg, isMe);
                    },
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
    final timestamp = DateTime.parse(msg['created_at']);
    final timeStr = DateFormat('hh:mm a').format(timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              gradient: isMe ? const LinearGradient(colors: [primaryPink, mediumPink]) : null,
              color: isMe ? null : surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(16),
              ),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (msg['chat_content'] != null)
                  Text(msg['chat_content'], style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(timeStr, style: TextStyle(color: isMe ? Colors.white70 : inkMuted, fontSize: 9)),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(msg['chat_isread'] == true ? Icons.done_all : Icons.done, size: 12, color: Colors.white70),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: surface,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.add_circle_outline, color: primaryPink), onPressed: () {}),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  fillColor: background,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: primaryPink,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: () => _sendMessage(text: _messageController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Placeholder for missing methods used in the snippet
// Inside _ChatPageState in chat_page.dart

Future<void> _sendMessage({String? text, String? fileUrl}) async {
  if ((text == null || text.trim().isEmpty) && fileUrl == null) return;
  
  try {
    final myId = supabase.auth.currentUser!.id; // This is the Psychologist's ID
    
    await supabase.from('tbl_chat').insert({
      'from_psychologistid': myId,     // Psychologist is the SENDER
      'to_parentid': widget.receiverId, // Parent is the RECEIVER
      'from_parentid': null,            // Ensure this is NULL
      'to_psychologistid': null,        // Ensure this is NULL
      'chat_content': text,
      'chat_file': fileUrl,
      'chat_replyto': _replyToId,
      'chat_isread': false,
      'created_at': DateTime.now().toIso8601String(),
    });

    _messageController.clear();
    setState(() {
      _replyToId = null;
      _replyingToMessage = null;
    });
  } catch (e) {
    debugPrint("Error sending message: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to send: $e"), backgroundColor: Colors.red),
    );
  }
}
}
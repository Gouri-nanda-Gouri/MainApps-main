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
  static const Color deep = Color(0xFF880E4F);
  static const Color primary = Color(0xFFE91E63);
  static const Color soft = Color(0xFFFCE4EC);
  static const Color background = Color(0xFFFFF1F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inkDark = Color(0xFF880E4F);
  static const Color inkMuted = Color(0xFFAD1457);
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
              bool isRelevant = (newMessage['from_parentid'] == myId && newMessage['to_psychologistid'] == widget.receiverId) ||
                                (newMessage['from_psychologistid'] == widget.receiverId && newMessage['to_parentid'] == myId);

              if (isRelevant) {
                setState(() => _messages.insert(0, newMessage));
                if (newMessage['from_psychologistid'] == widget.receiverId) _markAsRead();
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
          .or('and(from_parentid.eq.$myId,to_psychologistid.eq.${widget.receiverId}),and(from_psychologistid.eq.${widget.receiverId},to_parentid.eq.$myId)')
          .order('created_at', ascending: false);
          print("Fetched messages for psychologist: ${widget.receiverId}");

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
          .eq('from_psychologistid', widget.receiverId)
          .eq('to_parentid', myId)
          .eq('chat_isread', false);
    } catch (e) { debugPrint("Error: $e"); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: soft,
              backgroundImage: widget.receiverPhoto != null ? NetworkImage(widget.receiverPhoto!) : null,
              child: widget.receiverPhoto == null ? const Icon(Icons.person, color: primary, size: 20) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.receiverName, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: inkDark)),
                  const Text("Online", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call_outlined, color: primary), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: primary))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    reverse: true,
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg['from_parentid'] != null;
                      return _buildMessageBubble(msg, isMe);
                    },
                  ),
          ),
          if (_replyingToMessage != null) _buildReplyPreview(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
    final timestamp = DateTime.parse(msg['created_at']);
    final timeStr = DateFormat('hh:mm a').format(timestamp);
    final fileUrl = msg['chat_file']?.toString() ?? "";
    final isImage = fileUrl.toLowerCase().contains(RegExp(r'\.(jpg|jpeg|png|gif)'));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (msg['chat_replyto'] != null) _buildRepliedMessageHeader(msg['chat_replyto'].toString(), isMe),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMe ? primary : surface,
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
                if (isImage) 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(imageUrl: fileUrl, placeholder: (context, url) => Container(height: 150, color: soft)),
                  ),
                if (msg['chat_content'] != null && msg['chat_content'].toString().isNotEmpty)
                  Text(msg['chat_content'], style: TextStyle(color: isMe ? Colors.white : inkDark, fontSize: 14)),
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

  Widget _buildRepliedMessageHeader(String replyId, bool isMe) {
    final repliedMsg = _messages.firstWhere((m) => m['chat_id'].toString() == replyId, orElse: () => {});
    if (repliedMsg.isEmpty) return const SizedBox();
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: soft.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: const Border(left: BorderSide(color: primary, width: 3)),
      ),
      child: Text(
        repliedMsg['chat_content'] ?? "Attachment",
        style: const TextStyle(fontSize: 11, color: inkMuted, fontStyle: FontStyle.italic),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: surface,
      child: Row(
        children: [
          Container(width: 4, height: 40, color: primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Replying to", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primary)),
                Text(_replyingToMessage?['chat_content'] ?? "Attachment", style: const TextStyle(fontSize: 13, color: inkMuted), maxLines: 1),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => setState(() { _replyingToMessage = null; _replyToId = null; })),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: surface,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.add_circle_outline, color: primary), onPressed: () {}),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(24)),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(hintText: "Type a message...", border: InputBorder.none, hintStyle: TextStyle(fontSize: 14, color: inkMuted)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: primary,
              child: IconButton(
                icon: Icon(_messageController.text.isEmpty ? Icons.mic : Icons.send, color: Colors.white, size: 20),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) _sendMessage(text: _messageController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

 Future<void> _sendMessage({String? text, String? fileUrl}) async {
  try {
    final myId = supabase.auth.currentUser!.id;
    
    await supabase.from('tbl_chat').insert({
      'from_parentid': myId,
      'to_psychologistid': widget.receiverId, // Receiver is the psychologist
      'to_parentid': null,                   // Explicitly set to null
      'from_psychologistid': null,           // Explicitly set to null
      'chat_content': text,
      'chat_file': fileUrl,
      'chat_replyto': _replyToId,
      'chat_isread': false,
    });
    print("Message sent successfully to ${widget.receiverId}");

    _messageController.clear();
    setState(() {
      _replyToId = null;
      _replyingToMessage = null;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Message sent"), backgroundColor: primary));
    });
  } catch (e) {
    debugPrint("Final error check: $e");
  }
}
}
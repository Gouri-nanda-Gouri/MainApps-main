import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'chat_page.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _chats = [];
  bool _isLoading = true;

  // ── Pink Rose Palette ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFFE91E63);
  static const Color soft = Color(0xFFFCE4EC);
  static const Color background = Color(0xFFFFF1F5);
  static const Color inkDark = Color(0xFF880E4F);

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      // 1. Get psychologists from appointments (Active contacts)
      final List<dynamic> appointments = await supabase
          .from('tbl_appointment')
          .select('''
            psychologist_id,
            tbl_psychologist (
              psychologist_id,
              psychologist_name,
              psychologist_photo
            )
          ''')
          .eq('parent_id', user.id)
          .eq('appointment_status', 1);

      final Map<String, Map<String, dynamic>> psychologistMap = {};

      // Add psychologists from appointments to the map
      for (var item in appointments) {
        final psy = item['tbl_psychologist'] as Map<String, dynamic>?;
        if (psy != null && psy['psychologist_id'] != null) {
          psychologistMap[psy['psychologist_id'].toString()] = {
            ...psy,
            'is_active_appointment': true,
          };
        }
      }

      // 2. Fetch all messages to find historical chats not in active appointments
      // This ensures "all messages" are shown even if appointment status changed
      final List<dynamic> historicalChats = await supabase
          .from('tbl_chat')
          .select('from_psychologistid, to_psychologistid')
          .or('from_parentid.eq.${user.id},to_parentid.eq.${user.id}');

      Set<String> allPsyIds = psychologistMap.keys.toSet();
      for (var chat in historicalChats) {
        if (chat['from_psychologistid'] != null)
          allPsyIds.add(chat['from_psychologistid'].toString());
        if (chat['to_psychologistid'] != null)
          allPsyIds.add(chat['to_psychologistid'].toString());
      }

      // 3. For any historical psychologist not in map, fetch their details
      for (String id in allPsyIds) {
        if (!psychologistMap.containsKey(id)) {
          final psyDetails = await supabase
              .from('tbl_psychologist')
              .select('psychologist_id, psychologist_name, psychologist_photo')
              .eq('psychologist_id', id)
              .maybeSingle();
          if (psyDetails != null) {
            psychologistMap[id] = psyDetails;
          }
        }
      }

      // 4. For each psychologist, get the last message and CORRECT unread count
      final List<Map<String, dynamic>> chatsWithDetails = [];
      for (final psyId in psychologistMap.keys) {
        final psy = psychologistMap[psyId]!;

        // Fetch the very last message between user and this psychologist
        final lastMessageResponse = await supabase
            .from('tbl_chat')
            .select('chat_content, chat_file, created_at')
            .or(
              'and(from_parentid.eq.${user.id},to_psychologistid.eq.$psyId),and(from_psychologistid.eq.$psyId,to_parentid.eq.${user.id})',
            )
            .order('created_at', ascending: false)
            .limit(1);

        // Fetch unread count ONLY from this specific psychologist to the user
        // Change your query to this:
        final unreadResponse = await supabase
            .from('tbl_chat')
            .select('chat_id') // We only need the ID to count it
            .eq('to_parentid', user.id)
            .eq('from_psychologistid', psyId)
            .eq('chat_isread', false)
            .count(CountOption.exact); // Use .count() at the end

        // Access the count property from the response
        final unreadCount = unreadResponse.count;
        final lastMessage = lastMessageResponse.isNotEmpty
            ? lastMessageResponse[0]
            : null;

        // Determine preview text
        String preview = "No messages yet";
        if (lastMessage != null) {
          if (lastMessage['chat_content'] != null &&
              lastMessage['chat_content'].toString().trim().isNotEmpty) {
            preview = lastMessage['chat_content'];
          } else if (lastMessage['chat_file'] != null) {
            preview = "📷 Attachment";
          }
        }

        chatsWithDetails.add({
          ...psy,
          'last_message': preview,
          'last_message_time': lastMessage?['created_at'],
          'unread_count': unreadCount,
        });
      }

      // 5. Sort by last message time (most recent first)
      // Those with no messages go to the bottom
      chatsWithDetails.sort((a, b) {
        final aTime = a['last_message_time'];
        final bTime = b['last_message_time'];
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return DateTime.parse(bTime).compareTo(DateTime.parse(aTime));
      });

      if (mounted) {
        setState(() {
          _chats = chatsWithDetails;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching chats: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          "Messages",
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: inkDark,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primary,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchChats,
        color: primary,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: primary))
            : _chats.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  return _buildChatCard(chat);
                },
              ),
      ),
    );
  }

  Widget _buildChatCard(Map<String, dynamic> chat) {
    final name = chat['psychologist_name'] ?? "Psychologist";
    final photo = chat['psychologist_photo'];
    final lastMessage = chat['last_message'];
    final lastMessageTime = chat['last_message_time'];
    final unreadCount = chat['unread_count'] ?? 0;

    String timeStr = "";
    if (lastMessageTime != null) {
      final dateTime = DateTime.parse(lastMessageTime).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        timeStr = DateFormat('hh:mm a').format(dateTime);
      } else if (difference.inDays == 1) {
        timeStr = "Yesterday";
      } else if (difference.inDays < 7) {
        timeStr = DateFormat('EEEE').format(dateTime);
      } else {
        timeStr = DateFormat('MM/dd/yy').format(dateTime);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: soft,
              backgroundImage: (photo != null && photo.toString().isNotEmpty)
                  ? NetworkImage(photo)
                  : null,
              child: (photo == null || photo.toString().isEmpty)
                  ? const Icon(Icons.person, color: primary, size: 30)
                  : null,
            ),
            if (unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: inkDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (timeStr.isNotEmpty)
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 11,
                  color: unreadCount > 0 ? primary : Colors.grey,
                  fontWeight: unreadCount > 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            lastMessage,
            style: TextStyle(
              fontSize: 13,
              color: unreadCount > 0 ? Colors.black87 : Colors.grey[600],
              fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverId: chat['psychologist_id'].toString(),
                receiverName: name,
                receiverPhoto: photo,
              ),
            ),
          ).then((_) => _fetchChats());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 80, color: soft),
          const SizedBox(height: 16),
          const Text(
            "No messages yet",
            style: TextStyle(
              color: inkDark,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Start a conversation with a psychologist",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

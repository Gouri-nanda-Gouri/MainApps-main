import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    setState(() => _isLoading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('tbl_appointment')
          .select('parent_id, tbl_parent(*)')
          .eq('psychologist_id', user.id);

      final List<dynamic> data = response;

      final Map<String, Map<String, dynamic>> uniqueParents = {};

      for (var item in data) {
        final parent = item['tbl_parent'] as Map<String, dynamic>?;
        if (parent != null) {
          uniqueParents[parent['parent_id'].toString()] = parent;
        }
      }

      setState(() {
        _chats = uniqueParents.values.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching chats: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color.fromRGBO(61, 14, 86, 1),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchChats,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(61, 14, 86, 1),
              ),
            )
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
    );
  }

  Widget _buildChatCard(Map<String, dynamic> chat) {
    final name = chat['parent_name'] ?? "Parent";
    final photo = chat['parent_photo'];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: const Color.fromRGBO(61, 14, 86, 0.1),
          backgroundImage: photo != null ? NetworkImage(photo) : null,
          child: photo == null
              ? const Icon(
                  Icons.person,
                  color: Color.fromRGBO(61, 14, 86, 1),
                )
              : null,
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          "Tap to view messages",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color.fromRGBO(61, 14, 86, 1),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverId: chat['parent_id'].toString(),
                receiverName: name,
                receiverPhoto: photo,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            "No active chats yet",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 6),
          const Text(
            "Accepted appointments will appear here",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
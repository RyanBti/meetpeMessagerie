import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/chat_preview_tile.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserId;
  const ChatListScreen({super.key, required this.currentUserId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    final url = 'http://10.0.2.2:3000/api/messages/conversations/${widget.currentUserId}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          conversations = data.map((conv) {
            return {
              'name': conv['userId'],
              'message': conv['lastMessage'],
              'avatar': 'https://i.pravatar.cc/150?u=${conv['userId']}',
              'unread': conv['unreadCount'] > 0,
              'timestamp': conv['timestamp'],
              'unreadCount': conv['unreadCount'],
              'id': conv['userId'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        print('❌ Erreur API: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Erreur chargement conversations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages (${widget.currentUserId})",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : conversations.isEmpty
          ? const Center(child: Text("Aucune conversation pour le moment"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          return ChatPreviewTile(
            name: convo['name'],
            message: convo['message'],
            avatarUrl: convo['avatar'],
            unread: convo['unread'],
            timestamp: convo['timestamp'],
            unreadCount: convo['unreadCount'],
            onTap: () {
              Navigator.pushNamed(
                context,
                '/chat',
                arguments: {
                  'currentUserId': widget.currentUserId,
                  'otherUserId': convo['id'],
                  'username': convo['name'],
                },
              ).then((_) => fetchConversations()); // Rafraîchir au retour
            },
          );
        },
      ),
    );
  }
}

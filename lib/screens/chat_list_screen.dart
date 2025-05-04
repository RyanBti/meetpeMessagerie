import 'package:flutter/material.dart';
import '../widgets/chat_preview_tile.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> conversations = [
      {
        'name': 'Marianne',
        'message': 'Merci pour votre réservation, rendez-vous place du Tertre...',
        'avatar': 'https://i.pravatar.cc/150?img=5',
        'unread': true,
        'id': 'user456',
      },
      {
        'name': 'Team Meetpe',
        'message': 'Bienvenue dans l’application Sofia 🎉',
        'avatar': 'https://i.pravatar.cc/150?img=10',
        'unread': false,
        'id': 'team',
      },
    ];

    const String currentUserId = 'user123'; // Simulé pour l’instant

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          return ChatPreviewTile(
            name: convo['name'],
            message: convo['message'],
            avatarUrl: convo['avatar'],
            unread: convo['unread'],
            onTap: () {
              Navigator.pushNamed(
                context,
                '/chat',
                arguments: {
                  'currentUserId': currentUserId,
                  'otherUserId': convo['id'],
                  'username': convo['name'],
                },
              );
            },
          );
        },
      ),
    );
  }
}

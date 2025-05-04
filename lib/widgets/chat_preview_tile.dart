import 'package:flutter/material.dart';

class ChatPreviewTile extends StatelessWidget {
  final String name;
  final String message;
  final String avatarUrl;
  final bool unread;
  final VoidCallback onTap;

  const ChatPreviewTile({
    super.key,
    required this.name,
    required this.message,
    required this.avatarUrl,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: unread
          ? const CircleAvatar(
        radius: 6,
        backgroundColor: Colors.red,
      )
          : null,
    );
  }
}

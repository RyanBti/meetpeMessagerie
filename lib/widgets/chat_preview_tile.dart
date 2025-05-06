import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPreviewTile extends StatelessWidget {
  final String name;
  final String message;
  final String avatarUrl;
  final bool unread;
  final String? timestamp;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatPreviewTile({
    super.key,
    required this.name,
    required this.message,
    required this.avatarUrl,
    required this.unread,
    required this.unreadCount,
    required this.onTap,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = '';
    if (timestamp != null && timestamp!.isNotEmpty) {
      try {
        final parsed = DateTime.parse(timestamp!);
        formattedTime = DateFormat('HH:mm').format(parsed);
      } catch (_) {
        formattedTime = '';
      }
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
            radius: 26,
          ),
          if (unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: unread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: unread ? FontWeight.bold : FontWeight.normal,
          color: unread ? Colors.black : Colors.grey[700],
        ),
      ),
      trailing: Text(
        formattedTime,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      onTap: onTap,
    );
  }
}

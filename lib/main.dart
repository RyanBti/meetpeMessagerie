import 'package:flutter/material.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const MeetPeopleChatApp());
}

class MeetPeopleChatApp extends StatelessWidget {
  const MeetPeopleChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeetPeople Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const ChatListScreen(),
      routes: {
        '/chat': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ChatScreen(
            currentUserId: args['currentUserId'],
            otherUserId: args['otherUserId'],
            username: args['username'],
          );
        },
      },
    );
  }
}

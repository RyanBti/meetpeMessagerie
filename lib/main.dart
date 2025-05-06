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
      initialRoute: '/',
      routes: {
        '/': (context) => const UserSelectorScreen(),
        '/chatList': (context) {
          final currentUserId = ModalRoute.of(context)!.settings.arguments as String;
          return ChatListScreen(currentUserId: currentUserId);
        },
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

class UserSelectorScreen extends StatelessWidget {
  const UserSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choisir un utilisateur")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/chatList', arguments: 'user123');
              },
              icon: const Icon(Icons.person),
              label: const Text("Se connecter en tant que user123"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/chatList', arguments: 'user456');
              },
              icon: const Icon(Icons.person_outline),
              label: const Text("Se connecter en tant que user456"),
            ),
          ],
        ),
      ),
    );
  }
}

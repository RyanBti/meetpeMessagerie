import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../services/socket_service.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.currentUserId, required this.otherUserId, required this.username});

  final String currentUserId;
  final String otherUserId;
  final String username;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    SocketService().connect(widget.currentUserId);
    fetchMessages();

    SocketService().socket.on('message', (data) {
      final msg = Message(
        from: data['from'],
        to: data['to'],
        content: data['message'],
        timestamp: DateTime.now(),
      );

      if (msg.from == widget.otherUserId) {
        setState(() {
          messages.add(msg);
        });
      }
    });
  }

  Future<void> fetchMessages() async {
    final url = 'http://192.168.10.26:3000/api/messages/${widget.currentUserId}/${widget.otherUserId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      setState(() {
        messages = data.map((json) => Message.fromJson(json)).toList();
      });
    } else {
      print('Erreur chargement messages: ${response.statusCode}');
    }
  }

  void handleSend(String text) {
    final msg = Message(
      from: widget.currentUserId,
      to: widget.otherUserId,
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(msg);
    });

    SocketService().sendMessage(text, widget.otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ChatBubble(
                  message: msg.content,
                  isMe: msg.from == widget.currentUserId,
                );
              },
            ),
          ),
          ChatInputField(onSend: handleSend),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../services/socket_service.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String username;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.username,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final SocketService socketService = SocketService();

  @override
  void initState() {
    super.initState();

    // Connexion WebSocket
    socketService.connect(widget.currentUserId);

    // Callback sur réception message
    socketService.onMessageReceived = (data) {
      final msg = Message(
        from: data['from'],
        to: data['to'],
        content: data['message'],
        timestamp: DateTime.parse(data['timestamp']),
      );

      if (msg.from == widget.currentUserId) return;
      // Si le message vient du bon utilisateur OU de moi-même, on l’ajoute
      if (msg.from == widget.otherUserId || msg.from == widget.currentUserId) {
        setState(() {
          messages.add(msg);
        });

        if (msg.from == widget.otherUserId) {
          markMessagesAsRead();
        }

        scrollToBottom();
      }
    };

    fetchMessages().then((_) {
      markMessagesAsRead();
      scrollToBottom();
    });
  }

  Future<void> fetchMessages() async {
    final url =
        'http://192.168.10.66:3000/api/messages/${widget.currentUserId}/${widget.otherUserId}';

    try {
      setState(() => isLoading = true);

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          messages = data.map((json) => Message.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        print('❌ Erreur chargement messages: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('❌ Exception fetchMessages: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> markMessagesAsRead() async {
    final url =
        'http://192.168.10.66:3000/api/messages/read/${widget.otherUserId}/${widget.currentUserId}';
    try {
      await http.put(Uri.parse(url));
    } catch (e) {
      print('❌ Erreur mise à jour des messages lus: $e');
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

    socketService.sendMessage(text, widget.otherUserId);
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    socketService.onMessageReceived = null;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.username,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Action de signalement
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                ? const Center(child: Text("Aucun message pour l'instant"))
                : ListView.builder(
              controller: _scrollController,
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
          const SizedBox(height: 8),
          ChatInputField(onSend: handleSend),
        ],
      ),
    );
  }
}

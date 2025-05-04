import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  void connect(String userId) {
    socket = IO.io('http://192.168.10.26:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'userId': userId},
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to WebSocket');
    });

    socket.onDisconnect((_) {
      print('Disconnected from WebSocket');
    });

    socket.on('message', (data) {
      print('New message received: $data');
    });
  }

  void sendMessage(String message, String toUserId) {
    socket.emit('message', {
      'to': toUserId,
      'message': message,
    });
  }
}

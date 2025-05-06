import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  bool _isConnected = false;

  /// ✅ Callback à définir dans ChatScreen pour traiter les messages reçus
  Function(dynamic data)? onMessageReceived;

  void connect(String userId) {
    if (_isConnected) {
      print('⚠️ Socket déjà connecté.');
      return;
    }

    socket = IO.io(
      'http://192.168.10.66:3000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'query': {'userId': userId},
      },
    );

    socket.connect();

    socket.onConnect((_) {
      _isConnected = true;
      print('✅ Connecté au WebSocket en tant que $userId');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      print('❌ Déconnecté du WebSocket');
    });

    socket.onConnectError((data) {
      print('❌ Erreur de connexion : $data');
    });

    socket.onError((data) {
      print('❌ Erreur socket : $data');
    });

    socket.on('message', (data) {
      print('📥 Nouveau message reçu : $data');
      if (onMessageReceived != null) {
        onMessageReceived!(data); // 🔄 Appelle le callback défini côté ChatScreen
      }
    });
  }

  void sendMessage(String message, String toUserId) {
    if (!_isConnected) {
      print('❌ Socket non connecté. Message non envoyé.');
      return;
    }

    print('📤 Envoi du message à $toUserId : $message');
    socket.emit('message', {
      'to': toUserId,
      'message': message,
    });
  }

  void disconnect() {
    if (_isConnected) {
      socket.disconnect();
      _isConnected = false;
      print('🔌 Socket manuellement déconnecté.');
    }
  }
}
import 'package:swarnet_admin_client/models/user.dart';

class ChatMessage {
  String text = "";
  DateTime? created;
  User? user;
  int chatId = -1;
  int isSent = 1;
  ChatMessage();

  ChatMessage.fromMap(Map<String, dynamic> map) {
    text = map['text'];
    created = DateTime.tryParse(map['created'] ?? "");

    if (map['user'] != null) {
      user = User.fromMap(map['user']);
    } else {
      user = User()..id = map['user_id'];
    }

    chatId = map['chat_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'chat_id': chatId,
      'created': created?.toIso8601String(),
      'text': text,
      'user_id': user?.id ?? -1,
      'is_sent': isSent
    };
  }
}

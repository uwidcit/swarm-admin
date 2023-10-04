class Chat{
  int id = 0;
  String name = "";

  Chat.fromMap(Map<String, dynamic> map){
    id = map['id'];
    name = map['chat_name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_name': name,
    };
  }

}
import 'package:uuid/uuid.dart';

class Tag{
  late String id;
  late String text;

  Tag.fromMap(Map<String, dynamic> map){
    id = map['id']??const Uuid().v4();
    text = map['text'];
  }

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "text": text,
    };
  }
}
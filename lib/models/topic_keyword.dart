class TopicKeyword{
  int id = 0;
  int topicId = 0;
  String keyword = "";

  TopicKeyword();

  TopicKeyword.fromMap(Map<String, dynamic> map){
    id = map['id'];
    topicId = map['topic_id'];
    keyword = map['keyword'];
  }

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'topic_id': topicId,
      'keyword': keyword
    };
  }
}
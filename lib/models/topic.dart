class Topic {
  int id = 0;
  bool subscriptionMandatory = false;
  bool subscriptionActive = false;
  String text = "";
  String keywords = "";
  double similarityThreshold = 0.0;
  int postCount = 0;
  bool shouldSync =
      false; // This here is for when things occur fully offline, we'd know what to sync w/ online

  List<String> get keywordList => keywords.split(",");

  Topic();

  Topic.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    text = map['text'];
    subscriptionMandatory = (map['subscription_mandatory'] is int)
        ? (map['subscription_mandatory'] == 1)
        : map['subscription_mandatory'];
    subscriptionActive = map.keys.toList().contains('subscription_active')
        ? (map['subscription_active'] is int)
            ? map['subscription_active'] == 1
            : map['subscription_active']
        : true;
    keywords = (map['keywords']);
    similarityThreshold = map['similarity_threshold'];
    postCount = map['post_count'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'keywords': keywords,
      'subscription_mandatory': subscriptionMandatory ? 1 : 0,
      'subscription_active': subscriptionActive ? 1 : 0,
      'should_sync': shouldSync ? 1 : 0,
      'similarity_threshold': similarityThreshold
    };
  }

  @override
  String toString() {
    return 'Topic: $text';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Topic && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^ text.hashCode;
  }
}

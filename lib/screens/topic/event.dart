import 'package:swarnet_admin_client/models/topic.dart';

abstract class TopicEvent {}

class InitEvent extends TopicEvent {}

class TopicFilterEvent extends TopicEvent {
  final String searchQuery;
  TopicFilterEvent(this.searchQuery);
}

class TopicCreateEvent extends TopicEvent {
  final String topicName;
  final String topicKeywords;
  final String similarityThreshold;

  TopicCreateEvent(
      this.topicName, this.topicKeywords, this.similarityThreshold);
}

class TopicDeleteEvent extends TopicEvent {
  final Topic topic;
  TopicDeleteEvent(this.topic);
}

class TopicEditEvent extends TopicEvent {
  final int id;
  final String topicName;
  final String topicKeywords;
  final String similarityThreshold;
  TopicEditEvent(
      this.id, this.topicName, this.topicKeywords, this.similarityThreshold);
}

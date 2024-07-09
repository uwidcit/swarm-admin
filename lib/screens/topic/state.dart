import 'package:swarnet_admin_client/models/topic.dart';

abstract class TopicState {}

class TopicLoadingState extends TopicState {}

class TopicLoadedState extends TopicState {
  final List<Topic> topics;
  final String query;
  TopicLoadedState(this.topics, {this.query = ""});
}

class TopicLoadingFailureState extends TopicLoadedState {
  TopicLoadingFailureState(super.topics);
}

import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/models/topic.dart';

abstract class PostEvent {}

class InitEvent extends PostEvent {}

class PostAddEvent extends PostEvent {
  final Post post;
  PostAddEvent(this.post);
}

class PostCreateEvent extends PostEvent {
  final Topic selectedTopic;
  final String content;
  PostCreateEvent(this.selectedTopic, this.content);
}

import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/models/topic.dart';

abstract class PostState {}

class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  final List<Post> posts;
  final List<Topic> topics;
  PostLoadedState(this.posts, this.topics);
}

class PostLoadFailState extends PostState {}

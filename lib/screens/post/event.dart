import 'package:swarnet_admin_client/models/post.dart';

abstract class PostEvent {}

class InitEvent extends PostEvent {}

class PostAddEvent extends PostEvent {
  final Post post;
  PostAddEvent(this.post);
}

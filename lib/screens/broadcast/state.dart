import 'package:swarnet_admin_client/models/post.dart';

abstract class BroadcastState {}

class BroadcastInitial extends BroadcastState {}

class BroadcastLoadedState extends BroadcastState {
  final List<Post> broadcasts;
  BroadcastLoadedState(this.broadcasts);
}

class BroadcastLoadingState extends BroadcastState {}

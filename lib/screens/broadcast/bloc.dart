import 'package:bloc/bloc.dart';
import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/services/api.dart';
import 'package:uuid/uuid.dart';

import 'event.dart';
import 'state.dart';

class BroadcastBloc extends Bloc<BroadcastEvent, BroadcastState> {
  final Api api = Api();
  BroadcastBloc() : super(BroadcastInitial()) {
    on<InitEvent>(_init);
    on<BroadcastCreateEvent>(_createBroadcast);
  }

  void _init(InitEvent event, Emitter<BroadcastState> emit) async {
    emit(BroadcastInitial());

    // Load broadcasts from API
    List<Post> broadcasts = await api.getPosts(topicIdFilter: "1");
    emit(BroadcastLoadedState(broadcasts));
  }

  void _createBroadcast(
      BroadcastCreateEvent event, Emitter<BroadcastState> emit) async {
    emit(BroadcastLoadingState());

    await api.createAdminPost({
      "text": event.text,
      "topic_id": 1,
    });

    // Load broadcasts from API
    List<Post> broadcasts = await api.getPosts(topicIdFilter: "1");
    emit(BroadcastLoadedState(broadcasts));
  }
}

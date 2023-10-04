import 'package:bloc/bloc.dart';
import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/models/topic.dart';
import 'package:swarnet_admin_client/services/api.dart';

import 'event.dart';
import 'state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final Api api = Api();

  PostBloc() : super(PostLoadingState()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());

    try {
      final List<Topic> topics = await api.getAllTopics();
      final List<Post> posts = await api.getPosts();
      emit(PostLoadedState(posts, topics));
    } catch (e) {
      emit(PostLoadFailState());
    }
  }
}

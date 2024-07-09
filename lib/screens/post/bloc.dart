import 'package:bloc/bloc.dart';
import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/models/topic.dart';
import 'package:swarnet_admin_client/models/user.dart';
import 'package:swarnet_admin_client/services/api.dart';
import 'package:uuid/uuid.dart';

import 'event.dart';
import 'state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final Api api = Api();
  List<Topic> topics = [];
  List<Post> posts = [];

  PostBloc() : super(PostLoadingState()) {
    on<InitEvent>(_init);
    on<PostCreateEvent>(_createPost);
  }

  void _init(InitEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());

    try {
      topics = (await api.getAllTopics())
          .where((element) => !element.subscriptionMandatory)
          .toList();

      posts = await api.getPosts();
      emit(PostLoadedState(posts, topics));
    } catch (e) {
      emit(PostLoadFailState());
    }
  }

  void _createPost(PostCreateEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());

    try {
      //TODO: Work on login and remove this
      api.user = User.fromMap({
        "id": 1,
        "credibility_score": 5.0,
        "first_name": "Admin",
        "last_name": "Test",
        "email": "admintest@mail.com",
        "profile_image": null,
      });
      Post p = Post.fromDevice(
          id: const Uuid().v4(),
          text: event.content,
          media: [],
          topic: event.selectedTopic,
          user: api.user!);

      if (await api.createPost(p)) {
        posts.insert(0, p);
      }

      emit(PostLoadedState(posts, topics));
    } catch (e) {
      emit(PostLoadFailState());
    }
  }
}

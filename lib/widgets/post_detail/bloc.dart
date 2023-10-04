import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc() : super(PostDetailState().init()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<PostDetailState> emit) async {
    emit(state.clone());
  }
}

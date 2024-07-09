import 'package:bloc/bloc.dart';
import 'package:swarnet_admin_client/models/topic.dart';
import 'package:swarnet_admin_client/services/api.dart';

import 'event.dart';
import 'state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final Api api = Api();
  List<Topic> topics = [];

  TopicBloc() : super(TopicLoadingState()) {
    on<InitEvent>(_init);
    on<TopicFilterEvent>(_filterTopics);
    on<TopicCreateEvent>(_createTopic);
    on<TopicDeleteEvent>(_deleteTopic);
    on<TopicEditEvent>(_editTopic);
  }

  void _init(InitEvent event, Emitter<TopicState> emit) async {
    emit(TopicLoadingState());

    try {
      topics = await api.getAllTopics();
      topics =
          topics.where((element) => !element.subscriptionMandatory).toList();
      emit(TopicLoadedState(topics));
    } catch (e) {
      emit(TopicLoadingFailureState(topics));
    }
  }

  void _filterTopics(TopicFilterEvent event, Emitter<TopicState> emit) async {
    emit(TopicLoadingState());
    try {
      emit(
        TopicLoadedState(
            topics
                .where((element) => element.text
                    .toLowerCase()
                    .contains(event.searchQuery.toLowerCase()))
                .toList(),
            query: event.searchQuery),
      );
    } catch (e) {
      emit(TopicLoadingFailureState(topics));
    }
  }

  void _createTopic(TopicCreateEvent event, Emitter<TopicState> emit) async {
    emit(TopicLoadingState());
    try {
      Topic t = Topic.fromMap({
        "id": 0,
        "text": event.topicName,
        "subscription_mandatory": 0,
        "subscription_active": 1,
        "keywords": event.topicKeywords,
        "similarity_threshold": double.parse(event.similarityThreshold),
        "post_count": 0
      });

      bool added = await api.createTopic(t);
      if (added) {
        topics.add(t);
      }
      emit(TopicLoadedState(topics));
    } catch (e) {
      emit(TopicLoadingFailureState(topics));
    }
  }
  void _deleteTopic(TopicDeleteEvent event, Emitter<TopicState> emit) async {
    emit(TopicLoadingState());
    try {

      bool removed = await api.deleteTopic(event.topic);
      if (removed) {
        topics.remove(event.topic);
      }
      emit(TopicLoadedState(topics));
    } catch (e) {
      emit(TopicLoadingFailureState(topics));
    }
  }
  void _editTopic(TopicEditEvent event, Emitter<TopicState> emit) async {
    emit(TopicLoadingState());
    try {
      await api.editTopic(event.id, event.topicName, event.topicKeywords, event.similarityThreshold);
      topics = await api.getAllTopics();
      topics =
          topics.where((element) => !element.subscriptionMandatory).toList();
      emit(TopicLoadedState(topics));
    } catch (e) {
      emit(TopicLoadingFailureState(topics));
    }
  }
}

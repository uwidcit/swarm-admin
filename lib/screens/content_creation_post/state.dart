import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swarnet_admin_client/models/topic.dart';

abstract class ContentCreationPostState {}

class ContentCreationLoadingState extends ContentCreationPostState {}

class ContentCreationLoadedState extends ContentCreationPostState {
  final List<XFile> attachments;
  final String content;
  final bool shouldShowLocation;
  final Topic? topic;
  final List<Topic> topicList;

  ContentCreationLoadedState(
      {required this.attachments,
      required this.content,
      required this.shouldShowLocation,
      required this.topic,
      required this.topicList});
}

class ContentCreationInvalidState extends ContentCreationLoadedState {
  final String failureReason;
  ContentCreationInvalidState(this.failureReason,
      {required super.attachments,
      required super.content,
      required super.shouldShowLocation,
      required super.topic,
      required super.topicList});
}

class ContentCreationValidState extends ContentCreationPostState {
  final int dbId;
  ContentCreationValidState(this.dbId);
}

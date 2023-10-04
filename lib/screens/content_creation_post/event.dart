import 'package:image_picker/image_picker.dart';
import 'package:swarnet_admin_client/models/topic.dart';

abstract class ContentCreationPostEvent {}

class InitEvent extends ContentCreationPostEvent {}

class ContentCreationVerifyPostEvent extends ContentCreationPostEvent {
  final List<XFile> attachments;
  final String content;
  final bool includeLocation;
  final Topic topic;
  final List<String> tags;

  ContentCreationVerifyPostEvent({required this.attachments, required this.content, required this.includeLocation, required this.topic, required this.tags});
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swarnet_admin_client/models/attachment.dart';
import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/models/topic.dart';
import 'package:swarnet_admin_client/services/api.dart';
import 'package:uuid/uuid.dart';

import 'event.dart';
import 'state.dart';

class ContentCreationPostBloc
    extends Bloc<ContentCreationPostEvent, ContentCreationPostState> {
  final Api api = Api();

  ContentCreationPostBloc() : super(ContentCreationLoadingState()) {
    on<InitEvent>(_init);
    on<ContentCreationVerifyPostEvent>(_determineAuthenticity);
  }

  void _init(InitEvent event, Emitter<ContentCreationPostState> emit) async {
    emit(ContentCreationLoadingState());

    final List<Topic> allTopics = [];
    await Future.delayed(const Duration(seconds: 1));

    emit(ContentCreationLoadedState(
        attachments: [],
        content: "",
        shouldShowLocation: false,
        topic: null,
        topicList: allTopics));
  }

  void _determineAuthenticity(ContentCreationVerifyPostEvent event,
      Emitter<ContentCreationPostState> emit) async {
    emit(ContentCreationLoadingState());

    //Get the location if need be
    Position? location;
    if (event.includeLocation) {
      location = await determinePosition();
    }
    Post newPost = Post.fromDevice(
        id: const Uuid().v4(),
        text: event.content,
        media: event.attachments
            .map((e) => Attachment.fromDevice(
                id: const Uuid().v4(),
                path: e.path,
                mimetype: e.mimeType ?? "image/*"))
            .toList(),
        topic: event.topic,
        user: api.user!,
        location: location);

    // Call to save post endpoint

    emit(ContentCreationValidState(2));
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
  }
}

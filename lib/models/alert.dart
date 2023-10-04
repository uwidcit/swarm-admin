import 'package:geolocator/geolocator.dart';
import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/models/topic.dart';
import 'package:swarnet_admin_client/models/user.dart';

class Alert extends Post {
  bool isFalse = false;
  bool isResolved = false;

  Alert.fromDevice(
      {required String id,
      required String text,
      required Topic topic,
      required User user,
      required Position location})
      : super.fromDevice(
            id: id,
            user: user,
            text: text,
            media: [],
            topic: topic,
            location: location);

  Alert.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    isFalse = (map['is_false'] is int) ? map['is_false'] == 1 : map['is_false'];
    isResolved = (map['is_resolved'] is int)
        ? map['is_resolved'] == 1
        : map['is_resolved'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map['is_false'] = isFalse ? 1 : 0;
    map['is_resolved'] = isResolved ? 1 : 0;
    return map;
  }
}

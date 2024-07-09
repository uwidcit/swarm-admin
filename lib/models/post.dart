import 'package:geolocator/geolocator.dart';
import 'package:swarnet_admin_client/models/attachment.dart';
import 'package:swarnet_admin_client/models/reply.dart';
import 'package:swarnet_admin_client/models/tag.dart';
import 'package:swarnet_admin_client/models/topic.dart';
import 'package:swarnet_admin_client/models/user.dart';

class Post {
  // Fields from model definition
  late String id;
  late User user;
  late Topic topic;
  late String text;
  late DateTime composed; // User Creation Time
  DateTime? created; // Backend Server Time
  DateTime? modified; // User Edit Time
  Position? location;
  List<Reply> replies = [];
  List<Tag> tags = [];
  List<Attachment> media = [];

  // Enrichment fields
  bool read = false;
  bool isLiked = false;
  bool isDisliked = false;
  int numLikes = 0;
  int numDislikes = 0;

  // keeps track on if the item needs syncing w/ server
  bool shouldSync = true;

  Post();

  Post.fromDevice(
      {required this.id,
      required this.text,
      required this.media,
      required this.topic,
      required this.user,
      this.location}) {
    composed = DateTime.now().toUtc();
  }

  Post.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> valMap = map.containsKey("post") ? map['post'] : map;
    id = valMap['id'];
    composed = DateTime.parse(valMap['composed']);

    created = DateTime.tryParse(valMap['created_date'] ?? "");
    modified = DateTime.tryParse(valMap['modified'] ?? "");
    if (valMap.containsKey("replies")) {
      replies =
          (valMap['replies'] as List).map((e) => Reply.fromMap(e)).toList();
    }
    if (valMap.containsKey("media")) {
      media = (valMap['media'] as List).map((e) {
        return Attachment.fromMap(e);
      }).toList();
    }
    if (valMap.containsKey("tags")) {
      tags = (valMap['tags'] as List).map((e) => Tag.fromMap(e)).toList();
    }
    if (valMap.containsKey("user")) {
      user = User.fromMap(valMap['user']);
    }
    if (valMap.containsKey("latitude") &&
        valMap.containsKey("longitude") &&
        valMap['latitude'] != null &&
        valMap['longitude'] != null) {
      location = Position.fromMap({
        "latitude": valMap['latitude'],
        "longitude": valMap['longitude'],
      });
    }
    if (valMap.containsKey("topic")) {
      topic = Topic.fromMap(valMap['topic']);
    }
    text = valMap['text'];

    isLiked = false;
    isDisliked = false;
    numLikes = 0;
    numDislikes = 0;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> postMap = {
      'id': id,
      'topic_id': topic.id,
      'user_id': user.id,
      'composed': composed.toIso8601String(),
      "num_replies": replies.length,
      "text": text,
      "is_liked": isLiked ? 1 : 0,
      "is_disliked": isDisliked ? 1 : 0,
      "likes": numLikes,
      "dislikes": numDislikes
    };

    if (created != null) {
      postMap['created_date'] = created!.toIso8601String();
    }
    if (modified != null) {
      postMap['modified'] = modified!.toIso8601String();
    }
    if (location != null) {
      postMap['latitude'] = location!.latitude;
      postMap['longitude'] = location!.longitude;
    }
    return postMap;
  }

  Map<String, dynamic> toMapForTransmit() {
    Map<String, dynamic> postMap = toMap();
    postMap['user'] = user.toMap();
    postMap['tags'] = tags.map((e) => e.toMap()).toList();
    postMap['replies'] = replies.map((e) => e.toMapForTransmit()).toList();
    postMap['is_liked'] =
        0; //resetting because the person receiving doesn't automatically like the post
    postMap['is_disliked'] =
        0; //resetting because the person receiving doesn't automatically like the post
    postMap['media'] = media.map((e) => e.toMapForTransmit()).toList();
    postMap['replies'] = replies.map((e) => e.toMap()).toList();
    postMap['topic'] = topic.toMap();
    return postMap;
  }
}

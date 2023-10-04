import 'package:swarnet_admin_client/models/post.dart';

class Reply extends Post {
  late String parentId;

  Reply.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    parentId = map['parent_id'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map['parent_id'] = parentId;
    return map;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Attachment {
  late String id; //UUID for media
  late String path; //path to file on device
  late String mimetype; // media type of attachment

  Attachment();

  Attachment.fromDevice(
      {required this.id, required this.path, required this.mimetype});

  Attachment.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? const Uuid().v4();
    mimetype = map['mimetype'];
    path = map['url'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "path": path,
      "mimetype": mimetype,
    };
  }

  Map<String, dynamic> toMapForTransmit() {
    return {
      "id": id,
      "mimetype": mimetype,
      "data": base64Encode(File(path).readAsBytesSync())
    };
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:swarnet_admin_client/models/attachment.dart';

class User {
  int id = 0;
  double credScore = 0;
  String first_name = "";
  String last_name = "";
  String email = "";
  String? get profile_image_url => profile_image?.path;
  Attachment? profile_image;
  Uint8List? tempProfilePicBytes;
  Attachment? tempProfilePic;
  User();

  String get name => "$first_name $last_name";

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    credScore = map['credibility_score'];
    first_name = map['first_name'];
    last_name = map['last_name'];
    email = map['email'];
    profile_image = map['profile_image'] != null
        ? Attachment.fromMap(map['profile_image'])
        : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'credibility_score': credScore,
      'first_name': first_name,
      'last_name': last_name,
      'email': email
    };
  }

  ImageProvider getImageProvider() {
    if (tempProfilePicBytes != null) {
      return MemoryImage(tempProfilePicBytes!);
    }
    if (profile_image_url != null) {
      return NetworkImage(profile_image_url!);
    }
    return const AssetImage("assets/img/blank_profile.png");
  }
}

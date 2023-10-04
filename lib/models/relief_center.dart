import 'package:flutter/material.dart';
import 'package:swarnet_admin_client/models/attachment.dart';

class ReliefCenter {
  String get address => "$line_1, $city";
  String city = "";
  String email = "";
  String firstName = "";
  int id = 0;
  String lastName = "";
  String get name => "$firstName $lastName";

  double latitude = 0;
  String line_1 = "";
  String line_2 = "";
  double longitude = 0;

  String phone = "";

  Attachment? profileImage;
  String? get profileImageUrl => profileImage?.path;

  ReliefCenter();

  ReliefCenter.fromMap(Map<String, dynamic> map) {
    city = map['city'];
    email = map['email'];
    firstName = map['first_name'];
    id = map['id'];
    lastName = map['last_name'];
    latitude = map['latitude'];
    line_1 = map['line_1'];
    line_2 = map['line_2'];
    longitude = map['longitude'];
    phone = map['phone'];
    profileImage = map['profile_image'] != null
        ? Attachment.fromMap(map['profile_image'])
        : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'latitude': latitude,
      'line_1': line_1,
      'line_2': line_2,
      'longitude': longitude,
      'phone': phone,
    };
  }

  ImageProvider getImageProvider() {
    if (profileImageUrl != null) {
      return NetworkImage(profileImageUrl!);
    }
    return const AssetImage("assets/img/blank_profile.png");
  }
}

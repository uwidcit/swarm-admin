import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:swarnet_admin_client/models/alert.dart';
import 'package:swarnet_admin_client/models/attachment.dart';
import 'package:swarnet_admin_client/models/post.dart';
import 'package:swarnet_admin_client/models/topic.dart';
import 'package:swarnet_admin_client/models/user.dart';
import 'package:swarnet_admin_client/services/shared_preferences_manager.dart';

class Api {
  Client client = Client();
  SharedPreferencesManager manager = SharedPreferencesManager();
  User? user;
  final String host = "swarnet.sundaebytes.com";
  Socket? webSocketChannel;

  static final Api _instance = Api._internal();
  Api._internal();
  factory Api() {
    return _instance;
  }

  // Calls for Admin App

  Future<List<Post>> getPosts({String topicIdFilter = ""}) async {
    final url = topicIdFilter.isEmpty
        ? "api/admin/posts"
        : "api/admin/posts/topic/$topicIdFilter";
    try {
      Response resp = await jsonGet(url);
      if (resp.statusCode == 200) {
        Map<String, dynamic> decodedResponse =
            jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
        List<dynamic> postMapList = decodedResponse['posts'];
        List<Post> postList = postMapList.map((e) => Post.fromMap(e)).toList();
        return postList;
      }
      return [];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> createAdminPost(Map<String, dynamic> adminPost) async {
    const url = "api/admin/posts";
    try {
      Response resp = await jsonPost(url, adminPost);
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Topic>> getAllTopics() async {
    const url = "api/topics";
    try {
      Response resp = await jsonGet(url);
      if (resp.statusCode == 200) {
        Map<String, dynamic> decodedResponse =
            jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
        List<dynamic> topicMapList = decodedResponse['topics'];

        List<Topic> topicList =
            topicMapList.map((e) => Topic.fromMap(e)).toList();
        return topicList;
      } else {
        return [];
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Alert>> getAlerts() async {
    const url = '/api/common/alert';
    try {
      Response resp = await jsonGet(url);
      if (resp.statusCode == 200) {
        Map<String, dynamic> decodedResponse =
            jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
        List<dynamic> alertMapList = decodedResponse['alerts'];
        List<Alert> alertList =
            alertMapList.map((e) => Alert.fromMap(e)).toList();
        return alertList;
      }
      return [];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> setAlertResolved(String alertId) async {
    final url = '/api/admin/alert/resolve/$alertId';
    try {
      Response resp = await jsonPut(url, {});
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setAlertFalse(String alertId) async {
    final url = '/api/admin/alert/falsify/$alertId';
    try {
      Response resp = await jsonPut(url, {});
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createPost(Post p) async {
    const url = 'api/user/feed';
    try {
      Response resp = await jsonPost(url, p.toMapForTransmit());
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createTopic(Topic t) async {
    const url = 'api/admin/topics';
    try {
      Response resp = await jsonPost(url, t.toMap());
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTopic(Topic t) async {
    const url = 'api/admin/topics';
    try {
      Response resp = await jsonDelete(url, {
        "topic_id": t.id,
      });
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editTopic(
      int id, String name, String keywords, String simScore) async {
    const url = 'api/admin/topics';
    try {
      Response resp = await jsonPut(url, {
        "topic_id": id,
        "text": name,
        "keywords": keywords,
        "similarity_threshold": simScore,
      });
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // BELOW IS CODE COPIED FROM SWARNET
  Future<Response> getUserProfile() async => await jsonGet('api/common/user');

  Future<Response> login(String username, String password) async =>
      jsonPost('api/admin/login', {"username": username, "password": password});

  Future<Response> register(
          String fName, String lName, String email, String pass) async =>
      jsonPost('api/register', {
        "firstname": fName,
        "lastname": lName,
        "email": email,
        "password": pass
      });

  Future<Response> forgotPassword(String username) async =>
      await jsonPost('api/reset-password', {"email": username});

  Future<Response> getAllTopicKeywords() async =>
      await jsonGet('api/common/keywords');

  Future<bool> isServerAlive() async {
    try {
      return (await jsonGet('api/status')).statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Response> getAllUserTopics() async => await jsonGet('api/user/topics');

  Future<Response> subscribeToTopic(int topicId) async =>
      await jsonPut('api/user/topics', {"topic_id": topicId});

  Future<Response> unsubscribeFromTopic(int topicId) async =>
      await jsonDelete("api/user/topics", {"topic_id": topicId});

  //Avoid duplicate calls to endpoint, return cached user if available
  Future<User> getUser() async {
    if (user == null) {
      Response userData = await getUserProfile();
      if (userData.statusCode == 200) {
        Map<String, dynamic> decodedResponse =
            jsonDecode(utf8.decode(userData.bodyBytes)) as Map<String, dynamic>;
        user = User.fromMap(decodedResponse);
      } else {
        return Future.error("An error has occurred");
      }
    }
    return user!;
  }

  Future<Response> editProfile(String firstName, String lastName, String email,
      Attachment? attachment) async {
    final String accessToken = await manager.getAccessToken();

    var uri = Uri.https(host, 'api/common/user');
    var request = MultipartRequest('POST', uri)
      ..fields['first_name'] = firstName
      ..fields['last_name'] = lastName
      ..fields['email'] = email
      ..headers['Authorization'] = "Bearer $accessToken";

    if (attachment != null) {
      request.files.add(await MultipartFile.fromPath('image', attachment.path,
          contentType: MediaType('image', '*')));
    }
    var response = await request.send();
    return Response.fromStream(response);
  }

  Future<Response> logout() async {
    Response result = await jsonPost('/api/common/logout', {});
    await manager.removeAccessToken();
    user = null;
    return result;
  }

  Future<Response> getFeed({int page = 1}) async => await jsonGet(
        '/api/user/feed/$page',
      );

  // Future<Response> createAlert(Alert a) async =>
  //     jsonPost('api/common/alert', a.toMapForTransmit());
  //

  Future<Response> likePost(String postId) async =>
      await jsonPost('/api/common/post/like', {"post_id": postId});

  Future<Response> unlikePost(String postId) async =>
      await jsonDelete('/api/common/post/like', {"post_id": postId});

  Future<Response> dislikePost(String postId) async =>
      await jsonPost('/api/common/post/dislike', {"post_id": postId});

  Future<Response> undislikePost(String postId) async =>
      await jsonDelete('/api/common/post/dislike', {"post_id": postId});

  Future<Response> getCommentsForPost(String postId) async => jsonGet(
        '/api/common/post/$postId/comments',
      );

  Future<Response> postCommentReply(
          String postId, int topicId, String comment) async =>
      jsonPost('api/common/post/comments', {
        'text': comment,
        'post_id': postId,
        'topic_id': topicId,
        'composed':
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc()),
      });

  Future<Response> createChatForUser(int uid) async =>
      jsonPost('/api/common/chats', {"user_id": uid});

  Future<Response> getChatList() async => jsonGet('/api/common/chats');

  Future<Response> getChatById(int chatId) async =>
      jsonGet('/api/common/chat/$chatId');

  Future<Response> sendChatMessage(int chatId, String message) async =>
      await jsonPut(
          '/api/common/chats', {"chat_id": chatId, "message": message});

  Future<Response> getReliefCenters() async =>
      jsonGet('api/common/relief_center');

  Future<Response> jsonGet(path) async {
    final String accessToken = await manager.getAccessToken();
    return await client.get(Uri.https(host, path), headers: {
      "content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    });
  }

  Future<Response> jsonPost(path, Map<String, dynamic> params) async {
    final String accessToken = await manager.getAccessToken();

    return await client.post(Uri.https(host, path),
        body: jsonEncode(params),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $accessToken"
        });
  }

  Future<Response> jsonDelete(path, Map<String, dynamic> params) async {
    final String accessToken = await manager.getAccessToken();
    return await client.delete(Uri.https(host, path),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode(params));
  }

  Future<Response> jsonPut(path, Map<String, dynamic> params) async {
    final String accessToken = await manager.getAccessToken();
    return await client.put(Uri.https(host, path),
        body: jsonEncode(params),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $accessToken"
        });
  }

  Socket getWebsocketChannel() {
    webSocketChannel = io(
        "wss://$host",
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    return webSocketChannel!;
  }
}

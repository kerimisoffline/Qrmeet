import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrmeet/models/chat_model.dart';
import 'package:qrmeet/models/message.dart';
import 'package:qrmeet/models/scan_detail.dart';
import 'package:qrmeet/models/scanned_qr.dart';
import 'package:qrmeet/services/base_list_response.dart';
import 'package:qrmeet/services/error_response.dart';
import 'package:qrmeet/utils/constants.dart';
import 'dart:convert';
import 'package:qrmeet/models/source.dart';
import 'package:qrmeet/services/base_response.dart';

import '../models/hits.dart';
import '../models/user.dart';

class HttpServices {
  //Get all users
  static Future<List<User>?> fetchUsers() async {
    List<User>? users;
    var url = baseUrl + "users";
    debugPrint("kerimDebuginside");
    final response = await http.get(Uri.parse(url));
    debugPrint("kerimDebug ${response.statusCode}");
    var baseListResponse =
        BaseListResponse<User>.fromJson(json.decode(response.body), (data) {
      List<User?> userMap = data.map((e) => User.fromJson(e)).toList();
      return userMap;
    });
    if (response.statusCode == 200) {
      users = baseListResponse.data;
      return users;
    } else {
      debugPrint(baseListResponse.message);
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }

  //log in to system

  static Future<User?> getLoginStatusBase(String mail, String password) async {
    User? user;
    debugPrint("mail $mail pass $password");

    final response = await http.post(
      Uri.parse(baseUrl + "login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'mail': mail,
        'password': password,
      }),
    );

    debugPrint("kerimDebug ${response.statusCode}");

    if (response.statusCode == 200) {
      //List<Source>? sources = sourcesJson !=null ? List.from(sourcesJson) : null;
      debugPrint("res" + response.body);
      var baseResponse = BaseResponse<User>.fromJson(
          json.decode(response.body), (data) => User.fromJson(data));
      user = baseResponse.data;
      return user;
    } else {
      var errorRespone = ErrorResponse.fromJson(json.decode(response.body));
      debugPrint(errorRespone.message);
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }

  static Future<User?> registerNewUser(
      String username, String mail, String password) async {
    User? user;
    debugPrint("mail $mail pass $password");

    final response = await http.put(
      Uri.parse(baseUrl + "login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'mail': mail,
        'password': password,
      }),
    );

    debugPrint("kerimDebug ${response.statusCode}");

    if (response.statusCode == 200) {
      //List<Source>? sources = sourcesJson !=null ? List.from(sourcesJson) : null;
      debugPrint("res" + response.body);
      var baseResponse = BaseResponse<User>.fromJson(
          json.decode(response.body), (data) => User.fromJson(data));
      user = baseResponse.data;
      return user;
    } else {
      var errorRespone = ErrorResponse.fromJson(json.decode(response.body));
      debugPrint(errorRespone.message);
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }

  static Future<List<Hit>?> fetchHitPage() async {
    List<Hit>? hits;
    var url = baseUrl + "hits";
    debugPrint("kerim hit page fetching");
    final response = await http.get(Uri.parse(url));
    debugPrint("kerimDebug ${response.statusCode}");

    if (response.statusCode == 200) {
      var baseListResponse =
          BaseListResponse<Hit>.fromJson(json.decode(response.body), (data) {
        List<Hit?> hitMap = data.map((e) => Hit.fromJson(e)).toList();
        return hitMap;
      });
      hits = baseListResponse.data;
      return hits;
    } else {
      var errorResponse = ErrorResponse.fromJson(json.decode(response.body));
      debugPrint(errorResponse.message);
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }

  static Future<List<ScannedQr>?> fetchRecentPage(String userId) async {
    List<ScannedQr>? scannedQr;
    debugPrint("userId $userId");

    final response = await http.post(
      Uri.parse(baseUrl + "scanned_qrs/" + userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    debugPrint("kerimDebug ${response.statusCode}");

    if (response.statusCode == 200) {
      var baseListResponse = BaseListResponse<ScannedQr>.fromJson(
          json.decode(response.body), (data) {
        List<ScannedQr?> hitMap =
            data.map((e) => ScannedQr.fromJson(e)).toList();
        return hitMap;
      });
      scannedQr = baseListResponse.data;
      return scannedQr;
    } else {
      var errorResponse = ErrorResponse.fromJson(json.decode(response.body));
      debugPrint(errorResponse.message);
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }

  static Future<List<ScanDetail>?> fetchScanDetailUsers(String qrId) async {
    List<ScanDetail>? scannedQr;
    debugPrint("qrId $qrId");

    final response = await http.post(
      Uri.parse(baseUrl + "qr_detail/" + qrId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    debugPrint("kerimDebug ${response.statusCode}");
    debugPrint("kerimDebug ${response.body}");
    if (response.statusCode == 200) {
      var baseListResponse = BaseListResponse<ScanDetail>.fromJson(
          json.decode(response.body), (data) {
        List<ScanDetail?> hitMap =
            data.map((e) => ScanDetail.fromJson(e)).toList();
        return hitMap;
      });
      scannedQr = baseListResponse.data;
      return scannedQr;
    } else {
      var errorResponse = ErrorResponse.fromJson(json.decode(response.body));
      debugPrint(errorResponse.message);
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }

  static Future<ScannedQr?> postNewScan(
      String qrLink, String qrTitle, int userId) async {
    ScannedQr? scannedQr;

    final response = await http.post(
      Uri.parse(baseUrl + "scanned_qrs"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'qr_link': qrLink,
        'qr_title': qrTitle,
        'user_id': userId,
      }),
    );

    debugPrint("kerimDebug ${response.statusCode}");

    if (response.statusCode == 200) {
      //List<Source>? sources = sourcesJson !=null ? List.from(sourcesJson) : null;
      debugPrint("res" + response.body);
      var baseResponse = BaseResponse<ScannedQr>.fromJson(
          json.decode(response.body), (data) => ScannedQr.fromJson(data));
      scannedQr = baseResponse.data;
      return scannedQr;
    } else {
      var errorRespone = ErrorResponse.fromJson(json.decode(response.body));
      debugPrint(errorRespone.message);
      return null;
    }
  }

  static Future<List<ChatModel>?> fetchChatList(String userId) async {
    List<ChatModel>? chatList;
    debugPrint("chatList user_id $userId");
    final response = await http.post(
      Uri.parse(baseUrl + "chat_list/" + userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    debugPrint("kerimDebug ${response.statusCode}");
    debugPrint("kerimDebug ${response.body}");
    if (response.statusCode == 200) {
      var baseListResponse = BaseListResponse<ChatModel>.fromJson(
          json.decode(response.body), (data) {
        List<ChatModel?> hitMap =
            data.map((e) => ChatModel.fromJson(e)).toList();
        return hitMap;
      });
      chatList = baseListResponse.data;
      return chatList;
    } else {
      var errorResponse = ErrorResponse.fromJson(json.decode(response.body));
      debugPrint(errorResponse.message);
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }

  static Future<List<Message>?> fetchMessageChannel(String chatId) async {
    List<Message>? messageList;
    debugPrint("messageList with chat_id $chatId");
    final response = await http.post(
      Uri.parse(baseUrl + "get_chat/" + chatId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    debugPrint("kerimDebug ${response.statusCode}");
    debugPrint("kerimDebug ${response.body}");
    if (response.statusCode == 200) {
      var baseListResponse = BaseListResponse<Message>.fromJson(
          json.decode(response.body), (data) {
        List<Message?> hitMap = data.map((e) => Message.fromJson(e)).toList();
        return hitMap;
      });
      messageList = baseListResponse.data;
      return messageList;
    } else {
      var errorResponse = ErrorResponse.fromJson(json.decode(response.body));
      debugPrint(errorResponse.message);
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }

  static Future<List<Message>?> fetchMessageSeenStatus(String chatId, String receiverID) async {
    debugPrint("chat_id $chatId");
    debugPrint("receiver_id $chatId");
    final response = await http.post(
      Uri.parse(baseUrl + "update_chat"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'receiver_id': receiverID,
        'chat_id': chatId,
      }),
    );
    debugPrint("kerimDebug updateSeenResponse ${response.statusCode}");
    return null;
  }

  static Future<Message?> postNewMessage(Message message) async {
    Message? _message;

    final response = await http.post(
      Uri.parse(baseUrl + "get_chat"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'message': message.message,
        'sender_id': message.senderID,
        'receiver_id': message.receiverID,
        'chat_id': message.chatID,
      }),
    );

    debugPrint("kerimDebug ${response.statusCode}");

    if (response.statusCode == 200) {
      //List<Source>? sources = sourcesJson !=null ? List.from(sourcesJson) : null;
      debugPrint("res" + response.body);
      var baseResponse = BaseResponse<Message>.fromJson(
          json.decode(response.body), (data) => Message.fromJson(data));
      _message = baseResponse.data;
      return _message;
    } else {
      var errorRespone = ErrorResponse.fromJson(json.decode(response.body));
      debugPrint(errorRespone.message);
      return null;
    }
  }
}

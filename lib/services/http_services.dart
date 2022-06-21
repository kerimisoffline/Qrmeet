import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

static Future<User?> registerNewUser(String username,String mail, String password) async {
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
}

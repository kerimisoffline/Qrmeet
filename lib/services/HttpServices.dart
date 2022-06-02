import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:qrmeet/utils/constants.dart';
import 'dart:convert';
import 'package:qrmeet/models/Source.dart';

class HttpServices {
  //Get all users
  static Future<List<Source>?> fetchSources() async {
    var url = baseUrl + "users";
    debugPrint("kerimDebuginside");
    final response = await http.get(Uri.parse(url));
    debugPrint("kerimDebug ${response.statusCode}");
    if (response.statusCode == 200) {
      String arrayText = response.body;
      var sourcesJson = jsonDecode(arrayText)["users"];
      debugPrint("kerimDebug $sourcesJson");
      //List<Source>? sources = sourcesJson !=null ? List.from(sourcesJson) : null;
      return sourceFromJson(json.encode(sourcesJson));
    } else {
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }

  //log in to system
  static Future<Source?> getLoginStatus(String mail, String password) async {
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
      return singleSourceFromJson(response.body);
    } else {
      debugPrint("kerimDebug null geldi ");
      return null;
    }
  }
}

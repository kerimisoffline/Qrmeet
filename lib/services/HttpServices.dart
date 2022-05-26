import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qrmeet/models/Source.dart';

class HttpServices {
  static Future<List<Source>?> fetchSources() async {
    var url = 'http://89.252.153.250:8081/api/users';
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
}

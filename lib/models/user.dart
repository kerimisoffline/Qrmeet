import 'dart:html';

import 'package:flutter/foundation.dart';

class User {
  int id;
  String name;
  String mail;

  User({required this.id, required this.name, required this.mail});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json["id"], name: json["name"], mail: json["mail"]);
  }
}

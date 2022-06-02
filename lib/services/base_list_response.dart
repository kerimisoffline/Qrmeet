import 'package:flutter/material.dart';

class BaseListResponse<T> {
  bool status;
  String message;
  List<T>? data;

  BaseListResponse(
      {required this.status, required this.message, required this.data});

  factory BaseListResponse.fromJson(
      Map<String, dynamic> json, Function(List<dynamic>) build) {
    return BaseListResponse<T>(
        status: json["status"],
        message: json["message"],
        data: build(json["data"]));
  }
}
import 'package:flutter/material.dart';

class BaseResponse<T> {
  bool status;
  String message;
  T? data;

  BaseResponse(
      {required this.status, required this.message, required this.data});

  factory BaseResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) build) {
    return BaseResponse<T>(
        status: json["status"],
        message: json["message"],
        data: build(json["data"]));
  }
}

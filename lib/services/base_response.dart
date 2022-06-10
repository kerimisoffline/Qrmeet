import 'package:flutter/material.dart';

class BaseResponse<T> {
  bool? success;
  String? message;
  T? data;

  BaseResponse(
      {required this.success, required this.message, required this.data});

  factory BaseResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) build) {
    return BaseResponse<T>(
        success: json["success"],
        message: json["message"],
        data: build(json["data"]));
  }
  
}

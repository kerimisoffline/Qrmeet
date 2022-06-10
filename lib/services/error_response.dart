import 'package:flutter/material.dart';

class ErrorResponse<T> {
  bool? success;
  String? message;

  ErrorResponse(
      {required this.success, required this.message});

  factory ErrorResponse.fromJson(
      Map<String, dynamic> json) {
    return ErrorResponse<T>(
        success: json["success"],
        message: json["message"]);
  }
  
}

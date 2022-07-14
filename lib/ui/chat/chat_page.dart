import 'dart:math';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/utils/converter.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPage extends StatelessWidget {
  final TextEditingController scanTitleController = TextEditingController();

  ChatPage({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'www.facebook.com\nreckols',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            enableSuggestions: false,
            autocorrect: false,
            style: const TextStyle(color: Colors.black),
            controller: scanTitleController,
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: AppLocalizations.of(context)!.enter_title,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.ok,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () {
            debugPrint(scanTitleController.text);
          },
        )
      ],
    );
  }
}

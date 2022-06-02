import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatelessWidget {
  final Controller controller = Get.find();
  
  RegisterPage({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.register_page)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: context.dynamicWidth(0.4),
                  child: TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: AppLocalizations.of(context)!.username_hint,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.send, color: Colors.grey, size: 24.0),
                )
              ],
            ),
          ),
        ));
  }
}

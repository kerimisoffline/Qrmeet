//import 'dart:ffi';
//import 'dart:html';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/models/source.dart';
import 'package:qrmeet/models/user.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:qrmeet/ui/login/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qrmeet/utils/http_sertificate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(GetMaterialApp(
      title: "QrMeet",
      theme: ThemeData(fontFamily: "Poppins"),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: LoginPage()));
}

class Controller extends GetxController {
  var count = 0.obs;
  var userList = <User>[].obs;
  var loginResponse = Source;

  increment() => count++;

  @override
  void onInit() {
    //fetchElements();
    super.onInit();
  }

  void fetchElements() async {
    debugPrint("kerimDebug1");
    try {
      var usersResponse = await HttpServices.fetchUsers();
      if (usersResponse != null) {
        debugPrint("kerimDebug2 $usersResponse");
        userList.assignAll(usersResponse);
      } else {
        debugPrint('null geldi');
      }
    } catch (err) {
      debugPrint('Caught error: $err');
    }
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final Controller controller = Get.put(Controller());

  @override
  Widget build(context) {
    return Material(
      child: GestureDetector(
        onTap: () => Get.to(() => LoginPage()),
        child: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset('assets/backgroundImages/loader.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(AppLocalizations.of(context)!.login_page,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300))),
            )
          ],
        ),
      ),
    );
  }
}

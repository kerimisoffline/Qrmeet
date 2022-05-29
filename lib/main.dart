import 'dart:ffi';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/models/Source.dart';
import 'package:qrmeet/services/HttpServices.dart';
import 'package:qrmeet/ui/user_list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qrmeet/ui/login/login_page.dart';

void main() => runApp(GetMaterialApp(
    title: "QrMeet",
    theme: ThemeData(fontFamily: "Poppins"),
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Home()));

class Controller extends GetxController {
  var count = 0.obs;
  var sourceList = <Source>[].obs;
  var loginResponse = Source;

  increment() => count++;

  @override
  void onInit() {
    fetchElements();
    super.onInit();
  }

  void fetchElements() async {
    debugPrint("kerimDebug1");
    try {
      var sources = await HttpServices.fetchSources();
      if (sources != null) {
        debugPrint("kerimDebug2 $sources");
        sourceList.assignAll(sources);
      } else {
        debugPrint('null geldi');
      }
    } catch (err) {
      debugPrint('Caught error: $err');
    }
  }

  void fetchLogin() async {
    debugPrint("fetchLogin");
    try {
      var sources = await HttpServices.getLoginStatus();
      if (sources != null) {
        debugPrint("kerimDebug2 $sources");
        loginResponse = so
      } else {
        debugPrint('null geldi');
      }
    } catch (err) {
      debugPrint('Caught error: $err');
    }
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    final Controller controller = Get.put(Controller());
    return Scaffold(
        appBar: AppBar(title: Obx(() => Text("Clicks: ${controller.count}"))),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context)!.login_page,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                onPressed: () => Get.to(LoginPage()),
              ),
            ),
            Center(
              child: ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context)!.user_list,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                onPressed: () => Get.to(UserList()),
              ),
            ),
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.trade_page),
                    onPressed: () => Get.to(LoginPage())),
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.local_market),
                    onPressed: () => Get.to(LoginPage())),
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.workshop),
                    onPressed: () => Get.to(LoginPage())),
                ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.adventure),
                    onPressed: () => Get.to(LoginPage())),
              ],
            )
            */
          ],
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: controller.increment,
        ));
  }
}

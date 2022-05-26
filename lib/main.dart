import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/models/Source.dart';
import 'package:qrmeet/services/HttpServices.dart';
import 'package:qrmeet/ui/tradePage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(GetMaterialApp(
    title: "QrMeet",
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
}

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    final Controller controller = Get.put(Controller());
    return Scaffold(
        appBar: AppBar(title: Obx(() => Text("Clicks: ${controller.count}"))),
        body: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                child: Text(AppLocalizations.of(context)!.trade_page),
                onPressed: () => Get.to(TradePageView())),
            ElevatedButton(
                child: Text(AppLocalizations.of(context)!.local_market),
                onPressed: () => Get.to(TradePageView())),
            ElevatedButton(
                child: Text(AppLocalizations.of(context)!.workshop),
                onPressed: () => Get.to(TradePageView())),
            ElevatedButton(
                child: Text(AppLocalizations.of(context)!.adventure),
                onPressed: () => Get.to(TradePageView())),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: controller.increment,
        ));
  }
}

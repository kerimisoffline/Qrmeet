import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/ui/hits/hits_page.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/utils/converter.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanDetailPageController extends GetxController {
  dynamic argumentData = Get.arguments;
  var qrTitle = "".obs;
  var qrId = 0.obs;
  final _isLoading = true.obs;

  void fetchScanDetailPage() async {
    try {
      /*
      _isLoading.value = true;
      var sources = await HttpServices.fetchRecentPage(mainUser.id.toString());
      if (sources != null) {
        _isLoading.value = false;
        sources = sources.reversed.toList();
        scannedQrData.clear();
        for (var i = 0; i < 9; i++) {
          if (sources.length <= i) break;
          scannedQrData.add(sources[i]);
        }
      } else {
        _isLoading.value = false;
      }
      */
    } catch (err) {
      _isLoading.value = false;
      debugPrint('Caught error: $err');
    }
  }

  @override
  void onInit() {
    qrId.value = argumentData[0]['qrId'];
    qrTitle.value = argumentData[1]['qrTitle'];
    debugPrint("qrid: " + qrId.value.toString());
    debugPrint("qrTitle: " + qrTitle.value);
    fetchScanDetailPage();
    super.onInit();
  }
}

class ScanDetailPage extends StatelessWidget {
  ScanDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    return scanField(context);
  }
}

Widget scanField(BuildContext context) {
  final ScanDetailPageController scanDetailPageController =
      Get.put(ScanDetailPageController());
  return Obx(() => Column(children: <Widget>[
        Column(
          children: <Widget>[Text(scanDetailPageController.qrTitle.value)],
        ),
        scanDetailList(context),
      ]));
}

Widget scanDetailList(BuildContext context) {
  return Container();
}

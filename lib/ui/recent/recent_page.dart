import 'dart:ffi';
import 'dart:math';
import 'package:qrmeet/models/scanned_qr.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/ui/scan/scan_page.dart';
import 'package:qrmeet/utils/converter.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RecentPage extends StatelessWidget {
  final LandingController landingController = Get.find();
  RecentPage({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    List<ScannedQr>? scannedQrList;
    scannedQrList = landingController.scannedQrData;
    return Obx(() => GridView.count(
          childAspectRatio: 0.55,
          padding: const EdgeInsets.all(10.0),
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: List.generate(scannedQrList!.length,
              (index) => recentCard(context, scannedQrList![index])),
        ));
  }
}

Widget recentCard(BuildContext context, ScannedQr scannedQr) {
  return Column(
    children: [
      QrImage(
        data: "${scannedQr.qrTitle}",
        version: QrVersions.auto,
        size: 100.0,
      ),
      Text(
        'Item ${scannedQr.qrTitle}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.black,
            fontSize: context.dynamicWidth(0.040),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
      Padding(
        padding: EdgeInsets.all(context.dynamicWidth(0.05)),
        child: Text(
          'Item ${scannedQr.id}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black,
              fontSize: context.dynamicWidth(0.030),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w300),
        ),
      ),
    ],
  );
}

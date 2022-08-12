import 'dart:ffi';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:qrmeet/models/scanned_qr.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/ui/scan/scan_detail_page.dart';
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
          padding: const EdgeInsets.all(16.0),
          crossAxisCount: 3,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          children: List.generate(scannedQrList!.length,
              (index) => recentCard(context, scannedQrList![index])),
        ));
  }
}

Widget recentCard(BuildContext context, ScannedQr scannedQr) {
  return InkWell(
    child: Column(
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: QrImage(
            data: scannedQr.qrLink,
            version: QrVersions.auto,
            size: context.dynamicWidth(0.30),
          ),
        ),
        Text(
          '${scannedQr.qrTitle}\n',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black,
              fontSize: context.dynamicWidth(0.040),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: EdgeInsets.all(context.dynamicWidth(0.005)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: Colors.black,
                size: context.dynamicWidth(0.04),
              ),
              SizedBox(
                width: context.dynamicWidth(0.01),
              ),
              Text(
                scannedQr.scannedDate!.isToday()
                    ? AppLocalizations.of(context)!.today
                    : scannedQr.scannedDate!.isYesterday()
                        ? AppLocalizations.of(context)!.yesterday
                        : DateFormat("d MMMM",
                                Localizations.localeOf(context).toString())
                            .format(scannedQr.scannedDate!),
                //'${convertDate(scannedQr.scannedDate!)}\n',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: context.dynamicWidth(0.030),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ],
    ),
    onTap: () {
      Get.to(() => ScanDetailPage(), arguments: [
        {"qrId": scannedQr.qrId},
        {"qrTitle": scannedQr.qrTitle}
      ]);
    },
  );
}

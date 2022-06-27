import 'dart:ffi';
import 'dart:math';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/utils/converter.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanPage extends StatelessWidget {
  final LandingController landingController = Get.find();
  ScanPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return scanField(context);
  }
}

Widget scanField(BuildContext context) {
  return Container();
}

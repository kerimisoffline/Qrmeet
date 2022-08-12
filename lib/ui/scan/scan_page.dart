import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScanController extends GetxController {
  void postNewScan(String qrLink, String qrTitle, int userId) async {
    debugPrint(qrLink);
    debugPrint(qrTitle);
    debugPrint("$userId");
    try {
      var sources = await HttpServices.postNewScan(qrLink, qrTitle, userId);
      if (sources != null) {
        Fluttertoast.showToast(
            msg: sources.qrTitle,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Get.find<LandingController>().changeSelectedIndex(0);
      } else {
        debugPrint('null geldi');
      }
    } catch (err) {
      debugPrint('Caught error: $err');
    }
  }
}

class ScanPage extends StatelessWidget {
  ScanPage({Key? key}) : super(key: key);
  final ScanController scanController = Get.put(ScanController());
  @override
  Widget build(context) {
    return Scaffold(body: scanField(context));
  }
}

Widget scanField(BuildContext context) {
  return Obx(() => Container(
        child: showScanDialog(context),
      ));
}

Widget showScanDialog(BuildContext context) {
  final LandingController landingController = Get.find();
  final ScanController scanController = Get.find();
  final TextEditingController scanTitleController = TextEditingController();
  return (landingController.barcodeMsg.value.isEmpty ||
          landingController.barcodeMsg.value == "-1")
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.lets_scan_qr,
                style: TextStyle(fontSize: context.dynamicWidth(0.07)),
              ),
              SizedBox(
                height: context.dynamicHeight(0.2),
                child: InkWell(
                  child: Icon(
                    Icons.qr_code_scanner_sharp,
                    size: context.dynamicWidth(0.2),
                  ),
                  onTap: () {
                    landingController.scanBarcode();
                  },
                ),
              )
            ],
          ),
        )
      : AlertDialog(
          title: Center(
            child: Text(
              landingController.barcodeMsg.value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
              child: Text(AppLocalizations.of(context)!.ok,
                  style: const TextStyle(color: Colors.white)),
              onPressed: () {
                String barcodeMsg = landingController.barcodeMsg.value;
                if (scanTitleController.text.toString().isNotEmpty &&
                    barcodeMsg.isNotEmpty) {
                  landingController.barcodeMsg.value = "-1";
                  scanController.postNewScan(
                      barcodeMsg,
                      scanTitleController.text.toString(),
                      landingController.mainUser.id!);
                } else {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!.enter_title,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: context.dynamicWidth(0.05));
                }
              },
            )
          ],
        );
}

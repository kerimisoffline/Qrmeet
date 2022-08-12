import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qrmeet/models/scan_detail.dart';
import 'package:qrmeet/models/scanned_qr.dart';
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
  var scannedUserList = <ScanDetail>[].obs;
  final _isLoading = true.obs;

  void fetchScanDetailPage() async {
    try {
      _isLoading.value = true;
      var sources = await HttpServices.fetchScanDetailUsers(qrId.toString());
      if (sources != null) {
        _isLoading.value = false;
        scannedUserList.clear();
        scannedUserList.value = sources;
      } else {
        _isLoading.value = false;
      }
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
  List<ScanDetail>? scannedUserList;
  scannedUserList = scanDetailPageController.scannedUserList;
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.white,
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(scanDetailPageController.qrTitle.value),
      actions: [
        IconButton(
            onPressed: () {
              Get.to(() => const ScanDetailSearchPage());
            },
            icon: const Icon(Icons.search))
      ],
    ),
    body: Obx(() => scanDetailPageController._isLoading.value
        ? const Align(
            alignment: Alignment.center, child: CircularProgressIndicator())
        : scanDetailList(context, scannedUserList!)),
  );
}

Widget scanDetailList(BuildContext context, List<ScanDetail> scannedUserList) {
  return ListView.builder(
      itemCount: scannedUserList.length,
      itemBuilder: ((BuildContext context, int index) =>
          scanDetailItem(context, scannedUserList[index])));
}

Widget scanDetailItem(BuildContext context, ScanDetail scannedUser) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: context.dynamicWidth(0.03),
        vertical: context.dynamicHeight(0.001)),
    child: Row(
      children: [
        CircleAvatar(
            backgroundImage: NetworkImage(scannedUser.userPic),
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0)),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                scannedUser.username,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: context.dynamicWidth(0.05),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500),
              ),
              Text(
                  scannedUser.scannedDate!.isToday()
                      ? AppLocalizations.of(context)!.today
                      : scannedUser.scannedDate!.isYesterday()
                          ? AppLocalizations.of(context)!.yesterday
                          : DateFormat("d MMMM",
                                  Localizations.localeOf(context).toString())
                              .format(scannedUser.scannedDate!),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: context.dynamicWidth(0.04),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ],
    ),
  );
}

class ScanDetailSearchPage extends StatelessWidget {
  const ScanDetailSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        title: Container(
          width: double.infinity,
          height: context.dynamicHeight(0.06),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    prefixIconConstraints: BoxConstraints(
                        minWidth: context.dynamicWidth(0.1),
                        maxHeight: context.dynamicWidth(0.1)),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.dynamicWidth(0.05)),
                      child:
                          Icon(Icons.search, size: context.dynamicWidth(0.07)),
                    ),
                    suffixIconConstraints: BoxConstraints(
                        minWidth: context.dynamicWidth(0.1),
                        maxHeight: context.dynamicWidth(0.1)),
                    suffixIcon: Padding(
                      padding:
                          EdgeInsets.only(right: context.dynamicWidth(0.02)),
                      child: IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: context.dynamicWidth(0.07),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    hintText: 'Search...',
                    hintStyle: const TextStyle(fontSize: 13),
                    border: InputBorder.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

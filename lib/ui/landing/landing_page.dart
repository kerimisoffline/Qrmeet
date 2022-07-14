import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrmeet/models/hits.dart';
import 'package:qrmeet/models/scanned_qr.dart';
import 'package:qrmeet/models/user.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/ui/chat/chat_page.dart';
import 'package:qrmeet/ui/hits/hits_page.dart';
import 'package:qrmeet/ui/recent/recent_page.dart';
import 'package:qrmeet/ui/scan/scan_page.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qrmeet/utils/converter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingController extends GetxController {
  dynamic argumentData = Get.arguments;
  final _selectedIndex = 0.obs;
  var scanData = <Hit>[].obs;
  var scannedQrData = <ScannedQr>[].obs;
  var barcodeMsg = "".obs;
  User mainUser = User();
  final _isLoading = true.obs;

  void changeSelectedIndex(int index) {
    _selectedIndex.value = index;
    switch (index) {
      case 0:
        fetchHitPage();
        break;
      case 1:
        fetchRecentPage();
        break;
      case 2:
        scanBarcode();
        break;
    }
  }

  Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.BARCODE);
    if (barcode == "-1" || barcode.isEmpty) {
      changeSelectedIndex(0);
      return;
    }
    barcodeMsg.value = barcode;
  }

  void loginIntoSystem(String mail, String pass) async {
    var generatedPass = generateMd5(pass);
    debugPrint(mail);
    debugPrint(generatedPass);
    try {
      var sources = await HttpServices.getLoginStatusBase(mail, generatedPass);
      if (sources != null) {
        debugPrint("kerimDebug2 $mainUser");
        mainUser = sources;
        Get.to(() => LandingPage());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLogged", true);
        await prefs.setString("mail", mail);
        await prefs.setString("password", pass);
      } else {
        debugPrint('null geldi');
      }
    } catch (err) {
      debugPrint('Caught error: $err');
    }
  }

  void registerIntoSystem(String mail, String pass) async {
    var generatedPass = generateMd5(pass);
    debugPrint(mail);
    debugPrint(generatedPass);
    String username = mail.split('@')[0];
    try {
      var sources =
          await HttpServices.registerNewUser(username, mail, generatedPass);
      if (sources != null) {
        debugPrint("kerimDebug2 $mainUser");
        mainUser = sources;
        Get.to(() => LandingPage());
      } else {
        debugPrint('null geldi');
      }
    } catch (err) {
      debugPrint('Caught error: $err');
    }
  }

  void fetchHitPage() async {
    try {
      _isLoading.value = true;
      var sources = await HttpServices.fetchHitPage();
      if (sources != null) {
        _isLoading.value = false;
        scanData.assignAll(sources);
      } else {
        _isLoading.value = false;
      }
    } catch (err) {
      _isLoading.value = false;
      debugPrint('Caught error: $err');
    }
  }

  void fetchRecentPage() async {
    try {
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
    } catch (err) {
      _isLoading.value = false;
      debugPrint('Caught error: $err');
    }
  }

  @override
  void onInit() {
    super.onInit();
    changeSelectedIndex(0);
  }
}

class LandingPage extends StatelessWidget {
  final LandingController landingController = Get.find();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);

  final TextStyle selectedLabelStyle = const TextStyle(
      color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 12);
  LandingPage({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    final _user = landingController.mainUser;

    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.app_name)),
        body: Obx(() => landingController._isLoading.value
            ? const Align(
                alignment: Alignment.center, child: CircularProgressIndicator())
            : IndexedStack(
                index: landingController._selectedIndex.value,
                children: [HitsPage(), RecentPage(), ScanPage(), ChatPage()],
              )),
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(20))),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "http://89.252.153.250:8081/images/avatar1.png"),
                        backgroundColor: Color.fromRGBO(0, 0, 0, 0)),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_user.username}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text("${_user.mail}",
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Hits'),
                onTap: () {
                  landingController.changeSelectedIndex(0);
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Recent'),
                onTap: () {
                  landingController.changeSelectedIndex(1);
                  Get.back();
                },
              ),
            ],
          ),
        ),
        drawerEdgeDragWidth: context.dynamicWidth(0.2),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelStyle: selectedLabelStyle,
            unselectedLabelStyle: unselectedLabelStyle,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.flash_on),
                  label: 'Hit',
                  backgroundColor: Colors.blue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.view_day),
                  label: 'Recent',
                  backgroundColor: Colors.blue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_scanner),
                  label: 'Scan',
                  backgroundColor: Colors.blue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chats',
                  backgroundColor: Colors.blue),
            ],
            currentIndex: landingController._selectedIndex.value,
            selectedItemColor: Colors.blue[800],
            onTap: landingController.changeSelectedIndex,
            unselectedItemColor: Colors.grey,
          ),
        ));
  }
}

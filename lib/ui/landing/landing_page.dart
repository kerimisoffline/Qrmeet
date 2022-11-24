import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrmeet/models/hits.dart';
import 'package:qrmeet/models/scanned_qr.dart';
import 'package:qrmeet/models/user.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/ui/chat/chat_page.dart';
import 'package:qrmeet/ui/event/event_page.dart';
import 'package:qrmeet/ui/hits/hits_page.dart';
import 'package:qrmeet/ui/login/login_page.dart';
import 'package:qrmeet/ui/profile/profile.dart';
import 'package:qrmeet/ui/recent/recent_page.dart';
import 'package:qrmeet/ui/settings/settings.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qrmeet/utils/converter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrmeet/models/chat_model.dart';

class LandingController extends GetxController {
  dynamic argumentData = Get.arguments;
  final _selectedIndex = 0.obs;
  var scanData = <Hit>[].obs;
  var scannedQrData = <ScannedQr>[].obs;
  var barcodeMsg = "".obs;
  var chatList = <ChatModel>[].obs;
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
        break;
      case 3:
        fetchChatList(mainUser.id!);
    }
  }

  Future<void> scanBarcode(BuildContext context) async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.BARCODE);
    if (barcode == "-1" || barcode.isEmpty) {
      changeSelectedIndex(0);
      return;
    }
    debugPrint("barcot okutuldu" + barcode);
    barcodeMsg.value = barcode;
    _showDialog(context, barcodeMsg.value);
  }

  void postNewScan(String qrLink, String qrTitle, int userId) async {
    debugPrint(qrLink);
    debugPrint(qrTitle);
    debugPrint("$userId");
    try {
      var sources = await HttpServices.postNewScan(qrLink, qrTitle, userId);
      if (sources != null) {
        Fluttertoast.showToast(
            msg: sources.qrTitle + " başarıyla okutuldu",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        Get.find<LandingController>().changeSelectedIndex(1);
      } else {
        debugPrint('null geldi');
      }
    } catch (err) {
      debugPrint('Caught error: $err');
    }
  }

  void fetchChatList(int userId) async {
    try {
      _isLoading.value = true;
      var sources = await HttpServices.fetchChatList(userId.toString());
      if (sources != null) {
        _isLoading.value = false;
        chatList.clear();
        ChatModel? removedChatModel;
        for (ChatModel chatUser in sources) {
          if (chatUser.id == mainUser.id) {
            removedChatModel = chatUser;
          }
        }
        if (removedChatModel != null) {
          sources.remove(removedChatModel);
        }
        chatList.value = sources;
      } else {
        _isLoading.value = false;
      }
    } catch (err) {
      _isLoading.value = false;
      debugPrint('Caught error: $err');
    }
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
        changeSelectedIndex(0);
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

  void clearAndReturnLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLogged", false);
        await prefs.setString("mail", "");
        await prefs.setString("password", "");  
        final LoginController loginController = Get.find();
        loginController.isLoading.value = false;
        Get.to(()=>LoginPage());  
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
    if (_selectedIndex == 0.obs) {
      changeSelectedIndex(0);
    }
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.app_name),
            actions: [
              GestureDetector(
                onTap: () {
                  landingController.scanBarcode(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.qr_code_sharp),
                ),
              )
            ],
          ),
          body: Obx(() => landingController._isLoading.value
              ? const Align(
                  alignment: Alignment.center, child: CircularProgressIndicator())
              : IndexedStack(
                  index: landingController._selectedIndex.value,
                  children: [HitsPage(), RecentPage(), EventPage(), ChatPage()],
                )),
          drawer: Drawer(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ProfileView());
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                  backgroundImage: NetworkImage(_user.userPic!),
                                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0)),
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
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(AppLocalizations.of(context)!.profile),
                        onTap: () {
                          Get.to(() => ProfileView());
                          //Get.back();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text(AppLocalizations.of(context)!.settings),
                        onTap: () {
                          Get.to(() => SettingsView());
                          //Get.back();
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: Text(AppLocalizations.of(context)!.quit),
                  onTap: () {
                    landingController.clearAndReturnLogin();
                    //Get.back();
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
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: const Icon(Icons.flash_on),
                    label: AppLocalizations.of(context)!.hit,
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.view_day),
                    label: AppLocalizations.of(context)!.recent,
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.festival),
                    label: AppLocalizations.of(context)!.events,
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.chat),
                    label: AppLocalizations.of(context)!.chats,
                    backgroundColor: Colors.blue),
              ],
              currentIndex: landingController._selectedIndex.value,
              selectedItemColor: Colors.blue[800],
              onTap: landingController.changeSelectedIndex,
              unselectedItemColor: Colors.grey,
            ),
          )),
    );
  }
}

void _showDialog(BuildContext context, String barcodeUrl) {
  final TextEditingController scanTitleController = TextEditingController();
  final LandingController landingController = Get.find();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              barcodeUrl,
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
                  landingController.postNewScan(
                      barcodeMsg,
                      scanTitleController.text.toString(),
                      landingController.mainUser.id!);
                  Get.back();
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
      });
}

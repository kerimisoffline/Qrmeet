import 'package:qrmeet/models/hits.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/ui/chat/chat_page.dart';
import 'package:qrmeet/ui/hits/hits_page.dart';
import 'package:qrmeet/ui/recent/recent_page.dart';
import 'package:qrmeet/ui/scan/scan_page.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingController extends GetxController {
  final _selectedIndex = 0.obs;
  var scanData = <Hit>[].obs;
  final _isLoading = true.obs;
  void changeSelectedIndex(int index) {
    _selectedIndex.value = index;
    switch (index) {
      case 0:
        fetchHitPage();
        break;
      case 1:
        break;
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

  @override
  void onInit() {
    super.onInit();
    changeSelectedIndex(0);
  }
}

class LandingPage extends StatelessWidget {
  final LandingController landingController = Get.put(LandingController());
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
                        backgroundColor: Colors.transparent),
                    Column(
                      children: const [
                        Text(
                          'Kerim Yıldırım',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text('kermmyldrm@gmail.com',
                            style: TextStyle(color: Colors.white)),
                      ],
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

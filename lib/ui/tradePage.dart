import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/models/Source.dart';
import 'package:qrmeet/services/HttpServices.dart';

class TradePageView extends StatelessWidget {
  final Controller controller = Get.find();
  final elementImages = [
    "assets/elementImages/voxelTile_42.png",
    "assets/elementImages/voxelTile_45.png",
    "assets/elementImages/voxelTile_46.png",
    "assets/elementImages/voxelTile_47.png",
    "assets/elementImages/voxelTile_48.png",
    "assets/elementImages/voxelTile_49.png",
  ];
  static const wideBox = 40.0;
  @override
  Widget build(context) {
    controller.fetchElements();
    debugPrint("list ${controller.sourceList.length}");
    return Scaffold(
        appBar: AppBar(title: const Text("Trade Page")),
        body: Center(
            child: GetBuilder<Controller>(
                builder: (_dx) => ListView.builder(
                    itemCount: _dx.sourceList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            _dx.sourceList[index].name,
                            style: TextStyle(
                                fontFamily: 'SourceCodePro',
                                fontWeight: FontWeight.bold),
                          ),
                          leading: ConstrainedBox(
                            constraints: const BoxConstraints(
                                minWidth: wideBox,
                                minHeight: wideBox,
                                maxWidth: wideBox,
                                maxHeight: wideBox),
                            child: Image.asset(
                              elementImages[index],
                            ),
                          ),
                          trailing: Text(
                            _dx.sourceList[index].price.toString() + " SR",
                            style: TextStyle(
                                fontFamily: 'SourceCodePro',
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      );
                    }))));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/main.dart';

class UserList extends StatelessWidget {
  final Controller controller = Get.find();
  static const wideBox = 40.0;

  UserList({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    controller.fetchElements();
    debugPrint("list ${controller.sourceList.length}");
    return Scaffold(
        appBar: AppBar(title: const Text("UserList Page")),
        body: Center(
            child: GetBuilder<Controller>(
                builder: (_dx) => ListView.builder(
                    itemCount: _dx.sourceList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            _dx.sourceList[index].username,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      );
                    }))));
  }
}

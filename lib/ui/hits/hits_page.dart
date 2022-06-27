import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/models/hits.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HitsPage extends StatelessWidget {
  final LandingController landingController = Get.find();
  HitsPage({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => hitSquareCard(context, 1)),
          Obx(() => hitSquareCard(context, 2)),
          Obx(() => hitSquareCard(context, 3))
        ],
      ),
    );
  }
}

Widget hitSquareCard(BuildContext context, int type) {
  List<Hit>? hitList;
  List<Hit>? filter = [];
  final LandingController landingController = Get.find();
  hitList = landingController.scanData;
  filter.addAll(hitList);
  filter.retainWhere((hit) {
    return hit.type == type;
  });
  return SizedBox(
    height: context.dynamicHeight((type == 1 || type == 3) ? 0.25 : 0.30),
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filter.length,
        itemBuilder: (BuildContext context, int i) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.blue,
              child: SizedBox(
                width:
                    context.dynamicWidth((type == 1 || type == 3) ? 0.6 : 0.4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.network(
                      filter[i].image,
                      height: context.dynamicHeight(
                          (type == 1 || type == 3) ? 0.15 : 0.20),
                      width: context
                          .dynamicWidth((type == 1 || type == 3) ? 0.40 : 0.25),
                    ),
                    Text(
                      filter[i].title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "${filter[i].total} taratma",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )),
  );
}

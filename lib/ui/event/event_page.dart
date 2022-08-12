import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventPage extends StatelessWidget {
  final LandingController landingController = Get.find();
  EventPage({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    return const SingleChildScrollView(
      child: Center(
        child: Text('EventPage'),
      ),
    );
  }
}

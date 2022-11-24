import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:qrmeet/utils/helper.dart';
import '../landing/landing_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(),
          title: Text(AppLocalizations.of(context)!.update_info)),
      body: Column(
        children: [
        ],
      ),
    );
  }
}
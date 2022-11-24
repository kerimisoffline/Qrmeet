import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qrmeet/utils/helper.dart';
import 'package:qrmeet/utils/get_screensize.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(),
          title: Text(AppLocalizations.of(context)!.settings)),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                trailing:
                    Icon(Icons.toggle_on, color: Colors.black,size: context.dynamicWidth(0.1),),
                onTap: (() => {}),
                title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customText(
                      data: AppLocalizations.of(context)!.notification,
                      fSize: context.dynamicWidth(0.05),
                    )),
              )),
          customListButton(
              data: AppLocalizations.of(context)!.change_pass,
              fSize: context.dynamicWidth(0.05))
        ],
      ),
    );
  }
}

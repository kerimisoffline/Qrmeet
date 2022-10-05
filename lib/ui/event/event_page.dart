import 'package:flutter/material.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);
  @override
  Widget build(context) {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(context.dynamicWidth(0.06)),
              child: Text(AppLocalizations.of(context)!.events_coming_soon,
                  style: TextStyle(
                      color: Colors.blue[800],
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 28.0)),
            ),
            SizedBox(
              height: context.dynamicWidth(0.8),
              width: context.dynamicHeight(0.6),
              child: Center(child: Image.asset('assets/backgroundImages/ic_no_event.png'))
            )
          ],
        ),
      );
  }
}

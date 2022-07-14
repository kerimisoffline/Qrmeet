import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showDialog(BuildContext context) {
  AlertDialog(
    title: const Text('Hata'),
    content: const Text('Doğrulama Kodu Giriniz.'),
    actions: [
      TextButton(
        child: Text(AppLocalizations.of(context)!.ok),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );
}

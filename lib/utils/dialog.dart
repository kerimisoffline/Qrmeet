import 'package:flutter/material.dart';

showAlertDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: Row(
            children: [
               const CircularProgressIndicator(),
               Container(margin: const EdgeInsets.only(left: 5),child: const Text("Yükleniyor...")),
            ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }
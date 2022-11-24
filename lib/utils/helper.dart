import 'package:flutter/material.dart';

Widget customText({required String data, double? fSize}) {
  return Text(
    data,
    style: TextStyle(
        color: Colors.black,
        fontSize: fSize,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400),
  );
}

Widget customListButton({required String data, double? fSize,Function? onClickAction}) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: (() => {if(onClickAction!=null)onClickAction()}),
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: customText(
              data: data,
              fSize: fSize,
            )),
      ));
}

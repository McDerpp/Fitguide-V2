import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';

Widget spaceLine(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      Container(
          color: tertiaryColor,
          height: MediaQuery.of(context).size.height * 0.001,
          width: MediaQuery.of(context).size.width * 0.9),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.01,
      )
    ],
  );
}

import 'package:flutter/material.dart';

void showCustomDialog(
  BuildContext context,
  Widget content, {
  double widthMultiplier = 1,
  double heightMultiplier = 0.35,
  int alphaValue = 190,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  Color transparentColor = Colors.white;

  void cancelfunc() {
    Navigator.pop(context);
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: transparentColor,
        content: Container(
          width: screenWidth * widthMultiplier,
          height: screenHeight * heightMultiplier,
          child: content,
        ),
      );
    },
  );
}

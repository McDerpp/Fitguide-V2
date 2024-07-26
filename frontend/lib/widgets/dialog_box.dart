import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showCustomDialog(
  BuildContext context,
  Widget content, {
  double widthMultiplier = 1,
  double heightMultiplier = 0.35,
  int alphaValue = 190,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  Color transparentColor = Colors.white.withOpacity(alphaValue / 255.0);

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

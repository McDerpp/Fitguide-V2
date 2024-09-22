import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color mainColorState = Colors.white;
const Color secondaryColorState = Color.fromARGB(255, 27, 26, 26);
const Color tertiaryColorState = Colors.black;

Color tertiaryColor = const Color.fromRGBO(255, 255, 255, 1);
Color secondaryColor = Colors.grey;
Color mainColor = Colors.black;
Color textColor = Colors.deepPurple;

int showPreviewCtrMax = 250;

double smallTextModifier = 0.025;
double mediumTextModifier = 0.05;
double largeTextModifier = 0.07;

double textAdaptModifier = 0.0009;

// =========================================================================================================================================

// this is to calibrate the counter of collecting delay for getting of coordinates
int collectingCtrDelay = 0;
double correctThreshold = 0.75;
int currentDuration = 6;
int restDuration = 30;
const int _duration = 10;

final StateProvider<Map<String, double>> textSizeModifier =
    StateProvider((ref) => {
          "smallText": 0.03,
          "smallText2": 0.04,
          "mediumText": 0.05,
          "largeText": 0.07,
        });

final StateProvider<Map<String, Map<String, dynamic>>> ColorSet =
    StateProvider((ref) => {
          "ColorSet1": {
            "mainColor": secondaryColor,
            "secondaryColor": secondaryColor,
            "tertiaryColor": secondaryColor,
          },
          "ColorSet2": {
            "mainColor": tertiaryColorState,
            "secondaryColor": tertiaryColor,
            "tertiaryColor": Colors.black,
          },
        });

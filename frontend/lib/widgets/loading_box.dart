import 'package:flutter/material.dart';
import 'package:frontend/misc/logicFunction/isolateProcessPDV.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/widgets/dialog_box.dart';

void loadingBoxTranslating(
  BuildContext context,
  List<dynamic> coordinatesData,
  double progress,
  Function(double) updateProgress,
) {
  translateCollectedDatatoTxt(
    coordinatesData,
    updateProgress,
  );

  return showCustomDialog(
    context,
    SizedBox(
      width: 100,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Please wait...",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          const SizedBox(
              height:
                  10), // Add some spacing between text and CircularProgressIndicator
          Center(
            child: CircularProgressIndicator(
              value: .5,
              strokeWidth: 8.0,
              color: secondaryColor,
              backgroundColor: mainColor,
              semanticsLabel: 'Loading',
            ),
          ),
          const SizedBox(
              height:
                  10), // Add some spacing between CircularProgressIndicator and bottom text
          Text(
            "Processing",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
        ],
      ),
    ),
  );
}

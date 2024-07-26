import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/main_settings.dart';

import '../provider/data_collection_provider.dart';

void dialogBoxNotif(
  BuildContext context,
  int notifState,
  String nextExercise, {
  List<Map<String, dynamic>>? exerciseProgram,
  List<Map<String, dynamic>>? exerciseUpdateList,
  List<String>? timeSpent,
  double widthMultiplier = .5,
  double heightMultiplier = 0.35,
  int alphaValue = 190,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  void cancelfunc() {
    Navigator.pop(context);
  }

  void dismissDialog() {
    Navigator.pop(context);
  }

  List<List<dynamic>> content = [
    [],
    [
      "Seems like you're having a hard time.",
      "I'll play the video again, just follow it.",
      Icons.sentiment_dissatisfied_sharp,
      Colors.red,
    ],
    [
      "GREAT WORK!",
      "Just keep doing that.",
      Icons.sentiment_very_satisfied,
      Colors.green,
    ],
    [
      "Good Job!",
      "(Follow the preview video to start the exercise)",
      Icons.check_circle_outline_sharp,
      mainColor,
    ],
    [
      "Next: ${nextExercise}",
      "(Follow the preview video to start the exercise)",
      Icons.check_circle_outline_sharp,
    ],
    [
      "Now collecting",
      "Positive datasets",
      Icons.check,
      Colors.green,
    ],
    [
      "Now collecting",
      "Negative datasets",
      Icons.close,
      Colors.red,
    ],
  ];

  Widget notifCompletion() {
    return AlertDialog(
      backgroundColor: mainColor,
      // ----------------------------------------------------------------------------------------------------[STATE 1]
      content: Container(
        width: screenWidth * 0.9, // Adjust the width to 80% of the screen width
        height:
            screenHeight * 0.6, // Adjust the height to 60% of the screen height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                'NICE WORK!',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: secondaryColorState,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                'You completed these exercises :',
                style: TextStyle(
                  fontSize: 15.0,
                  color: tertiaryColorState,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: exerciseProgram?.length,
                itemBuilder: (context, index) {
                  final exerciseDetail = exerciseProgram![index];
                  final String nameOfExercise =
                      exerciseDetail['nameOfExercise'];
                  final int setsNeeded = exerciseDetail['setsNeeded'];
                  final int numberOfExecution =
                      exerciseDetail['numberOfExecution'];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: screenWidth * 0.035),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: mainColorState,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          nameOfExercise,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: secondaryColorState,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              width: screenWidth * 0.15,
                              child: Text('Sets: $setsNeeded'),
                            ),
                            Container(
                              width: screenWidth * 0.15,
                              child: Text('Reps: $numberOfExecution'),
                            ),
                          ],
                        ),
                        trailing: Text('00'),
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Home"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget notifPerforming() {
    return AlertDialog(
      backgroundColor: content[notifState][3],
      // ----------------------------------------------------------------------------------------------------[STATE 1]

      content: Container(
        width: screenWidth * widthMultiplier,
        height: screenHeight * heightMultiplier,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content[notifState][0],
                style: TextStyle(
                  fontSize: 0.05 * screenWidth,
                  fontWeight: FontWeight.w800,
                  color: tertiaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              Icon(
                content[notifState][2],
                size: screenWidth * 0.35,
                color: tertiaryColor,
              ),
              Text(
                content[notifState][1],
                style: TextStyle(
                  fontSize: 0.05 * screenWidth,
                  fontWeight: FontWeight.w800,
                  color: tertiaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget notifupdate() {
    return AlertDialog(
      backgroundColor: mainColor,
      // ----------------------------------------------------------------------------------------------------[STATE 1]
      content: Container(
        width: screenWidth * 0.9, // Adjust the width to 80% of the screen width
        height:
            screenHeight * 0.6, // Adjust the height to 60% of the screen height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                'NICE WORK!',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: secondaryColorState,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                'You completed these exercises :',
                style: TextStyle(
                  fontSize: 15.0,
                  color: tertiaryColorState,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                itemCount: exerciseProgram?.length,
                itemBuilder: (context, index) {
                  final exerciseDetail = exerciseProgram![index];
                  final String nameOfExercise =
                      exerciseDetail['nameOfExercise'];
                  final int setsNeeded = exerciseDetail['setsNeeded'];
                  final int numberOfExecution =
                      exerciseDetail['numberOfExecution'];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: screenWidth * 0.035),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: mainColorState,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          nameOfExercise,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: secondaryColorState,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              width: screenWidth * 0.15,
                              child: Text('Sets: $setsNeeded'),
                            ),
                            Container(
                              width: screenWidth * 0.15,
                              child: Text('Reps: $numberOfExecution'),
                            ),
                          ],
                        ),
                        trailing: Text('00'),
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Home"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      exerciseProgram == null
          ? Timer(Duration(seconds: 3), dismissDialog)
          : null;

      return exerciseProgram != null
          ? notifCompletion()
          : exerciseUpdateList != null
              ? notifupdate()
              : notifPerforming();
    },
  );

  // showDialog(
  //   barrierDismissible: false,
  //   context: context,
  //   builder: (context) {
  //     Timer(Duration(seconds: 3), dismissDialog);
  //     return AlertDialog(
  //       backgroundColor: content[notifState][3],
  //       // ----------------------------------------------------------------------------------------------------[STATE 1]

  //       content: Container(
  //         width: screenWidth * widthMultiplier,
  //         height: screenHeight * heightMultiplier,
  //         child: Padding(
  //           padding:
  //               EdgeInsets.all(16.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 content[notifState][0],
  //                 style: TextStyle(
  //                   fontSize: 0.05 * screenWidth,
  //                   fontWeight: FontWeight.w800,
  //                   color: tertiaryColor,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               Icon(
  //                 content[notifState][2],
  //                 size: screenWidth * 0.35,
  //                 color: tertiaryColor,
  //               ),
  //               Text(
  //                 content[notifState][1],
  //                 style: TextStyle(
  //                   fontSize: 0.05 * screenWidth,
  //                   fontWeight: FontWeight.w800,
  //                   color: tertiaryColor,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   },
  // );
}

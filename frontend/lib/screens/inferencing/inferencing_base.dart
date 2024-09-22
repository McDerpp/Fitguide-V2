// ignore_for_file: empty_catches, empty_statements

import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/coreFunctionality/mainUISettings.dart';
import 'package:frontend/screens/coreFunctionality/pose_provider.dart';
import 'package:frontend/widgets/exrcise_ctr.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class InferencingBase extends ConsumerStatefulWidget {
  final int maxExercise;
  final int currentExerciseNum;
  final int maxRep;
  final int currentRep;
  final int maxSets;
  final int currentSets;
  final String exerciseName;
  final bool isAllCoordinatesPresent;
  final bool isNowPerforming;
  final Function(int)? onChangeExecise;

  const InferencingBase(
      {super.key,
      required this.maxRep,
      required this.currentRep,
      required this.maxSets,
      required this.currentSets,
      required this.exerciseName,
      required this.maxExercise,
      required this.currentExerciseNum,
      required this.isAllCoordinatesPresent,
      required this.isNowPerforming,
      this.onChangeExecise});

  @override
  ConsumerState<InferencingBase> createState() => _InferencingBaseState();
}

class _InferencingBaseState extends ConsumerState<InferencingBase> {
  double inferenceValue = 50;
  bool initTest = false;

  final List<int> exerciseElapsedTime = [];
  // ---------------------inferencing data mode variables----------------------------------------------------------

  bool countDowntoPerform = false;
  bool checkCountDowntoPerform = false;

  int _currentRep = 0;
  int _currentSets = 0;
  int _currentExerciseNum = 0;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    _currentRep = widget.currentRep;
    _currentSets = widget.currentSets;
    _currentExerciseNum = widget.currentExerciseNum;
  }

  Future<File> _downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      return file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Failed to download file');
    }
  }

  @override
  void dispose() async {
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Widget noDisplay() {
    return Container(
      width: 0,
      height: 0,
      color: Colors.transparent,
    );
  }

  Widget displayErrorPose(BuildContext context, double opacity) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Icon(
      Icons.accessibility_new_sharp,
      color: Colors.red.withOpacity(opacity),
      size: screenWidth * 0.07,
    );
  }

  Widget displayErrorPose2(BuildContext context, double opacity) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Icon(
      Icons.lightbulb_circle,
      color: Colors.red.withOpacity(opacity),
      size: screenWidth * 0.07,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textSizeModif = (screenHeight + screenWidth) * textAdaptModifier;
    Widget displayCountdownTimer;
    Widget displayError1;
    Widget displayError2;

    // exercise details------------------------------------------------------------

    final luminanceValue = ref.watch(luminanceProvider);

    if (widget.isAllCoordinatesPresent == false) {
      displayError1 = displayErrorPose(context, 1);
    } else {
      displayError1 = displayErrorPose(context, 0);
    }

    if (luminanceValue <= 50.0) {
      displayError2 = displayErrorPose2(context, 1);
    } else {
      displayError2 = displayErrorPose2(context, 0);
    }

    return Stack(
      children: [
// -----------------------------------------------------------------------------------------------------------[Current Exercise Description]
        Column(
          children: [
// -----------------------------------------------------------------------------------------------------------[Error Indicator Pose]
            SizedBox(
              height: screenHeight * 0.05,
            ),
            // SizedBox(
            //   height: 450,
            //   child: Row(
            //     children: <Widget>[
            //       FAProgressBar(
            //         currentValue: inferenceValue * 100,
            //         size: 15,
            //         maxValue: 100,
            //         changeColorValue: 95,
            //         changeProgressColor: Colors.pink,
            //         backgroundColor: Colors.white.withOpacity(0.05),
            //         progressColor: Colors.lightBlue,
            //         animatedDuration: const Duration(milliseconds: 25),
            //         direction: Axis.vertical,
            //         verticalDirection: VerticalDirection.up,
            //         formatValueFixed: 2,
            //       )
            //     ],
            //   ),
            // ),

            SizedBox(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: displayError2,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: displayError1,
                  ),
                ],
              ),
            ),

            Spacer(),

            SizedBox(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExrciseCtr(
                    numofContainer: widget.maxExercise,
                    numofCompleted: _currentExerciseNum,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
              width: screenWidth * 0.05,
            ),
            Row(
              children: [
                Spacer(),
                GestureDetector(
                  child: Container(
                    height: screenHeight * 0.11,
                    child: Icon(Icons.arrow_left_outlined),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(5), // Adjust the radius here
                    ),
                  ),
                  onTap: () {
                    print("trying to prev -> ${widget.currentExerciseNum}");

                    if (widget.currentExerciseNum != 0) {
                      int tempNum = widget.currentExerciseNum - 1;
                      widget.onChangeExecise!(tempNum);
                    }
                  },
                ),
                Spacer(),
                Container(
                  width: screenWidth * 0.80,
                  height: screenHeight * 0.11,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        child: LinearProgressIndicator(
                          minHeight: screenHeight * 0.5,
                          value: widget.currentRep / widget.maxRep,
                          backgroundColor: mainColor.withOpacity(0.9),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              secondaryColor.withOpacity(0.5)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                            10.0), // Adjust the padding as needed
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.exerciseName,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300,
                                      color: tertiaryColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // const Spacer(),
                                ],
                              ),
                            ),
                            Container(
                              child: Expanded(
                                child: widget.currentRep != widget.maxRep ||
                                        widget.currentSets != widget.maxSets
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Reps:",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0 * textSizeModif,
                                              fontWeight: FontWeight.w100,
                                              color: tertiaryColor,
                                            ),
                                          ),
                                          Text(
                                            "  ${widget.currentRep} / ${widget.maxRep}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0 * textSizeModif,
                                              fontWeight: FontWeight.w100,
                                              color: tertiaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.1,
                                          ),
                                          Text(
                                            "Sets:",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0 * textSizeModif,
                                              fontWeight: FontWeight.w100,
                                              color: tertiaryColor,
                                            ),
                                          ),
                                          Text(
                                            "  ${widget.currentSets} / ${widget.maxSets}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0 * textSizeModif,
                                              fontWeight: FontWeight.w100,
                                              color: tertiaryColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Completed!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0 * textSizeModif,
                                              fontWeight: FontWeight.w100,
                                              color: tertiaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ExerciseScreen(
                        //           exercise: widget.exercise[exerciseCtr]),
                        //     ),
                        //   );
                        // },
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.info, // Replace with your desired note icon
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                  child: Container(
                    height: screenHeight * 0.11,
                    child: Icon(Icons.arrow_right_outlined),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(5), // Adjust the radius here
                    ),
                  ),
                  onTap: () {
                    print("trying to next 1 -> ${widget.maxExercise}");
                    print("trying to next 2 -> ${widget.currentExerciseNum}");

                    if (widget.currentExerciseNum != widget.maxExercise - 1) {
                      int tempNum = widget.currentExerciseNum + 1;
                      print("tempNum -> $tempNum");
                      widget.onChangeExecise!(tempNum++);
                    }
                  },
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.01,
            )
          ],
        )
// -----------------------------------------------------------------------------------------------------------[Progress Container]
      ],
    );
  }
}

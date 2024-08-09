// ignore_for_file: non_constant_identifier_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/widgets/dialog_box_notif.dart';
import 'package:frontend/widgets/error_widget.dart';
import 'package:frontend/widgets/execution_analysis.dart';
import 'package:frontend/widgets/ignore_pose.dart';

import 'dart:core';

import '../../provider/data_collection_provider.dart';
import 'package:showcaseview/showcaseview.dart';

class DatasetCollection extends ConsumerStatefulWidget {
  final bool isRetraining;
  final bool isNewRetrain;

  // final Widget exerciseList;

  const DatasetCollection({
    super.key,
    this.isRetraining = false,
    this.isNewRetrain = false,
  });

  @override
  ConsumerState<DatasetCollection> createState() => _DatasetCollectionState();
}

class _DatasetCollectionState extends ConsumerState<DatasetCollection> {
  double requiredDataNum = 50;

  GlobalKey tutorial_deletePrev = GlobalKey();
  GlobalKey tutorial_pause = GlobalKey();
  GlobalKey tutorial_deleteAll = GlobalKey();
  GlobalKey tutorial_ignorePose = GlobalKey();

  GlobalKey tutorial_allMetrics = GlobalKey();
  GlobalKey tutorial_avgFrame = GlobalKey();
  GlobalKey tutorial_variance = GlobalKey();
  GlobalKey tutorial_avgFrame2 = GlobalKey();
  GlobalKey tutorial_variance2 = GlobalKey();

  GlobalKey tutorial_lightingError = GlobalKey();
  GlobalKey tutorial_poseError = GlobalKey();

  GlobalKey tutorial_progressBar = GlobalKey();
  GlobalKey tutorial_submit = GlobalKey();

  Color sequenceColor = Colors.yellow;
  Color averageColor = Colors.yellow;
  Color varianceColor = Colors.yellow;
  Color minFrameColor = Colors.yellow;
  Color maxFrameColor = Colors.yellow;
  late Map<String, double> textSizeModifierSet;

  double avgFrames = 0.0;
  int minFrame = 0;
  int maxFrame = 0;
  String resultAvgFrames = '';
  int execTotalFrames = 0;
  int execTotalNegativeFrames = 0;
  bool undoInit = false;

  // child: ref.watch(isCollectingCorrect.notifier).state == true
  void undoExecution(int undoTimes) {
    int tempexecTotalFrames = execTotalFrames;
    for (int ctr = 0; ctr < undoTimes; ctr++) {
      if (ref.read(coordinatesDataProvider).state.isNotEmpty) {
        tempexecTotalFrames = (tempexecTotalFrames -
                ref.read(coordinatesDataProvider).state.last.length)
            .toInt();
        ref.watch(isCollectingCorrect) == true
            ? ref.watch(coordinatesDataProvider).state.removeLast()
            : ref.watch(incorrectCoordinatesDataProvider).state.removeLast();
      }
    }

    setState(() {
      // nowPerforming = false;
      ref.watch(isPerforming.notifier).state = false;

      execTotalFrames = tempexecTotalFrames;
      avgFrames = execTotalFrames / ref.watch(numExec);
      ;
      resultAvgFrames = avgFrames.toStringAsFixed(2);
      avgFrames = double.parse(resultAvgFrames);
    });
  }

  void undoInitialize() async {
    undoExecution(ref.watch(coordinatesDataProvider).state.length);
    undoExecution(ref.watch(incorrectCoordinatesDataProvider).state.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Widget displayError1;
    Widget displayError2;

    final luminanceValue = ref.watch(luminanceProvider);

    if (undoInit == false) {
      undoInit = true;
      undoInitialize();
    }

    if (ref.watch(isAllCoordinatesPresent) == false) {
      displayError1 = const poseError(
        opacity: 1,
      );
    } else {
      displayError1 = const poseError(opacity: 0.0);
    }

    if (luminanceValue <= 50.0) {
      displayError2 = const luminanceError(opacity: 1);
    } else {
      displayError2 = const luminanceError(opacity: 0.0);
    }

    return Stack(
      children: [
        // --------------------------------------------------------------------------[HELP BUTTON]

        Align(
          alignment: const Alignment(1.0, 0.78),
          child: IconButton(
            icon: const Icon(
              Icons.question_mark,
              color: Colors.white,
            ),
            onPressed: () {
              ShowCaseWidget.of(context).startShowCase([
                tutorial_deletePrev,
                tutorial_pause,
                tutorial_deleteAll,
                tutorial_ignorePose,
                tutorial_lightingError,
                tutorial_poseError,
                tutorial_progressBar,
                tutorial_submit
              ]);
            },
          ),
        ),

// --------------------------------------------------------------------------[COUNTER]

        Align(
          alignment: const Alignment(0.0, -0.94),
          child: Container(
            width: screenWidth * 0.83,
            height: screenHeight * 0.05,
            decoration: BoxDecoration(
              color: tertiaryColor!.withOpacity(0.75),
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.80,
                  height: screenHeight * 0.017,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.07),
                  ),
                  child: Showcase(
                    key: tutorial_progressBar,
                    title: 'Progress Bar',
                    description:
                        'This indicates te amount of reps or data performed and collected.',
                    child: ref.watch(isCollectingCorrect.notifier).state == true
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.07),
                            child: LinearProgressIndicator(
                              value: ref
                                          .watch(coordinatesDataProvider)
                                          .state
                                          .length >
                                      requiredDataNum
                                  ? requiredDataNum
                                  : ref
                                          .watch(coordinatesDataProvider)
                                          .state
                                          .length /
                                      requiredDataNum,
                              backgroundColor: tertiaryColor!.withOpacity(0.5),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green.withOpacity(0.5)),
                            ),
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.07),
                            child: LinearProgressIndicator(
                              value: ref
                                          .watch(
                                              incorrectCoordinatesDataProvider)
                                          .state
                                          .length >
                                      requiredDataNum
                                  ? requiredDataNum
                                  : ref
                                          .watch(
                                              incorrectCoordinatesDataProvider)
                                          .state
                                          .length /
                                      requiredDataNum,
                              backgroundColor: Colors.red,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  secondaryColor.withOpacity(0.5)),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: screenHeight * 0.12,
          child: SizedBox(
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        ref.watch(isCollectingCorrect.notifier).state == true
                            ? Colors.green[800]
                            : Colors.red[800],
                    fixedSize: const Size(75, 35),
                  ),
                  onPressed: () {
                    ref.watch(isPerforming.notifier).state = false;
                    if (ref.watch(isCollectingCorrect.notifier).state == true) {
                      dialogBoxNotif(context, 6, "aasetsdaf");
                      ref.watch(isCollectingCorrect.notifier).state = false;
                    } else {
                      dialogBoxNotif(context, 5, "aasetsdaf");
                      ref.watch(isCollectingCorrect.notifier).state = true;
                    }
                  },
                  child: ref.watch(isCollectingCorrect.notifier).state == true
                      ? const Icon(
                          Icons.check,
                          size: 30,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.white,
                        ),
                )
              ],
            ),
          ),
        ),

// --------------------------------------------------------------------------[FRAME DETAIL CONTAINER 2]
        Positioned(
          bottom: screenHeight * 0.03,
          left: screenWidth * 0.05,
          height: screenHeight * 0.05,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(
                      30.0), // Adjust the radius as needed
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Showcase(
                      key: tutorial_deletePrev,
                      title: 'Delete Previous',
                      description: 'Press this to delete recent collected data',
                      child: IconButton(
                        icon: Icon(
                          Icons.restart_alt,
                          color: Colors.white,
                          size: screenWidth * .06, //
                        ),
                        onPressed: () {
                          undoExecution(1);
                        },
                      ),
                    ),
                    Showcase(
                      key: tutorial_pause,
                      title: 'Pause',
                      description: 'Press this to pause the collection of data',
                      child: IconButton(
                        icon: Icon(
                          Icons.pause,
                          color: Colors.white,
                          size: screenWidth * .06, //
                        ),
                        onPressed: () {
                          // simulateCollectData();
                          setState(() {
                            ref.watch(isPerforming.notifier).state = false;
                          });
                        },
                      ),
                    ),
                    Showcase(
                      key: tutorial_deleteAll,
                      title: 'Delete All',
                      description: 'Press this to delete all data collected',
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                          size: screenWidth * .06, //
                        ),
                        onPressed: () {
                          undoExecution(ref
                                      .watch(isCollectingCorrect.notifier)
                                      .state ==
                                  true
                              ? ref.watch(coordinatesDataProvider).state.length
                              : ref
                                  .watch(incorrectCoordinatesDataProvider)
                                  .state
                                  .length);
                        },
                      ),
                    ),
                    Showcase(
                      key: tutorial_ignorePose,
                      title: 'Ignore Pose',
                      description:
                          'Press this to have the option to ignore certain parts of your body from being collected or being detected. This is usually used if a part of your body is behind something or not directly at the camera',
                      // child: customDialogEA(
                      //   iconSize: screenWidth * .06,
                      //   igrnoreCoordinatesList: igrnoreCoordinatesList,
                      // ),
                      child: const IgnorePose(),
                      //
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: screenHeight * 0.015,
          right: screenWidth * 0.05,
          child: Showcase(
            key: tutorial_submit,
            title: 'Submit',
            description:
                'After collecting data submit it to get a data analysis and proceed to the next part',
            child: Container(
              decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: cwDataAnalysis(
                execCount: ref.watch(numExec),
                data: ref.watch(coordinatesDataProvider).state,
                data2: ref.watch(incorrectCoordinatesDataProvider).state,
                isRetraining: widget.isRetraining,
                isNewRetrain: widget.isNewRetrain,
              ),
            ),
          ),
        ),

        Positioned(
          top: screenWidth * 0.16,
          child: SizedBox(
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Showcase(
                  key: tutorial_poseError,
                  title: 'Pose Error',
                  description:
                      'This indicates whether you whole body is present directly at the camera(Exceptions on parts of the body you ignored).',
                  child: displayError1,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Showcase(
                  key: tutorial_lightingError,
                  title: 'Lighting Error',
                  description:
                      'This indicates the lighting conditions. This could affect the accuracy of the model',
                  child: displayError2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

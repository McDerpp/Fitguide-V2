// // ignore_for_file: non_constant_identifier_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/provider/main_settings.dart';
// import 'package:frontend/screens/coreFunctionality/data_collection_provider.dart';
// import 'package:frontend/screens/coreFunctionality/pose_provider.dart';
// import 'package:frontend/widgets/dialog_box_notif.dart';
// import 'package:frontend/widgets/error_widget.dart';
// import 'package:frontend/widgets/execution_analysis.dart';
// import 'package:frontend/widgets/ignore_pose.dart';

// import 'dart:core';

// import 'package:showcaseview/showcaseview.dart';

// class DatasetCollection extends ConsumerStatefulWidget {
//   final bool isRetraining;
//   final bool isNewRetrain;
//   final Function(int)? onChangeNoMovementBuffer;
//   final Function(double)? onChangeChangeRange;
//   final Function(bool)? onChangeShowPose;
//   final Function(bool)? onChanegShowPreview;
//   final Function(bool)? onChangePause;
//   final void Function(List<List<List<double>>>) onChangePositiveDataset;
//   final void Function(List<List<List<double>>>) onChangeNegativeDataset;
//   final List<List<List<double>>> positiveData;
//   final List<List<List<double>>> negativeData;

//   const DatasetCollection({
//     super.key,
//     this.isRetraining = false,
//     this.isNewRetrain = false,
//     this.onChangeNoMovementBuffer,
//     this.onChangeChangeRange,
//     this.onChangeShowPose,
//     this.onChanegShowPreview,
//     this.onChangePause,
//     required this.onChangePositiveDataset,
//     required this.onChangeNegativeDataset,
//     required this.positiveData,
//     required this.negativeData,
//   });

//   @override
//   ConsumerState<DatasetCollection> createState() => _DatasetCollectionState();
// }

// class _DatasetCollectionState extends ConsumerState<DatasetCollection> {
//   List<List<List<double>>> _positiveDataset = [];
//   List<List<List<double>>> _negativeDataset = [];

//   double requiredDataNum = 50;

//   GlobalKey tutorial_deletePrev = GlobalKey();
//   GlobalKey tutorial_pause = GlobalKey();
//   GlobalKey tutorial_deleteAll = GlobalKey();
//   GlobalKey tutorial_ignorePose = GlobalKey();

//   GlobalKey tutorial_allMetrics = GlobalKey();
//   GlobalKey tutorial_avgFrame = GlobalKey();
//   GlobalKey tutorial_variance = GlobalKey();
//   GlobalKey tutorial_avgFrame2 = GlobalKey();
//   GlobalKey tutorial_variance2 = GlobalKey();

//   GlobalKey tutorial_lightingError = GlobalKey();
//   GlobalKey tutorial_poseError = GlobalKey();

//   GlobalKey tutorial_progressBar = GlobalKey();
//   GlobalKey tutorial_submit = GlobalKey();

//   double avgFrames = 0.0;

//   String resultAvgFrames = '';
//   int execTotalFrames = 0;
//   bool undoInit = false;
//   bool _isPause = false;

//   // child: ref.watch(isCollectingCorrect.notifier).state == true
//   void undoExecution(int undoTimes) {
//     int tempexecTotalFrames = execTotalFrames;
//     for (int ctr = 0; ctr < undoTimes; ctr++) {
//       if (ref.read(coordinatesDataProvider).state.isNotEmpty) {
//         tempexecTotalFrames = (tempexecTotalFrames -
//                 ref.read(coordinatesDataProvider).state.last.length)
//             .toInt();
//         ref.watch(isCollectingCorrect) == true
//             ? ref.watch(coordinatesDataProvider).state.removeLast()
//             : ref.watch(incorrectCoordinatesDataProvider).state.removeLast();
//       }
//     }

//     setState(() {
//       // nowPerforming = false;
//       ref.watch(isPerforming.notifier).state = false;

//       execTotalFrames = tempexecTotalFrames;
//       avgFrames = execTotalFrames / ref.watch(numExec);
//       resultAvgFrames = avgFrames.toStringAsFixed(2);
//       avgFrames = double.parse(resultAvgFrames);
//     });
//   }

//   void undoInitialize() async {
//     undoExecution(ref.watch(coordinatesDataProvider).state.length);
//     undoExecution(ref.watch(incorrectCoordinatesDataProvider).state.length);
//   }

//   @override
//   void initState() {
//     _positiveDataset = widget.positiveData;
//     _negativeDataset = widget.negativeData;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     if (undoInit == false) {
//       undoInit = true;
//       undoInitialize();
//     }

//     return Stack(
//       children: [
//         Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Showcase(
//                   key: tutorial_poseError,
//                   title: 'Pose Error',
//                   description:
//                       'This indicates whether you whole body is present directly at the camera(Exceptions on parts of the body you ignored).',
//                   child: poseError(
//                     poseState: ref.watch(isAllCoordinatesPresent) == false,
//                   ),
//                 ),
//                 SizedBox(
//                   height: screenHeight * 0.05,
//                 ),
//                 Showcase(
//                   key: tutorial_lightingError,
//                   title: 'Lighting Error',
//                   description:
//                       'This indicates the lighting conditions. This could affect the accuracy of the model',
//                   child: luminanceError(
//                     lumincanceVlue: ref.watch(luminanceProvider),
//                   ),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             Row(
//               children: [
//                 Showcase(
//                   key: tutorial_ignorePose,
//                   title: 'Settings',
//                   description:
//                       'Press this to have the option to ignore certain parts of your body from being collected or being detected. This is usually used if a part of your body is behind something or not directly at the camera',
//                   child: PoseSettings(
//                     onChangeNoMovementBuffer: widget.onChangeNoMovementBuffer,
//                     onChangeChangeRange: widget.onChangeChangeRange,
//                     onChangeShowPose: widget.onChangeShowPose,
//                     onChanegShowPreview: widget.onChanegShowPreview,
//                   ),
//                 ),
//                 const Spacer(),
//                 Column(
//                   children: [
//                     Text(
//                       ref.watch(isCollectingCorrect.notifier).state == true
//                           ? ref
//                               .watch(coordinatesDataProvider)
//                               .state
//                               .length
//                               .toString()
//                           : ref
//                               .watch(incorrectCoordinatesDataProvider)
//                               .state
//                               .length
//                               .toString(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontFamily: 'Roboto',
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Container(
//                       width: screenWidth * 0.6,
//                       height: screenHeight * 0.03,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(screenWidth * 0.03),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: screenWidth * 0.80,
//                             height: screenHeight * 0.008,
//                             decoration: BoxDecoration(
//                               color: secondaryColor,
//                               borderRadius:
//                                   BorderRadius.circular(screenWidth * 0.07),
//                             ),
//                             child: Showcase(
//                               key: tutorial_progressBar,
//                               title: 'Progress Bar',
//                               description:
//                                   'This indicates te amount of reps or data performed and collected.',
//                               child: ref
//                                           .watch(isCollectingCorrect.notifier)
//                                           .state ==
//                                       true
//                                   ? ClipRRect(
//                                       borderRadius: BorderRadius.circular(
//                                           screenWidth * 0.07),
//                                       child: LinearProgressIndicator(
//                                         value: ref
//                                                     .watch(
//                                                         coordinatesDataProvider)
//                                                     .state
//                                                     .length >
//                                                 requiredDataNum
//                                             ? requiredDataNum
//                                             : ref
//                                                     .watch(
//                                                         coordinatesDataProvider)
//                                                     .state
//                                                     .length /
//                                                 requiredDataNum,
//                                         backgroundColor:
//                                             tertiaryColor!.withOpacity(0.5),
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 Colors.green.withOpacity(0.5)),
//                                       ),
//                                     )
//                                   : ClipRRect(
//                                       borderRadius: BorderRadius.circular(
//                                           screenWidth * 0.07),
//                                       child: LinearProgressIndicator(
//                                         value: ref
//                                                     .watch(
//                                                         incorrectCoordinatesDataProvider)
//                                                     .state
//                                                     .length >
//                                                 requiredDataNum
//                                             ? requiredDataNum
//                                             : ref
//                                                     .watch(
//                                                         incorrectCoordinatesDataProvider)
//                                                     .state
//                                                     .length /
//                                                 requiredDataNum,
//                                         backgroundColor:
//                                             tertiaryColor!.withOpacity(0.5),
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 Colors.red.withOpacity(0.5)),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.question_mark,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     print("question mark pressed");
//                     ShowCaseWidget.of(context).startShowCase([
//                       tutorial_deletePrev,
//                       tutorial_pause,
//                       tutorial_deleteAll,
//                       tutorial_ignorePose,
//                       tutorial_lightingError,
//                       tutorial_poseError,
//                       tutorial_progressBar,
//                       tutorial_submit
//                     ]);
//                   },
//                 ),
//               ],
//             ),
//             Container(
//               height: screenHeight * 0.1,
//               width: screenWidth,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(screenHeight * .02),
//                   topRight: Radius.circular(screenHeight * .02),
//                 ),
//                 color: tertiaryColor,
//               ),
//               child: // --------------------------------------------------------------------------[FRAME DETAIL CONTAINER 2]
//                   Row(
//                 children: [
//                   const Spacer(),
//                   Row(
//                     children: [
//                       Container(
//                         height: screenWidth * 0.11,
//                         decoration: BoxDecoration(
//                           color: secondaryColor,
//                           borderRadius: BorderRadius.circular(
//                               15.0), // Adjust the radius as needed
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Showcase(
//                               key: tutorial_deletePrev,
//                               title: 'Delete Previous',
//                               description:
//                                   'Press this to delete recent collected data',
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.restart_alt,
//                                   color: tertiaryColor,
//                                   size: screenWidth * .06, //
//                                 ),
//                                 onPressed: () {
//                                   undoExecution(1);
//                                 },
//                               ),
//                             ),
//                             Showcase(
//                               key: tutorial_pause,
//                               title: 'Pause',
//                               description:
//                                   'Press this to pause the collection of data',
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.pause,
//                                   color: tertiaryColor,
//                                   size: screenWidth * .06, //
//                                 ),
//                                 onPressed: () {
//                                   // simulateCollectData();
//                                   setState(() {
//                                     print("Pausing! --> $_isPause");
//                                     widget.onChangePause!(!_isPause);
//                                     _isPause = !_isPause;
//                                     ref.watch(isPerforming.notifier).state =
//                                         false;
//                                   });
//                                 },
//                               ),
//                             ),
//                             Showcase(
//                               key: tutorial_deleteAll,
//                               title: 'Delete All',
//                               description:
//                                   'Press this to delete all data collected',
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.delete_forever,
//                                   color: tertiaryColor,
//                                   size: screenWidth * .06, //
//                                 ),
//                                 onPressed: () {
//                                   undoExecution(ref
//                                               .watch(
//                                                   isCollectingCorrect.notifier)
//                                               .state ==
//                                           true
//                                       ? ref
//                                           .watch(coordinatesDataProvider)
//                                           .state
//                                           .length
//                                       : ref
//                                           .watch(
//                                               incorrectCoordinatesDataProvider)
//                                           .state
//                                           .length);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
// // ------------------------------------------------------------[DATASET COLLECTION CHANGE]
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.circular(15), // Dynamic radius
//                       ),
//                       backgroundColor:
//                           ref.watch(isCollectingCorrect.notifier).state == true
//                               ? Colors.green[800]
//                               : Colors.red[800],
//                       fixedSize: Size(
//                         screenWidth * 0.11,
//                         screenWidth * 0.11,
//                       ),
//                     ),
//                     onPressed: () {
//                       ref.watch(isPerforming.notifier).state = false;
//                       if (ref.watch(isCollectingCorrect.notifier).state ==
//                           true) {
//                         dialogBoxNotif(context, 6, "aasetsdaf");
//                         ref.watch(isCollectingCorrect.notifier).state = false;
//                       } else {
//                         dialogBoxNotif(context, 5, "aasetsdaf");
//                         ref.watch(isCollectingCorrect.notifier).state = true;
//                       }
//                     },
//                     child: ref.watch(isCollectingCorrect.notifier).state == true
//                         ? const Icon(
//                             Icons.check,
//                             size: 20,
//                             color: Colors.white,
//                           )
//                         : const Icon(
//                             Icons.close,
//                             size: 20,
//                             color: Colors.white,
//                           ),
//                   ),
//                   const Spacer(),
//                   Showcase(
//                     key: tutorial_submit,
//                     title: 'Submit',
//                     description:
//                         'After collecting data submit it to get a data analysis and proceed to the next part',
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: tertiaryColor,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: cwDataAnalysis(
//                         execCount: ref.watch(numExec),
//                         data: ref.watch(coordinatesDataProvider).state,
//                         data2:
//                             ref.watch(incorrectCoordinatesDataProvider).state,
//                         isRetraining: widget.isRetraining,
//                         isNewRetrain: widget.isNewRetrain,
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: non_constant_identifier_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/coreFunctionality/data_collection_provider.dart';
import 'package:frontend/screens/coreFunctionality/pose_provider.dart';
import 'package:frontend/widgets/dialog_box_notif.dart';
import 'package:frontend/widgets/error_widget.dart';
import 'package:frontend/widgets/execution_analysis.dart';
import 'package:frontend/widgets/ignore_pose.dart';

import 'dart:core';

import 'package:showcaseview/showcaseview.dart';

class DatasetCollection extends ConsumerStatefulWidget {
  final bool isRetraining;
  final bool isNewRetrain;
  final Function(int)? onChangeNoMovementBuffer;
  final Function(double)? onChangeChangeRange;
  final Function(bool)? onChangeShowPose;
  final Function(bool)? onChanegShowPreview;
  final Function(bool)? onChangePause;
  final Function(bool)? onChangeCollectingPositive;
  final Function(bool)? onChangeState;
  final void Function() onInitDatasetCalc;

  final List<List<List<double>>> positiveData;
  final List<List<List<double>>> negativeData;
  final bool isCollectingPositive;

  DatasetCollection({
    super.key,
    this.isRetraining = false,
    this.isNewRetrain = false,
    required this.onChangeNoMovementBuffer,
    required this.onInitDatasetCalc,
    required this.onChangeChangeRange,
    required this.onChangeShowPose,
    required this.onChanegShowPreview,
    required this.onChangePause,
    required this.onChangeState,
    required this.positiveData,
    required this.negativeData,
    required this.isCollectingPositive,
    required this.onChangeCollectingPositive,
  });

  @override
  ConsumerState<DatasetCollection> createState() => _DatasetCollectionState();
}

class _DatasetCollectionState extends ConsumerState<DatasetCollection> {
  bool isCollectingPositive = true;

  List<List<List<double>>> _positiveDataset = [];
  List<List<List<double>>> _negativeDataset = [];

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

  double avgFrames = 0.0;

  String resultAvgFrames = '';
  int execTotalFrames = 0;
  bool undoInit = false;
  bool _isPause = false;

  void undoExecution(int undoTimes) {
    print("positiveData-->${_positiveDataset.length}");
    for (int ctr = 0; ctr < undoTimes; ctr++) {
      if (widget.isCollectingPositive
          ? _positiveDataset.isNotEmpty
          : _negativeDataset.isNotEmpty) {
        widget.isCollectingPositive
            ? _positiveDataset.removeLast()
            : _negativeDataset.removeLast();
      }
    }

    setState(() {
      widget.onChangeState!(false);
    });
  }

  @override
  void initState() {
    _positiveDataset = widget.positiveData;
    _negativeDataset = widget.negativeData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Showcase(
                  key: tutorial_poseError,
                  title: 'Pose Error',
                  description:
                      'This indicates whether you whole body is present directly at the camera(Exceptions on parts of the body you ignored).',
                  child: poseError(
                    poseState: ref.watch(isAllCoordinatesPresent) == false,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Showcase(
                  key: tutorial_lightingError,
                  title: 'Lighting Error',
                  description:
                      'This indicates the lighting conditions. This could affect the accuracy of the model',
                  child: luminanceError(
                    lumincanceVlue: ref.watch(luminanceProvider),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Showcase(
                  key: tutorial_ignorePose,
                  title: 'Settings',
                  description:
                      'Press this to have the option to ignore certain parts of your body from being collected or being detected. This is usually used if a part of your body is behind something or not directly at the camera',
                  child: PoseSettings(
                    onChangeNoMovementBuffer: widget.onChangeNoMovementBuffer,
                    onChangeChangeRange: widget.onChangeChangeRange,
                    onChangeShowPose: widget.onChangeShowPose,
                    onChanegShowPreview: widget.onChanegShowPreview,
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      // ref.watch(isCollectingCorrect.notifier).state == true
                      widget.isCollectingPositive == true
                          ? _positiveDataset.length.toString()
                          : _negativeDataset.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.03,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.80,
                            height: screenHeight * 0.008,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.07),
                            ),
                            child: Showcase(
                              key: tutorial_progressBar,
                              title: 'Progress Bar',
                              description:
                                  'This indicates te amount of reps or data performed and collected.',
                              // child: ref
                              //             .watch(isCollectingCorrect.notifier)
                              //             .state ==
                              child: widget.isCollectingPositive == true
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.07),
                                      child: LinearProgressIndicator(
                                        value: ref
                                                    .watch(
                                                        coordinatesDataProvider)
                                                    .state
                                                    .length >
                                                requiredDataNum
                                            ? requiredDataNum
                                            : ref
                                                    .watch(
                                                        coordinatesDataProvider)
                                                    .state
                                                    .length /
                                                requiredDataNum,
                                        backgroundColor:
                                            tertiaryColor!.withOpacity(0.5),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.green.withOpacity(0.5)),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.07),
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
                                        backgroundColor:
                                            tertiaryColor!.withOpacity(0.5),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red.withOpacity(0.5)),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.question_mark,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    print("question mark pressed");
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
              ],
            ),
            Container(
              height: screenHeight * 0.1,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenHeight * .02),
                  topRight: Radius.circular(screenHeight * .02),
                ),
                color: tertiaryColor,
              ),
              child: // --------------------------------------------------------------------------[FRAME DETAIL CONTAINER 2]
                  Row(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        height: screenWidth * 0.11,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(
                              15.0), // Adjust the radius as needed
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Showcase(
                              key: tutorial_deletePrev,
                              title: 'Delete Previous',
                              description:
                                  'Press this to delete recent collected data',
                              child: IconButton(
                                icon: Icon(
                                  Icons.restart_alt,
                                  color: tertiaryColor,
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
                              description:
                                  'Press this to pause the collection of data',
                              child: IconButton(
                                icon: Icon(
                                  Icons.pause,
                                  color: tertiaryColor,
                                  size: screenWidth * .06, //
                                ),
                                onPressed: () {
                                  // simulateCollectData();
                                  setState(() {
                                    print("Pausing! --> $_isPause");
                                    widget.onChangePause!(!_isPause);
                                    _isPause = !_isPause;
                                    // ref.watch(isPerforming.notifier).state =
                                    //     false;
                                    widget.onChangeState!(false);
                                  });
                                },
                              ),
                            ),
                            Showcase(
                              key: tutorial_deleteAll,
                              title: 'Delete All',
                              description:
                                  'Press this to delete all data collected',
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: tertiaryColor,
                                  size: screenWidth * .06, //
                                ),
                                onPressed: () {

                                  
                                  undoExecution(
                                      widget.isCollectingPositive == true
                                          ? _positiveDataset.length
                                          : _negativeDataset.length);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
// ------------------------------------------------------------[DATASET COLLECTION CHANGE]
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Dynamic radius
                      ),
                      backgroundColor: widget.isCollectingPositive == true
                          ? Colors.green[800]
                          : Colors.red[800],
                      fixedSize: Size(
                        screenWidth * 0.11,
                        screenWidth * 0.11,
                      ),
                    ),
                    onPressed: () {
                      // ref.watch(isPerforming.notifier).state = false;
                      widget.onChangeState!(false);

                      if (widget.isCollectingPositive == true) {
                        dialogBoxNotif(context, 6, "aasetsdaf");
                        // ref.watch(isCollectingCorrect.notifier).state = false;
                        widget.onChangeCollectingPositive!(false);
                      } else {
                        dialogBoxNotif(context, 5, "aasetsdaf");
                        // ref.watch(isCollectingCorrect.notifier).state = true;
                        widget.onChangeCollectingPositive!(true);
                      }
                    },
                    child: widget.isCollectingPositive == true
                        ? const Icon(
                            Icons.check,
                            size: 20,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.white,
                          ),
                  ),
                  const Spacer(),
                  Showcase(
                    key: tutorial_submit,
                    title: 'Submit',
                    description:
                        'After collecting data submit it to get a data analysis and proceed to the next part',
                    child: Container(
                      decoration: BoxDecoration(
                        color: tertiaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // child: cwDataAnalysis(
                      //   execCount: ref.watch(numExec),
                      //   data: ref.watch(coordinatesDataProvider).state,
                      //   data2:
                      //       ref.watch(incorrectCoordinatesDataProvider).state,
                      //   isRetraining: widget.isRetraining,
                      //   isNewRetrain: widget.isNewRetrain,
                      // ),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onInitDatasetCalc();
                          Navigator.pop(context);
                        },
                        child: Text("Done"),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

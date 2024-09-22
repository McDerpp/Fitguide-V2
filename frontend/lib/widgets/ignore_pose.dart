// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/screens/coreFunctionality/globalVariables.dart';
// import 'package:frontend/screens/coreFunctionality/provider_collection.dart';

// import '../provider/main_settings.dart';
// import 'custom_button.dart';

// class IgnorePose extends ConsumerStatefulWidget {
//   const IgnorePose({super.key});

//   @override
//   ConsumerState<IgnorePose> createState() => _IgnorePoseState();
// }

// class _IgnorePoseState extends ConsumerState<IgnorePose> {
//   List<int> ignoreCoordinatesInitialized = [];
//   bool isInit = false;

//   Future<void> baseInit() async {
//     await initiateIgnoreCoordinates();
//   }

// // ignoreCoordinatesProvider
//   Future<void> initiateIgnoreCoordinates() async {
//     List<int> head = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
//     List<int> body = [12, 11, 24, 23];
//     List<int> leftArm = [11, 13, 21, 17, 19, 15];
//     List<int> rightArm = [12, 14, 16, 18, 20, 22];
//     List<int> leftLeg = [23, 25, 27, 29, 31];
//     List<int> rightLeg = [24, 26, 28, 32, 30];
//     ref.read(ignoreCoordinatesProvider).clear();

//     if (ref.watch(headBoolState) == true) {
//       for (int coordinate in head) {
//         ref.read(ignoreCoordinatesProvider).add(coordinate);
//       }
//       setState(() {});
//     }

//     if (ref.watch(bodyBoolState) == true) {
//       // ignoreCoordinatesInitialized.addAll(body);
//       for (int coordinate in body) {
//         ref.read(ignoreCoordinatesProvider).add(coordinate);
//       }
//       setState(() {});
//     }

//     if (ref.watch(leftArmBoolState) == true) {
//       // ignoreCoordinatesInitialized.addAll(leftArm);
//       for (int coordinate in leftArm) {
//         ref.read(ignoreCoordinatesProvider).add(coordinate);
//       }
//       setState(() {});
//     }

//     if (ref.watch(rightArmBoolState) == true) {
//       // ignoreCoordinatesInitialized.addAll(rightArm);
//       for (int coordinate in rightArm) {
//         ref.read(ignoreCoordinatesProvider).add(coordinate);
//       }
//       setState(() {});
//     }

//     if (ref.watch(leftLegBoolState) == true) {
//       // ignoreCoordinatesInitialized.addAll(leftLeg);
//       for (int coordinate in leftLeg) {
//         ref.read(ignoreCoordinatesProvider).add(coordinate);
//       }
//       setState(() {});
//     }

//     if (ref.watch(rightLegBoolState) == true) {
//       // ignoreCoordinatesInitialized.addAll(rightLeg);
//       for (int coordinate in rightLeg) {
//         ref.read(ignoreCoordinatesProvider).add(coordinate);
//       }
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   void dialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             // Builder for the AlertDialog
//             return AlertDialog(
//                 backgroundColor: mainColor,
//                 content: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       color: mainColorState.withOpacity(0),
//                       // width: MediaQuery.of(context).size.width * 0.80,
//                       height: MediaQuery.of(context).size.height * 0.235,
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Column(
//                                 children: [
//                                   // Row(
//                                   //   children: [
//                                   //     IconButton(
//                                   //       alignment: Alignment.topLeft,
//                                   //       padding: EdgeInsets.zero,
//                                   //       icon: Icon(
//                                   //         Icons.arrow_back,
//                                   //         color: ref.watch(tertiaryColorState),
//                                   //         size: screenWidth * .08,
//                                   //       ),
//                                   //       highlightColor: Colors.transparent,
//                                   //       onPressed: () {
//                                   //         Navigator.pop(context);
//                                   //       },
//                                   //     ),
//                                   //   ],
//                                   // ),
//                                   Row(
//                                     children: [
//                                       buildElevatedButton(
//                                         isCustom: true,
//                                         context: context,
//                                         label: "Head",
//                                         colorSet: ref.read(headColor),
//                                         textSizeModifierIndividual: ref.watch(
//                                             textSizeModifier)["smallText"]!,
//                                         func: () {
//                                           if (ref.watch(headBoolState) ==
//                                               true) {
//                                             ref
//                                                 .read(headBoolState.notifier)
//                                                 .state = false;
//                                             ref.read(headColor.notifier).state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet2"]!;
//                                           } else {
//                                             ref
//                                                 .read(headBoolState.notifier)
//                                                 .state = true;
//                                             ref.read(headColor.notifier).state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet1"]!;
//                                           }
//                                           setState(() {});
//                                           initiateIgnoreCoordinates(); // Update the AlertDialog content
//                                         },
//                                       ),
//                                       buildElevatedButton(
//                                         isCustom: true,
//                                         context: context,
//                                         label: "Body",
//                                         colorSet: ref.read(bodyColor),
//                                         textSizeModifierIndividual: ref.watch(
//                                             textSizeModifier)["smallText"]!,
//                                         func: () {
//                                           if (ref.watch(bodyBoolState) ==
//                                               true) {
//                                             ref
//                                                 .read(bodyBoolState.notifier)
//                                                 .state = false;
//                                             ref.read(bodyColor.notifier).state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet2"]!;
//                                           } else {
//                                             ref
//                                                 .read(bodyBoolState.notifier)
//                                                 .state = true;
//                                             ref.read(bodyColor.notifier).state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet1"]!;
//                                           }
//                                           setState(() {});
//                                           initiateIgnoreCoordinates(); // Update the AlertDialog content
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       buildElevatedButton(
//                                         isCustom: true,
//                                         context: context,
//                                         label: "Left Arm",
//                                         colorSet: ref.read(leftArmColor),
//                                         textSizeModifierIndividual: ref.watch(
//                                             textSizeModifier)["smallText"]!,
//                                         func: () {
//                                           if (ref.watch(leftArmBoolState) ==
//                                               true) {
//                                             ref
//                                                 .read(leftArmBoolState.notifier)
//                                                 .state = false;
//                                             ref
//                                                     .read(leftArmColor.notifier)
//                                                     .state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet2"]!;
//                                           } else {
//                                             ref
//                                                 .read(leftArmBoolState.notifier)
//                                                 .state = true;
//                                             ref
//                                                     .read(leftArmColor.notifier)
//                                                     .state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet1"]!;
//                                           }
//                                           setState(() {});
//                                           initiateIgnoreCoordinates(); // Update the AlertDialog content
//                                         },
//                                       ),
//                                       buildElevatedButton(
//                                         isCustom: true,
//                                         context: context,
//                                         label: "Right Arm",
//                                         colorSet: ref.read(rightArmColor),
//                                         textSizeModifierIndividual: ref.watch(
//                                             textSizeModifier)["smallText"]!,
//                                         func: () {
//                                           if (ref.watch(rightArmBoolState) ==
//                                               true) {
//                                             ref
//                                                 .read(
//                                                     rightArmBoolState.notifier)
//                                                 .state = false;
//                                             ref
//                                                     .read(rightArmColor.notifier)
//                                                     .state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet2"]!;
//                                           } else {
//                                             ref
//                                                 .read(
//                                                     rightArmBoolState.notifier)
//                                                 .state = true;
//                                             ref
//                                                     .read(rightArmColor.notifier)
//                                                     .state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet1"]!;
//                                           }
//                                           setState(() {});
//                                           initiateIgnoreCoordinates(); // Update the AlertDialog content
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       buildElevatedButton(
//                                         isCustom: true,
//                                         context: context,
//                                         label: "Left Leg",
//                                         colorSet: ref.read(leftLegColor),
//                                         textSizeModifierIndividual: ref.watch(
//                                             textSizeModifier)["smallText"]!,
//                                         func: () {
//                                           if (ref.watch(leftLegBoolState) ==
//                                               true) {
//                                             ref
//                                                 .read(leftLegBoolState.notifier)
//                                                 .state = false;
//                                             ref
//                                                     .read(leftLegColor.notifier)
//                                                     .state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet2"]!;
//                                           } else {
//                                             ref
//                                                 .read(leftLegBoolState.notifier)
//                                                 .state = true;
//                                             ref
//                                                     .read(leftLegColor.notifier)
//                                                     .state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet1"]!;
//                                           }
//                                           setState(() {});
//                                           initiateIgnoreCoordinates(); // Update the AlertDialog content
//                                         },
//                                       ),
//                                       buildElevatedButton(
//                                         isCustom: true,
//                                         context: context,
//                                         label: "Right Leg",
//                                         colorSet: ref.read(rightLegColor),
//                                         textSizeModifierIndividual: ref.watch(
//                                             textSizeModifier)["smallText"]!,
//                                         func: () {
//                                           if (ref.watch(rightLegBoolState) ==
//                                               true) {
//                                             ref
//                                                 .read(
//                                                     rightLegBoolState.notifier)
//                                                 .state = false;
//                                             ref
//                                                     .read(rightLegColor.notifier)
//                                                     .state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet2"]!;
//                                           } else {
//                                             ref
//                                                 .read(
//                                                     rightLegBoolState.notifier)
//                                                 .state = true;
//                                             ref
//                                                     .read(rightLegColor.notifier)
//                                                     .state =
//                                                 ref.watch(
//                                                     ColorSet)["ColorSet1"]!;
//                                           }
//                                           setState(() {});
//                                           initiateIgnoreCoordinates(); // Update the AlertDialog content
//                                         },
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               )

//                               // Other widgets...
//                             ],
//                           ),
//                           // Other widgets...
//                         ],
//                       ),
//                     ),
//                   ],
//                 )

//                 // actions: <Widget>[...],
//                 );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isInit == false) {
//       isInit = true;
//       initiateIgnoreCoordinates();
//     }

//     double screenWidth = MediaQuery.of(context).size.width;

//     return IconButton(
//       icon: Icon(
//         Icons.accessibility_sharp,
//         color: Colors.white,
//         size: screenWidth * .06, //
//       ),
//       onPressed: () {
//         // Call the dialog function
//         dialog(context);
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/coreFunctionality/pose_provider.dart';
import 'package:frontend/screens/dataCollection/create_exercise/data_collection_settings.dart';
import 'package:frontend/screens/inferencing/inferencing/mainUISettings.dart';
import 'package:frontend/widgets/custom_button.dart';

class PoseSettings extends ConsumerStatefulWidget {
  const PoseSettings({
    super.key,
    this.onChangeNoMovementBuffer,
    this.onChangeChangeRange,
    this.onChangeShowPose,
    this.onChanegShowPreview,
  });

  final Function(int)? onChangeNoMovementBuffer;
  final Function(double)? onChangeChangeRange;
  final Function(bool)? onChangeShowPose;
  final Function(bool)? onChanegShowPreview;

  @override
  ConsumerState<PoseSettings> createState() => _PoseSettingsState();
}

class _PoseSettingsState extends ConsumerState<PoseSettings> {
  int _noMovementBuffer = 0;
  double _changeRange = 0;
  List<int> ignoreCoordinatesInitialized = [];
  bool isInit = false;
  bool showPreview = true;
  bool showPose = true;

  Future<void> baseInit() async {
    await initiateIgnoreCoordinates();
  }

  void revertDefault() {
    _noMovementBuffer = noMovementBufferThresholdDefault;
    _changeRange = changeRangeDefault;
    showPreview = true;
    showPose = true;

    widget.onChangeNoMovementBuffer!(noMovementBufferThresholdDefault);
    widget.onChangeChangeRange!(changeRangeDefault);
    widget.onChangeShowPose!(true);
    widget.onChanegShowPreview!(true);

    ref.read(headBoolState.notifier).state = true;
    ref.read(headColor.notifier).state = ref.watch(ColorSet)["ColorSet1"]!;

    ref.read(bodyBoolState.notifier).state = true;
    ref.read(bodyColor.notifier).state = ref.watch(ColorSet)["ColorSet1"]!;

    ref.read(leftArmBoolState.notifier).state = true;
    ref.read(leftArmColor.notifier).state = ref.watch(ColorSet)["ColorSet1"]!;

    ref.read(rightArmBoolState.notifier).state = true;
    ref.read(rightArmColor.notifier).state = ref.watch(ColorSet)["ColorSet1"]!;

    ref.read(leftLegBoolState.notifier).state = true;
    ref.read(leftLegColor.notifier).state = ref.watch(ColorSet)["ColorSet1"]!;

    ref.read(rightLegBoolState.notifier).state = true;
    ref.read(rightLegColor.notifier).state = ref.watch(ColorSet)["ColorSet1"]!;
    initiateIgnoreCoordinates();
  }

// ignoreCoordinatesProvider
  Future<void> initiateIgnoreCoordinates() async {
    List<int> head = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    List<int> body = [12, 11, 24, 23];
    List<int> leftArm = [11, 13, 21, 17, 19, 15];
    List<int> rightArm = [12, 14, 16, 18, 20, 22];
    List<int> leftLeg = [23, 25, 27, 29, 31];
    List<int> rightLeg = [24, 26, 28, 32, 30];
    ref.read(ignoreCoordinatesProvider).clear();

    if (ref.watch(headBoolState) == true) {
      for (int coordinate in head) {
        ref.read(ignoreCoordinatesProvider).add(coordinate);
      }
      setState(() {});
    }

    if (ref.watch(bodyBoolState) == true) {
      // ignoreCoordinatesInitialized.addAll(body);
      for (int coordinate in body) {
        ref.read(ignoreCoordinatesProvider).add(coordinate);
      }
      setState(() {});
    }

    if (ref.watch(leftArmBoolState) == true) {
      // ignoreCoordinatesInitialized.addAll(leftArm);
      for (int coordinate in leftArm) {
        ref.read(ignoreCoordinatesProvider).add(coordinate);
      }
      setState(() {});
    }

    if (ref.watch(rightArmBoolState) == true) {
      // ignoreCoordinatesInitialized.addAll(rightArm);
      for (int coordinate in rightArm) {
        ref.read(ignoreCoordinatesProvider).add(coordinate);
      }
      setState(() {});
    }

    if (ref.watch(leftLegBoolState) == true) {
      // ignoreCoordinatesInitialized.addAll(leftLeg);
      for (int coordinate in leftLeg) {
        ref.read(ignoreCoordinatesProvider).add(coordinate);
      }
      setState(() {});
    }

    if (ref.watch(rightLegBoolState) == true) {
      // ignoreCoordinatesInitialized.addAll(rightLeg);
      for (int coordinate in rightLeg) {
        ref.read(ignoreCoordinatesProvider).add(coordinate);
      }
      setState(() {});
    }
  }

  // Widget poseButton(String label,) {
  //   return buildElevatedButton(
  //     isCustom: true,
  //     context: context,
  //     label: "Head",
  //     colorSet: ref.read(headColor),
  //     textSizeModifierIndividual: ref.watch(textSizeModifier)["smallText"]!,
  //     func: () {
  //       if (ref.watch(headBoolState) == true) {
  //         ref.read(headBoolState.notifier).state = false;
  //         ref.read(headColor.notifier).state =
  //             ref.watch(ColorSet)["ColorSet2"]!;
  //       } else {
  //         ref.read(headBoolState.notifier).state = true;
  //         ref.read(headColor.notifier).state =
  //             ref.watch(ColorSet)["ColorSet1"]!;
  //       }
  //       setState(() {});
  //       initiateIgnoreCoordinates();
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _noMovementBuffer = noMovementBufferThresholdDefault;
    _changeRange = changeRangeDefault;
  }

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Builder for the AlertDialog
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Container(
                color: mainColorState.withOpacity(0),
                height: MediaQuery.of(context).size.height * 0.67,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.64,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              'No Movement Buffer: ${_noMovementBuffer.toStringAsFixed(2)}'),
                          Slider(
                            value: _noMovementBuffer.toDouble(),
                            min: 0.0,
                            max: 50.0,
                            divisions: 50,
                            label: _noMovementBuffer.toStringAsFixed(2),
                            onChanged: (value) {
                              widget.onChangeNoMovementBuffer!(value.toInt());
                              setState(
                                () {
                                  _noMovementBuffer = value.toInt();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.64,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              'Change range counter: ${_changeRange.toStringAsFixed(2)}'),
                          Slider(
                            value: _changeRange,
                            min: 0.0,
                            max: 100.0,
                            divisions: 20,
                            label: _changeRange.toStringAsFixed(2),
                            onChanged: (value) {
                              widget.onChangeChangeRange!(value / 1000);

                              setState(
                                () {
                                  _changeRange = value;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showPreview = !showPreview;
                                  widget.onChanegShowPreview!(showPreview);
                                });
                              },
                              icon: Icon(showPreview
                                  ? Icons.check_box_outline_blank_outlined
                                  : Icons.check_box),
                            ),
                            const Text("Hide Camera Preview"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showPose = !showPose;
                                  widget.onChangeShowPose!(showPose);
                                });
                              },
                              icon: Icon(showPose
                                  ? Icons.check_box_outline_blank_outlined
                                  : Icons.check_box),
                            ),
                            const Text("Hide Pose"),
                          ],
                        ),
                      ],
                    ),

                    const Center(
                      child: Text("Ignore Coordinates"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                buildElevatedButton(
                                  isCustom: true,
                                  context: context,
                                  label: "Head",
                                  colorSet: ref.read(headColor),
                                  textSizeModifierIndividual:
                                      ref.watch(textSizeModifier)["smallText"]!,
                                  func: () {
                                    if (ref.watch(headBoolState) == true) {
                                      ref.read(headBoolState.notifier).state =
                                          false;
                                      ref.read(headColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet2"]!;
                                    } else {
                                      ref.read(headBoolState.notifier).state =
                                          true;
                                      ref.read(headColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet1"]!;
                                    }
                                    setState(() {});
                                    initiateIgnoreCoordinates();
                                  },
                                ),
                                buildElevatedButton(
                                  isCustom: true,
                                  context: context,
                                  label: "Body",
                                  colorSet: ref.read(bodyColor),
                                  textSizeModifierIndividual:
                                      ref.watch(textSizeModifier)["smallText"]!,
                                  func: () {
                                    if (ref.watch(bodyBoolState) == true) {
                                      ref.read(bodyBoolState.notifier).state =
                                          false;
                                      ref.read(bodyColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet2"]!;
                                    } else {
                                      ref.read(bodyBoolState.notifier).state =
                                          true;
                                      ref.read(bodyColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet1"]!;
                                    }
                                    setState(() {});
                                    initiateIgnoreCoordinates(); // Update the AlertDialog content
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                buildElevatedButton(
                                  isCustom: true,
                                  context: context,
                                  label: "Left Arm",
                                  colorSet: ref.read(leftArmColor),
                                  textSizeModifierIndividual:
                                      ref.watch(textSizeModifier)["smallText"]!,
                                  func: () {
                                    if (ref.watch(leftArmBoolState) == true) {
                                      ref
                                          .read(leftArmBoolState.notifier)
                                          .state = false;
                                      ref.read(leftArmColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet2"]!;
                                    } else {
                                      ref
                                          .read(leftArmBoolState.notifier)
                                          .state = true;
                                      ref.read(leftArmColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet1"]!;
                                    }
                                    setState(() {});
                                    initiateIgnoreCoordinates(); // Update the AlertDialog content
                                  },
                                ),
                                buildElevatedButton(
                                  isCustom: true,
                                  context: context,
                                  label: "Right Arm",
                                  colorSet: ref.read(rightArmColor),
                                  textSizeModifierIndividual:
                                      ref.watch(textSizeModifier)["smallText"]!,
                                  func: () {
                                    if (ref.watch(rightArmBoolState) == true) {
                                      ref
                                          .read(rightArmBoolState.notifier)
                                          .state = false;
                                      ref.read(rightArmColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet2"]!;
                                    } else {
                                      ref
                                          .read(rightArmBoolState.notifier)
                                          .state = true;
                                      ref.read(rightArmColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet1"]!;
                                    }
                                    setState(() {});
                                    initiateIgnoreCoordinates(); // Update the AlertDialog content
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                buildElevatedButton(
                                  isCustom: true,
                                  context: context,
                                  label: "Left Leg",
                                  colorSet: ref.read(leftLegColor),
                                  textSizeModifierIndividual:
                                      ref.watch(textSizeModifier)["smallText"]!,
                                  func: () {
                                    if (ref.watch(leftLegBoolState) == true) {
                                      ref
                                          .read(leftLegBoolState.notifier)
                                          .state = false;
                                      ref.read(leftLegColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet2"]!;
                                    } else {
                                      ref
                                          .read(leftLegBoolState.notifier)
                                          .state = true;
                                      ref.read(leftLegColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet1"]!;
                                    }
                                    setState(() {});
                                    initiateIgnoreCoordinates(); // Update the AlertDialog content
                                  },
                                ),
                                buildElevatedButton(
                                  isCustom: true,
                                  context: context,
                                  label: "Right Leg",
                                  colorSet: ref.read(rightLegColor),
                                  textSizeModifierIndividual:
                                      ref.watch(textSizeModifier)["smallText"]!,
                                  func: () {
                                    if (ref.watch(rightLegBoolState) == true) {
                                      ref
                                          .read(rightLegBoolState.notifier)
                                          .state = false;
                                      ref.read(rightLegColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet2"]!;
                                    } else {
                                      ref
                                          .read(rightLegBoolState.notifier)
                                          .state = true;
                                      ref.read(rightLegColor.notifier).state =
                                          ref.watch(ColorSet)["ColorSet1"]!;
                                    }
                                    setState(() {});
                                    initiateIgnoreCoordinates(); // Update the AlertDialog content
                                  },
                                ),
                              ],
                            )
                          ],
                        )

                        // Other widgets...
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () {
                          setState(() {
                            revertDefault();
                          });
                        },
                        child: const Text(
                          "Revert to Default",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )

                    // Other widgets...
                  ],
                ),
              ),

              // actions: <Widget>[...],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      isInit = true;
      initiateIgnoreCoordinates();
    }

    return IconButton(
      icon: const Icon(
        Icons.settings,
        color: Colors.white, // Replace with your secondaryColor
      ),
      onPressed: () {
        // Call the dialog function
        dialog(context);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/coreFunctionality/globalVariables.dart';
import 'package:frontend/screens/coreFunctionality/provider_collection.dart';

import '../provider/main_settings.dart';
import 'custom_button.dart';

class IgnorePose extends ConsumerStatefulWidget {
  const IgnorePose({super.key});

  @override
  ConsumerState<IgnorePose> createState() => _IgnorePoseState();
}

class _IgnorePoseState extends ConsumerState<IgnorePose> {
  List<int> ignoreCoordinatesInitialized = [];
  bool isInit = false;

  Future<void> baseInit() async {
    await initiateIgnoreCoordinates();
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

  @override
  void initState() {
    super.initState();
  }

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Builder for the AlertDialog
            return AlertDialog(
                backgroundColor: mainColor,
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: mainColorState.withOpacity(0),
                      // width: MediaQuery.of(context).size.width * 0.80,
                      height: MediaQuery.of(context).size.height * 0.235,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  // Row(
                                  //   children: [
                                  //     IconButton(
                                  //       alignment: Alignment.topLeft,
                                  //       padding: EdgeInsets.zero,
                                  //       icon: Icon(
                                  //         Icons.arrow_back,
                                  //         color: ref.watch(tertiaryColorState),
                                  //         size: screenWidth * .08,
                                  //       ),
                                  //       highlightColor: Colors.transparent,
                                  //       onPressed: () {
                                  //         Navigator.pop(context);
                                  //       },
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      buildElevatedButton(
                                        isCustom: true,
                                        context: context,
                                        label: "Head",
                                        colorSet: ref.read(headColor),
                                        textSizeModifierIndividual: ref.watch(
                                            textSizeModifier)["smallText"]!,
                                        func: () {
                                          if (ref.watch(headBoolState) ==
                                              true) {
                                            ref
                                                .read(headBoolState.notifier)
                                                .state = false;
                                            ref.read(headColor.notifier).state =
                                                ref.watch(
                                                    ColorSet)["ColorSet2"]!;
                                          } else {
                                            ref
                                                .read(headBoolState.notifier)
                                                .state = true;
                                            ref.read(headColor.notifier).state =
                                                ref.watch(
                                                    ColorSet)["ColorSet1"]!;
                                          }
                                          setState(() {});
                                          initiateIgnoreCoordinates(); // Update the AlertDialog content
                                        },
                                      ),
                                      buildElevatedButton(
                                        isCustom: true,
                                        context: context,
                                        label: "Body",
                                        colorSet: ref.read(bodyColor),
                                        textSizeModifierIndividual: ref.watch(
                                            textSizeModifier)["smallText"]!,
                                        func: () {
                                          if (ref.watch(bodyBoolState) ==
                                              true) {
                                            ref
                                                .read(bodyBoolState.notifier)
                                                .state = false;
                                            ref.read(bodyColor.notifier).state =
                                                ref.watch(
                                                    ColorSet)["ColorSet2"]!;
                                          } else {
                                            ref
                                                .read(bodyBoolState.notifier)
                                                .state = true;
                                            ref.read(bodyColor.notifier).state =
                                                ref.watch(
                                                    ColorSet)["ColorSet1"]!;
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
                                        textSizeModifierIndividual: ref.watch(
                                            textSizeModifier)["smallText"]!,
                                        func: () {
                                          if (ref.watch(leftArmBoolState) ==
                                              true) {
                                            ref
                                                .read(leftArmBoolState.notifier)
                                                .state = false;
                                            ref
                                                    .read(leftArmColor.notifier)
                                                    .state =
                                                ref.watch(
                                                    ColorSet)["ColorSet2"]!;
                                          } else {
                                            ref
                                                .read(leftArmBoolState.notifier)
                                                .state = true;
                                            ref
                                                    .read(leftArmColor.notifier)
                                                    .state =
                                                ref.watch(
                                                    ColorSet)["ColorSet1"]!;
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
                                        textSizeModifierIndividual: ref.watch(
                                            textSizeModifier)["smallText"]!,
                                        func: () {
                                          if (ref.watch(rightArmBoolState) ==
                                              true) {
                                            ref
                                                .read(
                                                    rightArmBoolState.notifier)
                                                .state = false;
                                            ref
                                                    .read(rightArmColor.notifier)
                                                    .state =
                                                ref.watch(
                                                    ColorSet)["ColorSet2"]!;
                                          } else {
                                            ref
                                                .read(
                                                    rightArmBoolState.notifier)
                                                .state = true;
                                            ref
                                                    .read(rightArmColor.notifier)
                                                    .state =
                                                ref.watch(
                                                    ColorSet)["ColorSet1"]!;
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
                                        textSizeModifierIndividual: ref.watch(
                                            textSizeModifier)["smallText"]!,
                                        func: () {
                                          if (ref.watch(leftLegBoolState) ==
                                              true) {
                                            ref
                                                .read(leftLegBoolState.notifier)
                                                .state = false;
                                            ref
                                                    .read(leftLegColor.notifier)
                                                    .state =
                                                ref.watch(
                                                    ColorSet)["ColorSet2"]!;
                                          } else {
                                            ref
                                                .read(leftLegBoolState.notifier)
                                                .state = true;
                                            ref
                                                    .read(leftLegColor.notifier)
                                                    .state =
                                                ref.watch(
                                                    ColorSet)["ColorSet1"]!;
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
                                        textSizeModifierIndividual: ref.watch(
                                            textSizeModifier)["smallText"]!,
                                        func: () {
                                          if (ref.watch(rightLegBoolState) ==
                                              true) {
                                            ref
                                                .read(
                                                    rightLegBoolState.notifier)
                                                .state = false;
                                            ref
                                                    .read(rightLegColor.notifier)
                                                    .state =
                                                ref.watch(
                                                    ColorSet)["ColorSet2"]!;
                                          } else {
                                            ref
                                                .read(
                                                    rightLegBoolState.notifier)
                                                .state = true;
                                            ref
                                                    .read(rightLegColor.notifier)
                                                    .state =
                                                ref.watch(
                                                    ColorSet)["ColorSet1"]!;
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
                          // Other widgets...
                        ],
                      ),
                    ),
                  ],
                )

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

    double screenWidth = MediaQuery.of(context).size.width;

    return IconButton(
      icon: Icon(
        Icons.accessibility_sharp,
        color: Colors.white,
        size: screenWidth * .06, //
      ),
      onPressed: () {
        // Call the dialog function
        dialog(context);
      },
    );
  }
}

// ignore_for_file: unused_local_variable, unused_field

import 'dart:core';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/misc/logicFunction/isolateProcessPDV.dart';
import 'package:frontend/misc/pose/detector_view.dart';
import 'package:frontend/misc/pose/pose_painter.dart';
import 'package:frontend/screens/coreFunctionality/data_collection_provider.dart';
import 'package:frontend/screens/coreFunctionality/mainUISettings.dart';
import 'package:frontend/screens/coreFunctionality/pose_provider.dart';
import 'package:frontend/screens/dataCollection/create_exercise/data_collection_settings.dart';
import 'package:frontend/screens/dataCollection/create_exercise/dataset_collection.dart';
import 'package:frontend/widgets/count_down.dart';
import 'package:frontend/widgets/error_widget.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class BaseCollection extends ConsumerStatefulWidget {
  final bool isRetraining;
  final bool isNewRetrain;

  const BaseCollection({
    super.key,
    this.isRetraining = false,
    this.isNewRetrain = false,
  });

  @override
  ConsumerState<BaseCollection> createState() => _BaseCollectionState();
}

class _BaseCollectionState extends ConsumerState<BaseCollection> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController? _cameraController;

  String resultAvgFrames = '';

  // ---------------------inferencing mode variables----------------------------------------------------------
  // isolate initialization for heavy process
  RootIsolateToken rootIsolateTokenNormalization = RootIsolateToken.instance!;
  RootIsolateToken rootIsolateTokenNoMovement = RootIsolateToken.instance!;
  RootIsolateToken rootIsolateTokenInferencing = RootIsolateToken.instance!;
  RootIsolateToken rootIsolateTokenTranslating = RootIsolateToken.instance!;

// IMPORTANT CONFIGURATIONS---------------------------------------------------------------------------------------
  // double requiredDataNum = 50;
// IMPORTANT CONFIGURATIONS---------------------------------------------------------------------------------------
  late Size sizeTemp;
  late InputImageRotation rotationTemp;
  late CameraLensDirection cameraLensDirectionTemp;

  List<double> prevCoordinates = [];
  List<double> currentCoordinates = [];
  List<List<double>> inferencingList = [];
  List<List<double>> tempPrevCurr = [];
  List<List<List<double>>> coordinatesData = [];

  int noMovementBufferCtr = 0;

  int bufferCtr = 0;

  List<Map<String, dynamic>> queueNormalizeData = [];
  List<Map<String, dynamic>> queueMovementData = [];
  List<Map<String, dynamic>> queueInferencingData = [];
  int executionStateResult = 0;

  Map<String, double> boundingBox = {};
  List<double> temp = [];
  bool nowCollecting = false;

  final CountDownController _countDownController = CountDownController();
  bool countDowntoPerform = false;

  bool showPose = true;
  bool showVideoPreview = true;
  bool _isPause = false;

  bool isPerforming = false;

  int noMovementBufferThreshold = 0;
  double changeRange = 0;

  @override
  void initState() {
    super.initState();
    noMovementBufferThreshold = noMovementBufferThresholdDefault;
    changeRange = changeRangeDefault;
  }

  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  void onChangeNoMovementBuffer(int bufferCount) {
    setState(() {
      noMovementBufferThreshold = bufferCount;
    });
  }

  void onChangeChangeRange(double changeRangeCount) {
    setState(() {
      changeRange = changeRangeCount;
    });
  }

  void onChangeShowPose(bool showPoseValue) {
    print("pose show adjust");

    setState(() {
      showPose = showPoseValue;
    });
  }

  void onChanegShowPreview(bool showPreviewValue) {
    print("preview showing adjust");
    setState(() {
      showVideoPreview = showPreviewValue;
    });
  }

  void onChangeState(bool performing) {
    print("now performing");
    setState(() {
      isPerforming = performing;
    });
  }

  void onChangePause(bool isPause) {
    print("preview showing adjust");
    setState(() {
      _isPause = isPause;
    });
  }

  void _handleControllerInitialized(CameraController controller) {
    print("video controller handled");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _cameraController = controller;
        });
      }
    });
  }

  void dataMovementCheck() {
    // true --> no movement
//  false --> movement detected
    try {
      if (queueMovementData.isNotEmpty) {
        compute(checkMovement, queueMovementData.elementAt(0)).then(
          (value) async {
            queueMovementData.removeAt(0);
            if (isPerforming == true) {
              if (value == false) {
                nowCollecting = true;
              }
              if (nowCollecting == false) {
                inferencingList = [];
              }
              if (nowCollecting == true) {
                if (value == true) {
                  if (temp.isNotEmpty) {
                    inferencingList.add(temp);
                    temp = [];
                  }
                  noMovementBufferCtr++;
                  if (inferencingList.isNotEmpty &&
                      noMovementBufferCtr == noMovementBufferThreshold) {
                    executionStateResult = 2;
                    noMovementBufferCtr = 0;

                    inferencingList.removeRange(
                        inferencingList.length - noMovementBufferThreshold,
                        inferencingList.length);

                    if (ref.read(isCollectingCorrect) == true) {
                      ref
                          .read(coordinatesDataProvider)
                          .addItem(inferencingList);
                      ref.read(numExec.notifier).state++;
                    } else {
                      ref
                          .read(incorrectCoordinatesDataProvider)
                          .addItem(inferencingList);
                      ref.read(numExecNegative.notifier).state++;
                    }

                    nowCollecting = false;
                    inferencingList = [];
                  }
                } else {
                  executionStateResult = 1;
                  if (temp.isNotEmpty) {
                    noMovementBufferCtr = 0;
                    inferencingList.add(temp);
                    temp = [];
                  }
                }
              }
            }

            // if no movement and not performing yet
            if (value == true && isPerforming == false) {
              // if countdown has not yet started then start it
              if (countDowntoPerform == false) {
                _countDownController.start();
                countDowntoPerform = true;
              }

              // if countdown reached to 0 and no
              if (_countDownController.getTime().toString() == "0") {
                print("DONE!");
                inferencingList = [];
                isPerforming = true;
              }
            }

            if (isPerforming == false &&
                countDowntoPerform == true &&
                value == false) {
              _countDownController.reset();
              countDowntoPerform = false;
            }
          },
        ).catchError(
          (error) {},
        );
      }
    } catch (error) {
      print("Erorr at check movement function -> $error");
    }
  }

  void relativeDataBox() {
    try {
      if (queueNormalizeData.isNotEmpty) {
        if (bufferCtr >= bufferNum) {
          bufferCtr = 0;
          compute(coordinatesRelativeBoxIsolate,
                  queueNormalizeData.elementAt(0))
              .then((value) {
            queueNormalizeData.removeAt(0);
            tempPrevCurr.add(value['translatedCoordinates']);

            if (isPerforming == true) {
              temp = value['translatedCoordinates'];
              boundingBox = value['minMaxCoordinatesXY'];
            }
            ref.read(isAllCoordinatesPresent.notifier).state =
                value['allCoordinatesPresent'];

            if (tempPrevCurr.length > 1) {
              prevCoordinates = tempPrevCurr.elementAt(0);
              currentCoordinates = tempPrevCurr.elementAt(1);

              Map<String, dynamic> checkMovementIsolate = {
                'minMaxCoordinatesXY': value['minMaxCoordinatesXY'],
                'prevCoordinates': prevCoordinates,
                'currentCoordinates': currentCoordinates,
                'token': rootIsolateTokenNoMovement,
                'screenHeight': MediaQuery.of(context).size.height,
                'screenWidth': MediaQuery.of(context).size.width,
                'poseLikelihood': value['poseLikelihood'],
              };
              queueMovementData.add(checkMovementIsolate);
              tempPrevCurr.removeAt(0);
            }
          }).catchError((error) {});
        } else {
          queueNormalizeData.removeAt(0);
        }
      }
    } catch (error) {
      print("Error at relative data box function -> $error");
    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    try {
      if (!_canProcess) return;
      if (_isBusy) return;
      if (_isPause) return;
      _isBusy = true;
      late final List<Pose> poses;

      try {
        poses = await _poseDetector.processImage(inputImage);
        Map<String, dynamic> dataNormalizationIsolate = {
          'inputImage': poses.first.landmarks.values,
          'token': rootIsolateTokenNormalization,
          'coordinatesIgnore': ref.read(ignoreCoordinatesProvider),
        };

        queueNormalizeData.add(dataNormalizationIsolate);
      } catch (error) {}
      bufferCtr++;
      relativeDataBox();
      dataMovementCheck();

      if (inputImage.metadata?.size != null &&
          inputImage.metadata?.rotation != null) {
        setState(() {
          sizeTemp = inputImage.metadata!.size;
          rotationTemp = inputImage.metadata!.rotation;
          cameraLensDirectionTemp = _cameraLensDirection;
        });

        final painter = PosePainter(
          poses,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection,
          executionStateResult,
          ref.read(ignoreCoordinatesProvider),
          // boundingBox,
        );
        _customPaint = CustomPaint(painter: painter);
      } else {
        _text = 'Poses found: ${poses.length}\n\n';

        _customPaint = null;
      }
      _isBusy = false;
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print("Error at process image -> $error");
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textSizeModif = (screenHeight + screenWidth) * textAdaptModifier;
    Widget displayCountdownTimer;

    if (isPerforming == true) {
      displayCountdownTimer = const noDisplay();
    } else {
      displayCountdownTimer = countDownTimer(
        controller: _countDownController,
      );
    }
    if (_cameraController == null) {
      print("_cameraController is null");
    }
    return ShowCaseWidget(
      builder: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  color: Colors.amber,
                  width: screenWidth,
                  height: screenHeight,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: DetectorView(
                      isCollecting: true,
                      title: 'Pose Detector',
                      customPaint: null,
                      text: _text,
                      onImage: _processImage,
                      initialCameraLensDirection: _cameraLensDirection,
                      onCameraLensDirectionChanged: (value) =>
                          _cameraLensDirection = value,
                      onControllerInitialized: _handleControllerInitialized,
                    ),
                  ),
                ),
                _cameraController != null && showVideoPreview
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: screenWidth,
                          height: screenHeight,
                          child: Transform.scale(
                            scaleX: 1.39 * scaleX,
                            scaleY: 1.39 * scaleY,
                            alignment: Alignment.center,
                            child: CameraPreview(
                              _cameraController!,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                // // Center(
                // //   child: TextCutOutExample(),
                // // ),
                showPose
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: screenWidth,
                          height: screenHeight,
                          child: Transform.scale(
                            scaleX: 1.39 * scaleX,
                            scaleY: 1.39 * scaleY,
                            alignment: Alignment.center,
                            child: _customPaint ?? const Text(""),
                          ),
                        ),
                      )
                    : const SizedBox(),
                countDownTimer(
                  controller: _countDownController,
                  isPerforming: isPerforming,
                ),
                isPerforming
                    ? SizedBox()
                    : Center(
                        child: Text(
                          "Dont move to start collecting",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),

                DatasetCollection(
                  onChangeNoMovementBuffer: onChangeNoMovementBuffer,
                  onChangeChangeRange: onChangeChangeRange,
                  isRetraining: widget.isRetraining,
                  isNewRetrain: widget.isNewRetrain,
                  onChangeShowPose: onChangeShowPose,
                  onChanegShowPreview: onChanegShowPreview,
                  onChangePause: onChangePause,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

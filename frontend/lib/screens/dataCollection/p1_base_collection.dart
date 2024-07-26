import 'dart:core';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/misc/logicFunction/isolateProcessPDV.dart';
import 'package:frontend/misc/pose/detector_view.dart';
import 'package:frontend/misc/pose/pose_painter.dart';
import 'package:frontend/screens/coreFunctionality/globalVariables.dart';
import 'package:frontend/screens/coreFunctionality/provider_collection.dart';
import 'package:frontend/screens/dataCollection/p1_datset_collection.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/widgets/error_widget.dart';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import '../coreFunctionality/mainUISettings.dart';

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
  List<List<Pose>> tempPose = [];
  late Size sizeTemp;
  late InputImageRotation rotationTemp;
  late CameraLensDirection cameraLensDirectionTemp;

  List<double> prevCoordinates = [];
  List<double> currentCoordinates = [];
  List<List<double>> inferencingList = [];
  List<List<double>> tempPrevCurr = [];
  List<List<List<double>>> coordinatesData = [];

  int noMovementBufferThreshold = 5;
  int noMovementBufferCtr = 0;
  int framesCapturedCtr = 0;
  int execTotalFrames = 0;
  double avgFrames = 0.0;
  int minFrame = 0;
  int maxFrame = 0;
  int buffer = 4;
  int bufferCtr = 0;

  List<Map<String, dynamic>> queueNormalizeData = [];
  List<Map<String, dynamic>> queueMovementData = [];
  List<Map<String, dynamic>> queueInferencingData = [];
  int executionStateResult = 0;

  List<double> temp = [];
  bool executionCaptured = false;
  bool nowCollecting = false;
  bool isDataCollected = false;

  late Map<String, Color> colorSet1;
  late Map<String, Color> colorSet2;

  List<int> ignoreCoordinatesInitialized = [];

// [head,leftArm,rightArm,leftLeg,rightLeg,body]
  // List<bool> igrnoreCoordinatesList = [
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false
  // ];

  final CountDownController _controller = CountDownController();
  // bool nowPerforming = false;
  bool countDowntoPerform = false;
  bool checkCountDowntoPerform = false;

  String dynamicCountDownText = 'Ready';
  Color dynamicCountDownColor = secondaryColor;

  @override
  void initState() {
    super.initState();
  }

  // List<List<Pose>> poseQueue = [];
  // List<List<double>> queueNormalizedListQueue = [];

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
    // _poseDetector.close();
    super.dispose();
  }

  Future<void> _processImage(InputImage inputImage) async {
    // createFile();
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    late final List<Pose> poses;
    // bool noMovement = false;

    setState(() {
      _text = '';
    });

// // ==================================[isolate function processImage ]==================================
    try {
      poses = await _poseDetector.processImage(inputImage);
      Map<String, dynamic> dataNormalizationIsolate = {
        'inputImage': poses.first.landmarks.values,
        'token': rootIsolateTokenNormalization,
        'coordinatesIgnore': ref.read(ignoreCoordinatesProvider),
      };

      queueNormalizeData.add(dataNormalizationIsolate);
    } catch (error) {}

    // buffering code
    bufferCtr++;

// // ==================================[isolate function forcoordinatesRelativeBoxIsolate ]==================================
    if (queueNormalizeData.isNotEmpty) {
      if (bufferCtr >= buffer) {
        bufferCtr = 0;

        compute(coordinatesRelativeBoxIsolate, queueNormalizeData.elementAt(0))
            .then((value) {
          queueNormalizeData.removeAt(0);
          tempPrevCurr.add(value['translatedCoordinates']);

          if (ref.watch(isPerforming) == true) {
            temp = value['translatedCoordinates'];
          }

          setState(() {
            ref.watch(isAllCoordinatesPresent.notifier).state =
                value['allCoordinatesPresent'];
          });

          if (tempPrevCurr.length > 1) {
            prevCoordinates = tempPrevCurr.elementAt(0);
            currentCoordinates = tempPrevCurr.elementAt(1);

            Map<String, dynamic> checkMovementIsolate = {
              'prevCoordinates': prevCoordinates,
              'currentCoordinates': currentCoordinates,
              'token': rootIsolateTokenNoMovement,
            };
            queueMovementData.add(checkMovementIsolate);
            tempPrevCurr.removeAt(0);
          }
        }).catchError((error) {});
      } else {
        queueNormalizeData.removeAt(0);
      }
    }

// true --> no movement
//  false --> movement detected
    if (queueMovementData.isNotEmpty) {
      compute(checkMovement, queueMovementData.elementAt(0))
          .then((value) async {
        queueMovementData.removeAt(0);

        if (ref.watch(isPerforming) == true) {
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
                  ref.read(coordinatesDataProvider).addItem(inferencingList);
                  ref.read(numExec.notifier).state++;
                  // execTotalFrames = execTotalFrames + inferencingList.length;
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

        if (value == true && ref.watch(isPerforming) == false) {
          if (countDowntoPerform == false) {
            _controller.start();
            countDowntoPerform = true;
            dynamicCountDownText = 'Perform';
          }

          if (_controller.getTime().toString() == "3" &&
              ref.watch(isPerforming) == false) {
            inferencingList = [];

            ref.watch(isPerforming.notifier).state = true;
          }
        }
        // -----------------checking for movement before executing for collecting data--------------------------------------

        if (ref.watch(isPerforming) == false &&
            countDowntoPerform == true &&
            value == false) {
          _controller.reset();
          countDowntoPerform = false;
        }
        // -----------------------------------------------------------------------------------------------------------
      }).catchError((error) {});
    }

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
          ref.watch(ignoreCoordinatesProvider));
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Poses found: ${poses.length}\n\n';

      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Widget timerCountDown(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textSizeModif = (screenHeight + screenWidth) * textAdaptModifier;
    return Align(
        alignment: const Alignment(0.0, -0.2),
        child: CircularCountDownTimer(
          duration: currentDuration,
          initialDuration: 0,
          controller: _controller,
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 1.5,
          ringColor: Colors.transparent,
          ringGradient: null,
          fillColor: Colors.white,
          fillGradient: null,
          backgroundColor: Colors.transparent,
          backgroundGradient: null,
          strokeWidth: screenWidth * .10,
          strokeCap: StrokeCap.round,
          textStyle: TextStyle(
              fontSize: 50.0 * textSizeModif,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textFormat: CountdownTextFormat.S,
          isReverse: false,
          isReverseAnimation: true,
          isTimerTextShown: true,
          autoStart: false,
          onStart: () {},
          onComplete: () {},
          onChange: (String timeStamp) {},
          timeFormatterFunction: (defaultFormatterFunction, duration) {
            // if (nowPerforming == true) {
            if (ref.watch(isPerforming) == true) {
              return dynamicCountDownText;
            } else {
              return Function.apply(defaultFormatterFunction, [duration]);
            }
          },
        )
        // countdownTimer(context, dynamicCountDownText,
        //     dynamicCountDownColor, _controller)
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

    // Color color1 = ref.watch(mainColorState);
    // Color color2 = ref.watch(secondaryColorState);
    // Color color3 = ref.watch(tertiaryColorState);

    var textSizeModifierSet = ref.watch(textSizeModifier);
    // var textSizeModifierSetIndividual = textSizeModifierSet["smallText"]!;

    final luminanceValue = ref.watch(luminanceProvider);

    if (ref.watch(isPerforming) == true) {
      displayCountdownTimer = const noDisplay();
    } else {
      displayCountdownTimer = timerCountDown(context);
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
                  // Set top to 0 to cover the entire screen from the top
                  child: Container(
                    width: screenWidth, // Set a specific width
                    height:
                        screenHeight, // Set a specific height or use constraints
                    child: DetectorView(
                      isCollecting: true,
                      title: 'Pose Detector',
                      customPaint: _customPaint,
                      text: _text,
                      onImage: _processImage,
                      initialCameraLensDirection: _cameraLensDirection,
                      onCameraLensDirectionChanged: (value) =>
                          _cameraLensDirection = value,
                    ),
                  ),
                ),

                displayCountdownTimer,
// -------------------------------------------------------------------[main black thing below :)]
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenHeight * 0.11,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(screenHeight * .02),
                        topRight: Radius.circular(screenHeight * .02),
                      ),
                      color: tertiaryColor,
                    ),
                  ),
                ),

// --------------------------------------------------------------------------[HELP BUTTON]
                DatasetCollection(
                  isRetraining: widget.isRetraining,
                  isNewRetrain: widget.isNewRetrain,
                ),

//
              ],
            ),
          );
        },
      ),
    );
  }
}

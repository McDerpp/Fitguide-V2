// ignore_for_file: empty_catches, empty_statements

import 'dart:async';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/misc/logicFunction/isolateProcessPDV.dart';
import 'package:frontend/misc/pose/detector_view.dart';
import 'package:frontend/misc/pose/pose_painter.dart';
import 'package:frontend/models/exercise.dart';

import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/coreFunctionality/globalVariables.dart';
import 'package:frontend/screens/exercise/exercise.dart';
import 'package:frontend/screens/inferencing/inferencing_end.dart';
import 'package:frontend/widgets/dialog_box_notif.dart';

import 'package:google_ml_kit/google_ml_kit.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:video_player/video_player.dart';

import '../../provider/data_collection_provider.dart';
// import '../../provider/global_variable_provider.dart';
import '../coreFunctionality/mainUISettings.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class InferencingSeamless extends ConsumerStatefulWidget {
  // final List<Map<String, dynamic>> exercise;
  final List<Exercise> exercise;

  // final List<Exercise> exerciseDetailList;

  const InferencingSeamless(
    this.exercise, {
    super.key,
    // required this.exercise,
    // required this.exerciseDetailList,
  });

  @override
  ConsumerState<InferencingSeamless> createState() =>
      _InferencingSeamlessState();
}

class _InferencingSeamlessState extends ConsumerState<InferencingSeamless> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// THIS DOES NOT MAKE ANY SENSE BUT DONT REMOVE THIS, ITLL BREAK EVERYTHING PROB...
  int tensorInputNeeded = 9;

// exercise detials
  String nameOfExercise = "";
  File model = File("");
  File video = File("");
  // List<String> ignoredCoordinates = [];
  List<int> ignoredCoordinates = [];

  int numberOfExecution = 0;
  int setsNeeded = 0;
  int restDuration = 0;
  bool isEnd = false;

  // isolate initialization for heavy process
  RootIsolateToken rootIsolateTokenNormalization = RootIsolateToken.instance!;
  RootIsolateToken rootIsolateTokenNoMovement = RootIsolateToken.instance!;
  RootIsolateToken rootIsolateTokenInferencing = RootIsolateToken.instance!;

  List<List<Pose>> poseQueue = [];
  List<List<double>> queueNormalizedListQueue = [];

  List<double> prevCoordinates = [];
  List<double> currentCoordinates = [];
  List<List<double>> inferencingList = [];
  List<List<double>> tempPrevCurr = [];
  int framesCapturedCtr = 0;

  String resultAvgFrames = '';
  String dynamicText = 'no movement \n detected';
  String dynamicCtr = '0';
  int execTotalFrames = 0;
  int numExec = 0;
  double avgFrames = 0.0;

  Map<String, dynamic> inferencingData = {};
  Map<String, dynamic> checkMovementIsolate = {};

  List<Map<String, dynamic>> queueNormalizeData = [];
  List<Map<String, dynamic>> queueMovementData = [];
  List<Map<String, dynamic>> queueInferencingData = [];
  int noMovementCtr = 0;
  int showPreviewCtr = 0;

  bool isExerciseInit = false;

  // ---------------------countdown variables----------------------------------------------------------

  List<double> translatedCoordinates = [];
  List<dynamic> coordinatesData = [];
  // bool isSet = true;
  // int collectingCtr = 0;
  List<int> igrnoreCoordinatesList = [];
  int executionStateResult = 0;
  bool allCoordinatesPresent = false;
  bool restState = false;
  bool restingInitialized = false;

  double inferenceValue = 50;

  int buffer = 4;
  int bufferCtr = 0;

  List<bool> inferenceBuffer = [];

  late VideoPlayerController _controller;
  late double scale;

  // late int inferencingBuffer;
  // ---------------------inferencing data mode variables----------------------------------------------------------
  int inferenceCorrectCtr = 0;
  int setsAchieved = 0;
  int exerciseCtr = 0;

  late int maxexercise;
  late List<Map<String, dynamic>> tempexercise;

  // ---------------------countdown variables----------------------------------------------------------
  final CountDownController controller = CountDownController();

  bool nowPerforming = false;
  bool countDowntoPerform = false;
  bool checkCountDowntoPerform = false;

  @override
  void initState() {
    super.initState();
    // ref.watch(showPreviewProvider.notifier).state = true;
  }

  Future<File> downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      return file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Failed to download file');
    }
  }

  void initNextExercuse() async {
    if (isExerciseInit == false) {
      isExerciseInit = true;
      maxexercise = widget.exercise.length;
      buffer = ref.watch(bufferProvider);

      try {
        if (exerciseCtr < maxexercise) {
          nameOfExercise = widget.exercise[exerciseCtr].name;
          model = await downloadFile(
              widget.exercise[exerciseCtr].model.model, 'temp_model');
          ignoredCoordinates = widget.exercise[exerciseCtr].ignoreCoordinates;
          setsNeeded = widget.exercise[exerciseCtr].numSet;
          numberOfExecution = widget.exercise[exerciseCtr].numExecution;
          initializeVideo(widget.exercise[exerciseCtr].videoUrl);
        } else {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => inferencingEnd(exercise: widget.exercise),
          //   ),
          // );
        }
      } catch (error) {}
      setState(() {});
    }
  }

  void isDoneNavigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => inferencingEnd(exercise: widget.exercise),
      ),
    );
  }

  void initializeVideo(String video) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(video))
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      }).catchError((error) {});

    scale = 1 /
        (_controller!.value.aspectRatio *
            MediaQuery.of(context).size.aspectRatio);
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

    _controller.dispose();
    super.dispose();
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (bufferCtr == 0) {
      // setState(() {
      //   inferenceValue = 0;
      // });
      inferenceValue = 0;
    }
    ;
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    late final List<Pose> poses;
    // bool noMovement = false;

// [ISOLATE FUNCTION] PROCESSING IMAGE ==========================================================================================================================
    try {
      poses = await _poseDetector.processImage(inputImage);
      Map<String, dynamic> dataNormalizationIsolate = {
        'inputImage': poses.first.landmarks.values,
        'token': rootIsolateTokenNormalization,
        'coordinatesIgnore': ignoredCoordinates,
        // 'coordinatesIgnore': ref.read(ignoreCoordinatesProvider),
      };
      queueNormalizeData.add(dataNormalizationIsolate);
    } catch (error) {}

// buffering code
    bufferCtr++;

// [ISOLATE FUNCTION] INFERENCING ==========================================================================================================================
    if (queueNormalizeData.isNotEmpty) {
// buffering code
      if (bufferCtr >= buffer) {
        bufferCtr = 0;

        compute(coordinatesRelativeBoxIsolate, queueNormalizeData.elementAt(0))
            .then((value) {
          queueNormalizeData.removeAt(0);
// this is a list that stores coordinates for checking of movement
          tempPrevCurr.add(value['translatedCoordinates']);

// if its performing(after countdown) then collect translated coordinates to be compiled later on
// later on... the checkmovement it will be checked if previous present coordinates has gone beyond the threshold
// if yes then this coordinate is compiled
          if (nowPerforming == true) {
            translatedCoordinates = value['translatedCoordinates'];
          }

//checking for all relevant coordinates are present
          // setState(() {
          //   allCoordinatesPresent = value['allCoordinatesPresent'];
          // });
          allCoordinatesPresent = value['allCoordinatesPresent'];

// if the list is above 1 length then get 2 set of translated sequences
// this will be in queue and be processed in the check movement isolate function
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

// =====================================================================================================================================================

    try {
      if (restState == true && restingInitialized == false) {
        restingInitialized = true;
        controller.restart(duration: 10);

        nowPerforming = false;
      }
    } catch (error) {
      CountDownController controller = CountDownController();
      controller.restart(duration: 10);
    }

// [ISOLATE FUNCTION] MOVEMENT CHECK ==========================================================================================================================
    if (queueMovementData.isNotEmpty) {
      compute(checkMovement, queueMovementData.elementAt(0))
          .then((value) async {
        queueMovementData.removeAt(0);

// if rest state is true but it has not started yet then initialize or start it--------------------------------------------------------------------------

        if (value == true) {
// this is checking for at the start of the exercise if movement is detected or not
// if detected then it will start countdown otherwise it will restart
          if (nowPerforming == false && restState == false) {
            if (countDowntoPerform == false) {
              controller.start();
              countDowntoPerform = true;
            }
          }

          // reststate countdown is done and resetting
          if (controller.getTime().toString() == "10" &&
              nowPerforming == false &&
              restState == true) {
            nowPerforming = true;
            restState = false;
            restingInitialized = false;
          }

          if (controller.getTime().toString() == "3" &&
              nowPerforming == false &&
              restState == false) {
            nowPerforming = true;
          }
        } else {}
      }).catchError((error) {});
    }
// =====================================================================================================================================================

// checking if number of execution is achieved
// if yes proceed to rest state
// rest state will then count down to proceed with another set
    if (inferenceCorrectCtr == numberOfExecution) {
      setsAchieved = setsAchieved + 1;
      nowPerforming = false;
      inferenceCorrectCtr = 0;
      restState = true;

// if all the sets have been performed
      if (setsAchieved == setsNeeded) {
        isExerciseInit = false;
        exerciseCtr++;

        if (exerciseCtr < maxexercise) {
          // dialogBoxNotif(context, 3, "aasetsdaf");
          ref.watch(showPreviewProvider.notifier).state = true;
        }
        setsAchieved = 0;
      }
    }

// checks if performing state is available(after countdown)--------------------------------------------------------------------------
    try {
      if (nowPerforming == true) {
        if (inferencingList.isNotEmpty &&
            inferencingList.length >= tensorInputNeeded) {
          executionStateResult = 2;

          inferencingData = {
            'coordinatesData': inferencingList,
            'token': rootIsolateTokenInferencing,
          };
          numExec++;
          queueInferencingData.add(inferencingData);

          if (inferencingList.length == tensorInputNeeded) {
            inferencingList.removeAt(0);
          }
        }
      }
    } catch (error) {}

// if its is performing(after countdown)----------------------------------------------------------------------------------------------------------------------
    if (nowPerforming == true && translatedCoordinates.isNotEmpty) {
      inferencingList.add(translatedCoordinates);
      translatedCoordinates = [];
    }

// [ISOLATE FUNCTION] INFERENCING ==========================================================================================================================
    if (queueInferencingData.isNotEmpty && nowPerforming == true) {
      inferencingCoordinatesData(queueInferencingData.elementAt(0), model)
          .then((value) {
        inferenceValue = value[1];

        if (inferenceBuffer.length == 2) {
          inferenceBuffer.removeAt(0);
          inferenceBuffer.add(value[0]);
        } else {
          inferenceBuffer.add(value[0]);
        }
        if (value[0] == true) {
          if (ref.watch(showPreviewProvider) == false) {
            if (inferenceBuffer.elementAt(0) == false &&
                inferenceBuffer.elementAt(1) == true &&
                nowPerforming == true) {
              inferenceCorrectCtr++;

              showPreviewCtr = 0;
            }
          }
          if (ref.watch(showPreviewProvider) == true) {
            ref.watch(showPreviewProvider.notifier).state = false;
            dialogBoxNotif(context, 2, "aasetsdaf");
            showPreviewCtr = 0;
          }
        } else {
          if (ref.watch(showPreviewProvider) == false) {
            showPreviewCtr++;
          }

          if (showPreviewCtr == showPreviewCtrMax &&
              ref.watch(showPreviewProvider) == false) {
            dialogBoxNotif(context, 1, "aasetsdaf");

            ref.watch(showPreviewProvider.notifier).state = true;
          }
        }
        if (queueInferencingData.isNotEmpty) {
          queueInferencingData.removeAt(0);
        }
      }).catchError((error) {});
    }

// =====================================================================================================================================================

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
          poses,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection,
          executionStateResult,
          //=========================================================================> NEEDS TO BE INITIALIZED FIRST FOR INFERENCING TO CHECK THE IGNORE COORDINATES
          ref.read(ignoreCoordinatesProvider));
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
      color: secondaryColor.withOpacity(opacity),
      size: screenWidth * 0.07,
    );
  }

  Widget displayErrorPose2(BuildContext context, double opacity) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Icon(
      Icons.lightbulb_circle,
      color: secondaryColor.withOpacity(opacity),
      size: screenWidth * 0.07,
    );
  }

  Widget buildContainerList(
    int numofContainer,
    int numofCompleted,
    BuildContext context, {
    double spaceModifier = .8,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> containers = [];
    int ctr = 0;

    for (int i = 0; i < numofContainer; i++) {
      ctr++;
      if (ctr <= numofCompleted) {
        containers.add(
          Row(
            children: [
              containers.isNotEmpty
                  ? SizedBox(
                      width: ((screenWidth * spaceModifier) / numofContainer) *
                          .10,
                    )
                  : Container(),
              Container(
                width: ((screenWidth * spaceModifier) / numofContainer) * .90,
                height: (screenHeight * .010),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.07),
                  color: secondaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        );
      } else {
        containers.add(
          Row(
            children: [
              containers.isNotEmpty
                  ? SizedBox(
                      width: ((screenWidth * spaceModifier) / numofContainer) *
                          .10,
                    )
                  : const SizedBox(
                      width: 0,
                    ),
              Container(
                width: ((screenWidth * spaceModifier) / numofContainer) * .90,
                height: (screenHeight * .015),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.07),
                  color: tertiaryColor!.withOpacity(0.8),
                ),
              ),
            ],
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: containers,
    );
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
          controller: controller,
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
            return Function.apply(defaultFormatterFunction, [duration]);
          },
        ));
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
    initNextExercuse();

    final luminanceValue = ref.watch(luminanceProvider);

    if (nowPerforming == true) {
      displayCountdownTimer = noDisplay();
    } else {
      displayCountdownTimer = timerCountDown(context);
    }

    if (allCoordinatesPresent == false) {
      displayError1 = displayErrorPose(context, 1);
    } else {
      displayError1 = displayErrorPose(context, 0.0);
    }

    if (luminanceValue <= 50.0) {
      displayError2 = displayErrorPose2(context, 1);
    } else {
      displayError2 = displayErrorPose2(context, 0.0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEnd == true) {
        isDoneNavigate();
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.amber,
              width: screenWidth,
              height: screenHeight * 1.5,
            ),
          ),

          Center(
            child: ref.watch(showPreviewProvider) == true
                ? Transform.scale(
                    scaleX: scale * 0.67,
                    scaleY: scale * 0.67,
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const SizedBox(),
          ),

          // Align(
          //   alignment: Alignment.topCenter,
          //   child: SizedBox(
          //     width: screenWidth,
          //     height: screenHeight,
          //     child: DetectorView(
          //       title: 'Pose Detector',
          //       customPaint: _customPaint,
          //       text: _text,
          //       onImage: _processImage,
          //       initialCameraLensDirection: _cameraLensDirection,
          //       onCameraLensDirectionChanged: (value) =>
          //           _cameraLensDirection = value,
          //     ),
          //   ),
          // ),

          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: DetectorView(
                title: 'Pose Detector',
                // customPaint: _customPaint,
                text: _text,
                onImage: _processImage,
                initialCameraLensDirection: _cameraLensDirection,
              ),
            ),
          ),

// -----------------------------------------------------------------------------------------------------------[Current Exercise Description]

          displayCountdownTimer,

          Positioned(
            bottom: screenHeight * 0.15,
            child: SizedBox(
              width: screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildContainerList(
                      widget.exercise.length, exerciseCtr, context,
                      spaceModifier: 0.8),
                ],
              ),
            ),
          ),

          Align(
            alignment: const Alignment(0, .98),
            child: Container(
              width: screenWidth * 0.95,
              height: screenHeight * 0.13,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
              ),
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  child: LinearProgressIndicator(
                    minHeight: screenHeight * 0.5,
                    value: inferenceCorrectCtr / numberOfExecution,
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
                      Row(
                        children: [
                          Text(
                            nameOfExercise,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 28.0 * textSizeModif,
                              fontWeight: FontWeight.w800,
                              color: tertiaryColor,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              // Add the navigation logic or any action you want
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ExerciseScreen(
                              //         exercise: widget.exercise[exerciseCtr]),
                              //   ),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      inferencingEnd(exercise: widget.exercise),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons
                                    .info, // Replace with your desired note icon
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Reps:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19.0 * textSizeModif,
                              fontWeight: FontWeight.w300,
                              color: tertiaryColor,
                            ),
                          ),
                          Text(
                            "  $inferenceCorrectCtr / $numberOfExecution",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19.0 * textSizeModif,
                              fontWeight: FontWeight.w300,
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
                              fontSize: 19.0 * textSizeModif,
                              fontWeight: FontWeight.w300,
                              color: tertiaryColor,
                            ),
                          ),
                          Text(
                            "  $setsAchieved / $setsNeeded",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19.0 * textSizeModif,
                              fontWeight: FontWeight.w300,
                              color: tertiaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),

          Align(
            alignment: const Alignment(-1.0, 0.7),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: tertiaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

// -----------------------------------------------------------------------------------------------------------[Error Indicator Pose]
          Positioned(
            top: screenWidth * 0.1,
            child: SizedBox(
              width: screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  displayError2,
                  displayError1,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenWidth * 0.42,
            left: 4,
            child: SizedBox(
              height: 450,
              child: Row(
                children: <Widget>[
                  FAProgressBar(
                    currentValue: inferenceValue * 100,
                    size: 15,
                    maxValue: 100,
                    changeColorValue: 95,
                    changeProgressColor: Colors.pink,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    progressColor: Colors.lightBlue,
                    animatedDuration: const Duration(milliseconds: 25),
                    direction: Axis.vertical,
                    verticalDirection: VerticalDirection.up,
                    formatValueFixed: 2,
                  )
                ],
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                inferenceCorrectCtr++;
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(300, 5),
                foregroundColor: Colors.white,
                backgroundColor: tertiaryColor,
              ),
              child: const Text('Test execution'),
            ),
          ),
// -----------------------------------------------------------------------------------------------------------[Progress Container]
        ],
      ),
    );
  }
}

// ignore_for_file: empty_catches, empty_statements

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:frontend/misc/logicFunction/isolateProcessPDV.dart';
import 'package:frontend/misc/pose/detector_view.dart';
import 'package:frontend/misc/pose/pose_painter.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/coreFunctionality/pose_provider.dart';
import 'package:frontend/screens/dataCollection/create_exercise/data_collection_settings.dart';
import 'package:frontend/screens/inferencing/inferencing_end.dart';
import 'package:frontend/widgets/count_down.dart';
import 'package:frontend/screens/inferencing/inferencing_base.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_ml_kit/google_ml_kit.dart';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class InferencingSeamless extends ConsumerStatefulWidget {
  final List<Exercise> exercise;
  final int workoutId;

  const InferencingSeamless({
    super.key,
    required this.workoutId,
    required this.exercise,
  });

  @override
  ConsumerState<InferencingSeamless> createState() =>
      _InferencingSeamlessState();
}

class _InferencingSeamlessState extends ConsumerState<InferencingSeamless> {
  late VideoPlayerController videoController;
  CameraController? _cameraController;
  final CountDownController _controller = CountDownController();

// THIS DOES NOT MAKE ANY SENSE BUT DONT REMOVE THIS, ITLL BREAK EVERYTHING PROB...
  int tensorInputNeeded = 9;

// NOTE!: majority of variables are initialized globally since it is used by different functions to lessen boiler plates

// [INITIAL STATES]
  //initializes the number of reps per sets
  int numberOfExecution = 0;
  //initializes the sets per exercise
  int setsNeeded = 0;
  // sets the rest duration(currently not implemented)
  int restDuration = 0;
  // checks if all exercise are done
  bool isEnd = false;
  // checks if any navigation is done(THIS WAS TO SOLVE SOME UNKNOWN ERRORS)
  bool _navigated = false;
  // checks whether all coodinates are presents(will error if not all are detected)
  bool allCoordinatesPresent = false;
  // current state is rest(countdown towards another exercise)
  bool restState = false;
  // transitioning to reststate(recently finished a set)
  bool restingInitialized = false;
  // initial value for the bar for inferencing
  double inferenceValue = 50;
  // current number of reps(resets every after sets)
  int inferenceCorrectCtr = 0;
  //  current number of sets(resets every after exercise)
  int setsAchieved = 0;
  // tracks what the current exercise is
  int exerciseCtr = 0;
  // tracks how many exercise
  int maxexercise = 5;

  // after certain amount of time when no succesful exercise is done, video preview will be shown
  int showPreviewCtr = 0;

  // tracks number of current buffer
  int bufferCtr = 0;

  // Pose detector variables
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

// exercise detials initialization------------------------------------------------------
  String nameOfExercise = "";
  File model = File("");
  File video = File("");
  List<int> ignoredCoordinates = [];

  // isolate initialization for heavy process---------------------------
  // Reasoning: Isolates allows certain heavy process to have a separate processes from ui, through isolate it wouldnt interfere with rendering with UI(wont make it lag)
  RootIsolateToken rootIsolateTokenNormalization = RootIsolateToken.instance!;
  RootIsolateToken rootIsolateTokenNoMovement = RootIsolateToken.instance!;
  RootIsolateToken rootIsolateTokenInferencing = RootIsolateToken.instance!;

  //movement checking -----------------------------------------
  // stores previous coordinates
  List<double> prevCoordinates = [];

  // stores current coordinates
  List<double> currentCoordinates = [];

  // stores current and previous coordinates for difference to determine if threshold is met to be considered a movement
  List<List<double>> tempPrevCurr = [];

  // if movement is detected, it is stored in here
  List<Map<String, dynamic>> queueMovementData = [];

  //movement checking ---------------------------------------
  // used to hold the movementData to be normalized into values of 0 - 1
  List<Map<String, dynamic>> queueNormalizeData = [];
  // holds normalized data
  List<double> translatedCoordinates = [];

  //Inferencing ----------------------------------------
  // data derived from normalized coordinates
  List<List<double>> inferencingList = [];
  // holds the list of inferencing lists
  List<Map<String, dynamic>> queueInferencingData = [];
  // buffers the inferencing(this disregards some of the data to improve performance)
  List<bool> inferenceBuffer = [];

  // ---------------------countdown variables-----------

  List<dynamic> coordinatesData = [];
  List<int> igrnoreCoordinatesList = [];
  int executionStateResult = 0;
  double scale = 0;
  bool isShowPreview = true;

  final List<int> exerciseElapsedTime = [];

  List<List<int>> setsReps = [];
  // ---------------------inferencing data mode variables----------------------------------------------------------

  bool nowPerforming = true;
  bool countDowntoPerform = false;

  // Per exercise time
  late Timer _timer;
  int framesCollected = 0;
  bool _isRunning = false;
  int _secondsElapsed = 0;

  // timer for exercise timer limit
  late Timer _exerciseTimer;
  int _secondsElapsedExercise = 0;

  bool isInitNext = false;

  late tfl.Interpreter modelInferencing;

  List<double> normalizedData = [];

  bool isVideoInitialize = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initNextExercse();
    _initSetsReps();
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          _secondsElapsed++;
        });
      });
      _exerciseTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          _secondsElapsedExercise++;
        });
      });
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  Future<File> _downloadFile(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');

      // final Map<String, dynamic> modelData =
      //     await initializedModel(await file.writeAsBytes(response.bodyBytes));
      // tensorInputNeeded = modelData["inputTensorNeeded"];
      // modelInferencing = modelData["model"];

      return file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Failed to download file');
    }
  }

  void _initSetsReps() {
// [reps,sets]
    for (int ctr = 0; ctr < widget.exercise.length; ctr++) {
      setsReps.add([0, 0]);
    }
  }

  void _initNextExercse() async {
    // if (isExerciseInit == false) {
    //   isExerciseInit = true;
    maxexercise = widget.exercise.length;
    try {
      // List<dynamic> decodedList =
      //     jsonDecode(widget.exercise[exerciseCtr].ignoreCoordinates);
      // List<int> ignoreList = List<int>.from(decodedList[0]);
      if (exerciseCtr < maxexercise) {
        print("mode test -> ${widget.exercise[exerciseCtr].model!.model}");
        try {
          model = await _downloadFile(
              '${widget.exercise[exerciseCtr].model!.model}', 'temp_model');
        } catch (error) {
          print("Error at download file -> $error");
        }
        try {
          _initializeVideo("${widget.exercise[exerciseCtr].videoUrl}");
        } catch (error) {
          print("Error at intialize video -> $error");
        }

        nameOfExercise = widget.exercise[exerciseCtr].name;

        // ignoredCoordinates = ignoreList;
        setsNeeded = widget.exercise[exerciseCtr].numSet;
        numberOfExecution = widget.exercise[exerciseCtr].numExecution;
        // setsNeeded = 2;
        // numberOfExecution = 2;
      } else {}
    } catch (error) {
      print("error detected initializing ->$error");
    }
    setState(() {});
    // }
  }

  void _isDoneNavigate() {
    videoController.dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => inferencingEnd(
            exercise: widget.exercise, workoutID: widget.workoutId),
      ),
    );
  }

  void onChangeState(bool stateChange) {
    setState(() {
      restState = stateChange;
    });
  }

  void onChangeExecise(int changeExercise) {
    setState(() {
      print("changing exercise -> $changeExercise");
      exerciseCtr = changeExercise;
      _initNextExercse();
    });
  }

  void _stopProcessAndNavigate() {
    dispose();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => inferencingEnd(
            exercise: widget.exercise, workoutID: widget.workoutId),
      ),
    );
  }

  void _initializeVideo(String video) {
    if (isVideoInitialize) {
      videoController.dispose();
      isVideoInitialize = false;

      print("video disposed");
    }
    videoController = VideoPlayerController.networkUrl(Uri.parse(video))
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          videoController.setVolume(0);
          videoController.play();
        });
      }).catchError((error) {});

    scale = 1 /
        (videoController.value.aspectRatio *
            MediaQuery.of(context).size.aspectRatio);

    isVideoInitialize = true;
  }

  @override
  void dispose() {
    super.dispose();
    disposeAll();
  }

  Future disposeAll() async {
    _canProcess = false;
    _poseDetector.close();
    videoController.dispose();
    _cameraController!.dispose();
    _exerciseTimer.cancel();
    _stopTimer();
  }

  void _navigateToNextPage() {
    if (_navigated) return;
    setState(() {
      _navigated = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => inferencingEnd(
              exercise: widget.exercise, workoutID: widget.workoutId),
        ),
      );
    });
  }

  void _handleControllerInitialized(CameraController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _cameraController = controller;
        });
      }
    });
  }

  void videoPreviewSuggest() {}

  Future<void> _processImage(InputImage inputImage) async {
    if (exerciseCtr >= maxexercise) {
      _navigateToNextPage();
    }

    if (bufferCtr == 0) {
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
      if (bufferCtr >= bufferNum) {
        bufferCtr = 0;

        compute(coordinatesRelativeBoxIsolate, queueNormalizeData.elementAt(0))
            .then((value) {
          queueNormalizeData.removeAt(0);
          tempPrevCurr.add(value['translatedCoordinates']);

          if (nowPerforming == true) {
            translatedCoordinates = value['translatedCoordinates'];
          }

          allCoordinatesPresent = value['allCoordinatesPresent'];

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
        _controller.restart(duration: 10);

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
              _controller.start();
              countDowntoPerform = true;
            }
          }

          // reststate countdown is done and resetting
          if (_controller.getTime().toString() == "10" &&
              nowPerforming == false &&
              restState == true) {
            nowPerforming = true;
            restState = false;
            restingInitialized = false;
          }

          if (_controller.getTime().toString() == "3" &&
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
    if (setsReps[exerciseCtr][1] >= numberOfExecution) {
      setState(() {
        setsAchieved = setsReps[exerciseCtr][0];
        setsAchieved = setsAchieved + 1;
        setsReps[exerciseCtr][0] = setsAchieved;
        nowPerforming = false;
        inferenceCorrectCtr = 0;
        restState = true;
      });

// if all the sets have been performed
      if (setsReps[exerciseCtr][0] >= setsNeeded) {
        exerciseElapsedTime.add(_secondsElapsed);

        _initNextExercse();
        exerciseCtr++;

        if (exerciseCtr < maxexercise) {
          // dialogBoxNotif(context, 3, "aasetsdaf");
          isShowPreview = true;
        }
        setsAchieved = 0;
      } else {
        setsReps[exerciseCtr][1] = 0;
      }
    }

// checks if performing state is available(after countdown)--------------------------------------------------------------------------
    try {
      if (nowPerforming == true) {
        if (inferencingList.isNotEmpty &&
            inferencingList.length >= tensorInputNeeded) {
          executionStateResult = 2;

          var inferencingData = {
            'coordinatesData': inferencingList,
            'token': rootIsolateTokenInferencing,
          };
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
      inferencingCoordinatesDataV1(queueInferencingData.elementAt(0), model)
          .then((value) {
        inferenceValue = value[1];
        print("inferencing -> $inferenceValue");

        if (inferenceBuffer.length == 2) {
          inferenceBuffer.removeAt(0);
          inferenceBuffer.add(value[0]);
        } else {
          inferenceBuffer.add(value[0]);
        }
        if (value[0] == true) {
          if (isShowPreview == false) {
            if (inferenceBuffer.elementAt(0) == false &&
                inferenceBuffer.elementAt(1) == true &&
                nowPerforming == true) {
              inferenceCorrectCtr = setsReps[exerciseCtr][1];
              inferenceCorrectCtr++;
              setsReps[exerciseCtr][1] = inferenceCorrectCtr;
              _secondsElapsedExercise = 0;
              showPreviewCtr = 0;
            }
          }
          // if (isShowPreview == true) {
          //   isShowPreview = false;
          //   dialogBoxNotif(context, 2, "aasetsdaf");
          //   showPreviewCtr = 0;
          // }
        } else {
          // if (isShowPreview == false) {
          //   showPreviewCtr++;
          // }

          // if (showPreviewCtr == showPreviewCtrMax && isShowPreview == false) {
          //   dialogBoxNotif(context, 1, "aasetsdaf");
          //   isShowPreview = true;
          // }
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
        ref.read(ignoreCoordinatesProvider),
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
    if (exerciseCtr >= maxexercise && isInitNext == false) {
      isInitNext = true;
      _stopProcessAndNavigate();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // exercise details------------------------------------------------------------
    // _initNextExercse();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEnd == true) {
        _isDoneNavigate();
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
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

          // _cameraController != null
          //     ? Align(
          //         alignment: Alignment.topCenter,
          //         child: Container(
          //           width: screenWidth,
          //           height: screenHeight,
          //           child: Transform.scale(
          //             scaleX: 1.39 * scaleX,
          //             scaleY: 1.39 * scaleY,
          //             alignment: Alignment.center,
          //             child: CameraPreview(
          //               _cameraController!,
          //             ),
          //           ),
          //         ),
          //       )
          //     : SizedBox(),

          Center(
            child: isShowPreview == true
                ? Transform.scale(
                    scaleX: scale * 0.67,
                    scaleY: scale * 0.67,
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: videoController.value.aspectRatio,
                      child: VideoPlayer(videoController),
                    ),
                  )
                : const SizedBox(),
          ),
          Align(
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
          ),

          InferencingBase(
            onChangeExecise: onChangeExecise,
            maxRep: numberOfExecution,
            // currentRep: inferenceCorrectCtr,
            currentRep: setsReps[exerciseCtr][1],
            maxSets: setsNeeded,
            currentSets: setsReps[exerciseCtr][0],
            // currentSets: setsAchieved,
            exerciseName: nameOfExercise,
            maxExercise: maxexercise,
            currentExerciseNum: exerciseCtr,
            isAllCoordinatesPresent: true,
            isNowPerforming: nowPerforming,
          ),
          restState == true
              ? countDownTimer(
                  isInference: true,
                  controller: _controller,
                  onChangeState: onChangeState,
                )
              : const SizedBox(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                inferenceCorrectCtr++;
                setsReps[exerciseCtr][1] = inferenceCorrectCtr;
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 5),
                foregroundColor: Colors.white,
                backgroundColor: tertiaryColor,
              ),
              child: const Text('Test execution'),
            ),
          ),

          // restState == true
          //     ? countDownTimer(
          //         controller: _controller,
          //       )
          //     : SizedBox(),
// //-----------------------------------------------------------------------------------------------------------[Current Exercise Description]
        ],
      ),
    );
  }
}

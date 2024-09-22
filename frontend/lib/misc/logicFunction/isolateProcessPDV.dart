import 'dart:io';
import 'dart:core';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:frontend/screens/dataCollection/create_exercise/data_collection_settings.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

List<double> paddingList = [];
late tfl.Interpreter head;
double progressT = 1.0;

void paddingInitialize() {
  for (int i = 0; i < 66; i++) {
    paddingList.add(0);
  }
}

List<List<double>> padding(List<List<double>> input, int requiredLength) {
  List<List<double>> result =
      List.from(input); // Create a copy of the input list
  List<double> paddingList =
      List.filled(66, 0); // Initialize paddingList with zeros

  while (result.length > requiredLength) {
    int maxRange = result.length;
    int randomNumber = Random().nextInt(maxRange);
    result.removeAt(randomNumber);
  }

  while (result.length < requiredLength) {
    result.add(
        List.from(paddingList)); // Create a new instance of the padding list
  }

  return result;
}

Future<Map<String, dynamic>> initializedModel(dynamic modelPath) async {
  print("initializing model 1");

  final model = tfl.Interpreter.fromFile(modelPath);
  print("initializing model 2");

  final inputShape = model.getInputTensor(0).shape;
  final inputTensorNeeded = inputShape[1];

  return {"model": model, "inputTensorNeeded": inputTensorNeeded};
}

Future<List<dynamic>> inferencingCoordinatesDataV1(
    Map<String, dynamic> inputs, dynamic modelPath) async {
// CHANGE THIS TO fromAsset if testing
  final head = tfl.Interpreter.fromFile(modelPath);
  // final head = await tfl.Interpreter.fromAsset(modelPath);

  final inputShape = head.getInputTensor(0).shape;

  var output = List.generate(1, (index) => List<double>.filled(1, 0));

  List<List<double>> coordinates = inputs['coordinatesData'];
  coordinates = padding(coordinates, inputShape[1]);

  try {
    head.run(coordinates, output);
  } catch (error) {}

  try {
    head.runInference(coordinates);
  } catch (error) {}

// threshold
  if (output.elementAt(0).elementAt(0) >= .85) {
    return [true, output.elementAt(0).elementAt(0)];
  } else {
    return [false, output.elementAt(0).elementAt(0)];
  }
}






Future<List<dynamic>> inferencingCoordinatesData(
  Map<String, dynamic> inputs,
  tfl.Interpreter model,
  int tensorInputNeeded,
) async {
  try {
    var output = List.generate(1, (index) => List<double>.filled(1, 0));

    List<List<double>> coordinates = inputs['coordinatesData'];
    print("tensorInputNeeded --> $tensorInputNeeded");

    print("coordinates1 --> ${coordinates.length}");
    print("coordinates2 --> ${coordinates.elementAt(0).length}");

    coordinates = padding(coordinates, tensorInputNeeded);
    print("padded out -> $coordinates");
    try {
      head.run(coordinates, output);
    } catch (error) {}

    try {
      head.runInference(coordinates);
    } catch (error) {}
    print("output --> $output");

// threshold
    if (output.elementAt(0).elementAt(0) >= .95) {
      return [true, output.elementAt(0).elementAt(0)];
    } else {
      return [false, output.elementAt(0).elementAt(0)];
    }
  } catch (error) {
    print("Error at inferencing -> $error");
  }
  return [false, 0];
}

// [BACK UP]
Map<String, dynamic> coordinatesRelativeBoxIsolate(
  Map<String, dynamic> inputs,
) {
  List<int> coordinatesIgnore = [];

  if (inputs.containsKey('token')) {
    var rootIsolateToken = inputs['token'];
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  }

  if (inputs.containsKey('coordinatesIgnore')) {
    coordinatesIgnore = inputs['coordinatesIgnore'];
  }
  Iterable<PoseLandmark> rawCoordiantes = inputs['inputImage'];

  List<double> translatedCoordinates = [];

  double minCoordinatesX = rawCoordiantes.first.x;
  double minCoordinatesY = rawCoordiantes.first.y;

  double maxCoordinatesX = rawCoordiantes.first.x;
  double maxCoordinatesY = rawCoordiantes.first.y;

  double valueXRange;
  double valueYRange;

  int ctr = 0;
  int ctr2 = 0;

  int checkLikelihoodCtr = 0;
  bool allCoordinatesPresent = true;

  for (var pose in rawCoordiantes) {
    if (coordinatesIgnore.contains(ctr) == true) {
      if (pose.likelihood <= .75) {
        checkLikelihoodCtr++;
      }

      if (minCoordinatesX >= pose.x) {
        minCoordinatesX = pose.x;
      }
      if (minCoordinatesY >= pose.y) {
        minCoordinatesY = pose.y;
      }

      if (maxCoordinatesX <= pose.x) {
        maxCoordinatesX = pose.x;
      }
      if (maxCoordinatesY <= pose.y) {
        maxCoordinatesY = pose.y;
      }
    }
    ctr++;
  }

  for (var pose in rawCoordiantes) {
    if (coordinatesIgnore.contains(ctr2) == true) {
      valueXRange =
          (pose.x - minCoordinatesX) / (maxCoordinatesX - minCoordinatesX);
      valueYRange =
          (pose.y - minCoordinatesY) / (maxCoordinatesY - minCoordinatesY);
    } else {
      valueXRange = 0.0;
      valueYRange = 0.0;
    }
    // flattening it ahead of time for later processes later...

    translatedCoordinates.add(
        double.parse(valueXRange.toStringAsFixed(dataNormalizedDecimalPlace)));
    translatedCoordinates.add(
        double.parse(valueYRange.toStringAsFixed(dataNormalizedDecimalPlace)));

    ctr2++;
  }

  if (checkLikelihoodCtr >= 1) {
    allCoordinatesPresent = false;
  }

  Map<String, double> minMaxCoordinatesXY = {
    'maxCoor_Y': maxCoordinatesY,
    'maxCoor_X': maxCoordinatesX,
    'minCoor_Y': minCoordinatesY,
    'minCoor_X': minCoordinatesX,
  };

  Map<String, dynamic> dataNormalizationIsolateResults = {
    'translatedCoordinates': translatedCoordinates,
    'allCoordinatesPresent': allCoordinatesPresent,
    'minMaxCoordinatesXY': minMaxCoordinatesXY,
  };

  return dataNormalizationIsolateResults;
}

// [Movement Check V1]
// bool checkMovement(Map<String, dynamic> input) {
//   var prevCoordinates = input['prevCoordinates'];
//   var currentCoordinates = input['currentCoordinates'];
//   var screenHeight = input['screenHeight'];
//   var screenWidth = input['screenWidth'];

//   Map<String, double> minMaxCoordinatesXY = input['minMaxCoordinatesXY'];
//   double maxCoordinatesY = input['maxCoor_Y'];
//   double maxCoordinatesX = input['maxCoor_X'];
//   double minCoordinatesY = input['minCoor_Y'];
//   double minCoordinatesX = input['minCoor_X'];

//   double minBoxHeight = screenHeight * .60;
//   double minBoxwidth = screenHeight * .75;

//   double boxHeight = maxCoordinatesY - minCoordinatesY;
//   double boxWidth = maxCoordinatesX - minCoordinatesX;

//   if (boxHeight < minBoxHeight) {
//     (minBoxHeight - boxHeight) / boxHeight * 100;
//   }

//   if (boxWidth < minBoxwidth) {
//     (minBoxwidth - boxWidth) / boxWidth * 100;
//   }

//   int noMovementCtr = 0;

//   for (int ctr = 0; ctr < prevCoordinates.length; ctr++) {
//     if (prevCoordinates.elementAt(ctr) - changeRange <=
//             currentCoordinates.elementAt(ctr) &&
//         prevCoordinates.elementAt(ctr) + changeRange >=
//             currentCoordinates.elementAt(ctr)) {
//       noMovementCtr++;
//     } else {
//       return false;
//     }
//   }

//   if (noMovementCtr >= 65) {
//     return true;
//   } else {
//     return false;
//   }
// }

// Things to consider for movement check
// flutter might not be as efficient as python when it comes to managing matrices(python has numpy), might need to avoid dealing with matrices as much as possible...i guess...

// potential solutions checking movement:
// [checking coordinates individually](Currently being used together with nullified change range)
// we would check indidivual coordiantes for their differences taking into consideration the change range
// this might be highly efficient if the coordinates that has movement is at the first part of the matrices but less efficient if its at the last.

// [minMaxXY]
// should set a maximum and minimum X and Y coordinates, since in side profile(or if only 1-3 parts are only recorded) it creates a smaller min and max and if we base it of from that value it will detect a movement even in a miniscule movement(sometimes with the jittery nature of the pose estimation)
// by having this kind of approach the user would have to adjust to accomodate for the max and min of both X and Y... user would need to put a little bit of allowance(min max X Y should be significantly lower than the image input)...hypothetically...

// [adaptive changeRange]
// depending on the current max and min of the X and Y coordinates change range would be based of it through a percentage calculation.
// we can based it off from respective value of min and max of X and Y
// could jittery nature of pose estimation render this solution useless since under unique scenario of coordinates overlaping(coordinates overlapping or body parts overlapping could have a more jittery effect)
// problem is how, we are comparing to matrices each having unique minMaxXY

// [Bounding box comparison]
// past and current minMaxXY would be compared
// this is highly efficient since we would only be comparing 8 variables
// but this creates problem under unique cirumstances for instance when elbow is held outward and the hand inward, movement of hand wont be detected

// [Adding coordinates then checking the difference]
//current and previous would add all of its corresponding elements then see the difference of it
// change range would be determine by percentage based of the sum of current and previous coordinates
// highly efficient since we would only add and compare 2 variables
// Current flow of the data is it is normalized first then checked those value for movement, since it is percentage movement will still be detected with miniscule movement(unless X and Y would have unique change range)

//[Nullified Change range](Currently being used along with checking coordinates individually )
// disregards the X or Y coordinates change to detect a movement if under the threshold(bounding box of width or height too small)

// [Take into a ccount likelyhood of poses]
// lesser likelihood == more jittery
// we can disregard coordinates with less likelihood

// [Movement Check V2]
// applied nullified change range
// applied minMaxXY
// Reasons: to be able to use ignore coordinates more reliably
bool checkMovement(Map<String, dynamic> input) {
  try {
    var prevCoordinates = input['prevCoordinates'];
    var currentCoordinates = input['currentCoordinates'];
    var screenHeight = input['screenHeight'];
    var screenWidth = input['screenWidth'];

    Map<String, double> minMaxCoordinatesXY = input['minMaxCoordinatesXY'];

    double maxCoordinatesY = minMaxCoordinatesXY['maxCoor_Y']!;
    double maxCoordinatesX = minMaxCoordinatesXY['maxCoor_X']!;
    double minCoordinatesY = minMaxCoordinatesXY['minCoor_Y']!;
    double minCoordinatesX = minMaxCoordinatesXY['minCoor_X']!;

    double minBoxHeight = screenHeight * heightMultiplierThreshold;
    double minBoxwidth = screenWidth * widthMultiplierThreshold;

    double boxHeight = maxCoordinatesY - minCoordinatesY;
    double boxWidth = maxCoordinatesX - minCoordinatesX;

    bool isWidthSmall = false;
    bool isHeightSmall = false;

    if (boxHeight <= minBoxHeight) {
      isWidthSmall = true;
    }

    if (boxWidth <= minBoxwidth) {
      isHeightSmall = true;
    }

    for (int ctr = 0; ctr < prevCoordinates.length; ctr++) {
      if (ctr % 2 == 0 && isHeightSmall == false ||
          ctr % 2 != 0 && isWidthSmall == false) {
        if (currentCoordinates.elementAt(ctr) <
                prevCoordinates.elementAt(ctr) - changeRangeDefault ||
            currentCoordinates.elementAt(ctr) >
                prevCoordinates.elementAt(ctr) + changeRangeDefault) {
          return false;
        }
      }
    }
    return true;
  } catch (error) {
    print("Error at check movement --> $error");
  }
  return false;
}

Map<String, dynamic> coordinatesRelativeBoxIsolateV2(
    Map<String, dynamic> inputs) {
  try {
    List<double> translatedCoordinates = [];
    List<int> coordinatesIgnore = [];

    if (inputs.containsKey('token')) {
      var rootIsolateToken = inputs['token'];
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    }

    if (inputs.containsKey('coordinatesIgnore')) {
      coordinatesIgnore = inputs['coordinatesIgnore'];
    }
    Iterable<PoseLandmark> rawCoordiantes = inputs['rawData'];

    double minCoordinatesX = rawCoordiantes.first.x;
    double minCoordinatesY = rawCoordiantes.first.y;

    double maxCoordinatesX = rawCoordiantes.first.x;
    double maxCoordinatesY = rawCoordiantes.first.y;

    double valueXRange;
    double valueYRange;

    int ctr = 0;
    int ctr2 = 0;

    int checkLikelihoodCtr = 0;
    bool allCoordinatesPresent = true;

    for (var pose in rawCoordiantes) {
      if (coordinatesIgnore.contains(ctr) == true) {
        if (pose.likelihood <= .75) {
          checkLikelihoodCtr++;
        }

        if (minCoordinatesX >= pose.x) {
          minCoordinatesX = pose.x;
        }
        if (minCoordinatesY >= pose.y) {
          minCoordinatesY = pose.y;
        }

        if (maxCoordinatesX <= pose.x) {
          maxCoordinatesX = pose.x;
        }
        if (maxCoordinatesY <= pose.y) {
          maxCoordinatesY = pose.y;
        }
      }
      ctr++;
    }

    for (var pose in rawCoordiantes) {
      if (coordinatesIgnore.contains(ctr2) == true) {
        valueXRange =
            (pose.x - minCoordinatesX) / (maxCoordinatesX - minCoordinatesX);
        valueYRange =
            (pose.y - minCoordinatesY) / (maxCoordinatesY - minCoordinatesY);
      } else {
        valueXRange = 0.0;
        valueYRange = 0.0;
      }
      // flattening it ahead of time for later processes later...
      translatedCoordinates.add(double.parse(
          valueXRange.toStringAsFixed(dataNormalizedDecimalPlace)));
      translatedCoordinates.add(double.parse(
          valueYRange.toStringAsFixed(dataNormalizedDecimalPlace)));

      ctr2++;
    }

    if (checkLikelihoodCtr >= 1) {
      allCoordinatesPresent = false;
    }

    Map<String, double> minMaxCoordinatesXY = {
      'maxCoor_Y': maxCoordinatesY,
      'maxCoor_X': maxCoordinatesX,
      'minCoor_Y': minCoordinatesY,
      'minCoor_X': minCoordinatesX,
    };

    Map<String, dynamic> dataNormalizationIsolateResults = {
      'translatedCoordinates': translatedCoordinates,
      'allCoordinatesPresent': allCoordinatesPresent,
      'minMaxCoordinatesXY': minMaxCoordinatesXY
    };

    return dataNormalizationIsolateResults;
  } catch (error) {
    print("Error at normalizing data isolate -> $error");
  }
  return {};
}

Map<String, double> getMinMaxXY(
    Iterable<PoseLandmark> rawCoordiantes, List<int> coordinatesIgnore) {
  double minCoordinatesX = rawCoordiantes.first.x;
  double minCoordinatesY = rawCoordiantes.first.y;

  double maxCoordinatesX = rawCoordiantes.first.x;
  double maxCoordinatesY = rawCoordiantes.first.y;

  int ctr = 0;

  for (var pose in rawCoordiantes) {
    if (coordinatesIgnore.contains(ctr) == true) {
      if (minCoordinatesX >= pose.x) {
        minCoordinatesX = pose.x;
      }
      if (minCoordinatesY >= pose.y) {
        minCoordinatesY = pose.y;
      }

      if (maxCoordinatesX <= pose.x) {
        maxCoordinatesX = pose.x;
      }
      if (maxCoordinatesY <= pose.y) {
        maxCoordinatesY = pose.y;
      }
    }
    ctr++;
  }
  return {
    'minCoordinatesX': minCoordinatesX,
    'minCoordinatesY': minCoordinatesY,
    'maxCoordinatesX': maxCoordinatesX,
    'maxCoordinatesY': maxCoordinatesY
  };
}

Future<void> translateCollectedDatatoTxt(
  List<dynamic> dataCollected,
  Function(double) updateProgress,
) async {
  Directory externalDir = await getApplicationDocumentsDirectory();
  String externalPath = externalDir.path;
  String filePath = '$externalPath/coordinatesCollected.txt';
  File file = File(filePath);
  file.writeAsStringSync('');
  int progressCtr = 0;

  for (List exerciseSet in dataCollected) {
    progressCtr++;
    progressT = (progressCtr / dataCollected.length);
    updateProgress(progressT);

    await file.writeAsString('START\n', mode: FileMode.append);

    for (List sequence in exerciseSet) {
      for (double individualCoordinate in sequence) {
        if (individualCoordinate.toString().length > 10) {
          await file.writeAsString(
              '${individualCoordinate.toString().substring(0, 10)}|',
              mode: FileMode.append);
        } else {
          await file.writeAsString('${individualCoordinate.toString()}|',
              mode: FileMode.append);
        }
      }
      await file.writeAsString('\n', mode: FileMode.append);
    }
    await file.writeAsString('END\n', mode: FileMode.append);
  }
}

// this one is being used
Future<void> translateCollectedDatatoTxt2(
  Map<String, dynamic> inputs,
) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(inputs['token']);
  Directory externalDir = await getApplicationDocumentsDirectory();
  String externalPath = externalDir.path;
  String filePath = '$externalPath/coordinatesCollected.txt';
  File file = File(filePath);
  file.writeAsStringSync('');
  // ignore: unused_local_variable
  int progressCtr = 0;

  for (List exerciseSet in inputs['coordinates']) {
    progressCtr++;
    await file.writeAsString('START\n', mode: FileMode.append);

    for (List sequence in exerciseSet) {
      for (double individualCoordinate in sequence) {
        if (individualCoordinate.toString().length > 10) {
          await file.writeAsString(
              '${individualCoordinate.toString().substring(0, 10)}|',
              mode: FileMode.append);
        } else {
          await file.writeAsString('${individualCoordinate.toString()}|',
              mode: FileMode.append);
        }
      }
      await file.writeAsString('\n', mode: FileMode.append);
      // }
      await file.writeAsString('END\n', mode: FileMode.append);
      // print(
      // "=========================================================================");
    }
  }
}

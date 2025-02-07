import 'dart:io';
import 'dart:core';
import 'dart:math';

import 'package:flutter/services.dart';
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

// Future<void> modelInitialize(String modelPath) async {
//   final head = await tfl.Interpreter.fromAsset(modelPath);
// }

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

Future<List<dynamic>> inferencingCoordinatesData(
    Map<String, dynamic> inputs, dynamic modelPath) async {
  print("inferencing!");
// CHANGE THIS TO fromAsset if testing
  final head = await tfl.Interpreter.fromFile(modelPath);
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
  print(
      "output.elementAt(0).elementAt(0) ---> ${output.elementAt(0).elementAt(0)}");
// threshold
  if (output.elementAt(0).elementAt(0) >= .90) {
    return [true, output.elementAt(0).elementAt(0)];
  } else {
    return [false, output.elementAt(0).elementAt(0)];
  }
}

Map<String, dynamic> coordinatesRelativeBoxIsolate(
  Map<String, dynamic> inputs,
) {
  // BE AWARE OF THIS PARAMETER
  // This should match the training data pre process...currently its 3 decimal places
  int dataNormalizedDecimalPlace = 3;
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
  double allowance = .03;

  double minCoordinatesX = rawCoordiantes.first.x;
  double minCoordinatesY = rawCoordiantes.first.y;

  double maxCoordinatesX = rawCoordiantes.first.x;
  double maxCoordinatesY = rawCoordiantes.first.y;

  // print("minCoordinatesX _first--->$minCoordinatesX");
  // print("minCoordinatesY _first--->$minCoordinatesY");
  // print("maxCoordinatesX _first--->$maxCoordinatesX");
  // print("maxCoordinatesY _first--->$maxCoordinatesY");
  var valueXRange;
  var valueYRange;

  var rawX;
  var rawY;
  int ctr = 0;
  int ctr2 = 0;

  int checkLikelihoodCtr = 0;
  bool allCoordinatesPresent = true;

  for (var pose in rawCoordiantes) {
    // if (!coordinatesIgnore.contains(ctr)) {
    if (coordinatesIgnore.contains(ctr)) {
      // print("getting max and min");
      if (pose.likelihood <= .75) {
        checkLikelihoodCtr++;
      }

      if (minCoordinatesX > pose.x) {
        minCoordinatesX = pose.x;
      }
      if (minCoordinatesY > pose.y) {
        minCoordinatesY = pose.y;
      }

      if (maxCoordinatesX < pose.x) {
        maxCoordinatesX = pose.x;
      }
      if (maxCoordinatesY < pose.y) {
        maxCoordinatesY = pose.y;
      }
    }
    ctr++;
  }
  // print("minCoordinatesX_final--->$minCoordinatesX");
  // print("minCoordinatesY_final--->$minCoordinatesY");
  // print("maxCoordinatesX_final--->$maxCoordinatesX");
  // print("maxCoordinatesY_final--->$maxCoordinatesY");

  for (var pose in rawCoordiantes) {
    // if (coordinatesIgnore.contains(ctr2) == false) {
    // lazy fix...should fix properly later on
    if (coordinatesIgnore.contains(ctr2) == true) {
      valueXRange =
          (pose.x - minCoordinatesX) / (maxCoordinatesX - minCoordinatesX);
      valueYRange =
          (pose.y - minCoordinatesY) / (maxCoordinatesY - minCoordinatesY);

    } else {
      // print("coordinates ignoring");
      valueXRange = 0.0;
      valueYRange = 0.0;
    }

    translatedCoordinates.add(
        double.parse(valueXRange.toStringAsFixed(dataNormalizedDecimalPlace)));
    translatedCoordinates.add(
        double.parse(valueYRange.toStringAsFixed(dataNormalizedDecimalPlace)));

    ctr2++;
  }
  int ctr3 = 0;

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
}

bool checkMovement(Map<String, dynamic> input) {
  var prevCoordinates = input['prevCoordinates'];
  var currentCoordinates = input['currentCoordinates'];
  var token = input['token'];

  double changeRange = 0.045;
  int noMovementCtr = 0;

  for (int ctr = 0; ctr < prevCoordinates.length; ctr++) {
    if (prevCoordinates.elementAt(ctr) - changeRange <=
            currentCoordinates.elementAt(ctr) &&
        prevCoordinates.elementAt(ctr) + changeRange >=
            currentCoordinates.elementAt(ctr)) {
      noMovementCtr++;
    } else {
      return false;
    }
  }

  if (noMovementCtr >= 65) {
    return true;
  } else {
    return false;
  }
}

Future<void> translateCollectedDatatoTxt(
  List<dynamic> dataCollected,
  Function(double) updateProgress,
) async {
  Directory externalDir = await getApplicationDocumentsDirectory();
  String externalPath = externalDir!.path;
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
  String externalPath = externalDir!.path;
  String filePath = '$externalPath/coordinatesCollected.txt';
  File file = File(filePath);
  file.writeAsStringSync('');
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

void calculateVarianceIsolate(
    int numFrameGroup, List<List<List<double>>> coordinatesData) {
  if (coordinatesData.length % numFrameGroup == 0) {
    double variance = 0;
    List<int> sequenceLen = [];
    List<int> sequenceTally = [];
    List<List<List<double>>> individualCoorManager = [];

    for (List<List<double>> sequenceData in coordinatesData) {
      if (sequenceLen.contains(sequenceData.length) == false) {
        sequenceLen.add(sequenceData.length);
        individualCoorManager.add(sequenceData);
        sequenceTally.add(1);
      } else {
        int tempIndex = sequenceLen.indexOf(sequenceData.length);
        int tempSeq = sequenceLen[tempIndex];

        sequenceTally[tempIndex] = sequenceTally[tempIndex]++;
        for (int ctr1 = 0;
            ctr1 <= individualCoorManager[tempIndex].length;
            ctr1++) {
          for (int ctr = 0;
              ctr <= individualCoorManager[tempIndex][ctr1].length;
              ctr++) {
            individualCoorManager[tempIndex][ctr1][ctr] =
                individualCoorManager[tempIndex][ctr1][ctr] +
                    sequenceData[ctr1][ctr];
          }
        }
      }
    }
  }
}

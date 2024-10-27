import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/coreFunctionality/data_collection_provider.dart';
import 'package:frontend/screens/exercise/create_exercise/create_exercise.dart';
import 'package:frontend/screens/inferencing/inferencing/mainUISettings.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:frontend/screens/coreFunctionality/provider_collection.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:math';

class generateTxtFile extends ConsumerStatefulWidget {
  final List<List<List<double>>> correctDataset;
  final List<List<List<double>>> incorretcDataset;

  bool isGenerated;

  generateTxtFile({
    super.key,
    required this.correctDataset,
    required this.incorretcDataset,
    required this.isGenerated,
  });

  @override
  ConsumerState<generateTxtFile> createState() => _generateTxtFileState();
}

class _generateTxtFileState extends ConsumerState<generateTxtFile> {
  late int progress;
  double progressT = 0;
  int progressCtr = 0;
  int seriousFactsRandIndex = 0;
  var random = Random();

  List<String> seriousFacts = [
    "Did you know? Regular exercise boosts mood and energy levels!",
    "Exercise is not just about physical health, it's also great for mental well-being.",
    "A balanced diet and regular exercise are key to a healthy lifestyle.",
    "Stay hydrated! Drinking water before, during, and after exercise is essential.",
    "Set goals, stay consistent, and celebrate your progress on your fitness journey!",
    "Remember, every step you take towards better health counts, no matter how small.",
    "Exercise doesn't have to be intense to be beneficial. Find activities you enjoy and make them a part of your routine.",
    "Quality sleep is just as important as exercise and nutrition for overall health.",
    "Variety is the spice of life! Mix up your workouts to keep things interesting and challenge your body.",
    "Listen to your body. Rest when needed and don't push yourself beyond your limits.",
    "Running late counts as cardio, right? Asking for a friend.",
    "Sweat is just fat crying because you're about to burn it off!",
    "Remember, the only bad workout is the one that didn't happen. So get moving and make your couch jealous!",
    "Want to be as strong as Saitama? Just do 100 push-ups, 100 sit-ups, 100 squats, and run 10 kilometers every single day! No AC!",
    "Saitama didn't become the strongest hero overnight. It took 100 push-ups, sit-ups, squats, and a lot of bananas!",
    "ARE YOU KIRIN ME?!",
    "???",
    "AI: WHAT KIND OF EXERCISE IS THIS?!",
    "AI: YOU CALL THIS AN EXERCISE?!",
    "AI: ARE TRYING TO KILL SOMEONE WITH THIS EXERCISE OF YOURS",
    "AI: 01101011 01100001 01110000 01101111 01111001 01100001 00100000 01110100 01101000 01100101 01110011 01101001 01110011 00100000 01101111 01101001",
  ];

  void navigateDone() {
    int count = 0;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CreateExercise()),
      (Route<dynamic> route) {
        return count++ >= 4;
      },
    );
  }

  Future<void> translateCollectedDatatoTxt(
    List<dynamic> dataCollected,
    bool isCorrectDataset,
  ) async {
    Directory externalDir = await getApplicationDocumentsDirectory();
    String externalPath = externalDir.path;

    String filePath = isCorrectDataset == true
        ? '$externalPath/coordinatesCollected.txt'
        : '$externalPath/coordinatesCollected(incorrect).txt';

    print("filpathhh -->$filePath ");
    File file = File(filePath);
    file.writeAsStringSync('');
    int progressCtr = 0;

    for (List exerciseSet in dataCollected) {
      progressCtr++;
      try {
        setState(() {
          progressT = (progressCtr / dataCollected.length);

          if (double.parse(progressT.toStringAsFixed(2)) % .10 == 0) {
            seriousFactsRandIndex = random.nextInt(seriousFacts.length);
          }
        });
      } catch (e) {
        break;
      }
      if (exerciseSet.isNotEmpty) {
        await file.writeAsString('START\n', mode: FileMode.append);

        for (List sequence in exerciseSet) {
          for (double individualCoordinate in sequence) {
            if (individualCoordinate.toString().length > 10) {
              // ---------------------------------------------------------------------------[DECIMAL PLACES NUMBER...ADJUST ACCORDINGLY]

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

    if (isCorrectDataset == true) {
      ref.read(correctDataSetPath.notifier).state = filePath;
      ref.read(positiveDatasetProvider.notifier).state = File(filePath);
    } else {
      ref.read(incorrectDataSetPath.notifier).state = filePath;
      ref.read(negativeDatasetProvider.notifier).state = File(filePath);
    }
  }

  @override
  void initState() {
    super.initState();
    translateCollectedDatatoTxt(widget.correctDataset, true);
    translateCollectedDatatoTxt(widget.incorretcDataset, false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> testLoading() async {
    for (int ctr = 0; ctr < 100; ctr++) {
      setState(() {
        progress = ctr;
      });
      await Future.delayed(
          const Duration(milliseconds: 100)); 
    }
  }

  @override
  Widget build(BuildContext context) {
    print("txt conversion1 ->${widget.isGenerated}");
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Color mainColor = mainColorState;
    Color secondaryColor = secondaryColorState;
    Color tertiaryColor = tertiaryColorState;
    Map<String, double> textSizeModif = ref.watch(textSizeModifier);

    late Map<String, Color> colorSet;
    colorSet = {
      "mainColor": mainColor,
      "secondaryColor": secondaryColor,
      "tertiaryColor": tertiaryColor,
    };

    progressT == 1 ? progressCtr++ : null;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(
          //   child: SizedBox(
          //     width: screenWidth * 0.75,
          //     child: Text(seriousFacts[seriousFactsRandIndex],
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           fontSize: textSizeModif["smallText2"]! * screenWidth,
          //           color: Colors.white,
          //         )),
          //   ),
          // ),
          Center(
            child: SizedBox(
              width: screenWidth * 0.65,
              height: screenHeight * 0.01,
              child: LinearProgressIndicator(
                minHeight: 20,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColorState),
                value: progressT,
              ),
            ),
          )
        ],
      ),
    );
  }
}

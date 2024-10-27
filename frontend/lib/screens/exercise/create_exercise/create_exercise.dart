import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/screens/coreFunctionality/data_collection_provider.dart';
import 'package:frontend/screens/dataCollection/create_exercise/base_collection_v1.dart';
import 'package:frontend/screens/dataCollection/create_exercise/txt_conversion.dart';
import 'package:frontend/screens/exercise/MET.dart';
import 'package:frontend/screens/exercise/parts.dart';
import 'package:frontend/screens/modelTraining/test.dart';
import 'package:frontend/widgets/spaceLine.dart';
import 'package:frontend/widgets/upload_image.dart';
import 'package:frontend/provider/main_settings.dart';

import 'package:frontend/services/exercise.dart';
import 'package:frontend/widgets/dialog_box.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/widgets/upload_video.dart';
import 'package:path_provider/path_provider.dart';

class CreateExercise extends ConsumerStatefulWidget {
  final bool isEdit;

  const CreateExercise({
    super.key,
    this.isEdit = false,
  });

  @override
  ConsumerState<CreateExercise> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends ConsumerState<CreateExercise> {
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeDescription = FocusNode();

  String METDescription =
      "MET(Metabolic Equivalent of Task) \n\nThis quantifies the amount of energy burn during execution of certain movements. The use of this is to have a better guage as much as possible of the exercise through matching it with the MET of an exercise that  closely ressemble the effort done to the exercise currently being made.";

  String CollectDescription =
      "Datset collection \n\nThe app collects datsets of the exercise through your movement \n\nStep 1: Dont move to initiate collecting data \nStep 2: Start performing the exercise and stop momentarily to end collecting of the exercution \nStep 3: Repeat... \nStep 4: Alternate Collecting Positive Dataset(Correct execution of the exercise) and Negative Dataset(Incorrect execution of the exercise), this can be done through pressing either the X or check button.  ";

  String exampleDescription =
      "Exercise Example \n users can attempt more rigurous version of this exercise by putting weights on back, this can result into more muscle build up if your aiming for a toned up body \n\n However users may also do it casually this can result with significant calorie burn that can have your body loose fat in no time.";

  final Map<String, bool> _parts = {
    'Neck': false,
    'Traps': false,
    'Shoulder': false,
    'Chest': false,
    'Biceps': false,
    'Forearms': false,
    'Abs': false,
    'Quadriceps': false,
    'Calves': false,
    'Middle Back': false,
    'Triceps': false,
    'Lower Back': false,
    'Side Abs': false,
    'Lower Leg': false,
    'Glutes': false,
    'Hamstrings': false,
    'Others': false
  };

  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController estimateTimeController = TextEditingController();
  final TextEditingController negativeDatasetController =
      TextEditingController();
  final TextEditingController positiveDatasetController =
      TextEditingController();
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void testListener() {
    print("test");
  }



  String _selectedIntensity = "Easy";
  List<String> _selected_part = [];
  double METValue = 0.0;

  File? _image = null;
  Uint8List? _imageThumbnail = null;

  File? _video = null;
  Uint8List? _videoThumbnail = null;

  int _sets = 0;
  int _reps = 0;

  bool helpShowDataset = false;
  bool helpShowMET = false;

  List<List<List<double>>> _positiveDataset = [];
  List<List<List<double>>> _negativeDataset = [];

  double avgPositive = 0.0;
  double avgNegative = 0.0;

  int minNegative = 0;
  int minPositive = 0;

  int maxNegative = 0;
  int maxPositive = 0;

  bool isDataValid = false;
  bool _isGenerated = false;

  double progressT = 0;

  void _onChangeImage(File? imagePicked) {
    setState(() {
      _image = imagePicked;
    });
  }

  void _onChangeImageThumbnail(Uint8List? thumbnail) {
    setState(() {
      _imageThumbnail = thumbnail;
    });
  }

  void _onChangeVideo(File? video) {
    setState(() {
      _video = video;
    });
  }

  void _onChangeVideoThumbnail(Uint8List? videoThumbnail) {
    setState(() {
      _videoThumbnail = videoThumbnail;
    });
  }

  Widget inputTitle(String name, String subDescription) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              " $subDescription",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
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
          print("progressT-->$progressT");
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

  Future<void> _calculateDataset() async {
    setState(
      () {
        int totalFramesPositive = 0;
        int totalFramesNegative = 0;

        minPositive = 0;
        maxPositive = 0;
        avgPositive = 0;

        minNegative = 0;
        maxNegative = 0;
        avgNegative = 0;

        _isGenerated = false;

        for (List<List<double>> execution in _positiveDataset) {
          print("positive data");
          totalFramesPositive = totalFramesPositive + execution.length;

          if (minPositive == 0) {
            minPositive = execution.length;
          }

          if (maxPositive < execution.length) {
            maxPositive = execution.length;
          }

          if (minPositive > execution.length) {
            minPositive = execution.length;
          }
        }

        for (List<List<double>> execution in _negativeDataset) {
          totalFramesNegative = totalFramesNegative + execution.length;

          if (minPositive == 0) {
            minNegative = execution.length;
          }

          if (maxNegative < execution.length) {
            maxNegative = execution.length;
          }

          if (minPositive > execution.length) {
            minNegative = execution.length;
          }
        }

        if (totalFramesPositive != 0) {
          avgPositive = double.parse(
              (totalFramesPositive / _positiveDataset.length)
                  .toStringAsFixed(2));
        }

        if (totalFramesNegative != 0) {
          avgNegative = double.parse(
              (totalFramesNegative / _negativeDataset.length)
                  .toStringAsFixed(2));
        }
      },
    );
    if (_positiveDataset.length >= 30 && _negativeDataset.length >= 30) {
      await translateCollectedDatatoTxt(_positiveDataset, true);
      await translateCollectedDatatoTxt(_negativeDataset, false);
      setState(() {
        _isGenerated = true;
        print("_isGenerated --> $_isGenerated");
      });
    }
  }

  Widget _datasetInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            dataset(_positiveDataset.length.toString(), "Positive"),
            SizedBox(
              width: 20,
            ),
            dataset(_negativeDataset.length.toString(), "Negative"),
            Spacer()
          ],
        ),
        datasetSubInfo(
          minPositive.toString(),
          minNegative.toString(),
          "Minimum Frames",
        ),
        datasetSubInfo(
          maxPositive.toString(),
          maxNegative.toString(),
          "Maximum Frames",
        ),
        datasetSubInfo(
          avgPositive.toString(),
          avgNegative.toString(),
          "Average Frames",
        ),
      ],
    );
  }

  Widget _setsReps() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Spacer(),
          Column(
            children: [
              Text(
                "Sets",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      child: Icon(
                        size: 25,
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      if (_sets != 0) {
                        setState(
                          () {
                            _sets--;
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .16,
                    height: MediaQuery.of(context).size.width * .13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "$_sets",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    child: Container(
                      child: Icon(
                        size: 25,
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _sets++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Text(
                "Reps",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      child: Icon(
                        size: 25,
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      if (_reps != 0) {
                        setState(
                          () {
                            _reps--;
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .16,
                    height: MediaQuery.of(context).size.width * .13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "$_reps",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    child: Container(
                      child: Icon(
                        size: 25,
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _reps++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget dataset(String num, String name) {
    return Column(
      children: [
        Text(
          "$name",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w100,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .21,
          child: Container(
            decoration: BoxDecoration(
              color: mainColor,
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 45,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: Text(
                "${num}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget datasetSubInfo(String positive, String negative, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 25,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .21,
          child: Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 45,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: Text(
                "${positive}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        Text(
          "$name",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w100,
          ),
        ),
        Spacer(),
        SizedBox(
          width: MediaQuery.of(context).size.width * .21,
          child: Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 45,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: Text(
                "${negative}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 25,
        ),
      ],
    );
  }

  Widget checkInput(bool isDone, String inputDetails,
      {bool isOptional = false}) {
    return Row(
      children: [
        !isDone
            ? isOptional
                ? Icon(
                    size: 17,
                    Icons.remove_circle,
                    color: Colors.yellow,
                  )
                : Icon(
                    size: 17,
                    Icons.cancel,
                    color: Colors.red,
                  )
            : Icon(
                size: 17,
                Icons.check_circle,
                color: Colors.green,
              ),
        Text(
          " $inputDetails",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }

  Widget _validateInput() {
    return Container(
        child: Row(
      children: [
        SizedBox(
          width: 25,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          checkInput(_exerciseNameController.text.isNotEmpty, "Exercise name"),
          checkInput(_image != null, "Image submitted"),
          checkInput(_video != null, "Video submitted"),
          checkInput(_selected_part.isNotEmpty, "Parts input(s)"),
          checkInput(_sets != 0 && _reps != 0, "Sets and Reps input"),
          checkInput(METValue != 0.0, "MET input"),
          checkInput(_descriptionController.text.isNotEmpty, "Description",
              isOptional: true),
          checkInput(_positiveDataset.length > 5 && _negativeDataset.length > 5,
              "Atleast 30 negative and positive dataset"),
        ]),
      ],
    ));
  }

  void _submitCheck() {
    print(
        "_exerciseNameController.text.isNotEmpty-->${_exerciseNameController.text.isNotEmpty}");
    print("_image-->${_image != null}");
    print("_video-->${_video != null}"); // Checking if _video is not null
    print("_selected_part.isNotEmpty-->${_selected_part.isNotEmpty}");
    print("_sets-->${_sets != 0}");
    print("_reps-->${_reps != 0}");
    print("METValue-->${METValue != 0.0}");
    print("_positiveDataset.length-->${_positiveDataset.length > 5}");
    print("_negativeDataset.length-->${_negativeDataset.length > 5}");

    if (_exerciseNameController.text.isNotEmpty &&
        _image != null &&
        _video != null &&
        _selected_part.isNotEmpty &&
        _sets != 0 &&
        _reps != 0 &&
        METValue != 0.0 &&
        _positiveDataset.length > 5 &&
        _negativeDataset.length > 5) {
      setState(() {
        isDataValid = true;
      });
    } else {
      setState(() {
        isDataValid = false;
      });
    }

    print("checking validity -> $isDataValid");
  }

  Widget parts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputTitle("Parts", "(You can choose multiple parts)"),
        Center(
          child: musclePart(
            abs: _parts["Abs"]!,
            biceps: _parts["Biceps"]!,
            calves: _parts["Calves"]!,
            chest: _parts["Chest"]!,
            forearms: _parts["Forearms"]!,
            glutes: _parts["Glutes"]!,
            hamstrings: _parts["Hamstrings"]!,
            lowerBack: _parts["Lower Back"]!,
            lowerLeg: _parts["Lower Leg"]!,
            middleBack: _parts["Middle Back"]!,
            quadriceps: _parts["Quadriceps"]!,
            shoulder: _parts["Shoulder"]!,
            sideAbs: _parts["Side Abs"]!,
            traps: _parts["Traps"]!,
            triceps: _parts["Triceps"]!,
          ),
        ),
        Wrap(
          spacing: 4.0,
          runSpacing: 2.0,
          children: List.generate(
            _parts.length,
            (index) {
              return GestureDetector(
                child: Chip(
                  color: _parts[_parts.keys.elementAt(index)] == true
                      ? WidgetStateProperty.all(secondaryColor)
                      : WidgetStateProperty.all(mainColor),
                  label: Text(
                    _parts.keys.elementAt(index),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _parts[_parts.keys.elementAt(index)] == false
                        ? _selected_part.add(_parts.keys.elementAt(index))
                        : _selected_part.remove(_parts.keys.elementAt(index));

                    _parts[_parts.keys.elementAt(index)] == false
                        ? _parts[_parts.keys.elementAt(index)] = true
                        : _parts[_parts.keys.elementAt(index)] = false;

                    print("parts -> ${ref.read(exercisePart)}");
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void onChangeIntensity(String intensity) {
    setState(() {
      print("intensity -> $intensity");
      _selectedIntensity = intensity;
    });
    _submitCheck();
  }

  void onChangeMET(double MET) {
    print("MET -> $MET");

    setState(() {
      METValue = MET;
    });

    _submitCheck();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _descriptionController.addListener(testListener);
    });
  }

  void dispose() {
    _exerciseNameController.dispose();
    _focusNodeName.dispose();
    _focusNodeDescription.dispose();
    super.dispose();
  }

  void submitData() async {
    await ExerciseApiService.addExercise(
      ref: ref,
      part: _selected_part,
      // positiveNum: ref.watch(coordinatesDataProvider).state.length.toString(),
      // negativeNum:
      //     ref.watch(incorrectCoordinatesDataProvider).state.length.toString(),
      accountId: int.parse(setup.id),
      name: _exerciseNameController.text,
      intensity: _selectedIntensity,
      description: _descriptionController.text,
      sets: _sets.toString(),
      reps: _reps.toString(),
      image: _image,
      video: _video,
      positiveDataset: ref.read(positiveDatasetProvider),
      negativeDataset: ref.read(negativeDatasetProvider),
      estimatedTime: ref.read(estimatedTimeProvider),
      MET: ref.read(metProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    _submitCheck();

    return Scaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: false,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .87,
                width: MediaQuery.of(context).size.width * .9,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Exercise",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        spaceLine(context),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Exercise Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: mainColor,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: TextField(
                              focusNode: _focusNodeName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                              enabled: true,
                              obscureText: false,
                              controller: _exerciseNameController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(36),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        spaceLine(context),
                        inputTitle("Image",
                            "(This is a thumbnail shown in the library)"),
                        UploadImage(
                          onChangeImage: _onChangeImage,
                          onChangeThumbnail: _onChangeImageThumbnail,
                          thumbnail: _imageThumbnail,
                        ),
                        spaceLine(context),
                        inputTitle(
                            "Video", "(This will be a guide for other users)"),
                        UploadVideo(
                          onChangeVideo: _onChangeVideo,
                          onChangeVideoThumbnail: _onChangeVideoThumbnail,
                          thumbnail: _videoThumbnail,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        spaceLine(context),
                        parts(),
                        spaceLine(context),
                        inputTitle("Sets and Reps", ""),
                        _setsReps(),
                        spaceLine(context),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            inputTitle(
                                "MET", "(Find the estimated equivalent)"),
                            Spacer(),
                            GestureDetector(
                              child: Icon(
                                size: 17,
                                Icons.question_mark,
                                color: Colors.white,
                              ),
                              onTap: () {
                                setState(() {
                                  helpShowMET = !helpShowMET;
                                });
                              },
                            ),
                          ],
                        ),
                        helpShowMET
                            ? Text(
                                METDescription,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w100,
                                ),
                              )
                            : SizedBox(),
                        MET(
                          intensity: onChangeIntensity,
                          met: onChangeMET,
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration:
                              InputDecoration(labelText: 'Enter Description'),
                        ),
                        spaceLine(context),
                        inputTitle("Description",
                            "(Optional, but useful to guide user)"),
                        Container(
                          decoration: BoxDecoration(
                            color: mainColor,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              focusNode: _focusNodeDescription,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(500),
                              ],
                              enabled: true,
                              obscureText: false,
                              controller: _descriptionController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: 50,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 12),
                                hintText: exampleDescription,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        spaceLine(context),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            inputTitle(
                                "Collect Dataset", "(Used for training model)"),
                            Spacer(),
                            GestureDetector(
                              child: Icon(
                                size: 17,
                                Icons.question_mark,
                                color: Colors.white,
                              ),
                              onTap: () {
                                setState(() {
                                  helpShowDataset = !helpShowDataset;
                                });
                              },
                            )
                          ],
                        ),
                        helpShowDataset
                            ? Text(
                                CollectDescription,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w100,
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        _datasetInfo(),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: _positiveDataset.length >= 30 &&
                                    _negativeDataset.length >= 30 &&
                                    _isGenerated == false
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Generating datasets...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                      LinearProgressIndicator(
                                        minHeight: 20,
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                secondaryColor),
                                        value: progressT,
                                      )
                                    ],
                                  )
                                : _positiveDataset.length <= 30 &&
                                        _negativeDataset.length <= 30
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            size: 17,
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          Text(
                                            "More data is needed.",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ],
                                      )
                                    : _positiveDataset.length >= 30 &&
                                            _negativeDataset.length >= 30 &&
                                            _isGenerated == true
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                size: 17,
                                                Icons.check_circle,
                                                color: Colors.green,
                                              ),
                                              Text(
                                                " Data generated and ready.",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BaseCollection(
                                    isGenerated: _isGenerated,
                                    onInitDatasetCalc: _calculateDataset,
                                    positiveData: _positiveDataset,
                                    negativeData: _negativeDataset,
                                  ),
                                ),
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => TaskStatusPage(),
                              //   ),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(300, 5),
                              foregroundColor: Colors.white,
                              backgroundColor: tertiaryColor,
                            ),
                            child: const Text('Add Dataset'),
                          ),
                        ),
                        spaceLine(context),
                        _validateInput(),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: ElevatedButton(
                            // onPressed: () {
                            //   widget.isEdit ? editData() : submitData();
                            // },
                            onPressed: () {
                              isDataValid ? submitData() : () {};
                            },
                            style: ElevatedButton.styleFrom(
                              side: isDataValid
                                  ? null
                                  : BorderSide(color: Colors.blue, width: 2),
                              fixedSize: const Size(300, 5),
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  isDataValid ? tertiaryColor : mainColor,
                            ),
                            child: const Text('Create Exercise'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

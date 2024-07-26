import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/dataCollection/p1_base_collection.dart';
import 'package:frontend/screens/dataCollection/p5_model_training.dart';
import 'package:frontend/widgets/custom_button.dart';

import 'package:image_picker/image_picker.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../provider/data_collection_provider.dart';
import '../../provider/global_variable_provider.dart';

// import 'package:fitguide_main/services/globalVariables.dart';

class ExerciseDetails extends ConsumerStatefulWidget {
  final int exerciseID;
  const ExerciseDetails({super.key, this.exerciseID = 0});

  @override
  ConsumerState<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends ConsumerState<ExerciseDetails> {
  late TextEditingController nameController;
  late TextEditingController repetitionsController;
  late TextEditingController setsController;
  late TextEditingController descriptionController;

  String exerciseName = "";
  int executionNum = 0;
  int setsNum = 0;
  String description = "";
  String extraNote = "";
  String _selectedItem = 'Beginner';

  File? exerciseImage;

  @override
  Future<void> initState() async {
    super.initState();
    if (widget.exerciseID != 0) {
      // try {
      //   dynamic exerciseInfo = await getExerciseInfo(widget.exerciseID);
      //   dynamic exercise = exerciseInfo['exercise_info'];
      //   setState(() {
      //     nameController = TextEditingController(text: exercise['name']);
      //     repetitionsController =
      //         TextEditingController(text: exercise['repetitions'].toString());
      //     setsController =
      //         TextEditingController(text: exercise['set'].toString());
      //     descriptionController =
      //         TextEditingController(text: exercise['description']);
      //     _selectedItem = exercise["difficulty"];
      //     ref.watch(exerciseNameProvider.notifier).state = exercise['name'];
      //     ref.watch(descriptionProvider.notifier).state =
      //         exercise['description'];
      //     ref.watch(exerciseNumSetProvider.notifier).state = exercise['set'];
      //     ref.watch(exerciseNumExecutionProvider.notifier).state =
      //         exercise['repetitions'];
      //     ref.watch(difficultyProvider.notifier).state = exercise["difficulty"];
      //     ref.watch(exerciseID.notifier).state = widget.exerciseID.toString();
      //   });
      // } catch (error) {
      //   print(error);
      // }
    } else {
      ref.watch(exerciseNameProvider.notifier).state = '';
      ref.watch(descriptionProvider.notifier).state = '';
      ref.watch(exerciseNumSetProvider.notifier).state = 0;
      ref.watch(exerciseNumExecutionProvider.notifier).state = 0;
      ref.watch(difficultyProvider.notifier).state = '';
      nameController = TextEditingController(text: '');
      repetitionsController = TextEditingController(text: '');
      setsController = TextEditingController(text: '');
      descriptionController = TextEditingController(text: '');
    }
  }

  Widget customLargeTextField({
    required String label,
    required String hintText,
    required double width,
    required String variable,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.height * 0.15,
      child: TextField(
        controller: controller,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(16.0),
        ),
        onChanged: (value) {
          setState(() {
            String enteredText = value.replaceAll('\n', '');

            if (variable == "description") {
              description = enteredText;
              ref.read(descriptionProvider.notifier).state = description;
            }

            if (variable == "extraNote") {
              extraNote = enteredText;
              ref.read(additionalNotesProvider.notifier).state = extraNote;
            }
          });
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        setState(() {
          ref.read(imagePath.notifier).state = image.path;
          exerciseImage = File(image.path);
        });
      }
    } on PlatformException {}
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickVideo(ImageSource source) async {
    final pickedFile = await _picker.pickVideo(source: source);

    if (pickedFile != null) {
      // String videoPath = pickedFile.path;
      // ...
    }
  }

  void _showSelectPhotoOptions(
      BuildContext context, double initialSize, double maxSize) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialSize,
        maxChildSize: maxSize,
        minChildSize: 0.28,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            // child: SelectPhotoOptionsScreen(
            //   onTap: _pickImage,
            // ),
          );
        },
      ),
    );
  }

  Widget customText({
    required screenWidth,
    required textSizeModif,
    required value,
    required text1,
    required text2,
    bool isMain = false,
    sizeModif = 1,
  }) {
    double letterSpacing = -0.5;
    return Container(
      child: Row(
        mainAxisAlignment:
            isMain == true ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              letterSpacing: letterSpacing - .10,
              color: tertiaryColorState,
              fontSize:
                  screenWidth * 3 * textSizeModif["largeText"]! * sizeModif,
            ),
          ),
          // -------------------------------------------------[executions performed]
          Column(
            children: [
              Text(
                text1,
                style: TextStyle(
                  letterSpacing: letterSpacing,
                  color: tertiaryColorState,
                  fontSize:
                      screenWidth * textSizeModif["smallText"]! * sizeModif,
                ),
              ),
              Text(
                text2,
                style: TextStyle(
                  letterSpacing: letterSpacing,
                  color: tertiaryColorState,
                  fontSize:
                      screenWidth * textSizeModif["smallText"]! * sizeModif,
                ),
              ),
              Text(
                "",
                style: TextStyle(
                  letterSpacing: letterSpacing,
                  color: tertiaryColorState,
                  fontSize:
                      screenWidth * textSizeModif["smallText"]! * sizeModif,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Color darkenColor(Color color, double factor) {
    assert(factor >= 0 && factor <= 1, 'Factor must be between 0 and 1');
    int red = (color.red * (1 - factor)).round().clamp(0, 255);
    int green = (color.green * (1 - factor)).round().clamp(0, 255);
    int blue = (color.blue * (1 - factor)).round().clamp(0, 255);
    return Color.fromRGBO(red, green, blue, 1);
  }

  Widget customCheckBox({
    required bool value,
    required String label,
    required double width,
    required double height,
    required double spacing,
  }) {
    return Column(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: darkenColor(tertiaryColorState, 0.2),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Checkbox(
                fillColor: MaterialStateProperty.all(secondaryColorState),
                checkColor: tertiaryColorState,
                value: value,
                onChanged: (bool? value) {},
              ),
              Text(label)
            ],
          ),
        ),
        SizedBox(
          height: spacing,
        ),
      ],
    );
  }

  Widget customTextField({
    required String label,
    required String hintText,
    required double width,
    required double height,
    required String variable,
    required TextEditingController controller,

    // required double height,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: variable == "exerciseName"
            ? TextInputType.name
            : TextInputType.number,
        maxLength: variable == "exerciseName" ? 20 : 2,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const UnderlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
        ),
        onChanged: (String value) {
          setState(() {
            if (variable == "exerciseName") {
              exerciseName = value;
              ref.read(exerciseNameProvider.notifier).state = exerciseName;
            }
            if (variable == "executionNum") {
              value.isNotEmpty
                  ? executionNum = int.parse(value)
                  : executionNum = 0;
              ref.read(exerciseNumExecutionProvider.notifier).state =
                  executionNum;
            }
            if (variable == "setsNum") {
              value.isNotEmpty ? setsNum = int.parse(value) : setsNum = 0;
              ref.read(exerciseNumSetProvider.notifier).state = setsNum;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, double> textSizeModif = ref.watch(textSizeModifier);

    return ShowCaseWidget(
      builder: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: screenHeight * 0.25,
                  ),
                  Container(
                    color: mainColorState,
                    height: screenHeight,
                    width: screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Text(
                          "Exercise Details",
                          style: TextStyle(
                              color: tertiaryColorState,
                              fontSize:
                                  screenWidth * textSizeModif["largeText"]!),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        customTextField(
                            controller: nameController,
                            label: "Exercise Name",
                            hintText: "Push-Up",
                            width: screenWidth * .9,
                            height: screenWidth * .18,
                            variable: "exerciseName"),
                        SizedBox(
                          height: screenWidth * 0.02,
                        ),
                        SizedBox(
                          height: screenWidth * 0.02,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customTextField(
                              controller: repetitionsController,
                              label: "Repetition",
                              hintText: "10",
                              width: screenWidth * .44,
                              height: screenWidth * .18,
                              variable: "executionNum",
                            ),
                            SizedBox(
                              width: screenWidth * 0.02,
                            ),
                            customTextField(
                              controller: setsController,
                              label: "Sets",
                              hintText: "5",
                              width: screenWidth * .44,
                              height: screenWidth * .18,
                              variable: "setsNum",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenWidth * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Difficulty:',
                            ),
                            const SizedBox(
                                width:
                                    20), // Add spacing between title and dropdown
                            DropdownButton<String>(
                              value: _selectedItem,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedItem = newValue!;
                                  ref.watch(difficultyProvider.notifier).state =
                                      newValue;
                                });
                              },
                              items: <String>[
                                'beginner',
                                'intermediate',
                                'advanced',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenWidth * 0.02,
                        ),
                        customLargeTextField(
                          controller: descriptionController,
                          label: "Description",
                          hintText: "Do this and that and don't do this...",
                          width: screenWidth * .9,
                          variable: 'description',
                        ),
                        SizedBox(
                          height: screenWidth * 0.05,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  _showSelectPhotoOptions(context, 0.28, 0.4);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.4, // Adjust width as needed
                                  height: 100, // Adjust height as needed
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust border radius as needed
                                    color: Colors.grey[
                                        200], // You can set the background color
                                    image: exerciseImage != null
                                        ? DecorationImage(
                                            image: FileImage(exerciseImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: exerciseImage == null
                                      ? const Icon(Icons.person,
                                          size: 50) // Placeholder icon or text
                                      : null,
                                ),
                              ),
                              widget.exerciseID != 0
                                  ? Column(
                                      children: [
                                        buildElevatedButton(
                                          context: context,
                                          label: "Retrain",
                                          colorSet:
                                              ref.watch(ColorSet)["ColorSet1"]!,
                                          textSizeModifierIndividual: ref.watch(
                                              textSizeModifier)["smallText2"]!,
                                          func: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BaseCollection(
                                                        isRetraining: true,
                                                      )),
                                            );
                                          },
                                        ),
                                        buildElevatedButton(
                                          context: context,
                                          label: "Train",
                                          colorSet:
                                              ref.watch(ColorSet)["ColorSet1"]!,
                                          textSizeModifierIndividual: ref.watch(
                                              textSizeModifier)["smallText2"]!,
                                          func: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BaseCollection(
                                                        isRetraining: true,
                                                        isNewRetrain: true,
                                                      )),
                                            );
                                          },
                                        ),
                                        buildElevatedButton(
                                          context: context,
                                          label: "Record",
                                          colorSet:
                                              ref.watch(ColorSet)["ColorSet1"]!,
                                          textSizeModifierIndividual: ref.watch(
                                              textSizeModifier)["smallText2"]!,
                                          func: () {},
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ]),
                        SizedBox(
                          height: screenWidth * 0.05,
                        ),
                        widget.exerciseID == 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      customCheckBox(
                                        value: ref.watch(headBoolState),
                                        label: 'Head',
                                        width: screenWidth * .44,
                                        height: screenWidth * .07,
                                        spacing: screenWidth * 0.02,
                                      ),
                                      customCheckBox(
                                        value: ref.watch(leftLegBoolState),
                                        label: 'Left Leg',
                                        width: screenWidth * .44,
                                        height: screenWidth * .07,
                                        spacing: screenWidth * 0.02,
                                      ),
                                      customCheckBox(
                                        value: ref.watch(leftArmBoolState),
                                        label: 'Left Arm',
                                        width: screenWidth * .44,
                                        height: screenWidth * .07,
                                        spacing: screenWidth * 0.02,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Column(
                                    children: [
                                      customCheckBox(
                                        value: ref.watch(bodyBoolState),
                                        label: 'Body',
                                        width: screenWidth * .44,
                                        height: screenWidth * .07,
                                        spacing: screenWidth * 0.02,
                                      ),
                                      customCheckBox(
                                        value: ref.watch(rightArmBoolState),
                                        label: 'Right Arm',
                                        width: screenWidth * .44,
                                        height: screenWidth * .07,
                                        spacing: screenWidth * 0.02,
                                      ),
                                      customCheckBox(
                                        value: ref.watch(rightArmBoolState),
                                        label: 'Right Leg',
                                        width: screenWidth * .44,
                                        height: screenWidth * .07,
                                        spacing: screenWidth * 0.02,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildElevatedButton(
                                context: context,
                                label: "Submit",
                                colorSet: ref.watch(ColorSet)["ColorSet1"]!,
                                textSizeModifierIndividual:
                                    ref.watch(textSizeModifier)["smallText2"]!,
                                func: () {
                                  setState(() {});

                                  if (widget.exerciseID != 0) {
                                    // updateExercise(ref, widget.exerciseID);
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const collectionDataP4(),
                                    ),
                                  );
                                },
                              ),
                            ])
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

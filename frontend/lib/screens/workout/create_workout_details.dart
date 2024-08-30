import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/widgets/upload_image.dart';
import 'package:frontend/screens/workout/create_workout_exercise.dart';
import 'package:frontend/provider/main_settings.dart';

import 'package:frontend/screens/workout/workout_data_management.dart';
import 'package:frontend/screens/workout/workouts_library.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/widgets/dialog_box.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/input_field.dart';
import 'package:frontend/widgets/navigation_drawer.dart';

class CreateWorkout extends ConsumerStatefulWidget {
  final bool isEdit;

  const CreateWorkout({
    super.key,
    this.isEdit = false,
  });

  @override
  ConsumerState<CreateWorkout> createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends ConsumerState<CreateWorkout> {
  List<String> _intensity = ['Easy', 'Normal', 'Hard', 'Advance'];
  List<String> _type = ['Muscle Buildup', 'Cardio'];

  late String _selectedItemIntensity;
  late String _selectedItemType;

  final TextEditingController workoutNameController = TextEditingController();
  final TextEditingController descriptionNameController =
      TextEditingController();

  String title = '';
  File? exerciseImage;
  bool isInit = false;

  List<int> pickedExercise = [];
  List<int> toRemoveExercise = [];
  List<int> toAddExercise = [];

  @override
  void initState() {
    super.initState();
    _selectedItemIntensity = _intensity[0];
    _selectedItemType = _type[0];
    initEdit();
  }

  void validateInput(BuildContext context) {
    showCustomDialog(
      widthMultiplier: 0.5,
      heightMultiplier: 0.25,
      context,
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Invalid Inputs:",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              workoutNameController.text == ""
                  ? const Text(
                      "  - Enter a workout name",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      ),
                    )
                  : const SizedBox(),
              ref.read(imageProvider) == null
                  ? const Text(
                      "  - Select a workout image",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox(),
              ref.read(exerciseListProvider).isEmpty
                  ? const Text(
                      "  - No exercise was added",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      ),
                    )
                  : const SizedBox(),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 5),
                    foregroundColor: Colors.white,
                    backgroundColor: tertiaryColor,
                  ),
                  child: const Text("Close"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addedWorkoutNotif(BuildContext context) {
    showCustomDialog(
      widthMultiplier: 0.5,
      heightMultiplier: 0.25,
      context,
      Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Succesfully created a workout",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    navigateDone();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 5),
                    foregroundColor: Colors.white,
                    backgroundColor: tertiaryColor,
                  ),
                  child: Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initEdit() {
    setState(() {
      workoutNameController.text = ref.read(name);
      descriptionNameController.text = ref.read(description);
      _selectedItemIntensity = ref.read(intensity);
      _selectedItemType = ref.read(type);
    });
  }

  Future<void> createExercise() async {
    ref.read(name.notifier).state = workoutNameController.text;
    ref.read(description.notifier).state = descriptionNameController.text;
    ref.read(intensity.notifier).state = _selectedItemIntensity;
    ref.read(type.notifier).state = _selectedItemType;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickExercise(
          isEdit: widget.isEdit,
        ),
      ),
    );
  }

  Future<void> createWorkout() async {
    if (workoutNameController.text == "" ||
        ref.read(imageProvider) == null ||
        ref.read(exerciseListProvider).isEmpty) {
      validateInput(context);
    } else {
      Workout temp = await WorkoutApiService.sendWorkoutData(
        ref: ref,
        type: _selectedItemType,
        accountId: int.parse(setup.id),
        name: workoutNameController.text,
        difficulty: _selectedItemIntensity,
        description: descriptionNameController.text,
        image: ref.read(imageProvider),
      );
      print(
          "descriptionNameController.text--->${descriptionNameController.text}");
      List<int> editedExercise = await ref.read(exerciseListProvider);

      for (int exercise in editedExercise) {
        WorkoutApiService.addExerciseToWorkout(
            exerciseID: exercise, workoutID: temp.id);
      }
      addedWorkoutNotif(context);
    }
  }

  Future<void> validateExerciseEdit() async {
    List<int> baseExercise = await ref.read(baseExerciseListProvider);
    List<int> editedExercise = await ref.read(exerciseListProvider);

    for (int exercise in baseExercise) {
      if (!editedExercise.contains(exercise)) {
        WorkoutApiService.deleteExerciseToWorkout(
            exerciseID: exercise, workoutID: int.parse(ref.read(workoutID)));
        toRemoveExercise.add(exercise);
      }
    }
    for (int exercise in editedExercise) {
      if (!baseExercise.contains(exercise)) {
        toAddExercise.add(exercise);

        WorkoutApiService.addExerciseToWorkout(
            exerciseID: exercise, workoutID: int.parse(ref.read(workoutID)));
      }
    }
  }

  Future<void> editWorkout() async {
    await validateExerciseEdit();

    await WorkoutApiService.editWorkoutData(
      ref: ref,
      workoutId: int.parse(ref.read(workoutID)),
      accountId: int.parse(setup.id),
      name: workoutNameController.text,
      difficulty: _selectedItemIntensity,
      type: _selectedItemIntensity,
      description: descriptionNameController.text,
      image: ref.read(imageProvider),
    );
    navigateDone();
  }

  void navigateDone() {
    int count = 0;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WorkoutLibrary()),
      (Route<dynamic> route) {
        return count++ >= 3;
      },
    );
  }

  Widget dropDown(List<String> inputList, String selectedItem,
      void Function(String?) onChanged) {
    return DropdownButton<String>(
      value: selectedItem,
      hint: Text(
        inputList[0],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      underline: Container(
        // Customize the underline
        height: 0,
        color: Colors.transparent,
      ),
      items: inputList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: false,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Column(
            children: [
              const Header(),
              Container(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Create Workout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        InputField(
                            inputName: " Workout Name:",
                            textController: workoutNameController),
                        Container(
                          width: MediaQuery.of(context).size.width * .9,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "  Intensity:",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: dropDown(
                                            _intensity,
                                            _selectedItemIntensity,
                                            (String? newValue) {
                                              setState(
                                                () {
                                                  _selectedItemIntensity =
                                                      newValue!;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .48,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "  Type:",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 40,
                                      child: dropDown(
                                        _type,
                                        _selectedItemType,
                                        (String? newValue) {
                                          setState(
                                            () {
                                              _selectedItemType = newValue!;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InputField(
                          inputName: " Description / Instruction:",
                          textController: descriptionNameController,
                          isParagraph: true,
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const Text(
                            "Workout Image:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          UploadImage(
                            isEdit: widget.isEdit,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        createExercise();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 5),
                        foregroundColor: Colors.white,
                        backgroundColor: tertiaryColor,
                      ),
                      child: const Text('Add Exercises'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        createExercise();
                        validateInput(context);

                        widget.isEdit == false
                            ? createWorkout()
                            : editWorkout();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 5),
                        foregroundColor: Colors.white,
                        backgroundColor: tertiaryColor,
                      ),
                      child: const Text('Create Workout'),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

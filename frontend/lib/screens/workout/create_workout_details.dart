import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/screens/upload_video.dart';
import 'package:frontend/screens/workout/create_workout_exercise.dart';
import 'package:frontend/provider/main_settings.dart';

import 'package:frontend/screens/workout/workout_data_management.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/input_field.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class CreateWorkout extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final String difficulty;
  final String description;
  final String imageUrl;
  final bool isEdit;

  const CreateWorkout({
    super.key,
    this.name = "",
    this.id = "",
    this.difficulty = "Easy",
    this.description = "",
    this.imageUrl = "",
    this.isEdit = false,
  });

  @override
  ConsumerState<CreateWorkout> createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends ConsumerState<CreateWorkout> {
  List<String> _intensity = ['Easy', 'Normal', 'Hard', 'Advance'];
  late String _selectedItemPart = _intensity[0];
  final TextEditingController workoutNameController = TextEditingController();
  final TextEditingController descriptionNameController =
      TextEditingController();

  String title = '';
  File? exerciseImage;
  bool isInit = false;

  late Future<List<Exercise>> _currentExercisesFuture;
  List<int> pickedExercise = [];

  late Future<List<Exercise>> _exercisesFuture;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    if (widget.id != "") {
      WorkoutApiService.fetchExerciseWorkouts(int.parse(widget.id));
      _exercisesFuture = ExerciseApiService.fetchExercises();
    }
    initEdit();
  }

  Future<void> initializeExerciseList() async {
    if (widget.isEdit == true) {
      if (ref.read(initExerciseEdit) == false) {
        _currentExercisesFuture =
            WorkoutApiService.fetchExerciseWorkouts(int.parse(widget.id));
        ref.read(initExerciseEdit.notifier).state = true;
        List<Exercise> workout = await _currentExercisesFuture;
        for (Exercise exercise in workout) {
          pickedExercise.add(exercise.id);
        }
        ref.read(baseExerciseListProvider.notifier).state = pickedExercise;

        ref.read(exerciseListProvider.notifier).state = pickedExercise;
      }
    }
  }

  void initEdit() {
    setState(() {
      workoutNameController.text = widget.name;
      descriptionNameController.text = widget.description;
      _selectedItemPart = widget.difficulty;
    });
  }

  void saveChanges() {
    ref.read(name.notifier).state = workoutNameController.text;
    ref.read(description.notifier).state = descriptionNameController.text;
    ref.read(difficulty.notifier).state = _selectedItemPart;
    ref.read(workoutID.notifier).state = widget.id;
  }

  Future<void> createExercise() async {
    await initializeExerciseList();

    saveChanges();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget.id != ""
            ? PickExercise(
                workoutID: int.parse(widget.id),
              )
            : PickExercise(),
      ),
    );
  }

  Future<void> createWorkout() async {
    dynamic temp = await WorkoutApiService.sendWorkoutData(
      accountId: int.parse(setup.id),
      name: workoutNameController.text,
      difficulty: _selectedItemPart,
      description: descriptionNameController.text,
      image: ref.read(imageProvider),
    );

    List<int> exerciseList = ref.read(exerciseListProvider);
    for (int exercise in exerciseList) {
      WorkoutApiService.addExerciseToWorkout(
          exerciseID: exercise, workoutID: temp.id);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickExercise(
          workoutID: int.parse(widget.id),
        ),
      ),
    );
  }

  Future<void> editWorkout() async {
    print("baseExerciseListProvider--->${ref.read(baseExerciseListProvider)}");
    print("baseExerciseListProvider--->${ref.read(exerciseListProvider)}");

    // dynamic temp = await WorkoutApiService.editWorkoutData(
    //   accountId: int.parse(setup.id),
    //   name: workoutNameController.text,
    //   difficulty: _selectedItemPart,
    //   description: descriptionNameController.text,
    //   image: ref.read(imageProvider),
    // );

    // List<int> exerciseList = ref.read(exerciseListProvider);
    // for (int exercise in exerciseList) {
    //   WorkoutApiService.addExerciseToWorkout(
    //       exerciseID: exercise, workoutID: temp.id);
    // }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PickExercise(
    //       workoutID: int.parse(widget.id),
    //     ),
    //   ),
    // );
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
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: tertiaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              children: [
                Row(
                  children: [],
                ),
              ],
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InputField(
                    inputName: " Workout Name:",
                    textController: workoutNameController),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: dropDown(_intensity, _selectedItemPart,
                          (String? newValue) {
                        setState(() {
                          _selectedItemPart = newValue!;
                        });
                      }),
                    ),
                  ],
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
          ),
          const Positioned(
            top: 55,
            left: 20,
            child: Text(
              "Create Workout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Header(),
          Positioned(
            left: 20,
            right: 20,
            bottom: 15,
            child: ElevatedButton(
              onPressed: () {
                createExercise();
                widget.isEdit == false ? createWorkout() : editWorkout();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(300, 5),
                foregroundColor: Colors.white,
                backgroundColor: tertiaryColor,
              ),
              child: const Text('Create Workout'),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 80,
            child: ElevatedButton(
              onPressed: () async {
                createExercise();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(300, 5),
                foregroundColor: Colors.white,
                backgroundColor: tertiaryColor,
              ),
              child: const Text('Add Exercises'),
            ),
          ),
          Positioned(
            top: 450,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VideoThumbnailScreen(
                    isEdit: widget.isEdit,
                    imageUrl: widget.imageUrl,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FutureBuilder<List<Exercise>>(
//           future: _exercisesFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.hasData) {
//               List<Exercise> exercises = snapshot.data!;
//               return

//             } else {
//               return Center(child: Text('No data available'));
//             }
//           },
//         ),


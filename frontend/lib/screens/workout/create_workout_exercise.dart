import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/screens/workout/workout_data_management.dart';
import 'package:frontend/screens/workout/create_workout_details.dart';
import 'package:frontend/screens/dataCollection/p1_base_collection.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/screens/exercise/exercise_card.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/name_indicator.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PickExercise extends ConsumerStatefulWidget {
  final bool isEdit;
  PickExercise({
    this.isEdit = false,
    super.key,
  });

  @override
  ConsumerState<PickExercise> createState() => _PickExerciseState();
}

class _PickExerciseState extends ConsumerState<PickExercise> {
  List<String> _bodyPart = ['All', 'Two', 'Three', 'Four'];
  List<String> intensity = ['All', 'Custom', 'Premade', 'Four'];
  List<String> _favorite = ['All', 'Favorite', 'Non-Favorite'];

  late String _selectedItemPart = _bodyPart[0];
  late String selectedIntensity = intensity[0];
  late String _selectedItemFavorite = _favorite[0];

  late List<int> pickedExercise;

  // late Future<List<Exercise>> _exercisesFuture;
  List<Exercise> _exercisesFuture = [];

  late Future<List<Exercise>> _currentExercisesFuture;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // _exercisesFuture = ExerciseApiService.fetchExercises();
  }

  void initExerciseList() {
    setState(() {
      pickedExercise = ref.read(exerciseListProvider);
    });
  }

  void createExercise() {
    int count = 0;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => CreateWorkout(
          isEdit: widget.isEdit,
        ),
      ),
      (Route<dynamic> route) {
        return count++ >= 2;
      },
    );
  }

  void addRemoveExercise(int exerciseID) {
    setState(() {
      pickedExercise.contains(exerciseID)
          ? pickedExercise.remove(exerciseID)
          : pickedExercise.add(exerciseID);
    });
  }

  Widget dropDown(List<String> inputList, String selectedItem,
      void Function(String?) onChanged) {
    return DropdownButton<String>(
      value: selectedItem,
      hint: Text(
        inputList[0],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
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
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    _exercisesFuture = ref.watch(exerciseFetchProvider);

    initExerciseList();
    return Scaffold(
      backgroundColor: mainColor,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.27,
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
            top: 85,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "  Exercise Name:",
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
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "  Parts:",
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
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: dropDown(_bodyPart, _selectedItemPart,
                              (String? newValue) {
                            setState(() {
                              _selectedItemPart = newValue!;
                            });
                          }),
                        ),
                      ],
                    ),
                    const Spacer(),
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
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: dropDown(intensity, selectedIntensity,
                              (String? newValue) {
                            setState(() {
                              selectedIntensity = newValue!;
                            });
                          }),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "  Tag:",
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
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: dropDown(_favorite, _selectedItemFavorite,
                              (String? newValue) {
                            setState(() {
                              _selectedItemFavorite = newValue!;
                            });
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            top: 55,
            left: 20,
            child: Text(
              "Exercises",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Header(),

          Positioned(
            top: 190,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: NameIndicator(
                controller: _pageController,
                names: ["All Exercises", "Current Exercises"],
              ),
            ),
          ),

          Positioned(
            top: 240,
            right: 5,
            left: 5,
            child: Container(
              height: 500,
              child: PageView(
                      controller: _pageController,
                      children: <Widget>[
                        Container(
                          height: 500,
                          child: SingleChildScrollView(
                            child: Column(
                              children: _exercisesFuture.map(
                                (exercise) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Stack(
                                      children: [
                                        ExerciseCard(
                                          exercise: exercise,
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              addRemoveExercise(exercise.id);
                                            },
                                            child: Icon(
                                              pickedExercise
                                                      .contains(exercise.id)
                                                  ? Icons.add_circle
                                                  : Icons
                                                      .add_circle_outline_sharp,
                                              color: secondaryColor,
                                              size: 30,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                        Container(
                          height: 500,
                          child: SingleChildScrollView(
                            child: Column(
                              children: _exercisesFuture.map(
                                (exercise) {
                                  return pickedExercise.contains(exercise.id)
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Stack(
                                            children: [
                                              ExerciseCard(
                                                exercise: exercise,
                                              ),
                                              Positioned(
                                                bottom: 5,
                                                right: 5,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    addRemoveExercise(
                                                        exercise.id);
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .highlight_remove_sharp,
                                                    color: secondaryColor,
                                                    size: 30,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : SizedBox();
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 15,
            child: ElevatedButton(
              onPressed: createExercise,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(300, 5),
                foregroundColor: Colors.white,
                backgroundColor: tertiaryColor,
              ),
              child: const Text('Done'),
            ),
          )
        ],
      ),
    );
  }
}

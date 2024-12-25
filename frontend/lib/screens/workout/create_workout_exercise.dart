import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/exercisePlan.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/provider/workout_data_management.dart';
import 'package:frontend/screens/workout/create_workout_details.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/exercise/exercise_card.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/name_indicator.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/widgets/spaceLine.dart';

class FilterCategory {
  final String title;
  final Map<String, bool> filters;

  FilterCategory({
    required this.title,
    required this.filters,
  });
}

class PickExercise extends ConsumerStatefulWidget {
  final void Function(ExercisePlan, bool, int) onChangeExericiseList;
  final List<ExercisePlan> pickedExercise;

  PickExercise({
    super.key,
    required this.onChangeExericiseList,
    required this.pickedExercise,
  });

  @override
  ConsumerState<PickExercise> createState() => _PickExerciseState();
}

class _PickExerciseState extends ConsumerState<PickExercise> {
  int upperState = 0;
  int filterState = 0;
  int positionCtr = 0;

  List<Exercise> _exercisesFuture = [];

  final PageController _pageController = PageController();

  final List<FilterCategory> filterCategories = [
    FilterCategory(
      title: 'Parts',
      filters: {
        "Neck": false,
        "Traps": false,
        "Shoulder": false,
        "Chest": false,
        "Biceps": false,
        "Forearms": false,
        "Abs": false,
        "Quadriceps": false,
        "Calves": false,
        "Upper Back": false,
        "Triceps": false,
        "Lower Back": false,
        "Glutes": false,
        "Hamstrings": false,
        "Others": false,
      },
    ),
    FilterCategory(
      title: 'Intensity',
      filters: {
        "Easy": false,
        "Normal": false,
        "Hard": false,
        "Advance": false,
      },
    ),
    FilterCategory(
      title: 'Order',
      filters: {
        "A->Z": false,
        "Z->A": false,
        "Newest": false,
        "Oldest": false,
      },
    ),
    FilterCategory(
      title: 'Others',
      filters: {
        "Favorite": false,
        "Non-Favorite": false,
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void createExercise() {
    int count = 0;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => CreateWorkout(),
      ),
      (Route<dynamic> route) {
        return count++ >= 2;
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

  void onChangePick() {
    positionCtr = 0;
    setState(() {});
  }

  void updateSetsRepsRest(
    int newSets,
    int newReps,
    int newRest,
    int position,
  ) {
    print("UPDATING [$position] SETS REPS");
    widget.pickedExercise.elementAt(position).reps = newReps;
    widget.pickedExercise.elementAt(position).sets = newSets;
    widget.pickedExercise.elementAt(position).restDuration = newRest;

    positionCtr = 0;
    setState(() {});
  }

  void updateExercisePosition() {}

  Widget filter() {
    return Container(
      decoration: BoxDecoration(
        color: miscColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      width: MediaQuery.of(context).size.width * .95,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: filterCategories.length,
          itemBuilder: (context, index) {
            final category = filterCategories[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 2.0,
                    runSpacing: 1.0,
                    children: category.filters.keys.map(
                      (key) {
                        return FilterChip(
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: tertiaryColor!,
                              width: 1.0,
                            ),
                          ),
                          backgroundColor: category.filters[key]!
                              ? tertiaryColor
                              : mainColor,
                          selectedColor: tertiaryColor,
                          label: Text(
                            key,
                            style: TextStyle(
                              color: category.filters[key]!
                                  ? Colors.white
                                  : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          selected: category.filters[key]!,
                          onSelected: (bool selected) {
                            setState(() {
                              category.filters[key] = selected;
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget upperSearchBase() {
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      decoration: BoxDecoration(
        color: tertiaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Exercises",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  // GestureDetector(
                  //   onTap: () {
                  //     createExercise();
                  //   },
                  //   child: Icon(
                  //     Icons.add_box_outlined,
                  //     color: Colors.white,
                  //     size: 25.0,
                  //   ),
                  // ),
                  SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          upperState = 1;
                        },
                      );
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 25.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget upperSearchExpanded() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .95,
          decoration: BoxDecoration(
            color: tertiaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(filterState == 1 ? 0 : 10),
              bottomRight: Radius.circular(filterState == 1 ? 0 : 10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Exercises",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      // GestureDetector(
                      //   onTap: () {
                      //     createExercise();
                      //   },
                      //   child: Icon(
                      //     Icons.add_box_outlined,
                      //     color: Colors.white,
                      //     size: 25.0,
                      //   ),
                      // ),
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                upperState = 0;
                              },
                            );
                          },
                          child: Icon(
                            upperState == 1
                                ? Icons.manage_search
                                : Icons.search,
                            color:
                                upperState == 1 ? Colors.amber : Colors.white,
                            size: 25.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  const Text(
                    "  Exercise Name:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
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
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: const TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        child: Icon(
                          filterState == 1
                              ? Icons.filter_alt
                              : Icons.filter_alt_outlined,
                          color: filterState == 1 ? Colors.amber : Colors.white,
                        ),
                        onTap: () {
                          print("filterState---> $filterState");
                          setState(() {
                            filterState = filterState == 1 ? 0 : 1;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        filterState == 1 ? filter() : SizedBox()
      ],
    );
  }

  Widget upperStateAdjust() {
    return upperState == 0 ? upperSearchBase() : upperSearchExpanded();
  }

  @override
  Widget build(BuildContext context) {
    _exercisesFuture = ref.watch(exerciseFetchProvider);

    return Scaffold(
      backgroundColor: mainColor,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Column(
            children: [
              const Header(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              upperStateAdjust(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: NameIndicator(
                  controller: _pageController,
                  names: ["All Exercises", "Current Exercises"],
                ),
              ),
              Expanded(
                child: Container(
                  child: PageView(
                    controller: _pageController,
                    children: <Widget>[
                      Container(
                        height: 500,
                        child: SingleChildScrollView(
                          child: Column(
                            children: _exercisesFuture.map(
                              (exercise) {
                                return ExerciseCard(
                                  pickedExercise: widget.pickedExercise,
                                  onChangeExericiseList:
                                      widget.onChangeExericiseList,
                                  exercise: exercise,
                                  isPickExerciseMode: true,
                                  isPicked: widget.pickedExercise.any(
                                      (ExercisePlan) =>
                                          ExercisePlan.exercise == exercise),
                                  onChangePick: onChangePick,
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
                            children: widget.pickedExercise.map(
                              (exercise) {
                                print("position-->$positionCtr");
                                positionCtr++;
                                return ExerciseCard(
                                  onChangeExericiseList:
                                      widget.onChangeExericiseList,
                                  isSetsRepsMode: true,
                                  exercise: exercise.exercise,
                                  sets: exercise.sets,
                                  reps: exercise.reps,
                                  restDuration: exercise.restDuration,
                                  position: positionCtr - 1,
                                  onChangeSetsRepsRest: updateSetsRepsRest,
                                  onChangePick: onChangePick,
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              spaceLine(context),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: tertiaryColor,
                        ),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

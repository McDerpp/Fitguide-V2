import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/workout/create_workout_details.dart';
import 'package:frontend/screens/workout/workout_data_management.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/screens/exercise/exercise_card.dart';
import 'package:frontend/widgets/header.dart';

class workoutPage extends ConsumerStatefulWidget {
  final int id;
  final String name;
  final String description;
  final int account;
  final String imageUrl;
  final String difficulty;

  const workoutPage({
    super.key,
    required this.id,
    required this.name,
    required this.difficulty,
    required this.description,
    required this.account,
    required this.imageUrl,
  });

  @override
  ConsumerState<workoutPage> createState() => _workoutPageState();
}

class _workoutPageState extends ConsumerState<workoutPage> {
  bool isFavorite = false;

  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = WorkoutApiService.fetchExerciseWorkouts(widget.id);
  }

  void editReset() {
    ref.read(exerciseListProvider.notifier).state = [];
  }

  void beginEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateWorkout(
              isEdit: true,
              id: widget.id.toString(),
              name: widget.name,
              difficulty: widget.difficulty,
              description: widget.description,
              imageUrl: widget.imageUrl)),
    );

    ref.read(name.notifier).state = "";
    ref.read(difficulty.notifier).state = "";
    ref.read(intensity.notifier).state = "";
    ref.read(description.notifier).state = "";
    ref.read(thumbnailProvider.notifier).state = null;
    ref.read(imageProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 3,
                foregroundDecoration: const BoxDecoration(),
                child: Container(
                  color: mainColor,
                ),
              ),
            ),
            FutureBuilder<List<Exercise>>(
              future: _exercisesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Exercise> exercises = snapshot.data!;
                  return Positioned(
                    top: 270,
                    right: 5,
                    left: 5,
                    child: Container(
                      height: 500,
                      child: SingleChildScrollView(
                        child: Column(
                          children: exercises.map(
                            (exercise) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.90,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ExerciseCard(
                                  id: exercise.id.toString(),
                                  nameExercise: exercise.name,
                                  repitions: exercise.numSet,
                                  sets: exercise.numSet,
                                  parts: exercise.parts,
                                  author: "NOBODY",
                                  image: exercise.imageUrl,
                                  video: exercise.videoUrl,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 80,
                  left: 15,
                  right: 5,
                  bottom: 15,
                ),
                // child: Scrollbar(
                //   trackVisibility: true,
                //   thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        // widget.nameExercise,
                                        "Name of Exercise",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      Text(
                                        // widget.nameExercise,
                                        widget.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  widget.account.toString() == setup.id
                                      ? Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                            onTap: () {
                                              beginEdit();
                                              editReset();
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: GestureDetector(
                                      child: Icon(
                                        isFavorite == false
                                            ? Icons.favorite_border
                                            : Icons.favorite,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                      onTap: () {
                                        setState(
                                          () {
                                            isFavorite = !isFavorite;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          // widget.nameExercise,
                                          "Difficulty",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        Text(
                                          // widget.nameExercise,
                                          widget.difficulty,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          // widget.nameExercise,
                                          "Duration",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        // Text(
                                        //   // widget.nameExercise,
                                        //   duration + " Mins",
                                        //   style: const TextStyle(
                                        //     color: Colors.white,
                                        //     fontSize: 17,
                                        //     fontWeight: FontWeight.w400,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    // widget.nameExercise,
                                    "Duration",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      widget.description,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 100,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // More widgets
                    ],
                  ),
                ),
                // ),
              ),
            ),
            const Header(),
            Positioned(
              top: 270,
              child: Container(
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // More widgets
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/provider/global_variable_provider.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/provider/workout.dart';
import 'package:frontend/screens/inferencing/inferencing_seamless.dart';
import 'package:frontend/screens/workout/create_workout_details.dart';
import 'package:frontend/screens/workout/workout_data_management.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/screens/exercise/exercise_card.dart';
import 'package:frontend/widgets/header.dart';

class workoutPage extends ConsumerStatefulWidget {
  final int id;

  const workoutPage({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<workoutPage> createState() => _workoutPageState();
}

class _workoutPageState extends ConsumerState<workoutPage> {
  bool isFavorite = false;
  List<Exercise> exerciseList = [];
  List<int> pickedExercise = [];
  late Workout workoutHere;

  late Future<List<Exercise>> _exercisesFuture;

  Future<void> initializeExerciseList() async {
    ref.read(initExerciseEdit.notifier).state = true;
    List<Exercise> workout =
        await WorkoutApiService.fetchExerciseWorkouts(widget.id);
    for (Exercise exercise in workout) {
      pickedExercise.add(exercise.id);
    }
    ref.read(baseExerciseListProvider.notifier).state =
        List.from(pickedExercise);
    ref.read(exerciseListProvider.notifier).state = List.from(pickedExercise);
  }

  Future<void> initEditInformation() async {
    ref.read(name.notifier).state = workoutHere.name;
    ref.read(description.notifier).state = workoutHere.description;
    ref.read(difficulty.notifier).state = workoutHere.difficulty;
    ref.read(intensity.notifier).state = workoutHere.difficulty;
    ref.read(accountID.notifier).state = workoutHere.account.toString();

    ref.read(workoutID.notifier).state = workoutHere.id.toString();
    ref.read(imageUrl.notifier).state = workoutHere.imageUrl;
    ref.read(id.notifier).state = workoutHere.id.toString();
  }

  Future<void> beginEdit() async {
    ref.read(name.notifier).state = "";
    ref.read(difficulty.notifier).state = "";
    ref.read(intensity.notifier).state = "";
    ref.read(description.notifier).state = "";
    ref.read(thumbnailProvider.notifier).state = null;
    ref.read(imageProvider.notifier).state = null;
    ref.read(baseExerciseListProvider.notifier).state = [];
    ref.read(exerciseListProvider.notifier).state = [];
    ref.read(accountID.notifier).state = "";

    await initializeExerciseList();
    await initEditInformation();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CreateWorkout(
                isEdit: true,
              )),
    );
  }

  @override
  void initState() {
    super.initState();
    _exercisesFuture = WorkoutApiService.fetchExerciseWorkouts(widget.id);
    _loadData();
  }

  Future<void> _loadData() async {
    _exercisesFuture = WorkoutApiService.fetchExerciseWorkouts(widget.id);
    final workoutNotifier = ref.read(workoutsFetchProvider.notifier);
    final workout = workoutNotifier.getWorkoutById(widget.id);

    if (workout != null) {
      setState(() {
        workoutHere = workout;
      });
    } else {
      print('Workout not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(showPreviewProvider.notifier).state = true;

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
                  return const Center(child: CircularProgressIndicator());
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
                              exerciseList.add(exercise);
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.90,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: ExerciseCard(
                                  exercise: exercise,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
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
                          padding: const EdgeInsets.only(right: 10),
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
                                        workoutHere.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  workoutHere.account.toString() == setup.id
                                      ? Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: GestureDetector(
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                            onTap: () {
                                              beginEdit();
                                            },
                                          ),
                                        )
                                      : const SizedBox(),
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
                                          // workoutHere.nameExercise,
                                          "Difficulty",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        Text(
                                          // workoutHere.nameExercise,
                                          workoutHere.difficulty,
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
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          // workoutHere.nameExercise,
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
                                      workoutHere.description,
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
                child: const SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // More widgets
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 15,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InferencingSeamless(exerciseList),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 5),
                  foregroundColor: Colors.white,
                  backgroundColor: tertiaryColor,
                ),
                child: const Text('Peform the workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/screens/home/lower_home.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/screens/home/upper_home.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<List<Workout>> _workoutsFuture;
  late Future<List<Exercise>> _exerciseFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initWorkout();
  }

  Future<void> initWorkout() async {
    _workoutsFuture = WorkoutApiService.fetchWorkouts(ref);
    final workout = await _workoutsFuture;
    print("workout--->$workout");
    ref.read(workoutsFetchProvider.notifier).setWorkouts(workout);

    _exerciseFuture = ExerciseApiService.fetchExercises();
    final exercises = await _exerciseFuture;
    print("exercises--->$exercises");

    ref.read(exerciseFetchProvider.notifier).setExercise(exercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerContent(),
      backgroundColor: mainColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UpperHome(),
                  ],
                ),
                LowerHome(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Header(),
          ),
        ],
      ),
    );
  }
}

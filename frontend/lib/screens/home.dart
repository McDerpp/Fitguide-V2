import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/lower_home.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/widgets/upper_home.dart';

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

  @override
  Future<void> initWorkout() async {
    _workoutsFuture = WorkoutApiService.fetchWorkouts();
    final workout = await _workoutsFuture;
    ref.read(workoutsFetchProvider.notifier).setWorkouts(workout);

    _exerciseFuture = ExerciseApiService.fetchExercises();
    final exercises = await _exerciseFuture;
    ref.read(exerciseFetchProvider.notifier).setExercise(exercises);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerContent(),
      backgroundColor: mainColor,
      body: const Stack(
        children: [
          Positioned(
            top: 235,
            right: 2,
            left: 2,
            child: LowerHome(),
          ),
          UpperHome(),
          Positioned(
            child: Header(),
          )
        ],
      ),
    );
  }
}

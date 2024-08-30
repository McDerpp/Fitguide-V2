import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/account.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/provider/account.dart';
import 'package:frontend/provider/exercise.dart';
import 'package:frontend/provider/workout.dart';

final workoutsFetchProvider =
    StateNotifierProvider<WorkoutsNotifier, List<Workout>>((ref) {
  return WorkoutsNotifier();
});

final exerciseFetchProvider =
    StateNotifierProvider<ExerciseNotifier, List<Exercise>>((ref) {
  return ExerciseNotifier();
});

final accountFetchProvider =
    StateNotifierProvider<AccountNotifier, Account>((ref) {
  return AccountNotifier();
});

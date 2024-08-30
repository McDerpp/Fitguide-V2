import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/workout.dart';
import 'workout.dart'; 

class WorkoutsNotifier extends StateNotifier<List<Workout>> {
  WorkoutsNotifier() : super([]);

  void setWorkouts(List<Workout> workouts) {
    state = workouts;
  }

  void addWorkout(Workout workout) {
    state = [...state, workout];
  }

  void updateWorkout(Workout updatedWorkout) {
    state = [
      for (final workout in state)
        if (workout.id == updatedWorkout.id) updatedWorkout else workout,
    ];
  }

  void removeWorkout(int workoutId) {
    state = state.where((workout) => workout.id != workoutId).toList();
  }

  void favoriteWorkout(int workoutId) {
    Workout tempWorkout = getWorkoutById(workoutId)!;
    Workout updatedWorkout = Workout(
        id: tempWorkout.id,
        name: tempWorkout.name,
        description: tempWorkout.description,
        account: tempWorkout.account,
        madeBy: tempWorkout.madeBy,
        imageUrl: tempWorkout.imageUrl,
        difficulty: tempWorkout.difficulty,
        isFavorite: !tempWorkout.isFavorite,
        exercise: tempWorkout.exercise);

    updateWorkout(updatedWorkout);
  }

  Workout? getWorkoutById(int workoutId) {
    return state.firstWhere(
      (workout) => workout.id == workoutId,
    );
  }
}

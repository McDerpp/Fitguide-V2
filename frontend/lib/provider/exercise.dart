import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/exercise.dart';

class ExerciseNotifier extends StateNotifier<List<Exercise>> {
  ExerciseNotifier() : super([]);

  void setExercise(List<Exercise> exercise) {
    state = exercise;
  }

  void addExercise(Exercise exercise) {
    state = [...state, exercise];
  }

  void updateExercise(Exercise updatedExercise) {
    state = [
      for (final exercise in state)
        if (exercise.id == updatedExercise.id) updatedExercise else exercise,
    ];
  }

  void removeExercise(int exerciseId) {
    state = state.where((exercise) => exercise.id != exerciseId).toList();
  }

  Exercise? getExerciseById(int exerciseId) {
    return state.firstWhere(
      (exercise) => exercise.id == exerciseId,
    );
  }

  void favoriteExercise(int exerciseId) {
    Exercise tempExercise = getIndividualExercisesByIds(exerciseId);
    Exercise updatedExercise = Exercise(
      id: tempExercise.id,
      name: tempExercise.name,
      description: tempExercise.description,
      intensity: tempExercise.intensity,
      estimatedTime: tempExercise.estimatedTime,
      imageUrl: tempExercise.imageUrl,
      videoUrl: tempExercise.videoUrl,
      ignoreCoordinates: tempExercise.ignoreCoordinates,
      numExecution: tempExercise.numExecution,
      numSet: tempExercise.numSet,
      uploadedAt: tempExercise.uploadedAt,
      isActive: tempExercise.isActive,
      isCustom: tempExercise.isCustom,
      parts: tempExercise.parts,
      account: tempExercise.account,
      datasets: tempExercise.datasets,
      model: tempExercise.model,
      madeBy: tempExercise.madeBy,
      isFavorite:!tempExercise.isFavorite,
      met:tempExercise.met.toString()
    );
    updateExercise(updatedExercise);
  }

  List<Exercise> getExercisesByIds(List<int> workoutID) {
    return state.where((exercise) => workoutID.contains(exercise.id)).toList();
  }

  Exercise getIndividualExercisesByIds(int exerciseID) {
    return state.firstWhere(
      (exercise) => exercise.id == exerciseID,
    );
  }
}

import 'package:frontend/models/exercise.dart';
import 'package:frontend/services/mainAPI.dart';

class ExercisePlan {
  final Exercise exercise;
  int sets;
  int reps;
  int restDuration;

  ExercisePlan({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.restDuration,

  });

  factory ExercisePlan.fromJson(Map<String, dynamic> json) {
    return ExercisePlan(
      exercise: json['exercise'],
      sets: json['sets'],
      reps: json['reps'],
      restDuration: json['restDuration'],

    );
  }
}

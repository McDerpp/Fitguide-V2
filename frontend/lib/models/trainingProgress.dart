import 'dart:convert';

import 'package:frontend/models/exercise.dart';
import 'package:frontend/services/mainAPI.dart';

class TrainingProgress {
  final int id;
  final String taskId;
  final String status;
  final Exercise exercise;

  TrainingProgress({
    required this.id,
    required this.taskId,
    required this.status,
    required this.exercise,
  });

  factory TrainingProgress.fromJson(Map<String, dynamic> json) {
    print("TESTING! -> ${json}");
    return TrainingProgress(
        id: json['id'],
        taskId: json['taskId'],
        status: json['status'],
        exercise: Exercise.fromJson(json['exercise']));
  }
}
 
import 'package:frontend/models/workout.dart';

DateTime parseDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) {
    return DateTime.now(); 
  }
  return DateTime.parse(dateStr);
}

class WorkoutDone {
  final int id;
  final Workout workout;
  final DateTime performeAt;

  WorkoutDone({
    required this.id,
    required this.workout,
    required this.performeAt,
    is_favorited,
  });

  factory WorkoutDone.fromJson(Map<String, dynamic> json) {
    return WorkoutDone(
      id: json['id'],
      workout: Workout.fromJson(json['workout'] as Map<String, dynamic>),
      performeAt: parseDate(json['performed_at'] as String?),
    );
  }
}

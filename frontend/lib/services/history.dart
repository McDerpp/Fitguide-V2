import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/provider.dart';
import 'package:http/http.dart' as http;

class HistoryApiService {
  static const String baseUrl = 'http://192.168.1.8:8000/api/history/';

  static Future<void> addWorkoutFavorite({
    required WidgetRef ref,
    required int accountID,
    required int workoutID,
  }) async {
    final uri =
        Uri.parse('${baseUrl}addFavoriteWorkout/$workoutID/$accountID/');

    final response = await http.post(
      uri,
    );

    if (response.statusCode == 201) {
      ref.read(workoutsFetchProvider.notifier).favoriteWorkout(workoutID);
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  static Future<void> deleteWorkoutFavorite({
    required int accountID,
    required int workoutID,
    required WidgetRef ref,
  }) async {
    final uri =
        Uri.parse('${baseUrl}addFavoriteWorkout/$workoutID/$accountID/');

    final response = await http.delete(
      uri,
    );

    if (response.statusCode == 204) {
      ref.read(workoutsFetchProvider.notifier).favoriteWorkout(workoutID);
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  static Future<void> addExerciseFavorite({
    required WidgetRef ref,
    required int accountID,
    required int exerciseID,
  }) async {
    final uri =
        Uri.parse('${baseUrl}addFavoriteExercise/$exerciseID/$accountID/');

    final response = await http.post(
      uri,
    );

    if (response.statusCode == 201) {
      ref.read(exerciseFetchProvider.notifier).favoriteExercise(exerciseID);
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  static Future<void> deleteExerciseFavorite({
    required int accountID,
    required int exerciseID,
    required WidgetRef ref,
  }) async {
    final uri =
        Uri.parse('${baseUrl}addFavoriteExercise/$exerciseID/$accountID/');

    final response = await http.delete(
      uri,
    );

    if (response.statusCode == 204) {
      ref.read(exerciseFetchProvider.notifier).favoriteExercise(exerciseID);
    } else {
      throw Exception('Failed to load exercise');
    }
  }
}

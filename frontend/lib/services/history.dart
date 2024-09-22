import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/workoutsDone.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/services/mainAPI.dart';
import 'package:http/http.dart' as http;

class HistoryApiService {
  static String baseUrl = '${api.baseUrl}/api/history/';

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

  static Future<void> addWorkoutsDone({
    required int accountID,
    required int workoutsID,
    required WidgetRef ref,
  }) async {
    final uri = Uri.parse('${baseUrl}addWorkoutsDone/$workoutsID/$accountID/');

    final response = await http.post(
      uri,
    );

    if (response.statusCode == 204) {
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  static Future<List<WorkoutDone>> getWorkoutsDone({
    required int year,
    required int month,
    required int day,
  }) async {
    final uri =
        Uri.parse('${baseUrl}getWorkoutsDone/${setup.id}/$year/$month/$day/');

    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => WorkoutDone.fromJson(json)).toList();
    } else {
      return throw Exception('workout done');
    }
  }

  static Future<List<dynamic>> getWorkoutsDoneNumberMonthly({
    required int year,
    required int month,
  }) async {
    final uri = Uri.parse(
        '${baseUrl}getWorkoutsDoneNumberMonthly/${setup.id}/$year/$month/');
    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      print("getWorkoutsDoneNumberMonthly---?$getWorkoutsDoneNumberMonthly");
      return jsonList;
    } else {
      return throw Exception('workout done');
    }
  }
}

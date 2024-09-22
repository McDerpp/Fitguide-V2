import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/services/mainAPI.dart';
import 'package:http/http.dart' as http;

class WorkoutApiService {
  static String baseUrl = '${api.baseUrl}/api/workouts/';

  static Future<List<Workout>> fetchWorkouts(WidgetRef ref) async {
    final response = await http.get(Uri.parse(
        '${baseUrl}getAllWorkout/${ref.read(accountFetchProvider).id}'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Workout.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Workouts');
    }
  }

  static Future<List<Exercise>> fetchExerciseWorkouts(int workoutID) async {
    final response = await http
        .post(Uri.parse('${baseUrl}getExercisesInWorkout/$workoutID'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Workouts');
    }
  }

  static Future<Workout> sendWorkoutData({
    required int accountId,
    required String name,
    required String difficulty,
    required String description,
    required String type,
    required WidgetRef ref,
    File? image,
  }) async {
    final uri = Uri.parse('${baseUrl}addWorkout/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['account'] = accountId.toString()
      ..fields['name'] = name
      ..fields['type'] = type
      ..fields['difficulty'] = difficulty
      ..fields['description'] = description;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(responseData);
      ref
          .read(workoutsFetchProvider.notifier)
          .addWorkout(Workout.fromJson(jsonResponse));

      return Workout.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create Workout');
    }
  }

  static Future<Workout> editWorkoutData({
    required WidgetRef ref,
    required int accountId,
    required int workoutId,
    required String name,
    required String difficulty,
    required String description,
    required String type,
    File? image,
  }) async {
    final uri = Uri.parse('${baseUrl}editWorkout/$workoutId/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['account'] = accountId.toString()
      ..fields['name'] = name
      ..fields['difficulty'] = difficulty
      ..fields['type'] = type
      ..fields['description'] = description;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseData);

      ref
          .read(workoutsFetchProvider.notifier)
          .updateWorkout(Workout.fromJson(jsonResponse));

      return Workout.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create Workout');
    }
  }

//   static Future<void> addExerciseToWorkout({
//     required int exerciseID,
//     required int workoutID,
//   }) async {
//     final uri = Uri.parse('${baseUrl}addWorkoutExercise/');

//     final response = await http.post(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'exercise': exerciseID,
//         'workout': workoutID,
//       }),
//     );

//     final responseData = response.body;

//     if (response.statusCode == 201) {
//       // Handle successful response
//     } else {
//       throw Exception('Failed to load exercise');
//     }
//   }
// }

  static Future<void> addExerciseToWorkout({
    required int exerciseID,
    required int workoutID,
  }) async {
    final uri =
        Uri.parse('${baseUrl}addWorkoutExercise/${workoutID}/${exerciseID}/');

    final response = await http.post(
      uri,
    );

    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  static Future<void> deleteExerciseToWorkout({
    required int exerciseID,
    required int workoutID,
  }) async {
    final uri = Uri.parse(
        '${baseUrl}deleteWorkoutExercise/${workoutID}/${exerciseID}/');

    final response = await http.delete(
      uri,
    );

    if (response.statusCode == 204) {
      // Handle successful response
    } else {
      throw Exception('Failed to load exercise');
    }
  }

  static Future<void> deleteWorkout({
    required WidgetRef ref,
    required int workoutID,
  }) async {
    ref.read(workoutsFetchProvider.notifier).removeWorkout(workoutID);

    final uri = Uri.parse('${baseUrl}deleteWorkout/${workoutID}/');

    final response = await http.delete(
      uri,
    );

    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to load exercise');
    }
  }
}

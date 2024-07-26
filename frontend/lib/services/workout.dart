import 'dart:convert';
import 'dart:io';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/workout.dart';
import 'package:http/http.dart' as http;

class WorkoutApiService {
  static const String baseUrl = 'http://192.168.1.2:8000/api/workout/';

  static Future<List<Workout>> fetchWorkouts() async {
    final response = await http.get(Uri.parse('${baseUrl}getWorkoutCard'));

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
    File? image,
  }) async {
    final uri = Uri.parse('${baseUrl}addWorkout/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['account'] = accountId.toString()
      ..fields['name'] = name
      ..fields['difficulty'] = difficulty
      ..fields['description'] = description;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(responseData);
      return Workout.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create Workout');
    }
  }


    static Future<Workout> editWorkoutData({
    required int accountId,
    required String name,
    required String difficulty,
    required String description,
    File? image,
  }) async {
    final uri = Uri.parse('${baseUrl}editWorkout/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['account'] = accountId.toString()
      ..fields['name'] = name
      ..fields['difficulty'] = difficulty
      ..fields['description'] = description;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(responseData);
      return Workout.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create Workout');
    }
  }


  static Future<void> addExerciseToWorkout({
    required int exerciseID,
    required int workoutID,
  }) async {
    final uri = Uri.parse('${baseUrl}addWorkoutExercise/');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'exercise': exerciseID,
        'workout': workoutID,
      }),
    );

    final responseData = response.body;

    if (response.statusCode == 201) {
      // Handle successful response
    } else {
      throw Exception('Failed to load exercise');
    }
  }
}

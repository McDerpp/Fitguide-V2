import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/services/mainAPI.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/exercise.dart';

class ExerciseApiService {
  static String baseUrl = '${api.baseUrl}/api/exercises/';

  static Future<dynamic> fetchExercises(
      int page, List<String> parts, String intensity, String name) async {
    try {
      final response = await http
          .post(Uri.parse('${baseUrl}getExerciseCard/${setup.id}/?page=$page'));

      Map<String, dynamic> body = {
        "filterType": "",
        "userId": "",
      };

      if (response.statusCode == 200) {
        List<dynamic> exercises =
            json.decode(response.body)["results"]["results"];
        int _maxPages = json.decode(response.body)["results"]["max_pages"];
        return {
          "exercises":
              exercises.map((json) => Exercise.fromJson(json)).toList(),
          "maxPages": _maxPages
        };
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      print("error at fetch exercise --> $e");
    }
  }

  static Future<Exercise> addExercise({
    required int accountId,
    required String name,
    required String intensity,
    required String description,
    required String sets,
    required String reps,
    // required String positiveNum,
    // required String negativeNum,
    required List<String> part,
    required String estimatedTime,
    required String MET,
    required WidgetRef ref,
    File? image,
    File? video,
    File? positiveDataset,
    File? negativeDataset,
  }) async {
    final uri = Uri.parse('${baseUrl}add/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['account'] = accountId.toString()
      ..fields['name'] = name
      ..fields['intensity'] = intensity
      ..fields['description'] = description
      // ..fields['positiveNum'] = positiveNum
      // ..fields['negativeNum'] = negativeNum
      ..fields['parts'] = jsonEncode(part)
      ..fields['numExecution'] = reps
      ..fields['numExecution'] = reps
      ..fields['numExecution'] = reps
      ..fields['numSet'] = sets
      ..fields['estimated_time'] = estimatedTime
      ..fields['MET'] = MET;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    if (video != null) {
      request.files.add(await http.MultipartFile.fromPath('video', video.path));
    }

    if (positiveDataset != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'positiveDataset', positiveDataset.path));
    }

    if (negativeDataset != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'negativeDataset', negativeDataset.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(responseData);
      // ref
      //     .read(exerciseFetchProvider.notifier)
      //     .addExercise(Exercise.fromJson(jsonResponse));
      print("jsonResponse-->$jsonResponse");
      String taskId = jsonResponse;
      monitorTaskProgress(taskId);

      return Exercise.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create Workout');
    }
  }

  static void monitorTaskProgress(String taskId) {
    final channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://192.168.1.16:8001/ws/task-status/$taskId/'), // Correct URL
    );

    channel.stream.listen((message) {
      final data = jsonDecode(message);
      final status = data['status'];
      final currentStep = data['current_step'] ?? 'Unknown step';
      print('Task Status: $status, Current Step: $currentStep');
    }, onError: (error) {
      print('Error: $error');
    });
  }

  static Future<Exercise> editExercise({
    required WidgetRef ref,
    required int exerciseID,
    required String name,
    required String intensity,
    required String description,
    required String sets,
    required String reps,
    required String positiveNum,
    required String negativeNum,
    required String parts,
    required String estimatedTime,
    required String MET,
    File? image,
    File? video,
    File? positiveDataset,
    File? negativeDataset,
  }) async {
    final uri = Uri.parse('${baseUrl}edit/$exerciseID/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['intensity'] = intensity
      ..fields['parts'] = parts
      ..fields['description'] = description
      ..fields['positiveNum'] = positiveNum
      ..fields['negativeNum'] = negativeNum
      ..fields['description'] = description
      ..fields['numExecution'] = reps
      ..fields['numSet'] = sets
      ..fields['estimated_time'] = estimatedTime
      ..fields['MET'] = MET;
    ;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    if (video != null) {
      request.files.add(await http.MultipartFile.fromPath('video', video.path));
    }

    if (positiveDataset != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'positiveDataset', positiveDataset.path));
    }

    if (negativeDataset != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'negativeDataset', negativeDataset.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(responseData);

      ref
          .read(exerciseFetchProvider.notifier)
          .updateExercise(Exercise.fromJson(jsonResponse));
      return Exercise.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create Workout');
    }
  }

  static Future<void> deleteExercise({
    required int exerciseID,
    required WidgetRef ref,
  }) async {
    final uri = Uri.parse('${baseUrl}deleteExercise/$exerciseID/');

    final response = await http.delete(
      uri,
    );

    if (response.statusCode == 204) {
      ref.read(exerciseFetchProvider.notifier).removeExercise(exerciseID);
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

  static Future<void> activateExercise(String exerciseId) async {
    final uri = Uri.parse('${baseUrl}activate_exercise/$exerciseId/');

    final response = await http.put(
      uri,
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load exercise');
    }
  }
}

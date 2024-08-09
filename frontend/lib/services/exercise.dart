import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/provider/provider.dart';

import '../models/exercise.dart';

class ExerciseApiService {
  static const String baseUrl = 'http://192.168.1.8:8000/api/exercises/';

  static Future<List<Exercise>> fetchExercises() async {
    final response =
        await http.get(Uri.parse('${baseUrl}getExerciseCard/${setup.id}'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  static Future<Exercise> addExercise({
    required int accountId,
    required String name,
    required String intensity,
    required String description,
    required String sets,
    required String reps,
    required String positiveNum,
    required String negativeNum,
    required String part,
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
      ..fields['positiveNum'] = positiveNum
      ..fields['negativeNum'] = negativeNum
      ..fields['description'] = description
      ..fields['parts'] = part
      ..fields['numExecution'] = reps
      ..fields['numSet'] = sets;

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
          .addExercise(Exercise.fromJson(jsonResponse));

      return Exercise.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create Workout');
    }
  }

  static Future<Exercise> editExercise({
    required int exerciseID,
    required String name,
    required String intensity,
    required String description,
    required String sets,
    required String reps,
    required String positiveNum,
    required String negativeNum,
    File? image,
    File? video,
    File? positiveDataset,
    File? negativeDataset,
  }) async {
    final uri = Uri.parse('${baseUrl}edit/$exerciseID/');
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['intensity'] = intensity
      ..fields['description'] = description
      ..fields['positiveNum'] = positiveNum
      ..fields['negativeNum'] = negativeNum
      ..fields['description'] = description
      ..fields['numExecution'] = reps
      ..fields['numSet'] = sets;

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
}

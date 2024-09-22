import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/mainAPI.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/provider/provider.dart';

import '../models/exercise.dart';

class ExerciseApiService {
  static  String baseUrl = '${api.baseUrl}/api/exercises/';

  static Future<List<Exercise>> fetchExercises() async {
    final response =
        // await http.get(Uri.parse('${baseUrl}getExerciseCard/${setup.id}'));
        await http.get(Uri.parse('${baseUrl}getExercise/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      print("jsonList-->$jsonList");
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
      ..fields['positiveNum'] = positiveNum
      ..fields['negativeNum'] = negativeNum
      ..fields['parts'] = part
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
      ref
          .read(exerciseFetchProvider.notifier)
          .addExercise(Exercise.fromJson(jsonResponse));

      return Exercise.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create Workout');
    }
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
}

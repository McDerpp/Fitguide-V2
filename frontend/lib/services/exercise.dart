import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/exercise.dart';

class ExerciseApiService {
  static const String baseUrl = 'http://192.168.1.2:8000/api/exercises/';

  static Future<List<Exercise>> fetchExercises() async {
    print("GETTING IT!!!!!!!!!!!!");
    final response = await http.get(Uri.parse('${baseUrl}getExerciseCard'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      print(jsonList);
      return jsonList.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}

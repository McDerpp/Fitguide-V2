// import 'dart:convert';

// class Workout {
//   final int id;
//   final String name;
//   final String description;
//   final int account;
//   final String madeBy;
//   final String imageUrl;
//   final String difficulty;
//   final bool isFavorite;

//   Workout(
//       {required this.id,
//       required this.name,
//       required this.madeBy,
//       required this.description,
//       required this.account,
//       required this.imageUrl,
//       required this.difficulty,
//       required this.isFavorite,
//       is_favorited});

//   static const String baseUrl = "http://192.168.1.8:8000";

//   factory Workout.fromJson(Map<String, dynamic> json) {
//     print("json['isFavorite']--->${json['isFavorite']}");
//     return Workout(
//       id: json['id'],
//       difficulty: json['difficulty'],
//       name: json['name'],
//       description: json['description'],
//       account: json['account']['id'],
//       madeBy: json['account']['username'],
//       imageUrl: '$baseUrl${json['image']}',
//       isFavorite: json['is_favorited'] ?? false,
//     );
//   }
// }

import 'dart:convert';

import 'package:frontend/models/exercise.dart';

class Workout {
  final int id;
  final String name;
  final String description;
  final int account;
  final String madeBy;
  final String imageUrl;
  final String difficulty;
  late final bool isFavorite;
  // late bool isFavorite;

  final List<int> exercise;

  Workout(
      {required this.id,
      required this.name,
      required this.madeBy,
      required this.description,
      required this.account,
      required this.imageUrl,
      required this.difficulty,
      required this.isFavorite,
      required this.exercise,
      is_favorited});

  static const String baseUrl = "http://192.168.1.8:8000";

  factory Workout.fromJson(Map<String, dynamic> json) {
    print("json['isFavorite']--->${json['isFavorite']}");
    return Workout(
      id: json['id'],
      difficulty: json['difficulty'],
      name: json['name'],
      description: json['description'],
      account: json['account']['id'],
      madeBy: json['account']['username'],
      imageUrl: '$baseUrl${json['image']}',
      isFavorite: json['is_favorited'] ?? false,
      exercise: (json['exercises'] as List)
          .map((item) => item['exercise'] as int)
          .toList(),
    );
  }
}

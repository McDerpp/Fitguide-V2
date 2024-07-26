import 'dart:convert';

class Workout {
  final int id;
  final String name;
  final String description;
  final int account;
  final String imageUrl;
  final String difficulty;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.account,
    required this.imageUrl,
    required this.difficulty,
  });

  static const String baseUrl = "http://192.168.1.2:8000"; // Your base URL

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      difficulty: json['difficulty'],
      name: json['name'],
      description: json['description'],
      account: json['account'],
      imageUrl: '$baseUrl${json['image']}',
    );
  }
}

import 'dart:convert';

import 'package:frontend/models/dataset.dart';
import 'package:frontend/models/model.dart';

class Exercise {
  final int id;
  final String name;
  final int account;

  final String description;
  final String intensity;
  final int estimatedTime;
  final String imageUrl;
  final String videoUrl;
  final List<int> ignoreCoordinates;
  final int numExecution;
  final int numSet;
  final DateTime uploadedAt;
  final bool isActive;
  final bool isCustom;
  final String parts;
  final List<Dataset> datasets;
  final Model model;
  final String madeBy;
  final bool isFavorite;


  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.intensity,
    required this.estimatedTime,
    required this.imageUrl,
    required this.videoUrl,
    required this.ignoreCoordinates,
    required this.numExecution,
    required this.numSet,
    required this.uploadedAt,
    required this.isActive,
    required this.isCustom,
    required this.parts,
    required this.account,
    required this.datasets,
    required this.model,
    required this.madeBy,
    required this.isFavorite,

  });

  static const String baseUrl = "http://192.168.1.8:8000"; // Your base URL

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      intensity: json['intensity'],
      estimatedTime: json['estimated_time'],
      imageUrl: '$baseUrl${json['image']}',
      videoUrl: '$baseUrl${json['video']}',
      ignoreCoordinates: List<int>.from(jsonDecode(json['ignoreCoordinates'])),
      numExecution: json['numExecution'],
      numSet: json['numSet'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
      isActive: json['is_active'],
      isCustom: json['is_custom'],
      parts: json['parts'],
      account: json['account']['id'],
      datasets: (json['datasets'] as List)
          .map((item) => Dataset.fromJson(item))
          .toList(),
      model: (json['model'] as List)
          .map((item) => Model.fromJson(item))
          .toList()[0],
      madeBy: json['account']['username'],
      isFavorite:json['is_favorited']
    );
  }
}

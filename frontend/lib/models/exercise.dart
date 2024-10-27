import 'dart:convert';

import 'package:frontend/models/dataset.dart';
import 'package:frontend/models/model.dart';
import 'package:frontend/services/mainAPI.dart';

class Exercise {
  final int id;
  final String name;
  final int account;

  final String description;
  final String intensity;
  // final int estimatedTime;
  final String imageUrl;
  final String videoUrl;
  final List<int> ignoreCoordinates;
  final int numExecution;
  final int numSet;
  final DateTime uploadedAt;
  final bool isActive;
  final bool isCustom;
  final List<String> parts;
  final List<Dataset> datasets;
  final Model? model;
  final String madeBy;
  final String met;
  final bool isFavorite;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.intensity,
    // required this.estimatedTime,
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
    this.model,
    required this.madeBy,
    required this.isFavorite,
    required this.met,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    print("TESTING! -> ${json['parts']}");

    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      intensity: json['intensity'],
      // estimatedTime: json['estimated_time'],
      imageUrl: '${api.baseUrl}${json['image']}',
      videoUrl: '${api.baseUrl}${json['video']}',
      ignoreCoordinates: List<int>.from(jsonDecode(json['ignoreCoordinates'])),
      numExecution: json['numExecution'],
      numSet: json['numSet'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
      isActive: json['is_active'],
      isCustom: json['is_custom'],
      // parts: List<String>.from(jsonDecode(json['parts'])),
      parts: List<String>.from(json['parts']),

      account: json['account']['id'],
      datasets: (json['datasets'] as List)
          .map((item) => Dataset.fromJson(item))
          .toList(),
      model: (json['model'] as List)
              .map((item) => Model.fromJson(item))
              .toList()
              .isNotEmpty
          ? (json['model'] as List)
              .map((item) => Model.fromJson(item))
              .toList()[0]
          : null,
      madeBy: json['account']['username'],
      isFavorite: json['is_favorited'],
      met: json['MET'].toString(),
    );
  }
}

import 'package:frontend/services/mainAPI.dart';

class Model {
  final int id;
  final int exercise;
  final String model;
  final double valLoss;
  final double valAccuracy;

  Model({
    required this.id,
    required this.exercise,
    required this.model,
    required this.valLoss,
    required this.valAccuracy,
  });

  static const String baseUrl = "http://192.168.1.12:8000"; // Your base URL

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      exercise: json['exercise'],
      model: '${api.baseUrl}/${json['model']}',
      valLoss: json['valLoss'].toDouble(),
      valAccuracy: json['valAccuracy'].toDouble(),
    );
  }
}

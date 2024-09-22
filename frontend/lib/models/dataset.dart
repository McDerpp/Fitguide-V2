import 'package:frontend/services/mainAPI.dart';

class Dataset {
  final int id;
  final int exercise;
  final String datasetURL;
  final int numData;
  final bool isPositive;

  Dataset({
    required this.id,
    required this.exercise,
    required this.datasetURL,
    required this.numData,
    required this.isPositive,
  });

  factory Dataset.fromJson(Map<String, dynamic> json) {
    return Dataset(
      id: json['id'],
      exercise: json['exercise'],
      datasetURL: '${api.baseUrl}${json['dataset']}',
      numData: json['numData'],
      isPositive: json['isPositive'],
    );
  }
}

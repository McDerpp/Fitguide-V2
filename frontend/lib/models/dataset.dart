// import 'dart:convert';

// class Dataset {
//   final int id;
//   final String exercise;
//   final String datasetURL;
//   final String numData;
//   final bool isPositive;

//   Dataset({
//     required this.id,
//     required this.exercise,
//     required this.datasetURL,
//     required this.numData,
//     required this.isPositive,
//   });

//   static const String baseUrl = "192.168.1.8"; // Your base URL

//   factory Dataset.fromJson(Map<String, dynamic> json) {
//     return Dataset(
//       id: json['id'],
//       exercise: json['exercise'],
//       datasetURL: '$baseUrl${json['dataset'][0]}',
//       numData: json['numData'],
//       isPositive: json['isPositive'],
//     );
//   }
// }

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

  static const String baseUrl = "192.168.1.16:8000"; 

  factory Dataset.fromJson(Map<String, dynamic> json) {
    
    return Dataset(
      id: json['id'],
      exercise: json['exercise'],
      datasetURL: '$baseUrl${json['dataset']}',
      numData: json['numData'],
      isPositive: json['isPositive'],
    );
  }
}

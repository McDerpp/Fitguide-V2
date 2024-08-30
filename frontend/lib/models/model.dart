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

  static const String baseUrl = "http://192.168.1.16:8000"; // Your base URL

  factory Model.fromJson(Map<String, dynamic> json) {
    print('$baseUrl${json['model']}');
    return Model(
      id: json['id'],
      exercise: json['exercise'],
      model: '$baseUrl/${json['model']}',
      valLoss: json['valLoss'].toDouble(),
      valAccuracy: json['valAccuracy'].toDouble(),
    );
  }
}

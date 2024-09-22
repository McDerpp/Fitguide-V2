class Account {
  final int id;
  final String username;
  final String first_name;
  final String last_name;
  final String email;
  final String date_joined;
  final String userType;
  final String? bmiDetail;
  final double height;
  final double weight;
  final double? bmi;

  Account({
    required this.id,
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.date_joined,
    required this.userType,
    required this.height,
    required this.weight,
    this.bmi,
    this.bmiDetail,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    print("testse --> ${json['height']}");
    print(
        "BMI--> ${json['weight'].toDouble() / ((json['height'].toDouble() / 100) * (json['height'].toDouble() / 100))}");

    String bmiTemp = (json['weight'].toDouble() /
            ((json['height'].toDouble() / 100) *
                (json['height'].toDouble() / 100)))
        .toStringAsFixed(2);
    String bmiDetail = "";

    double bmiFinal = double.tryParse(bmiTemp) ?? 0.0;

    if (bmiFinal < 18.5) {
      bmiDetail = "Underweight";
    } else if (bmiFinal >= 18.5 && bmiFinal < 24.9) {
      bmiDetail = "Normal weight";
    } else if (bmiFinal >= 25 && bmiFinal < 29.9) {
      bmiDetail = "Overweight";
    } else if (bmiFinal > 29.9) {
      bmiDetail = "Obesity";
    }

    return Account(
      id: json['id'],
      username: json['user'],
      first_name: json['fname'],
      last_name: json['lname'],
      email: json['email'],
      date_joined: json['joined'],
      userType: json['usertype'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      bmi: bmiFinal,
      bmiDetail: bmiDetail,
    );
  }
}

import 'dart:convert';
import 'package:frontend/account.dart';
import 'package:http/http.dart' as http;

class AccountsApiService {
  static const String baseUrl = 'http://192.168.1.8:8000/api/accounts/';

  // Example POST request
  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("${baseUrl}register/"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("${baseUrl}login/"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final apiData = jsonDecode(response.body);
      print("apiData--->$apiData");
      try {
        setup.updateFromApi(apiData);
      } catch (error) {
        print("error--->$error");
      }
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login user');
    }
  }
}

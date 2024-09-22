import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/account.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/services/mainAPI.dart';
import 'package:http/http.dart' as http;

class AccountsApiService {
  static String baseUrl = '${api.baseUrl}/api/accounts/';

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

  // static Future<Map<String, dynamic>> loginUser(
  //     Map<String, dynamic> data) async {
  //   final response = await http.post(
  //     Uri.parse("${baseUrl}login/"),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(data),
  //   );

  //   if (response.statusCode == 200) {
  //     final apiData = jsonDecode(response.body);
  //     try {
  //       setup.updateFromApi(apiData);
  //     } catch (error) {
  //       print("error--->$error");
  //     }
  //     print("response.body-->${response.body}");
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to login user');
  //   }
  // }

  static Future<Map<String, dynamic>> loginUser({
    required Map<String, dynamic>? data,
    required WidgetRef ref,
  }) async {
    final response = await http.post(
      Uri.parse("${baseUrl}login/"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    print("response-->$response");

    if (response.statusCode == 200) {
      final apiData = jsonDecode(response.body);
      print("apiData--->${apiData}");
      try {
        setup.updateFromApi(apiData);
      } catch (error) {
        print("error--->$error");
      }
      ref
          .read(accountFetchProvider.notifier)
          .setAccount(Account.fromJson(apiData));
      print("Account.fromJson(apiData)--->${Account.fromJson(apiData)}");

      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login user');
    }
  }

  static Future<Map<String, dynamic>> updateUser({
    required WidgetRef ref,
    required String fname,
    required String lname,
    required String email,
    required String userType,
    required double height,
    required double weight,
    required int id,
  }) async {
    final uri = Uri.parse("${baseUrl}editAccount/");

    final request = http.MultipartRequest('POST', uri)
      ..fields['first_name'] = fname
      ..fields['id'] = id.toString()
      ..fields['last_name'] = lname
      ..fields['email'] = email
      ..fields['userType'] = userType
      ..fields['height'] = height.toString()
      ..fields['weight'] = weight.toString();

    final response = await request.send();

    if (response.statusCode == 200) {
      try {} catch (error) {
        print("error--->$error");
      }
      ref.read(accountFetchProvider.notifier).setAccount(Account(
            id: ref.read(accountFetchProvider).id,
            username: ref.read(accountFetchProvider).username,
            first_name: fname,
            last_name: lname,
            email: email,
            date_joined: ref.read(accountFetchProvider).date_joined,
            userType: userType,
            height: height,
            weight: weight,
          ));
      return jsonDecode("");
    } else {
      throw Exception('Failed to login user');
    }
  }
}

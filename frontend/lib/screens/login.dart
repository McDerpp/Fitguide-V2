import 'package:flutter/material.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/services/accounts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void loginUser(BuildContext context) async {
    print("logging in");
    usernameController.text = "test901";
    passwordController.text = "test1234";
    Map<String, dynamic> userData = {
      'username': usernameController.text,
      'password': passwordController.text,
    };

    try {
      var response = await AccountsApiService.loginUser(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print('Failed to login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Fit",
                  style: TextStyle(
                    color: tertiaryColor,
                    fontSize: 60,
                  ),
                ),
                Text(
                  "Guide",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 60,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 60,
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white, // Border color
                  width: 2.0, // Border width
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 60,
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: ElevatedButton(
                onPressed: () {
                  loginUser(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: tertiaryColor,
                ),
                child: const Text('Login'),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: const Text('Login as guest'),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextButton(
              onPressed: register,
              child: const Text(
                "Don't have an account? Sign up here.",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

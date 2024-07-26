import 'package:flutter/material.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/accounts.dart';
import 'package:frontend/widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void registerUser() async {
    try {
      Map<String, dynamic> userData = {
        'username': usernameController.text,
        'email': emailController.text,
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'userType': 'Fit-User',
        'password': passwordController.text,
      };

      var response = await AccountsApiService.registerUser(userData);
      print('User registered successfully: $response');
    } catch (e) {
      print('Failed to register user: $e');
    }
  }

  void logIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
  // TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InputField(
                        inputName: "Username",
                        textController: usernameController),
                    InputField(
                        inputName: "Email", textController: emailController),
                    InputField(
                        inputName: "First Name",
                        textController: firstNameController),
                    InputField(
                        inputName: "Last Name",
                        textController: lastNameController),
                    InputField(
                        inputName: "Password",
                        textController: passwordController,
                        obscureText: true),
                    InputField(
                        inputName: "Confirm Password",
                        textController: passwordController,
                        obscureText: true),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ElevatedButton(
                        onPressed: registerUser,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: tertiaryColor,
                        ),
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Positioned(
            top: 55,
            left: 20,
            child: Text(
              "Register",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/screens/home/home.dart';
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

  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

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
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: keyboardVisible
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 0,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          Text(
                            "Start your fitness journey here!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: [
                              Expanded(
                                child: InputField(
                                  inputName: "First Name",
                                  textController: firstNameController,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: InputField(
                                  inputName: "Last Name",
                                  textController: lastNameController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: [
                              Expanded(
                                child: InputField(
                                  inputName: "Weight(kg)",
                                  textController: weightController,
                                  obscureText: true,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: InputField(
                                  inputName: "Height(inches)",
                                  textController: heightController,
                                  obscureText: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        InputField(
                          inputName: "Username",
                          textController: usernameController,
                        ),
                        SizedBox(height: 10),
                        InputField(
                          inputName: "Email",
                          textController: emailController,
                        ),
                        SizedBox(height: 10),
                        InputField(
                          inputName: "Password",
                          textController: passwordController,
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        InputField(
                          inputName: "Confirm Password",
                          textController: passwordController,
                          obscureText: true,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

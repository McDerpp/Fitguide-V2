import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/lower_home.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/widgets/upper_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerContent(),
      backgroundColor: mainColor,
      body: const Stack(
        children: [
          Positioned(
            top: 235,
            right: 2,
            left: 2,
            child: LowerHome(),
          ),
          UpperHome(),
          Positioned(
            child: Header(),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/history/calendar_min.dart';

class UpperHome extends StatefulWidget {
  const UpperHome({super.key});

  @override
  State<UpperHome> createState() => _UpperHomeState();
}

class _UpperHomeState extends State<UpperHome> {
  Widget workoutPerformed() {
    return Container(
      height: 85,
      width: 100,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.fitness_center,
              color: Colors.red,
              size: 20.0,
            ),
            Text(
              "25",
              style: TextStyle(
                color: tertiaryColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                decoration: BoxDecoration(
                  color: tertiaryColor, // Ensure secondaryColor is defined

                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const Positioned(
          top: 85,
          right: 20,
          left: 20,
          child: CalendarMin(),
        ),
        const Positioned(
          top: 50,
          left: 55,
          child: Row(
            children: [
              Text(
                'Hi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                ' Clark!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

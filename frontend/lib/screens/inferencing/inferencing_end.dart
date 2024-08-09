import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/coreFunctionality/provider_collection.dart';
import 'package:frontend/screens/exercise/exercise_card.dart';
import 'package:frontend/screens/exercise/exercises_library.dart';
import 'package:frontend/widgets/header.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class inferencingEnd extends ConsumerStatefulWidget {
  final List<Exercise> exercise;

  const inferencingEnd({
    required this.exercise,
    super.key,
  });

  @override
  ConsumerState<inferencingEnd> createState() => _inferencingEndState();
}

class _inferencingEndState extends ConsumerState<inferencingEnd> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  void _playConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    _playConfetti();

    return Scaffold(
      backgroundColor: mainColorState,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: mainColor,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: tertiaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              children: [
                Row(
                  children: [],
                ),
              ],
            ),
          ),
          Positioned(
            top: 150,
            right: 5,
            left: 5,
            child: Container(
              height: 530,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: widget.exercise.map(
                    (exercise) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ExerciseCard(
                          exercise: exercise,
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
          const Header(),
          Positioned(
            left: 20,
            right: 20,
            bottom: 15,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ExerciseLibrary()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 5),
                foregroundColor: Colors.white,
                backgroundColor: tertiaryColor,
              ),
              child: const Text('Done'),
            ),
          ),
          Positioned(
            top: 85,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Workout Completed!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 125,
            left: 20,
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Exercise :",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi /
                  2, // radial value - 0 (right), PI/2 (down), PI (left), 3PI/2 (up)
              emissionFrequency: 0.1,
              numberOfParticles: 30,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/coreFunctionality/provider_collection.dart';
import 'package:frontend/screens/exercise/exercise_card.dart';
import 'package:frontend/screens/exercise/exercises_library.dart';
import 'package:frontend/widgets/header.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:frontend/services/history.dart';
import 'package:frontend/widgets/spaceLine.dart';

class inferencingEnd extends ConsumerStatefulWidget {
  final List<Exercise> exercise;
  final int workoutID;

  const inferencingEnd({
    required this.exercise,
    required this.workoutID,
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
    HistoryApiService.addWorkoutsDone(
        accountID: int.parse(setup.id), workoutsID: widget.workoutID, ref: ref);
  }

  void _playConfetti() {
    _confettiController.play();
  }

  Widget dailyUpdateInfo(
      {required String name,
      required String value,
      required GestureCancelCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.width * 0.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dailyUpdate() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dailyUpdateInfo(
            name: 'Calories Burned',
            value: "500.69",
            onTap: () {},
          ),
          dailyUpdateInfo(
            name: 'Workouts Done',
            value: "",
            onTap: () {},
          ),
        ],
      ),
    );
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Header(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text(
                      "Workout Completed!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Icon(
                      Icons.emoji_events,
                      size: 100.0, // Icon size
                      color: Colors.amber,
                    ),
                    dailyUpdate(),
                    spaceLine(context),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .45,
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
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
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
            ],
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

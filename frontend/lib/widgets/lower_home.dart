import 'package:flutter/material.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/screens/exercise/exercises_library.dart';
import 'package:frontend/screens/inferencing/inferencing_end.dart';

import 'package:frontend/screens/workout/workouts_library.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/widgets/suggest.dart';

class LowerHome extends StatefulWidget {
  const LowerHome({super.key});

  @override
  State<LowerHome> createState() => _LowerHomeState();
}

class _LowerHomeState extends State<LowerHome> {
  late Future<List<Exercise>> _exercisesFuture;

  void workout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutLibrary(),
      ),
    );
  }

  void ExerciseLibraryNav() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExerciseLibrary()),
    );
  }

  void mightLike() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const WorkoutLibrary(),
    //   ),
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const inferencingEnd(
          exercise: [],
        ),
      ),
    );
  }

  void recentWorkout() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => VideoThumbnailScreen(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "You Might Like",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      mightLike();
                    },
                    child: const Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Suggest(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 320,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Recent Workouts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      recentWorkout();
                    },
                    child: const Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Suggest(
              autoplay: false,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Discover",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      workout();
                    },
                    child: Container(
                      width: 158,
                      height: 50,
                      decoration: BoxDecoration(
                        color: tertiaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.content_copy_outlined,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          Text(
                            "Workouts",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      ExerciseLibraryNav();
                    },
                    child: Container(
                      width: 158,
                      height: 50,
                      decoration: BoxDecoration(
                        color: tertiaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_run,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          Text(
                            "Exercises",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      workout();
                    },
                    child: Container(
                      width: 158,
                      height: 50,
                      decoration: BoxDecoration(
                        color: tertiaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.content_copy_outlined,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          Text(
                            "Workouts",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      ExerciseLibraryNav();
                    },
                    child: Container(
                      width: 158,
                      height: 50,
                      decoration: BoxDecoration(
                        color: tertiaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_run,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          Text(
                            "Exercises",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/screens/exercise/exercises_library.dart';

import 'package:frontend/screens/workout/workouts_library.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/widgets/spaceLine.dart';
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutLibrary(),
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

  Widget discoverContent(
      {required String name,
      required IconData icon,
      required GestureCancelCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.22,
        height: MediaQuery.of(context).size.width * 0.22,
        decoration: BoxDecoration(
          color: tertiaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20.0,
            ),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget discover() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Discover",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              discoverContent(
                name: 'Workouts',
                icon: Icons.content_copy_outlined,
                onTap: () {
                  workout();
                },
              ),
              Spacer(),
              discoverContent(
                name: 'Exercises',
                icon: Icons.directions_run,
                onTap: () {
                  ExerciseLibraryNav();
                },
              ),
              Spacer(),
              discoverContent(
                name: 'Game',
                icon: Icons.games_outlined,
                onTap: () {
                  ExerciseLibraryNav();
                },
              ),
              const Spacer(),
              discoverContent(
                name: 'Dances',
                icon: Icons.music_note_outlined,
                onTap: () {
                  ExerciseLibraryNav();
                },
              ),
            ],
          ),
        ],
      ),
    );
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
            onTap: () {
              ExerciseLibraryNav();
            },
          ),
          dailyUpdateInfo(
            name: 'Workouts Done',
            value: "",
            onTap: () {
              ExerciseLibraryNav();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        dailyUpdate(),
        spaceLine(context),
        discover(),
        spaceLine(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Recent Workouts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Suggest(
              autoplay: false,
            ),
          ],
        ),
        spaceLine(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "You Might Like",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Suggest(),
          ],
        ),
        spaceLine(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Random Workouts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Suggest(),
          ],
        ),
        spaceLine(context),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.22,
        )
      ],
    );
  }
}

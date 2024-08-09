import 'package:flutter/material.dart';
import 'package:frontend/screens/history/calendar.dart';
import 'package:frontend/screens/exercise/exercises_library.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/notification_library.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/screens/workout/workouts_library.dart';
import 'package:frontend/provider/main_settings.dart';

class NavigationDrawerContent extends StatelessWidget {
  final bool isNotif;
  final bool isProfile;
  final bool isWorkoutLibrary;
  final bool isExerciseLibrary;
  final bool isCalendar;

  const NavigationDrawerContent({
    super.key,
    this.isNotif = true,
    this.isProfile = true,
    this.isWorkoutLibrary = true,
    this.isExerciseLibrary = true,
    this.isCalendar = true,
  });

  Widget nav(String name, Function ontap, IconData icon) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
          child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20.0,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      )),
    );
  }

  Function navigate(
    BuildContext context,
    Widget page,
  ) {
    return () {
      isWorkoutLibrary
          ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            )
          : null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Drawer(
        child: Container(
          color: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 15,
            ),
            child: Column(
              children: [
                nav(
                    "Home",
                    navigate(
                      context,
                      const HomePage(),
                    ),
                    Icons.home_filled),
                nav(
                    "Profile",
                    navigate(
                      context,
                      const Profile(),
                    ),
                    Icons.person),
                nav(
                    "Notification",
                    navigate(
                      context,
                      const NotificationLibrary(),
                    ),
                    Icons.notifications),
                nav(
                    "Exercise Library",
                    navigate(
                      context,
                      const ExerciseLibrary(),
                    ),
                    Icons.fitness_center),
                nav(
                    "Workout Library",
                    navigate(
                      context,
                      const WorkoutLibrary(),
                    ),
                    Icons.layers),
                nav(
                    "Calendar",
                    navigate(
                      context,
                      Calendar(),
                    ),
                    Icons.calendar_month),
                Spacer(),
                nav(
                    "Logout",
                    navigate(
                      context,
                      const LoginPage(),
                    ),
                    Icons.logout),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

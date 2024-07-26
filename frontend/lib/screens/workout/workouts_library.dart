import 'package:flutter/material.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/screens/workout/create_workout_details.dart';
import 'package:frontend/screens/dataCollection/p1_base_collection.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/name_indicator.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/screens/workout/workout_card.dart';

class WorkoutLibrary extends StatefulWidget {
  const WorkoutLibrary({
    super.key,
  });

  @override
  State<WorkoutLibrary> createState() => _WorkoutLibraryState();
}

class _WorkoutLibraryState extends State<WorkoutLibrary> {
  late Future<List<Workout>> _workoutsFuture;
  final PageController _pageController = PageController();

  List<String> _bodyPart = ['All', 'Two', 'Three', 'Four'];
  List<String> _workoutType = ['All', 'Custom', 'Premade', 'Four'];
  List<String> _favorite = ['All', 'Favorite', 'Non-Favorite'];

  late String _selectedItemPart = _bodyPart[0];
  late String _selectedItemType = _workoutType[0];
  late String _selectedItemFavorite = _favorite[0];

  String title = '';

  Widget dropDown(List<String> inputList, String selectedItem,
      void Function(String?) onChanged) {
    return DropdownButton<String>(
      value: selectedItem,
      hint: Text(
        inputList[0],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
      ),
      underline: Container(
        // Customize the underline
        height: 0,
        color: Colors.transparent,
      ),
      items: inputList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void createWorkout() {
    Navigator.push(
      context,
      // MaterialPageRoute(builder: (context) => const BaseCollection()),
      MaterialPageRoute(builder: (context) => const CreateWorkout()),
    );
  }

  @override
  void initState() {
    super.initState();
    _workoutsFuture = WorkoutApiService.fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.32,
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
            top: 85,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "  Workout Name:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "  Type:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: dropDown(_bodyPart, _selectedItemPart,
                              (String? newValue) {
                            setState(() {
                              _selectedItemPart = newValue!;
                            });
                          }),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "  Duration:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: dropDown(_workoutType, _selectedItemType,
                              (String? newValue) {
                            setState(() {
                              _selectedItemType = newValue!;
                            });
                          }),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "  Tag:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: dropDown(_favorite, _selectedItemFavorite,
                              (String? newValue) {
                            setState(() {
                              _selectedItemFavorite = newValue!;
                            });
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "  Type:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.29,
                          child: dropDown(_workoutType, _selectedItemType,
                              (String? newValue) {
                            setState(() {
                              _selectedItemType = newValue!;
                            });
                          }),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.29,
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            top: 55,
            left: 20,
            child: Text(
              "Workouts",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Header(),

          Positioned(
            top: 225,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: NameIndicator(
                controller: _pageController,
                names: const ["All Workout", "My Workout"],
              ),
            ),
          ),

          Positioned(
            top: 270,
            right: 5,
            left: 5,
            child: Container(
              height: 500,
              child: FutureBuilder<List<Workout>>(
                future: _workoutsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<Workout> workouts = snapshot.data!;
                    return PageView(
                      controller: _pageController,
                      children: <Widget>[
                        Container(
                          height: 500,
                          child: SingleChildScrollView(
                            child: Column(
                              children: workouts.map(
                                (workout) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: WorkoutCard(
                                        id: workout.id,
                                        name: workout.name,
                                        description: workout.description,
                                        account: workout.account,
                                        imageUrl: workout.imageUrl,
                                        difficulty: workout.difficulty),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                        Container(
                          height: 500,
                          child: SingleChildScrollView(
                            child: Column(
                              children: workouts.map(
                                (workout) {
                                  return workout.account.toString() == setup.id
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: WorkoutCard(
                                              id: workout.id,
                                              name: workout.name,
                                              description: workout.description,
                                              account: workout.account,
                                              imageUrl: workout.imageUrl,
                                              difficulty: workout.difficulty),
                                        )
                                      : const SizedBox();
                                },
                              ).toList(),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ),
          // Positioned(
          //   top: 250,
          //   child: Container(
          //     height: 500,
          //     child: const SingleChildScrollView(
          //       child: Column(
          //         children: <Widget>[
          //           WorkoutCard(
          //             id: "090324",
          //           ),
          // WorkoutCard(
          //   id: "090324",
          // ),
          //           WorkoutCard(
          //             id: "090324",
          //           ),

          //           // More widgets
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 15,
            child: ElevatedButton(
              onPressed: createWorkout,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(300, 5),
                foregroundColor: Colors.white,
                backgroundColor: tertiaryColor,
              ),
              child: const Text('Create Custom Exercise'),
            ),
          ),
        ],
      ),
    );
  }
}

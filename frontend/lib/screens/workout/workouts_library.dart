import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/screens/workout/create_workout_details.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/workout/workout_data_management.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/widgets/deleteConfirmation.dart';
import 'package:frontend/widgets/dialog_box.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/name_indicator.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/screens/workout/workout_card.dart';

class WorkoutLibrary extends ConsumerStatefulWidget {
  const WorkoutLibrary({
    super.key,
  });

  @override
  ConsumerState<WorkoutLibrary> createState() => _WorkoutLibraryState();
}

class _WorkoutLibraryState extends ConsumerState<WorkoutLibrary>
    with RouteAware {
  List<Workout> _workoutsFuture = [];

  final PageController _pageController = PageController();

  final List<String> _bodyPart = ['All', 'Two', 'Three', 'Four'];
  final List<String> _workoutType = ['All', 'Custom', 'Premade', 'Four'];
  final List<String> _favorite = ['All', 'Favorite', 'Non-Favorite'];

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

  void inputReset() {
    ref.read(name.notifier).state = "";
    ref.read(description.notifier).state = "";
    ref.read(intensity.notifier).state = "Easy";
    ref.read(exerciseListProvider.notifier).state = [];
    ref.read(imageProvider.notifier).state = null;
    ref.read(image.notifier).state = null;
    ref.read(imageUrl.notifier).state = "";
    ref.read(thumbnailProvider.notifier).state = null;
  }

  @override
  void didPopNext() {
    setState(() {
      // _workoutsFuture = WorkoutApiService.fetchWorkouts();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure that ModalRoute is a PageRoute
    if (ModalRoute.of(context) is PageRoute) {
      routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    }
  }

  @override
  void initState() {
    super.initState();
    // _workoutsFuture = WorkoutApiService.fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    _workoutsFuture = ref.watch(workoutsFetchProvider);

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
              child: PageView(
                controller: _pageController,
                children: <Widget>[
                  Container(
                    height: 500,
                    child: SingleChildScrollView(
                      child: Column(
                        children: _workoutsFuture.map(
                          (workout) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: WorkoutCard(
                                workout: workout,
                              ),
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
                        children: _workoutsFuture.map(
                          (workout) {
                            return workout.account.toString() == setup.id
                                ? Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Stack(
                                      children: [
                                        WorkoutCard(
                                          workout: workout,
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: GestureDetector(
                                              onTap: () {
                                                deleteConfirmation(
                                                    isExercise: false,
                                                    ref: ref,
                                                    context: context,
                                                    id: workout.id);
                                              },
                                              child: Icon(
                                                Icons.highlight_remove_sharp,
                                                color: secondaryColor,
                                                size: 25.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox();
                          },
                        ).toList(),
                      ),
                    ),
                  )
                ],
              ),

              // Container(
              //   height: 500,
              //   child: FutureBuilder<List<Workout>>(
              //     future: _workoutsFuture,
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(child: CircularProgressIndicator());
              //       } else if (snapshot.hasError) {
              //         return Center(child: Text('Error: ${snapshot.error}'));
              //       } else if (snapshot.hasData) {
              //         List<Workout> workouts = snapshot.data!;
              //         return PageView(
              //           controller: _pageController,
              //           children: <Widget>[
              //             Container(
              //               height: 500,
              //               child: SingleChildScrollView(
              //                 child: Column(
              //                   children: workouts.map(
              //                     (workout) {
              //                       return Container(
              //                         width: MediaQuery.of(context).size.width *
              //                             0.90,
              //                         margin: const EdgeInsets.symmetric(
              //                             horizontal: 5.0),
              //                         child: WorkoutCard(
              //                           workout: workout,
              //                         ),
              //                       );
              //                     },
              //                   ).toList(),
              //                 ),
              //               ),
              //             ),
              //             Container(
              //               height: 500,
              //               child: SingleChildScrollView(
              //                 child: Column(
              //                   children: workouts.map(
              //                     (workout) {
              //                       return workout.account.toString() == setup.id
              //                           ? Container(
              //                               width: MediaQuery.of(context)
              //                                       .size
              //                                       .width *
              //                                   0.90,
              //                               margin: const EdgeInsets.symmetric(
              //                                   horizontal: 5.0),
              //                               child: Stack(
              //                                 children: [
              //                                   WorkoutCard(
              //                                     workout: workout,
              //                                   ),
              //                                   Positioned(
              //                                     bottom: 0,
              //                                     right: 0,
              //                                     child: Padding(
              //                                       padding: EdgeInsets.all(5),
              //                                       child: GestureDetector(
              //                                         onTap: () {
              //                                           deleteConfirmation(
              //                                               workout.id);
              //                                         },
              //                                         child: Icon(
              //                                           Icons
              //                                               .highlight_remove_sharp,
              //                                           color: secondaryColor,
              //                                           size: 25.0,
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             )
              //                           : const SizedBox();
              //                     },
              //                   ).toList(),
              //                 ),
              //               ),
              //             )
              //           ],
              //         );
              //       } else {
              //         return Center(child: Text('No data available'));
              //       }
              //     },
              //   ),
              // ),
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
              onPressed: () {
                createWorkout();
                inputReset();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 5),
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

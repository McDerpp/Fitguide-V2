import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/provider/provider.dart';
import 'package:frontend/screens/workout/create_workout_details.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/provider/workout_data_management.dart';
import 'package:frontend/widgets/deleteConfirmation.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/name_indicator.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/screens/workout/workout_card.dart';

class FilterCategory {
  final String title;
  final Map<String, bool> filters;

  FilterCategory({required this.title, required this.filters});
}

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

  int upperState = 0;
  int filterState = 0;

  final List<FilterCategory> filterCategories = [
    FilterCategory(
      title: 'Difficulty',
      filters: {
        "Easy": false,
        "Medium": false,
        "Hard": false,
        "Advance": false,
      },
    ),
    FilterCategory(
      title: 'Others',
      filters: {
        "Favorite": false,
        "Non-Favorite": false,
        "Custom": false,
        "Premade": false,
      },
    ),
  ];

  String title = '';

  Widget filter() {
    return Container(
      decoration: BoxDecoration(
        color: miscColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      width: MediaQuery.of(context).size.width * .95,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: filterCategories.length,
          itemBuilder: (context, index) {
            final category = filterCategories[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 2.0,
                    runSpacing: 1.0,
                    children: category.filters.keys.map(
                      (key) {
                        return FilterChip(
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: tertiaryColor!,
                              width: 1.0,
                            ),
                          ),
                          backgroundColor: category.filters[key]!
                              ? tertiaryColor
                              : mainColor,
                          selectedColor: tertiaryColor,
                          label: Text(
                            key,
                            style: TextStyle(
                              color: category.filters[key]!
                                  ? Colors.white
                                  : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          selected: category.filters[key]!,
                          onSelected: (bool selected) {
                            setState(() {
                              category.filters[key] = selected;
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
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

  Widget upperSearchBase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Header(),
        SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width * .95,
          decoration: BoxDecoration(
            color: tertiaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(filterState == 1 ? 0 : 10),
              bottomRight: Radius.circular(filterState == 1 ? 0 : 10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Workouts",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          createWorkout();
                          inputReset();
                        },
                        child: Icon(
                          Icons.add_box_outlined,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              setState(() {
                                if (upperState == 0) {
                                  upperState = 1;
                                } else {
                                  upperState = 0;
                                  filterState = 0;
                                }
                              });
                              print("upperState-->$upperState");
                            },
                          );
                        },
                        child: Icon(
                          upperState == 1 ? Icons.manage_search : Icons.search,
                          color: upperState == 1 ? Colors.amber : Colors.white,
                          size: 25.0,
                        ),
                      ),
                    ],
                  ),
                  upperState == 1
                      ? Column(
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
                            Row(
                              children: [
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  child: const TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  child: Icon(
                                    filterState == 1
                                        ? Icons.filter_alt
                                        : Icons.filter_alt_outlined,
                                    color: filterState == 1
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                  onTap: () {
                                    print("filterState---> $filterState");
                                    setState(() {
                                      filterState = filterState == 1 ? 0 : 1;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
        filterState == 1 ? filter() : SizedBox()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _workoutsFuture = ref.watch(workoutsFetchProvider);

    return Scaffold(
      backgroundColor: mainColor,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Column(
            children: [
              upperSearchBase(),
              Container(
                padding: const EdgeInsets.all(5),
                child: NameIndicator(
                  controller: _pageController,
                  names: const ["All Workout","Favorite", "My Workout"],
                ),
              ),
              Expanded(
                child: Container(
                  child: PageView(
                    controller: _pageController,
                    children: <Widget>[
                      // all workout page
                      Container(
                        height: 500,
                        child: SingleChildScrollView(
                          child: Column(
                            children: _workoutsFuture.map(
                              (workout) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: WorkoutCard(
                                    workout: workout,
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                      // my workout page
                      Container(
                        height: 500,
                        child: SingleChildScrollView(
                          child: Column(
                            children: _workoutsFuture.map(
                              (workout) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
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
                                return ref.read(accountFetchProvider).id ==
                                        workout.account
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    deleteConfirmation(
                                                        isExercise: false,
                                                        ref: ref,
                                                        context: context,
                                                        id: workout.id);
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .highlight_remove_sharp,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

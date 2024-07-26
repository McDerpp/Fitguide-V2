import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/screens/workout/workout_card_discover.dart';

class Suggest extends StatefulWidget {
  final bool autoplay;
  const Suggest({super.key, this.autoplay = true});

  @override
  State<Suggest> createState() => _SuggestState();
}

class _SuggestState extends State<Suggest> {
  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = ExerciseApiService.fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<Exercise>>(
          future: _exercisesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<Exercise> exercises = snapshot.data!;
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 150,
                    autoPlay: widget.autoplay,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    viewportFraction:
                        0.4, // Adjust the fraction to show multiple items
                  ),
                  items: exercises.map(
                    (item) {
                      

                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: WorkoutCardHome(
                              name: item.name,
                              image: item.imageUrl,
                            ),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ],
    );
  }
}

// FutureBuilder<List<Exercise>>(
//           future: _exercisesFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.hasData) {
//               List<Exercise> exercises = snapshot.data!;
//               return ListView.builder(
//                 itemCount: exercises.length,
//                 itemBuilder: (context, index) {
//                   Exercise exercise = exercises[index];
//                   return ListTile(
//                     title: Text(exercise.name),
//                     subtitle: Text(exercise.description),
//                   );
//                 },
//               );
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/screens/workout/workout.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:intl/intl.dart';

class WorkoutCardDone extends ConsumerStatefulWidget {
  final Workout workout;
  final DateTime performedAt;

  const WorkoutCardDone({
    super.key,
    required this.workout,
    required this.performedAt,
  });

  @override
  ConsumerState<WorkoutCardDone> createState() => _WorkoutCardDoneState();
}

class _WorkoutCardDoneState extends ConsumerState<WorkoutCardDone> {
  String name = "Something Workout someting";
  String author = "Someone I Know";
  String difficulty = "EZ AF";
  String duration = "30";
  bool isFavorite = false;

  void ExerciseLibrary() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => workoutPage(
                id: widget.workout.id,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () {
          ExerciseLibrary();
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        color: tertiaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('HH:mm').format(widget.performedAt),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              height: 0.8),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        color: tertiaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('HH:mm').format(widget.performedAt),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              height: 0.8),
                        ),
                      ),
                    ),
              Spacer(),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                      color: workoutColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              top: 10.0,
                              right: 5.0,
                              bottom: 10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  child: Text(
                                    widget.workout.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        height: 0.8),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.workout.difficulty,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ShaderMask(
                                shaderCallback: (rect) {
                                  return const LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [Colors.transparent, Colors.red],
                                  ).createShader(
                                    Rect.fromLTRB(rect.width * .75,
                                        rect.height * .75, 0, 0),
                                  );
                                },
                                blendMode: BlendMode.dstIn,
                                child: Image.network(
                                  widget.workout.imageUrl,
                                  fit: BoxFit.cover,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                ),
                              ),
                            ),
                            // Positioned(
                            //   top: 0,
                            //   right: 0,
                            //   child: Padding(
                            //     padding: EdgeInsets.all(5),
                            //     child: GestureDetector(
                            //       child: Icon(
                            //         widget.workout.isFavorite == false
                            //             ? Icons.favorite_border
                            //             : Icons.favorite,
                            //         color: secondaryColor,
                            //         size: 25.0,
                            //       ),
                            //       onTap: () {
                            //         widget.workout.isFavorite == false
                            //             ? HistoryApiService.addWorkoutFavorite(
                            //                 ref: ref,
                            //                 accountID: int.parse(setup.id),
                            //                 workoutID: widget.workout.id)
                            //             : HistoryApiService
                            //                 .deleteWorkoutFavorite(
                            //                     ref: ref,
                            //                     accountID: int.parse(setup.id),
                            //                     workoutID: widget.workout.id);
                            //         setState(() {});
                            //       },
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/workout.dart';
import 'package:frontend/screens/workout/workout.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/history.dart';

class WorkoutCard extends ConsumerStatefulWidget {
  final Workout workout;

  const WorkoutCard({
    super.key,
    required this.workout,
  });

  @override
  ConsumerState<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends ConsumerState<WorkoutCard> {
  String name = "Something Workout someting";
  String author = "Someone I Know";
  String difficulty = "EZ AF";
  String duration = "30";
  bool isFavorite = false;

  void WorkoutPage() {
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
          WorkoutPage();
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.09,
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
                              child: Text(
                                widget.workout.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 0.8),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              widget.workout.difficulty,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 110,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    child: Text(
                                      "ID: ${widget.workout.id}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          height: 1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: Text(
                                      "By: ${widget.workout.madeBy}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                          height: 1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                Rect.fromLTRB(
                                    rect.width * .65, rect.height * .65, 0, 0),
                              );
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              widget.workout.imageUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.50,
                              height: MediaQuery.of(context).size.height * 0.11,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: GestureDetector(
                              child: Icon(
                                widget.workout.isFavorite == false
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                                color: secondaryColor,
                                size: 25.0,
                              ),
                              onTap: () {
                                widget.workout.isFavorite == false
                                    ? HistoryApiService.addWorkoutFavorite(
                                        ref: ref,
                                        accountID: int.parse(setup.id),
                                        workoutID: widget.workout.id)
                                    : HistoryApiService.deleteWorkoutFavorite(
                                        ref: ref,
                                        accountID: int.parse(setup.id),
                                        workoutID: widget.workout.id);
                                setState(() {});
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

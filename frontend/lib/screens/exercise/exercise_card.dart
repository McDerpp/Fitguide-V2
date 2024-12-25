import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/exercisePlan.dart';
import 'package:frontend/models/trainingProgress.dart';
import 'package:frontend/screens/exercise/exercise.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/history.dart';

class ExerciseCard extends ConsumerStatefulWidget {
  // base
  final Exercise exercise;
  final bool trainingProgress;
  final bool isFavorite;

  // exercise picking mode
  final bool isPickExerciseMode;
  final bool isPicked;
  final void Function(ExercisePlan, bool, int)? onChangeExericiseList;
  final void Function()? onChangePick;

  //setting up sets and reps mode
  final bool isSetsRepsMode;
  final int sets;
  final int reps;
  final int position;
  final int restDuration;
  final void Function(Exercise, int, int)? onChangeSetsReps;

  // training mode
  final double progress;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.isFavorite = false,
    this.trainingProgress = false,
    this.isPickExerciseMode = false,
    this.isSetsRepsMode = false,
    this.onChangeExericiseList,
    this.onChangeSetsReps,
    this.onChangePick,
    this.restDuration = 60,
    this.isPicked = false,
    this.position = 0,
    this.progress = 0,
    this.sets = 1,
    this.reps = 1,
  });

  @override
  ConsumerState<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<ExerciseCard> {
  void ExerciseLibrary() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ExerciseScreen(
                exercise: widget.exercise,
              )),
    );
  }

  BorderRadius modes() {
    if (widget.trainingProgress == true) {
      return BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10));
    } else if (widget.isPickExerciseMode == true) {
      return BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10));
    } else if (widget.isSetsRepsMode == true) {
      return BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10));
    } else {
      return BorderRadius.circular(10);
    }

    return BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10));
  }

  Widget setsRepsModeAddRemove() {
    // this is from all exercises
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            // widget.onChangeExericiseList!(widget.exercise);
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.09,
          decoration: BoxDecoration(
            color: widget.isPicked ? Colors.amber : secondaryColor,
            border: Border.all(
              color: widget.isPicked ? Colors.amber : secondaryColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            widget.isPicked
                ? Icons.remove_circle_outline
                : Icons.add_circle_outline_sharp,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget modeSwitch() {
    if (widget.trainingProgress == true) {
      return setsRepsMode();
    } else if (widget.isPickExerciseMode == true) {
      return pickExercise();
    } else if (widget.isSetsRepsMode == true) {
      return setsRepsMode();
    } else {
      return base();
    }
  }

  Widget pickExercise() {
    return Column(
      children: [
        base(),
        SizedBox(
          height: 3,
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              // color: tertiaryColor,
              color: !widget.isPicked ? tertiaryColor : Colors.amber,

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            width: MediaQuery.of(context).size.width * .90,
            height: MediaQuery.of(context).size.width * .07,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          onTap: () {
            setState(() {
              widget.onChangeExericiseList!(
                  ExercisePlan(
                    exercise: widget.exercise,
                    sets: widget.reps,
                    reps: widget.sets,
                    restDuration: 60,
                  ),
                  true,
                  0);
              widget.onChangePick!();
            });
          },
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget setsRepsMode() {
    // this is from current exercise
    Widget sets() {
      return Container(
        child: Row(
          children: [
            Container(
              color: Colors.white,
              child: Icon(Icons.remove),
            ),
            Container(
              child: Text("1"),
            ),
            Container(
              color: Colors.white,
              child: Icon(Icons.add),
            )
          ],
        ),
      );
    }

    return Column(
      children: [
        base(),
        SizedBox(
          height: 3,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
            color: tertiaryColor,
          ),
          width: MediaQuery.of(context).size.width * .90,
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Row(
              children: [
// sets

                GestureDetector(
                  child: Container(
                    height: 28,
                    width: 28,
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                  onTap: () {
                    widget.onChangeSetsReps!(widget.exercise,
                        widget.sets != 0 ? widget.sets - 1 : 0, widget.reps);
                  },
                ),
                Container(
                    height: 50,
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                          ),
                          'Sets',
                        ),
                        Text(
                          style: TextStyle(color: Colors.white),
                          widget.sets.toString(),
                        ),
                      ],
                    )),
                GestureDetector(
                  child: Container(
                      height: 28,
                      width: 28,
                      child: Icon(Icons.add, color: Colors.white)),
                  onTap: () {
                    widget.onChangeSetsReps!(
                        widget.exercise, widget.sets + 1, widget.reps);
                  },
                ),

                SizedBox(
                  width: 25,
                ),
// reps
                GestureDetector(
                  child: Container(
                    height: 28,
                    width: 28,
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                  onTap: () {
                    widget.onChangeSetsReps!(widget.exercise, widget.sets,
                        widget.reps != 0 ? widget.reps - 1 : 0);
                  },
                ),
                Container(
                    height: 50,
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                          ),
                          'Reps',
                        ),
                        Text(
                          style: TextStyle(color: Colors.white),
                          widget.reps.toString(),
                        ),
                      ],
                    )),
                GestureDetector(
                  child: Container(
                    height: 28,
                    width: 28,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  onTap: () {
                    widget.onChangeSetsReps!(
                        widget.exercise, widget.sets, widget.reps + 1);
                  },
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    widget.onChangeExericiseList!(
                      ExercisePlan(
                        exercise: widget.exercise,
                        sets: widget.reps,
                        reps: widget.sets,
                        restDuration: 60,
                      ),
                      false,
                      widget.position,
                    );
                    widget.onChangePick!();
                  },
                  child: Container(
                    height: 28,
                    width: 28,
                    child: Icon(Icons.highlight_remove_rounded,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget base() {
    return Container(
      width: MediaQuery.of(context).size.width * .90,
      child: GestureDetector(
        onTap: () {
          ExerciseLibrary();
        },
        child: SizedBox(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                decoration:
                    BoxDecoration(color: secondaryColor, borderRadius: modes()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "${widget.exercise.name}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 0.8),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              '${widget.exercise.intensity}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            Wrap(
                              spacing: -9.0,
                              runSpacing: -9.0,
                              children: List.generate(
                                widget.exercise.parts.length,
                                (index) {
                                  return Transform(
                                    transform: new Matrix4.identity()
                                      ..scale(0.8),
                                    child: new Chip(
                                      padding: EdgeInsets.all(0),
                                      color: WidgetStateProperty.all(
                                          secondaryColor),
                                      label: new Text(
                                        widget.exercise.parts.elementAt(index),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      backgroundColor: const Color(0xFFa3bdc4),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          "By: ${widget.exercise.madeBy}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              height: 1),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: modes(),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [Colors.transparent, Colors.red],
                              ).createShader(Rect.fromLTRB(
                                  rect.width * 0.50, rect.height * 0.50, 0, 0));
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              widget.exercise.imageUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                          ),
                        ),
                        widget.trainingProgress
                            ? SizedBox()
                            : Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      widget.exercise.isFavorite == false
                                          ? Icons.favorite_border
                                          : Icons.favorite,
                                      color: secondaryColor,
                                      size: 25.0,
                                    ),
                                  ),
                                  onTap: () {
                                    widget.exercise.isFavorite == false
                                        ? HistoryApiService.addExerciseFavorite(
                                            ref: ref,
                                            accountID: int.parse(setup.id),
                                            exerciseID: widget.exercise.id)
                                        : HistoryApiService
                                            .deleteExerciseFavorite(
                                                ref: ref,
                                                accountID: int.parse(setup.id),
                                                exerciseID: widget.exercise.id);
                                  },
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return modeSwitch();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/dataset.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/model.dart';
import 'package:frontend/screens/exercise/exercise.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/history.dart';

class ExerciseCard extends ConsumerStatefulWidget {
  final Exercise exercise;

  final bool isFavorite;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.isFavorite = false,
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
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.93,
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
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
                                Container(
                                  width: 120,
                                  height: 28,
                                  child: Text(
                                    "${widget.exercise.name}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        height: 0.8),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${widget.exercise.parts}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Sets: ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        widget.exercise.numSet.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Reps: ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        widget.exercise.numSet.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 110,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    child: Text(
                                      "ID ${widget.exercise.id}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 7,
                                          fontWeight: FontWeight.w300,
                                          height: 1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: Text(
                                      "By: ${widget.exercise.madeBy}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 7,
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
                              ).createShader(Rect.fromLTRB(
                                  rect.width * 0.50, rect.height * 0.50, 0, 0));
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              widget.exercise.imageUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.50,
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                          ),
                        ),
                        Positioned(
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
                                  : HistoryApiService.deleteExerciseFavorite(
                                      ref: ref,
                                      accountID: int.parse(setup.id),
                                      exerciseID: widget.exercise.id);
                            },
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: GestureDetector(
                              child: Icon(
                                widget.exercise.isFavorite == false
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                                color: secondaryColor,
                                size: 25.0,
                              ),
                              onTap: () {
                                widget.exercise.isFavorite == false
                                    ? HistoryApiService.addExerciseFavorite(
                                        ref: ref,
                                        accountID: int.parse(setup.id),
                                        exerciseID: widget.exercise.id)
                                    : HistoryApiService.deleteExerciseFavorite(
                                        ref: ref,
                                        accountID: int.parse(setup.id),
                                        exerciseID: widget.exercise.id);
                                setState(() {});
                              },
                            ),
                          ),
                        )
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
}

// exerciseFetchProvider
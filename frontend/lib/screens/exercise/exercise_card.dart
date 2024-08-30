import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/exercise.dart';
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
        child: Expanded(
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.09,
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
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "${widget.exercise.name}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
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
                                '${widget.exercise.parts}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      Container(
                                          child: Expanded(
                                        child: Text(
                                          "ID: ${widget.exercise.id}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              height: 1),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
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
                            borderRadius: BorderRadius.circular(10),
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return const LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [Colors.transparent, Colors.red],
                                ).createShader(Rect.fromLTRB(rect.width * 0.50,
                                    rect.height * 0.50, 0, 0));
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.network(
                                widget.exercise.imageUrl,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.50,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
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
                                      : HistoryApiService
                                          .deleteExerciseFavorite(
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
      ),
    );
  }
}

// exerciseFetchProvider
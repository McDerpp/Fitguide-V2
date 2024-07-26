import 'package:flutter/material.dart';
import 'package:frontend/screens/exercise/exercise.dart';
import 'package:frontend/provider/main_settings.dart';

class ExerciseCard extends StatefulWidget {
  final String id;
  final String nameExercise;
  final int repitions;
  final int sets;
  final String parts;
  final String author;
  final String image;
  final String video;
  final bool isFavorite;

  const ExerciseCard({
    super.key,
    required this.id,
    required this.nameExercise,
    required this.repitions,
    required this.sets,
    required this.parts,
    required this.author,
    this.isFavorite = false,
    required this.image,
    required this.video,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  void ExerciseLibrary() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ExerciseScreen(
                id: widget.id,
                nameExercise: widget.nameExercise,
                repitions: widget.repitions,
                sets: widget.sets,
                parts: widget.parts,
                author: widget.author,
                video: widget.video,
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
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.favorite_border,
                            color: secondaryColor,
                            size: 30.0,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [Colors.transparent, Colors.red],
                              ).createShader(
                                  Rect.fromLTRB(0, 0, rect.width, rect.height));
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              widget.image,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.50,
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),

                            // Image.asset(
                            //   'assets/images/placeholder_image.jpg',
                            //   fit: BoxFit.cover,
                            //   width: MediaQuery.of(context).size.width * 0.50,
                            //   height: MediaQuery.of(context).size.height * 0.15,
                            // ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.favorite_border,
                            color: secondaryColor,
                            size: 25.0,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                          top: 5.0,
                          right: 5.0,
                          bottom: 5.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                widget.nameExercise,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 0.8),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.parts,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              "${widget.sets} Sets",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              "${widget.repitions} Repitions",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 110,
                              child: Text(
                                "ID ${widget.id}\nBy: ${widget.author}sdfavsdfvsefasvefaes",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 7,
                                    fontWeight: FontWeight.w300,
                                    height: 1),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
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

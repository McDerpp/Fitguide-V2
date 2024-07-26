import 'package:flutter/material.dart';
import 'package:frontend/screens/workout/workout.dart';
import 'package:frontend/provider/main_settings.dart';

class WorkoutCard extends StatefulWidget {
  final int id;
  final String name;
  final String description;
  final int account;
  final String imageUrl;
  final String difficulty;

  const WorkoutCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.account,
    required this.imageUrl,
    required this.difficulty,
  });

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
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
                id: widget.id,
                name: widget.name,
                difficulty: widget.difficulty,
                description: widget.description,
                account: widget.account,
                imageUrl: widget.imageUrl,
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
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: workoutColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
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
                                Rect.fromLTRB(0, 0, rect.width, rect.height),
                              );
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.50,
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
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
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 120,
                              child: Text(
                                widget.name,
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
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.difficulty,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            // Text(
                            //   duration + " Mins",
                            //   style: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.w300,
                            //   ),
                            // ),
                            Spacer(),
                            Container(
                              width: 110,
                              child: Text(
                                "ID ${widget.id}\nBy: ${author}sdfavsdfvsefasvefaes",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

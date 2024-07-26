import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:video_player/video_player.dart';

class ExerciseScreen extends StatefulWidget {
  final String id;
  final String nameExercise;
  final int repitions;
  final int sets;
  final String parts;
  final String author;
  final String video;
  final bool isFavorite;
  const ExerciseScreen({
    super.key,
    required this.id,
    required this.nameExercise,
    required this.repitions,
    required this.sets,
    required this.parts,
    required this.author,
    this.isFavorite = false,
    required this.video,
  });
  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<ExerciseScreen> {
  late VideoPlayerController _controller;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  void initializeVideo() {
    print("widget.video---> ${widget.video}");
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video))
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      }).catchError((error) {
        print('Error initializing video: $error');
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              child: FutureBuilder(
                future: _controller.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),

              // _controller.value.isInitialized
              //     ? AspectRatio(
              //         aspectRatio: _controller.value.aspectRatio,
              //         child: Transform.scale(
              //           scale: 1.15, // Adjust this value to zoom in or out
              //           child: VideoPlayer(_controller),
              //         ),
              //       )
              //     : const CircularProgressIndicator(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 3,
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      tertiaryColor!,
                      Colors.transparent,
                    ],
                    end: Alignment.topCenter,
                    begin: Alignment.bottomCenter,
                    stops: [.1, .3],
                  ),
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              top: 480,
              left: 5,
              right: 5,
              child: Container(
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        // widget.nameExercise,
                                        "Name of exercise:",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      Text(
                                        // widget.nameExercise,
                                        widget.nameExercise,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: GestureDetector(
                                      child: Icon(
                                        isFavorite == false
                                            ? Icons.favorite_border
                                            : Icons.favorite,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                      onTap: () {
                                        setState(
                                          () {
                                            isFavorite = !isFavorite;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // widget.nameExercise,
                                    "Intensity:",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  Text(
                                    // widget.nameExercise,
                                    "Medium",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // widget.nameExercise,
                                    "Estimated Time:",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  Text(
                                    // widget.nameExercise,
                                    "10 Minutes",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    // widget.nameExercise,
                                    "Description:",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  Container(
                                    child: const Text(
                                      // widget.nameExercise,
                                      "s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1s10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes10 Minutes1",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 100,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // More widgets
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

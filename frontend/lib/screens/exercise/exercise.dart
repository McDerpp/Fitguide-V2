import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/exercise/create_exercise.dart';
import 'package:frontend/screens/exercise/exercise_data_management.dart';
import 'package:frontend/screens/workout/workout_data_management.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:frontend/models/dataset.dart';
import 'package:frontend/models/model.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  final Exercise exercise;
  final bool isFavorite;

  const ExerciseScreen({
    super.key,
    required this.exercise,
    this.isFavorite = false,
  });
  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseState();
}

class _ExerciseState extends ConsumerState<ExerciseScreen> {
  late VideoPlayerController _controller;
  bool isFavorite = false;
  Uint8List? thumbnail;

  @override
  void initState() {
    super.initState();
    initializeVideo();
    // print("datasets--->${widget.datasets}");
  }

  // void initializeVideo() {
  //   print("widget.video---> ${widget.video}");
  //   _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video))
  //     ..initialize().then((_) {
  //       setState(() {});
  //       _controller.setLooping(true);
  //       _controller.play();
  //     }).catchError((error) {
  //       print('Error initializing video: $error');
  //     });
  // }

  void initializeVideo() {
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.exercise.videoUrl))
          ..setLooping(true)
          ..initialize().then((_) {
            setState(() {
              print("rebuilding...............");
              _controller.play();
            });
          }).catchError((error) {
            print('Error initializing video: $error');
          });
  }

  Future<void> downloadAndGenerateThumbnail(String videoUrl) async {
    // Download video
    final response = await http.get(Uri.parse(videoUrl));
    if (response.statusCode == 200) {
      // Save video to temporary location
      final tempDir = await getTemporaryDirectory();
      final videoPath = '${tempDir.path}/temp_video.mp4';
      final file = File(videoPath);
      await file.writeAsBytes(response.bodyBytes);

      // Generate thumbnail
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 150,
        maxWidth: 150,
        quality: 100,
      );

      ref.read(videoThumbnailProvider.notifier).state = uint8list;
    } else {
      throw Exception('Failed to load video');
    }
  }

  Future<void> initEdit() async {
    ref.read(setsProvider.notifier).state = widget.exercise.numSet.toString();
    ref.read(repsProvider.notifier).state =
        widget.exercise.numExecution.toString();
    ref.read(exerciseIntensity.notifier).state = widget.exercise.intensity;
    ref.read(exerciseDescription.notifier).state = widget.exercise.description;
    ref.read(exerciseNameProvider.notifier).state = widget.exercise.name;
    ref.read(exerciseIDProvider.notifier).state = widget.exercise.id.toString();

    ref.read(imageUrl.notifier).state = widget.exercise.imageUrl;
    ref.read(videoURLProvider.notifier).state = widget.exercise.videoUrl;

    await downloadAndGenerateThumbnail(widget.exercise.videoUrl);

    _controller.dispose();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CreateExercise(
                isEdit: true,
              )),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("isRebuilding");
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Positioned(
            //   child: FutureBuilder(
            //     future: _controller.initialize(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         return AspectRatio(
            //           aspectRatio: _controller.value.aspectRatio,
            //           child: VideoPlayer(_controller),
            //         );
            //       } else {
            //         return Center(child: CircularProgressIndicator());
            //       }
            //     },
            //   ),

            Positioned(
                child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )),
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
                                        widget.exercise.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  widget.exercise.account.toString() == setup.id
                                      ? Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                            onTap: () {
                                              initEdit();
                                            },
                                          ),
                                        )
                                      : SizedBox(),
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
                              Column(
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
                                    widget.exercise.intensity,
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
                                    child: Text(
                                      widget.exercise.description,
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

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
import 'package:frontend/services/history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:frontend/models/dataset.dart';
import 'package:frontend/models/model.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  final Exercise exercise;

  const ExerciseScreen({
    super.key,
    required this.exercise,
  });
  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseState();
}

class _ExerciseState extends ConsumerState<ExerciseScreen> {
  late VideoPlayerController _controller;
  Uint8List? thumbnail;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    initializeVideo();
    isFavorite = widget.exercise.isFavorite;
  }

  Widget informationDisplay(String title, String value,
      {bool isCenter = false}) {
    return Container(
      width: MediaQuery.of(context).size.width * .2,
      child: Column(
        crossAxisAlignment:
            isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w200,
            ),
          ),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void initializeVideo() {
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.exercise.videoUrl))
          ..setLooping(true)
          ..initialize().then((_) {
            setState(() {
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

    ref.read(metProvider.notifier).state = widget.exercise.met;
    ref.read(estimatedTimeProvider.notifier).state =
        widget.exercise.estimatedTime.toString();

    ref.read(positivedatasetNum.notifier).state = widget.exercise.met;
    ref.read(negativeDatasetNum.notifier).state = widget.exercise.met;

    if (widget.exercise.datasets.elementAt(0).isPositive == true) {
      ref.read(positivedatasetNum.notifier).state =
          widget.exercise.datasets.elementAt(0).numData.toString();
    } else {
      ref.read(negativeDatasetNum.notifier).state =
          widget.exercise.datasets.elementAt(0).numData.toString();
    }

    if (widget.exercise.datasets.elementAt(1).isPositive == true) {
      ref.read(positivedatasetNum.notifier).state =
          widget.exercise.datasets.elementAt(1).numData.toString();
    } else {
      ref.read(negativeDatasetNum.notifier).state =
          widget.exercise.datasets.elementAt(1).numData.toString();
    }

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
                                  Spacer(),
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
                                        widget.exercise.isFavorite == false
                                            ? HistoryApiService
                                                .addExerciseFavorite(
                                                    ref: ref,
                                                    accountID: int.parse(
                                                        setup.id),
                                                    exerciseID:
                                                        widget.exercise.id)
                                            : HistoryApiService
                                                .deleteExerciseFavorite(
                                                    ref: ref,
                                                    accountID:
                                                        int.parse(setup.id),
                                                    exerciseID:
                                                        widget.exercise.id);

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
                                  Row(
                                    children: [
                                      Container(
                                        width: 75,
                                        child: Text(
                                          "#${widget.exercise.id.toString()}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 75,
                                        child: Text(
                                          "By:${widget.exercise.madeBy}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    child: Text(
                                      widget.exercise.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: informationDisplay(
                                  "Parts:",
                                  widget.exercise.parts,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Container(
                                      child: informationDisplay("Intensity:",
                                          widget.exercise.intensity),
                                    ),
                                    Spacer(),
                                    Container(
                                      child: informationDisplay("Est. Time:",
                                          "${widget.exercise.estimatedTime.toString()} mins"),
                                    ),
                                    Spacer(),
                                    Container(
                                      child: informationDisplay("Calorie Burn:",
                                          "${widget.exercise.met} kcal"),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Description:",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w200,
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

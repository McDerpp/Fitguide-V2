import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/models/trainingProgress.dart';
import 'package:frontend/screens/exercise/exercise.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/exercise/exercise_card.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/services/history.dart';
import 'package:frontend/services/model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ModelCard extends ConsumerStatefulWidget {
  final TrainingProgress trainingProgress;

  final bool isFavorite;

  const ModelCard({
    super.key,
    required this.trainingProgress,
    this.isFavorite = false,
  });

  @override
  ConsumerState<ModelCard> createState() => _ModelCardState();
}

class _ModelCardState extends ConsumerState<ModelCard> {
  double progress = 0.0;
  late WebSocketChannel _channel;
  bool isWebSocketConnected = false;

  void ExerciseLibrary() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ExerciseScreen(
                exercise: widget.trainingProgress.exercise,
              )),
    );
  }

  Future<void> connectWebSocket() async {
    print("training progress available!");

    _channel = await ModelTrainingService.webSocketConnectSingle(
        widget.trainingProgress.taskId);
    setState(() {
      isWebSocketConnected = true;
      print("connected --> ${_channel}");
    });
  }

  @override
  void initState() {
    super.initState();
    connectWebSocket();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  Widget progressInfo(double progress) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.01,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              minHeight: 5,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
              value: progress / 100,
            ),
          ),
        ),
        progress == 100
            ? Text(
                "COMPLETED",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              )
            : Text(
                "Model Training in Progress (${progress}%)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              )
      ],
    );
  }

  Widget progressUpdate() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: tertiaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.05,
          child: isWebSocketConnected
              ? StreamBuilder(
                  stream: _channel!.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      try {
                        Map<String, dynamic> data =
                            json.decode(snapshot.data.toString());
                        double newProgress =
                            double.tryParse(data['status'].toString()) ?? 0.0;
                        print("new progress --> ${newProgress}");

                        if (newProgress != progress) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              progress = newProgress;
                            });
                          });
                        }

                        return progressInfo(progress);
                      } catch (e) {
                        print("error in websocket update --> $e");

                        return Text(
                          "INVALID PROGRESS UPDATE!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                          ),
                        );
                      }
                    } else {
                      return progressInfo(progress);
                    }
                  },
                )
              : Text(
                  "CONNECTING!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
        ),
        Spacer(),
        // Container(
        //   decoration: BoxDecoration(
        //     color: tertiaryColor,
        //     borderRadius: BorderRadius.only(
        //       bottomRight: Radius.circular(10),
        //     ),
        //   ),
        //   width: MediaQuery.of(context).size.width * 0.295,
        //   height: MediaQuery.of(context).size.height * 0.05,
        //   child: Center(
        //     child: Text(
        //       "Add exercise",
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 12,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
        // )
        progress == 100
            ? GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: tertiaryColor?.withOpacity(1),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.295,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Center(
                    child: Text(
                      "Add exercise",
                      style: TextStyle(
                        color: Colors.white.withOpacity(1),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  ExerciseApiService.activateExercise(
                      widget.trainingProgress.exercise.id.toString());
                },
              )
            : Container(
                decoration: BoxDecoration(
                  color: tertiaryColor?.withOpacity(0.25),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.295,
                height: MediaQuery.of(context).size.height * 0.05,
                child: Center(
                  child: Text(
                    "Add exercise",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.25),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExerciseCard(
          trainingProgress: true,
          exercise: widget.trainingProgress.exercise,
        ),
        progressUpdate(),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}

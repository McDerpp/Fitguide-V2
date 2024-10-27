import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/models/exercise.dart';
import 'package:frontend/screens/exercise/exercise_card.dart';
import 'package:frontend/screens/exercise/exercises_library.dart';
import 'package:frontend/screens/inferencing/inferencing/mainUISettings.dart';
import 'package:frontend/widgets/header.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:frontend/services/history.dart';
import 'package:frontend/widgets/spaceLine.dart';

class inferencingEnd extends ConsumerStatefulWidget {
  final List<Exercise> exercise;
  final int workoutID;

  const inferencingEnd({
    required this.exercise,
    required this.workoutID,
    super.key,
  });

  @override
  ConsumerState<inferencingEnd> createState() => _inferencingEndState();
}

class _inferencingEndState extends ConsumerState<inferencingEnd> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    HistoryApiService.addWorkoutsDone(
        accountID: int.parse(setup.id), workoutsID: widget.workoutID, ref: ref);
  }

  void _playConfetti() {
    _confettiController.play();
  }

  Widget dailyUpdateInfo(
      {required String name,
      required String value,
      required GestureCancelCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.width * 0.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w200,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dailyUpdate() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dailyUpdateInfo(
            name: 'Calories Burned',
            value: "500.69",
            onTap: () {},
          ),
          dailyUpdateInfo(
            name: 'Workouts Done',
            value: "",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _playConfetti();

    return Scaffold(
      backgroundColor: mainColorState,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: mainColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Header(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text(
                      "Workout Completed!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Icon(
                      Icons.emoji_events,
                      size: 100.0, // Icon size
                      color: Colors.amber,
                    ),
                    dailyUpdate(),
                    spaceLine(context),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.exercise.map(
                      (exercise) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ExerciseCard(
                            exercise: exercise,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExerciseLibrary()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 5),
                  foregroundColor: Colors.white,
                  backgroundColor: tertiaryColor,
                ),
                child: const Text('Done'),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi /
                  2, // radial value - 0 (right), PI/2 (down), PI (left), 3PI/2 (up)
              emissionFrequency: 0.1,
              numberOfParticles: 30,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:confetti/confetti.dart';
// import 'package:frontend/models/exercise.dart';

// import 'dart:math';

// import 'package:frontend/provider/main_settings.dart';
// import 'package:frontend/screens/inferencing/inferencing/mainUISettings.dart';

// class inferencingEnd extends ConsumerStatefulWidget {
//   final List<Exercise> exercise;
//   final int workoutID;
//   final int elapsedTime;
//   final List<List<int>> setsReps;

//   const inferencingEnd({
//     required this.exercise,
//     required this.workoutID,
//     required this.elapsedTime,
//     required this.setsReps,
//     super.key,
//   });

//   @override
//   ConsumerState<inferencingEnd> createState() => _inferencingEndState();
// }

// class _inferencingEndState extends ConsumerState<inferencingEnd> {
//   late ConfettiController _confettiController;

//   int exerciseCtr = 0;
//   bool _isNavigating = false;
//   double finalCompletionRate = 0;

//   @override
//   void initState() {
//     super.initState();
//     _confettiController =
//         ConfettiController(duration: const Duration(seconds: 2));
//     _playConfetti();
//     calculateCompleteRate();

//     // HistoryApiService.addWorkoutsDone(
//     //     accountID: int.parse(setup.id), workoutsID: widget.workoutID, ref: ref);
//   }

//   void _playConfetti() {
//     _confettiController.play();
//   }

//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int remainingSeconds = seconds % 60;

//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   double calculateCompleteRate() {
//     int calcExercise = 0;
//     double totalCompletionRate = 0;
//     for (List<int> content in widget.setsReps) {
//       print("content -> $content");
//       int sets = widget.exercise.elementAt(calcExercise).numSet;
//       int reps = widget.exercise.elementAt(calcExercise).numExecution;
//       int totalSets = sets * reps;
//       int performedSets = content[0];
//       int performedReps = content[1];
//       int totalSetsPerformed = 0;
//       if (performedSets == sets) {
//         print("complete sets");
//         totalSetsPerformed = performedSets * reps;
//       } else if (performedSets == 0) {
//         totalSetsPerformed = performedReps;
//       } else {
//         print("not complete sets");
//         int totalSetsPerformed = performedSets * sets + performedReps;
//       }

//       print("totalSetsPerformed -> $totalSetsPerformed");
//       print("totalSetsPerformed -> $totalSetsPerformed");
//       print("totalSets -> $totalSets");

//       double completionRate = totalSetsPerformed / totalSets * 100;
//       totalCompletionRate = totalCompletionRate + completionRate;

//       calcExercise++;
//     }
//     finalCompletionRate = totalCompletionRate / widget.exercise.length;
//     print("totalCompletionRate --> $totalCompletionRate");
//     return totalCompletionRate;
//   }

//   Widget dailyUpdateInfo(
//       {required String name,
//       required String value,
//       required GestureCancelCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.25,
//         height: MediaQuery.of(context).size.width * 0.22,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               name,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w200,
//               ),
//             ),
//             Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 23,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _confettiController.stop();
//     _confettiController.dispose();
//     print("is done disposing");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: mainColorState,
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//             ),
//           ),
//           Positioned(
//             top: 50,
//             right: 15,
//             left: 15,
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Workout Completed!",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 30,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                   const Icon(
//                     Icons.emoji_events,
//                     size: 100.0, // Icon size
//                     color: Colors.amber,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       dailyUpdateInfo(
//                         name: "Completion Time",
//                         value: _formatTime(widget.elapsedTime),
//                         onTap: () {},
//                       ),
//                       const SizedBox(width: 15),
//                       dailyUpdateInfo(
//                         name: "Exercises Done",
//                         value: '${widget.exer.length}',
//                         onTap: () {},
//                       ),
//                       const SizedBox(width: 15),
//                       dailyUpdateInfo(
//                         name: "Completion Rate",
//                         value: finalCompletionRate.toStringAsFixed(2),
//                         onTap: () {},
//                       ),
//                     ],
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: widget.workout.exercisePlans.map(
//                               (exercise) {
//                                 exerciseCtr++;

//                                 return Column(
//                                   children: [
//                                     Container(
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.12,
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.8,
//                                             child: ExerciseCard(
//                                               exercise: exercise.exercise,
//                                             ),
//                                           ),
//                                           Spacer(),
//                                           Container(
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 0.11,
//                                             decoration: BoxDecoration(
//                                               color: Colors.black,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             child: Padding(
//                                               padding: EdgeInsets.all(5),
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Spacer(),
//                                                   Text(
//                                                     "Reps :",
//                                                     textAlign: TextAlign.start,
//                                                     style: TextStyle(
//                                                       fontSize: 10.0,
//                                                       fontWeight:
//                                                           FontWeight.w300,
//                                                       color: Colors.white,
//                                                     ),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                   Text(
//                                                     "${widget.setsReps[exerciseCtr - 1][1]} / ${exercise.repetitions}",
//                                                     textAlign: TextAlign.start,
//                                                     style: TextStyle(
//                                                       fontSize: 13.0,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       color: Colors.white,
//                                                     ),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                   // Divider(
//                                                   //     color: Colors.white,
//                                                   //     thickness: 10),
//                                                   SizedBox(
//                                                     height: 5,
//                                                   ),
//                                                   Text(
//                                                     "Sets :",
//                                                     textAlign: TextAlign.start,
//                                                     style: TextStyle(
//                                                       fontSize: 10.0,
//                                                       fontWeight:
//                                                           FontWeight.w300,
//                                                       color: Colors.white,
//                                                     ),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                   Text(
//                                                     "${widget.setsReps[exerciseCtr - 1][0]} / ${exercise.sets}",
//                                                     textAlign: TextAlign.start,
//                                                     style: TextStyle(
//                                                       fontSize: 13.0,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       color: Colors.white,
//                                                     ),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                   ),
//                                                   Spacer(),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ).toList(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 15,
//             right: 15,
//             left: 15,
//             child: ElevatedButton(
//               // onPressed: () {
//               // for (int i = 0; i < 2; i++) {
//               //   Navigator.pop(context);
//               // }
//               // },
//               onPressed: _isNavigating
//                   ? null
//                   : () {
//                       setState(() {
//                         _isNavigating = true;
//                       });
//                       Future.delayed(Duration(milliseconds: 100), () {
//                         if (mounted) {
//                           for (int i = 0; i < 2; i++) {
//                             Navigator.pop(context);
//                           }
//                         }
//                       });
//                     },

//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(300, 5),
//                 foregroundColor: tertiaryColor,
//                 backgroundColor: Colors.black,
//               ),
//               child: const Text('Done'),
//             ),
//           ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: ConfettiWidget(
//               confettiController: _confettiController,
//               blastDirection: pi /
//                   2, // radial value - 0 (right), PI/2 (down), PI (left), 3PI/2 (up)
//               emissionFrequency: 0.1,
//               numberOfParticles: 30,
//               gravity: 0.1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

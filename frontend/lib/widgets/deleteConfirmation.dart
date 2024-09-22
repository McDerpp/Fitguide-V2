import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/exercise.dart';
import 'package:frontend/services/workout.dart';
import 'package:frontend/widgets/dialog_box.dart';

void deleteConfirmation({
  required WidgetRef ref,
  required BuildContext context,
  required bool isExercise,
  required int id,
}) {
  showCustomDialog(
    widthMultiplier: 0.5,
    heightMultiplier: 0.15,
    context,
    Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isExercise == true
                ? "Do you really want to delete this workout?"
                : "Do you really want to delete this exercise?",
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .28,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 5),
                      foregroundColor: Colors.white,
                      backgroundColor: tertiaryColor,
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * .28,
                  child: ElevatedButton(
                    onPressed: () {
                      isExercise == false
                          ? WorkoutApiService.deleteWorkout(
                              ref: ref, workoutID: id)
                          : ExerciseApiService.deleteExercise(
                              ref: ref, exerciseID: id);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 5),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red[700],
                    ),
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

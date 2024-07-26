import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/coreFunctionality/globalVariables.dart';
import 'package:frontend/screens/coreFunctionality/provider_collection.dart';

class inferencingP1 extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> exerciseProgram;

  const inferencingP1({
    required this.exerciseProgram,
    super.key,
  });

  @override
  ConsumerState<inferencingP1> createState() => _inferencingP1State();
}

class _inferencingP1State extends ConsumerState<inferencingP1> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, double> textSize = ref.watch(textSizeModifier);
    return Scaffold(
      backgroundColor: mainColorState,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.075,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'NICE WORK!',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: secondaryColorState,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'You completed these exercises :',
              style: TextStyle(
                fontSize: 20.0,
                color: tertiaryColorState,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.exerciseProgram.length,
              itemBuilder: (context, index) {
                final exerciseDetail = widget.exerciseProgram[index];
                final String nameOfExercise = exerciseDetail['nameOfExercise'];
                final int setsNeeded = exerciseDetail['setsNeeded'];
                final int numberOfExecution =
                    exerciseDetail['numberOfExecution'];

                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: screenWidth * 0.15),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.2,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: tertiaryColorState,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        nameOfExercise,
                        style: TextStyle(
                          fontSize: (screenWidth * textSize["mediumText"]!),
                          fontWeight: FontWeight.w600,
                          color: secondaryColorState,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Container(
                            width: screenWidth * 0.15,
                            child: Text('Sets: $setsNeeded'),
                          ),
                          Container(
                            width: screenWidth * 0.15,
                            child: Text('Reps: $numberOfExecution'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MainView(),
                    //   ),
                    // );
                  },
                  child: const Text("Home"))
            ],
          ),
          SizedBox(
            height: screenHeight * 0.075,
          ),
        ],
      ),
    );
  }
}

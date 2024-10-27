import 'package:flutter/material.dart';

class musclePart extends StatefulWidget {
  final bool abs;
  final bool biceps;
  final bool calves;
  final bool chest;
  final bool forearms;
  final bool glutes;
  final bool hamstrings;
  final bool lowerBack;
  final bool lowerLeg;
  final bool middleBack;
  final bool quadriceps;
  final bool shoulder;
  final bool sideAbs;
  final bool traps;
  final bool triceps;

  const musclePart({
    super.key,
    this.abs = false,
    this.biceps = false,
    this.calves = false,
    this.chest = false,
    this.forearms = false,
    this.glutes = false,
    this.hamstrings = false,
    this.lowerBack = false,
    this.lowerLeg = false,
    this.middleBack = false,
    this.quadriceps = false,
    this.shoulder = false,
    this.sideAbs = false,
    this.traps = false,
    this.triceps = false,
  });

  @override
  State<musclePart> createState() => _musclePartState();
}

class _musclePartState extends State<musclePart> {
  Widget showImage(String partName, bool show) {
    return show
        ? Image.asset(
            height: MediaQuery.of(context).size.width * .75,
            width: MediaQuery.of(context).size.width * .75,
            'assets/muscles/${partName}.png',
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          showImage("abs", widget.abs),
          showImage("biceps", widget.biceps),
          showImage("calves", widget.calves),
          showImage("chest", widget.chest),
          showImage("forearm", widget.forearms),
          showImage("glutes", widget.glutes),
          showImage("hamstring", widget.hamstrings),
          showImage("lowerBack", widget.lowerBack),
          showImage("lowerLeg", widget.lowerLeg),
          showImage("middleBack", widget.middleBack),
          showImage("quadriceps", widget.quadriceps),
          showImage("shoulder", widget.shoulder),
          showImage("sideAbs", widget.sideAbs),
          showImage("traps", widget.traps),
          showImage("triceps", widget.triceps),
          showImage("base", true),
        ],
      ),
    );
  }
}

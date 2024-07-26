import 'package:flutter/material.dart';

import '../provider/main_settings.dart';

class poseError extends StatelessWidget {
  final double opacity;
  const poseError({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return IconButton(
      icon: Icon(
        Icons.accessibility_new_sharp,
        color: Colors.red,
        size: screenWidth * 0.08,
      ),
      onPressed: () {},
    );
  }
}

class luminanceError extends StatelessWidget {
  final double opacity;
  const luminanceError({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return IconButton(
      icon: Icon(
        Icons.lightbulb_circle,
        color: Colors.red,
        size: screenWidth * 0.08,
      ),
      onPressed: () {},
    );
  }
}

class noDisplay extends StatelessWidget {
  const noDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0,
      height: 0,
      color: Colors.transparent,
    );
  }
}








// Widget displayErrorPose(BuildContext context, double opacity) {
  // double screenWidth = MediaQuery.of(context).size.width;
  // double screenHeight = MediaQuery.of(context).size.height;
  // return IconButton(
  //   icon: Icon(
  //     Icons.accessibility_new_sharp,
  //     color: secondaryColor.withOpacity(opacity),
  //     size: screenWidth * 0.08,
  //   ),
  //   onPressed: () {
  //     setState(() {
  //       ref.watch(isPerforming.notifier).state = false;
  //     });
  //   },
  // );
// }

// Widget displayErrorPose2(BuildContext context, double opacity) {
  // double screenWidth = MediaQuery.of(context).size.width;
  // double screenHeight = MediaQuery.of(context).size.height;
  // return IconButton(
  //   icon: Icon(
  //     Icons.lightbulb_circle,
  //     color: ref.watch(secondaryColorState).withOpacity(opacity),
  //     size: screenWidth * 0.08,
  //   ),
  //   onPressed: () {
  //     setState(() {
  //       // nowPerforming = false;
  //     });
  //   },
  // );
// }

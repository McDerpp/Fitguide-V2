// import 'package:flutter/material.dart';

// class poseError extends StatelessWidget {
//   final double opacity;
//   const poseError({super.key, required this.opacity});

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return IconButton(
//       icon: Icon(
//         Icons.accessibility_new_sharp,
//         color: Colors.red,
//         size: screenWidth * 0.08,
//       ),
//       onPressed: () {},
//     );
//   }
// }

// class luminanceError extends StatelessWidget {
//   final double opacity;
//   const luminanceError({super.key, required this.opacity});

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return IconButton(
//       icon: Icon(
//         Icons.lightbulb_circle,
//         color: Colors.red,
//         size: screenWidth * 0.08,
//       ),
//       onPressed: () {},
//     );
//   }
// }

// class noDisplay extends StatelessWidget {
//   const noDisplay({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 0,
//       height: 0,
//       color: Colors.transparent,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/screens/dataCollection/create_exercise/data_collection_settings.dart';

class poseError extends StatelessWidget {
  final bool poseState;
  const poseError({super.key, required this.poseState});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return IconButton(
      icon: Icon(
        Icons.accessibility_new_sharp,
        // color: Colors.red.withOpacity(opacity),
        color:
            poseState ? Colors.red.withOpacity(1) : Colors.red.withOpacity(0),
        size: screenWidth * 0.08,
      ),
      onPressed: () {},
    );
  }
}

class luminanceError extends StatelessWidget {
  final double lumincanceVlue;
  const luminanceError({super.key, required this.lumincanceVlue});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return IconButton(
      icon: Icon(
        Icons.lightbulb_circle,
        color: lumincanceVlue < luminanceValueThreshold
            ? Colors.red.withOpacity(1.0)
            : Colors.red.withOpacity(0),
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

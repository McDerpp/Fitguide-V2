import 'package:flutter/material.dart';

class ExrciseCtr extends StatefulWidget {
  final int numofContainer;
  final int numofCompleted;
  const ExrciseCtr({
    super.key,
    required this.numofContainer,
    required this.numofCompleted,
  });

  @override
  State<ExrciseCtr> createState() => _ExrciseCtrState();
}

class _ExrciseCtrState extends State<ExrciseCtr> {
  Widget buildContainerList(
    int numofContainer,
    int numofCompleted,
    BuildContext context, {
    double spaceModifier = .8,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> containers = [];
    int ctr = 0;

    for (int i = 0; i < numofContainer; i++) {
      ctr++;
      if (ctr <= numofCompleted) {
        containers.add(
          Row(
            children: [
              containers.isNotEmpty
                  ? SizedBox(
                      width: ((screenWidth * spaceModifier) / numofContainer) *
                          .10,
                    )
                  : Container(),
              Container(
                width: ((screenWidth * spaceModifier) / numofContainer) * .90,
                height: (screenHeight * .010),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.07),
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        );
      } else {
        containers.add(
          Row(
            children: [
              containers.isNotEmpty
                  ? SizedBox(
                      width: ((screenWidth * spaceModifier) / numofContainer) *
                          .10,
                    )
                  : const SizedBox(
                      width: 0,
                    ),
              Container(
                width: ((screenWidth * spaceModifier) / numofContainer) * .90,
                height: (screenHeight * .015),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.07),
                  color: Colors.red,
                ),
              ),
            ],
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: containers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildContainerList(
        widget.numofContainer, widget.numofCompleted, context);
  }
}

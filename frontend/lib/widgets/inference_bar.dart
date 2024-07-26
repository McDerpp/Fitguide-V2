// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class ProgressBarWidget extends StatefulWidget {
  final double value;
  final Duration animationDuration;

  ProgressBarWidget({
    required this.value,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  _ProgressBarWidgetState createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // ignore: unused_field
  late Animation<double> _animation;
  double value = 80;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startProgressAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: FAProgressBar(
          animatedDuration: Duration(milliseconds: 100),
          currentValue: value,
        )),
        FAProgressBar(
          currentValue: value,
          displayText: '%',
          progressGradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.75),
              Colors.green.withOpacity(0.75),
            ],
          ),
        ),
        FAProgressBar(
          currentValue: value,
          size: 25,
          maxValue: 100,
          changeColorValue: 100,
          changeProgressColor: Colors.pink,
          backgroundColor: Colors.white,
          progressColor: Colors.lightBlue,
          animatedDuration: const Duration(milliseconds: 300),
          direction: Axis.horizontal,
          verticalDirection: VerticalDirection.up,
          displayText: 'mph',
          formatValueFixed: 2,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              value = (value == 70) ? 0 : 70;
            });
          },
          child: Text("data"),
        ),
      ],
    );
  }
}

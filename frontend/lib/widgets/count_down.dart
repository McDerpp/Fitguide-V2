import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/coreFunctionality/mainUISettings.dart';

class countDownTimer extends StatefulWidget {
  CountDownController controller;
  final Function(bool)? onChangeState;
  final bool isPerforming;

  bool isInference;
  countDownTimer({
    super.key,
    required this.controller,
    this.isInference = false,
    this.isPerforming = false,
    this.onChangeState,
  });

  @override
  State<countDownTimer> createState() => _countDownTimerState();
}

class _countDownTimerState extends State<countDownTimer> {
  Widget timerCountDown(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textSizeModif = (screenHeight + screenWidth) * textAdaptModifier;
    return Align(
      alignment: const Alignment(0.0, -0.2),
      child: CircularCountDownTimer(
        duration: currentDuration,
        initialDuration: 0,
        controller: widget.controller,
        width: MediaQuery.of(context).size.width / 1.10,
        height: MediaQuery.of(context).size.height / 1.10,
        ringColor: Colors.transparent,
        ringGradient: null,
        fillColor: Colors.white,
        fillGradient: null,
        backgroundColor: Colors.transparent,
        backgroundGradient: null,
        strokeWidth: screenWidth * .025,
        strokeCap: StrokeCap.round,
        textStyle: TextStyle(
            fontSize: 50.0 * textSizeModif,
            color: Colors.white,
            fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.S,
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: false,
        autoStart: true,
        onStart: () {},
        onComplete: () {
          widget.isInference == true
              ? widget.onChangeState!(false)
              : const SizedBox();
        },
        onChange: (String timeStamp) {},
        timeFormatterFunction: (defaultFormatterFunction, duration) {
          return Function.apply(defaultFormatterFunction, [duration]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isPerforming ? SizedBox() : timerCountDown(context);
  }
}

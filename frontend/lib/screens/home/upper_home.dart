import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/history/calendar_min.dart';

class UpperHome extends StatefulWidget {
  const UpperHome({super.key});

  @override
  State<UpperHome> createState() => _UpperHomeState();
}

class _UpperHomeState extends State<UpperHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: CalendarMin(),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/history/progress.dart';
import 'package:frontend/widgets/header.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          Column(
            children: [
              const Header(
                isNotif: false,
                isProfile: false,
              ),
              Expanded(
                child: Container(
                  child: DailyProgress(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

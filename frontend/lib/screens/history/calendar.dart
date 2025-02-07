import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/history/progress.dart';
import 'package:frontend/widgets/header.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> _highlightedDates = {
    DateTime.utc(2024, 8, 1),
    DateTime.utc(2024, 8, 1),
    DateTime.utc(2024, 8, 1),
  };

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

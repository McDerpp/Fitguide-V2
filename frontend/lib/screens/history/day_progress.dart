import 'package:flutter/material.dart';
import 'package:frontend/models/workoutsDone.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/workout/workout_card.dart';
import 'package:frontend/screens/workout/workout_card_done.dart';
import 'package:frontend/services/history.dart';
import 'package:frontend/widgets/progress_information.dart';
import 'package:frontend/widgets/spaceLine.dart';
import 'package:table_calendar/table_calendar.dart';

class DayProgress extends StatefulWidget {
  const DayProgress({super.key});

  @override
  State<DayProgress> createState() => _DayProgressState();
}

class _DayProgressState extends State<DayProgress> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<WorkoutDone> _workoutsFuture = [];
  List<dynamic> monthlyWorkoutNumber = [];
  int workoutDoneNum = 0;
  int exerciseDoneNum = 0;

  final Map<DateTime, Color> _dateColors = {};

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void updateInformation(DateTime selectedDay) async {
    _workoutsFuture = await HistoryApiService.getWorkoutsDone(
        year: selectedDay.year, month: selectedDay.month, day: selectedDay.day);
    workoutDoneNum = _workoutsFuture.length;
    setState(() {});
  }

  void addDateColor(DateTime date, Color color) {
    _dateColors[date] = color;
  }

  Future<List<DateTime>> _getDays(DateTime focusedDay) async {
    workoutDoneNum = 0;
    exerciseDoneNum = 0;
    Color dayColor = Colors.green;
    Color dayColor1 = Colors.red.shade300;
    Color dayColor2 = Colors.red.shade500;
    Color dayColor3 = Colors.red.shade800;

    final List<DateTime> days = [];
    final startOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final endOfMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    monthlyWorkoutNumber = await HistoryApiService.getWorkoutsDoneNumberMonthly(
        year: focusedDay.year, month: focusedDay.month);

    for (dynamic test in monthlyWorkoutNumber) {
      if (test["count"] >= 8) {
        dayColor = dayColor3;
      } else if (test["count"] > 3 && test["count"] <= 7) {
        dayColor = dayColor2;
      } else if (test["count"] <= 3) {
        dayColor = dayColor1;
      }
      ;

      addDateColor(
          DateTime.utc(
            DateTime.parse(test["day"]).year,
            DateTime.parse(test["day"]).month,
            DateTime.parse(test["day"]).day,
          ),
          dayColor);
    }

    var currentDay = startOfMonth;

    while (currentDay.isBefore(endOfMonth.add(Duration(days: 1)))) {
      days.add(currentDay);
      currentDay = currentDay.add(Duration(days: 1));
    }
    setState(() {});
    return days;
  }

  @override
  void initState() {
    super.initState();
    _getDays(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: mainColor,
        body: Column(
          children: [
            Container(
              color: mainColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Padding(
                      child: Column(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Daily Workout Done",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            workoutDoneNum.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Padding(
                      child: Column(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Daily Time\nSpent    ",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            workoutDoneNum.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Padding(
                      child: Column(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Daily Calorie Burned",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            "0",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            spaceLine(context),
            Container(
              height: 265,
              child: SingleChildScrollView(
                child: Column(
                  children: _workoutsFuture.map(
                    (workoutDone) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: WorkoutCardDone(
                          performedAt: workoutDone.performeAt,
                          workout: workoutDone.workout,
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 250,
              child: TableCalendar(
                rowHeight: 32,
                daysOfWeekHeight: 20,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return _isSameDay(_selectedDay ?? DateTime.now(), day);
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  updateInformation(selectedDay);
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                  _getDays(focusedDay);
                },
                calendarStyle: const CalendarStyle(
                  cellMargin: EdgeInsets.all(2), //
                  defaultTextStyle:
                      TextStyle(fontSize: 14, color: Colors.white), //
                  weekendTextStyle:
                      TextStyle(fontSize: 14, color: Colors.red), //
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontSize: 14, color: Colors.white), //
                  weekendStyle: TextStyle(fontSize: 14, color: Colors.red), //
                ),
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle:
                      TextStyle(fontSize: 12, color: Colors.white), //
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final color = _dateColors[day];
                    if (color != null) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color, // Set color for specific dates
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return null;
                  },
                  // selectedBuilder: (context, day, focusedDay) {
                  //   return Container(
                  //     margin: const EdgeInsets.all(6.0),
                  //     alignment: Alignment.center,
                  //     decoration: const BoxDecoration(
                  //       color: Colors.orange,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Text(
                  //       '${day.day}',
                  //       style: const TextStyle(color: Colors.white),
                  //     ),
                  //   );
                  // },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

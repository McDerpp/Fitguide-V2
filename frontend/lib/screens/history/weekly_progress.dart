// import 'package:flutter/material.dart';
// import 'package:frontend/provider/main_settings.dart';
// import 'package:frontend/widgets/progress_information.dart';
// import 'package:table_calendar/table_calendar.dart';

// class WeeklyProgress extends StatefulWidget {
//   const WeeklyProgress({super.key});

//   @override
//   State<WeeklyProgress> createState() => _WeeklyProgressState();
// }

// class _WeeklyProgressState extends State<WeeklyProgress> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   late DateTime _startOfWeek;
//   late DateTime _endOfWeek;

//   void _updateWeekRange() {
//     _startOfWeek =
//         _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
//     _endOfWeek = _startOfWeek.add(Duration(days: 6));
//     _printDaysInRange();
//   }

//   void _printDaysInRange() {
//     DateTime currentDay = _startOfWeek;
//     print('Days in the range:');
//     while (currentDay.isBefore(_endOfWeek.add(Duration(days: 1)))) {
//       print(currentDay.toLocal());
//       currentDay = currentDay.add(Duration(days: 1));
//     }
//   }

//   void _printSelectedWeekDays(DateTime selectedDay) {
//     DateTime startOfWeek =
//         selectedDay.subtract(Duration(days: selectedDay.weekday - 1));
//     DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

//     print('Selected Week:');
//     for (int i = 0; i < 7; i++) {
//       DateTime day = startOfWeek.add(Duration(days: i));
//       print(day.toLocal());
//     }
//   }

//   void _onMonthChanged(DateTime month) {
//     print('Month changed to: ${month.year}-${month.month}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               color: mainColor,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Column(
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: tertiaryColor,
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '   Monthly :',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Spacer(),
//                                     information(
//                                         name: "Workout",
//                                         name2: "Done",
//                                         value: "5",
//                                         icon: Icons.fitness_center),
//                                     Spacer(),
//                                     information(
//                                         name: "Exercise",
//                                         name2: "Done",
//                                         value: "5",
//                                         icon: Icons.fitness_center),
//                                     Spacer(),
//                                     information(
//                                         name: "Calories",
//                                         name2: "Burned",
//                                         value: "5",
//                                         icon: Icons.fitness_center),
//                                     Spacer(),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 50,
//               left: 10,
//               right: 10,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: tertiaryColor,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 height: 150,
//                 child: TableCalendar(
//                   rowHeight: 32,
//                   daysOfWeekHeight: 0,
//                   firstDay: DateTime.utc(2020, 1, 1),
//                   lastDay: DateTime.utc(2030, 12, 31),
//                   focusedDay: _focusedDay,
//                   selectedDayPredicate: (day) {
//                     return _selectedDay != null && _selectedDay!.isSameDay(day);
//                   },
//                   calendarFormat: CalendarFormat.week,
//                   onFormatChanged: (format) {
//                     setState(() {});
//                   },
//                   onDaySelected: (selectedDay, focusedDay) {
//                     setState(() {
//                       _selectedDay = selectedDay;
//                       _focusedDay = focusedDay;
//                       _updateWeekRange();
//                     });
//                     _printSelectedWeekDays(selectedDay);
//                   },
//                   calendarStyle: CalendarStyle(
//                     cellMargin: EdgeInsets.zero,
//                     defaultTextStyle:
//                         TextStyle(fontSize: 14, color: Colors.white),
//                     weekendTextStyle:
//                         TextStyle(fontSize: 14, color: Colors.red),
//                     selectedDecoration: BoxDecoration(
//                         color: Colors.orange, shape: BoxShape.circle),
//                     todayDecoration: BoxDecoration(color: Colors.transparent),
//                   ),
//                   daysOfWeekStyle: DaysOfWeekStyle(
//                     weekdayStyle: TextStyle(fontSize: 14, color: Colors.white),
//                     weekendStyle: TextStyle(fontSize: 14, color: Colors.red),
//                   ),
//                   headerStyle: HeaderStyle(
//                     titleCentered: true,
//                     formatButtonVisible: false,
//                     titleTextStyle:
//                         TextStyle(fontSize: 15, color: Colors.white),
//                   ),
//                   calendarBuilders: CalendarBuilders(
//                     defaultBuilder: (context, day, focusedDay) {
//                       if (day.isAfter(
//                               _startOfWeek.subtract(Duration(days: 1))) &&
//                           day.isBefore(_endOfWeek.add(Duration(days: 1)))) {
//                         return Container(
//                           margin: const EdgeInsets.all(6.0),
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Text(
//                             '${day.day}',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         );
//                       }
//                       return null;
//                     },
//                     selectedBuilder: (context, day, focusedDay) {
//                       return Container(
//                         margin: const EdgeInsets.all(6.0),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: Colors.orange,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           '${day.day}',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       );
//                     },
//                   ),
//                   onPageChanged: (focusedDay) {
//                     setState(() {
//                       _focusedDay = focusedDay;
//                       _updateWeekRange();
//                     });
//                     _onMonthChanged(
//                         DateTime(focusedDay.year, focusedDay.month));
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// extension DateTimeComparison on DateTime {
//   bool isSameDay(DateTime other) {
//     return year == other.year && month == other.month && day == other.day;
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/history.dart';
import 'package:intl/intl.dart';

class CalendarMin extends StatefulWidget {
  const CalendarMin({super.key});

  @override
  State<CalendarMin> createState() => _CalendarMinState();
}

class _CalendarMinState extends State<CalendarMin> {
  final ScrollController _scrollController = ScrollController();

  late List<dynamic> dateInfo;
  late DateTime lastDay;
  List<int> temp = [25, 2, 3, 1, 3, 2, 4];
  int maxValue = 0;
  int barModif = 0;

  Map<int, Map<String, dynamic>> tempData = {};
  Map<int, Map<String, dynamic>> finalData = {};

  @override
  void initState() {
    super.initState();
    initDateInfo();
  }

  void scrollToCurrent() {
    _scrollController.animateTo(
      MediaQuery.of(context).size.width * 0.9 / 7 * DateTime.now().day,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> initDateInfo() async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateFormat dayFormat = DateFormat('EEE');
    DateTime temp = DateTime.now();
    DateTime filler = DateTime.now();

    int dayTemp = 0;

    dateInfo = await HistoryApiService.getWorkoutsDoneNumberMonthly(
        year: DateTime.now().year, month: DateTime.now().month);

    for (var data in dateInfo) {
      if (data['count'] > maxValue) {
        maxValue = data['count'];
      }
      Map<String, dynamic> valueInit = {'count': 1, 'day': 'Mon'};
      temp = DateTime.parse(data["day"]);
      dayTemp = DateTime.parse(data["day"]).day;
      valueInit['count'] = data['count'];
      valueInit['day'] = dayFormat.format(temp);
      tempData[temp.day] = valueInit;
    }

    lastDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
        .subtract(Duration(days: 1));
    for (int ctr = 1; ctr < lastDay.day + 1; ctr++) {
      Map<String, dynamic> valueInit = {'count': 1, 'day': 'Mon'};

      if (tempData.containsKey(ctr)) {
        finalData[ctr] = tempData[ctr]!;
      } else {
        filler = DateTime(DateTime.now().year, DateTime.now().month, ctr);
        valueInit = {'count': 0, 'day': dayFormat.format(filler)};
        finalData[ctr] = valueInit;
      }
    }
    print("finalData-->$finalData");
    setState(() {});
  }

  Widget dayBar() {
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month);
    return Column(
      children: [
        GestureDetector(
          child: Text(
            DateFormat('MMMM').format(date),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            scrollToCurrent();
          },
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: finalData.entries.map((entry) {
                double containerHeight =
                    (MediaQuery.of(context).size.height * .06) *
                            (entry.value['count'] / maxValue) +
                        MediaQuery.of(context).size.height * .02;
                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .9 / 7,
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(),
                      child: Center(
                        child: Text(
                          entry.key.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * .9 / 7,
                      height: containerHeight,
                      decoration: BoxDecoration(
                        color: entry.key == DateTime.now().day
                            ? Colors.amber
                            : tertiaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          entry.value['count'].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .9 / 7,
                      child: Center(
                        child: Text(
                          entry.value['day'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    scrollToCurrent();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                child: dayBar(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

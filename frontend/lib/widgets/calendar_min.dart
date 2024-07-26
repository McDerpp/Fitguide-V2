import 'dart:math';

import 'package:flutter/material.dart';

class CalendarMin extends StatefulWidget {
  const CalendarMin({super.key});

  @override
  State<CalendarMin> createState() => _CalendarMinState();
}

class _CalendarMinState extends State<CalendarMin> {
  List<int> temp = [2, 2, 3, 1, 3, 2, 4];
  double height = 50;
  double width = 180;
  int maxValue = 0;
  int barModif = 0;

  Map<String, int> dayContent = {
    'Mon': 0,
    'Tue': 0,
    'Wed': 0,
    'Thu': 0,
    'Fri': 0,
    'Sat': 0,
    'Sun': 0,
  };

  Map<String, int> datesList = {
    'Mon': 1,
    'Tue': 2,
    'Wed': 3,
    'Thu': 4,
    'Fri': 5,
    'Sat': 6,
    'Sun': 7,
  };

  void initDayContent() {
    maxValue = temp.reduce(max);

    dayContent = {
      'Mon': temp[0],
      'Tue': temp[1],
      'Wed': temp[2],
      'Thu': temp[3],
      'Fri': temp[4],
      'Sat': temp[5],
      'Sun': temp[6],
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDayContent();
  }

  List<Widget> dayBar(Map<String, int> map) {
    return map.entries.map((entry) {
      // Calculate height based on entry.value
      double containerHeight = (height - 10) * (entry.value / maxValue) + 10;

      return Column(
        children: [
          Container(
            width: width / 8,
            height: containerHeight,
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            decoration: const BoxDecoration(
              color: Colors.white, // Ensure Colors.white is defined

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      color: Colors.black, // Ensure tertiaryColor is defined
                      fontSize: 10,
                    ),
                  ),
                )
                // Add more child widgets as needed
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  List<Widget> days(Map<String, int> map) {
    return map.entries.map((entry) {
      return Column(
        children: [
          Container(
            width: width / 8,
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            decoration: const BoxDecoration(),
            child: Center(
              child: Text(
                entry.key,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<Widget> dates(Map<String, int> map) {
    return map.entries.map(
      (entry) {
        return Column(
          children: [
            Container(
              width: width / 8,
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              decoration: const BoxDecoration(),
              child: Center(
                child: Text(
                  entry.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "  Progress Report",
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontSize: 18,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
        const SizedBox(
          height: 5,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            // color: miscColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    height: 60,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fitness_center,
                                color: Colors.white,
                                size: 12.0,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Workout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "25",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                " done",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    height: 60,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer,
                                color: Colors.white,
                                size: 12.0,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Time",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "25",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                " Hr/s",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 100,
                width: 2,
                child: const SizedBox(),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                height: height + 75,
                width: width + 25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'March',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: dates(datesList),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: dayBar(dayContent),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: const SizedBox(),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: days(dayContent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

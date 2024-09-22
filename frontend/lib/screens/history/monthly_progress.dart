import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/services/history.dart';
import 'package:frontend/widgets/spaceLine.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyChart extends StatefulWidget {
  const MonthlyChart({super.key});

  @override
  State<MonthlyChart> createState() => _MonthlyChartState();
}

class _MonthlyChartState extends State<MonthlyChart> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Color> gradientColors = [
    Colors.white,
    Colors.white,
  ];
  DateTime _currentMonth = DateTime.now();
  List<dynamic> monthlyWorkoutNumber = [];
  List<FlSpot> valueGraph = [];
  double maxGraphValue = 0;

  bool showAvg = false;

  final Set<DateTime> _highlightedDates = {
    DateTime.utc(2024, 8, 1),
  };

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onMonthChanged(DateTime month) {
    print('Month changed to: ${month.year}-${month.month}');
  }

  Future<List<DateTime>> _getDays(DateTime focusedDay) async {
    final List<DateTime> days = [];
    valueGraph = [];
    maxGraphValue = 0;

    final endOfMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    // Initialize valueGraph with zeros
    for (int day = 1; day <= endOfMonth.day; day++) {
      valueGraph.add(FlSpot(day.toDouble(), 0));
    }

    monthlyWorkoutNumber = await HistoryApiService.getWorkoutsDoneNumberMonthly(
        year: focusedDay.year, month: focusedDay.month);

    for (var test in monthlyWorkoutNumber) {
      final day = DateTime.parse(test["day"]).day;
      final count = test["count"].toDouble();

      if (count > maxGraphValue) {
        maxGraphValue = count;
      }

      valueGraph[day - 1] = FlSpot(day.toDouble(), count);
    }

    print("valueGraph-->${valueGraph[0]}");

    for (int day = 1; day <= endOfMonth.day; day++) {
      days.add(DateTime(focusedDay.year, focusedDay.month, day));
    }

    setState(() {});

    return days;
  }

  @override
  void initState() {
    super.initState();
    _getDays(_focusedDay);
  }

  Widget information(String name, String value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              name,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return Text(value.toInt().toString(),
        style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      // this should be the number of days in a month
      maxX: 31,
      minY: 0,
      // this should be the max number of of workout in the month
      maxY: maxGraphValue.toDouble() + 2.0,
      lineBarsData: [
        LineChartBarData(
          spots: valueGraph,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget tableInformation() {
    return AspectRatio(
      aspectRatio: 2.0,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 12,
          bottom: 12,
        ),
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  Widget monthlyInformation() {
    return Column(
      children: [
        Container(
          child: Text(
            "Monthly Workout Performance",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        Row(
          children: [
            Spacer(),
            information("Monthly Workout Done", "0"),
            Spacer(),
            information("Monthly Time Spent", "0"),
            Spacer(),
            information("Monthly Calories Burned", "0"),
            Spacer(),
          ],
        ),
      ],
    );
  }

  Widget monthAverageInformation() {
    return Column(
      children: [
        Container(
          child: Text(
            "Monthly Average Performance",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        Row(
          children: [
            Spacer(),
            information("Average Workout Done", "0"),
            Spacer(),
            information("Average Time Spent", "0"),
            Spacer(),
            information("Average Calories Burned", "0"),
            Spacer(),
          ],
        ),
      ],
    );
  }

  Widget monthlyExerciseKind() {
    return Column(
      children: [
        Container(
          child: Text(
            "Exercise Count",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Spacer(),
                information("Neck", "0"),
                Spacer(),
                information("Traps", "0"),
                Spacer(),
                information("Shoulder", "0"),
                Spacer(),
              ],
            ),
            Row(
              children: [
                Spacer(),
                information("Chest", "0"),
                Spacer(),
                information("Biceps", "0"),
                Spacer(),
                information("Forearms", "0"),
                Spacer(),
              ],
            ),
            Row(
              children: [
                Spacer(),
                information("Abs", "0"),
                Spacer(),
                information("Quadriceps", "0"),
                Spacer(),
                information("Calves", "0"),
                Spacer(),
              ],
            ),
            Row(
              children: [
                Spacer(),
                information("Upper Back", "0"),
                Spacer(),
                information("Triceps", "0"),
                Spacer(),
                information("Lower Back", "0"),
                Spacer(),
              ],
            ),
            Row(
              children: [
                Spacer(),
                information("Glutes", "0"),
                Spacer(),
                information("Hamstrings", "0"),
                Spacer(),
                information("Others", "0"),
                Spacer(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget calenderControl() {
    return Container(
      decoration: BoxDecoration(
        color: tertiaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 65,
      child: TableCalendar(
        rowHeight: 0,
        daysOfWeekHeight: 0,
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
          print("Selected day: $selectedDay");
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
            if (_currentMonth.month != focusedDay.month ||
                _currentMonth.year != focusedDay.year) {
              _currentMonth = DateTime(focusedDay.year, focusedDay.month);
              _onMonthChanged(_currentMonth);
            }
            _getDays(_focusedDay);
          });
        },
        calendarStyle: const CalendarStyle(
          cellMargin: EdgeInsets.all(2), //
          defaultTextStyle: TextStyle(fontSize: 14, color: Colors.white), //
          weekendTextStyle: TextStyle(fontSize: 14, color: Colors.white), //
          selectedDecoration:
              BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: 14, color: Colors.white), //
          weekendStyle: TextStyle(fontSize: 14, color: Colors.white), //
        ),
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(fontSize: 15, color: Colors.white), //
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            for (DateTime highlightedDate in _highlightedDates) {
              if (_isSameDay(day, highlightedDate)) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
            }
            return null;
          },
          selectedBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(6.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      tableInformation(),
                      spaceLine(context),
                      monthlyInformation(),
                      spaceLine(context),
                      monthAverageInformation(),
                      spaceLine(context),
                      monthlyExerciseKind(),
                      spaceLine(context),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              calenderControl(),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/history/day_progress.dart';
import 'package:frontend/screens/history/monthly_progress.dart';
import 'package:frontend/widgets/name_indicator.dart';

class DailyProgress extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: NameIndicator(
                controller: _pageController,
                names: const ["Today", "Monthly"],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: PageView(
                controller: _pageController,
                children: <Widget>[
                  DayProgress(),
                  MonthlyChart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

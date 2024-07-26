import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';

class NameIndicator extends StatefulWidget {
  final PageController controller;
  final List<String> names;

  NameIndicator({required this.controller, required this.names});

  @override
  _NameIndicatorState createState() => _NameIndicatorState();
}

class _NameIndicatorState extends State<NameIndicator> {
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        currentPage =
            widget.controller.page ?? widget.controller.initialPage.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.names.asMap().entries.map((entry) {
        int index = entry.key;
        String name = entry.value;
        bool isSelected = index == currentPage.round();
        return Text(
          name,
          style: TextStyle(
            fontSize: isSelected ? 20 : 18,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
            color: isSelected ? secondaryColor : Colors.grey,
          ),
        );
      }).toList(),
    );
  }
}

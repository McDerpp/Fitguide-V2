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
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.names.asMap().entries.map(
          (entry) {
            int index = entry.key;
            String name = entry.value;
            bool isSelected = index == currentPage.round();
            return Expanded(
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? tertiaryColor : miscColor,
                    borderRadius: index != 0 && index != widget.names.length - 1
                        ? null
                        : BorderRadius.only(
                            topLeft: Radius.circular(
                                widget.names.length - 1 == index ? 0 : 10),
                            bottomLeft: Radius.circular(
                                widget.names.length - 1 == index ? 0 : 10),
                            topRight: Radius.circular(index == 0 ? 0 : 10),
                            bottomRight: Radius.circular(index == 0 ? 0 : 10),
                          ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w300,
                          color: isSelected ? secondaryColor : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  print("index-->$index");
                  widget.controller.animateToPage(
                    index,
                    duration: Duration(
                        milliseconds: 300), // Adjust duration as needed
                    curve: Curves.easeInOut, // Adjust curve as needed
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

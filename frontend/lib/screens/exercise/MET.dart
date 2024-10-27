import 'package:flutter/material.dart';
import 'package:frontend/provider/main_settings.dart';
import 'package:frontend/screens/exercise/METList.dart';

class MET extends StatefulWidget {
  final Function(String) intensity;
  final Function(double) met;

  const MET({
    super.key,
    required this.intensity,
    required this.met,
  });

  @override
  _METState createState() => _METState();
}

class _METState extends State<MET> {
  final ScrollController _controller = ScrollController();
  int _selectedIndex = 0;
  final double itemWidth = 15.0;

  void _onScrollEnd() {
    final centerOffset = MediaQuery.of(context).size.width / 2.32;
    final index = ((_controller.offset + centerOffset) / itemWidth).round();

    setState(() {
      _selectedIndex = index.clamp(0, 221);
    });

    _controller.animateTo(
      _selectedIndex * itemWidth - centerOffset + (itemWidth / 2),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    widget.met((index - 10) / 10);
    widget.intensity(intensityGuage((_selectedIndex - 10) / 10));
  }

  String intensityGuage(double MET) {
    if (MET <= 5)
      return "Easy";
    else if (MET <= 10)
      return "Normal";
    else if (MET <= 15)
      return "Hard";
    else if (MET <= 20) return "Advance";

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 70,
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              " ${METCompendium.metList[(_selectedIndex - 10) / 10]}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 65, // Adjust height if necessary
          width: MediaQuery.of(context).size.width,
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              _onScrollEnd();
              return true;
            },
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: 221,
              itemBuilder: (context, index) {
                double height;
                if (index % 10 == 0) {
                  height = 50;
                } else if (index % 5 == 0) {
                  height = 35;
                } else {
                  height = 25;
                }
                return Container(
                  width: itemWidth,
                  height: 50,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            index > 9 && index < 211
                                ? Text(
                                    index % 10 == 0
                                        ? "${((index - 9) / 10).toInt()}"
                                        : "",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200),
                                  )
                                : SizedBox(),
                            Spacer(),
                            Container(
                              height: height,
                              width: 3,
                              decoration: index > 9 && index < 211
                                  ? BoxDecoration(
                                      color: _selectedIndex == index
                                          ? secondaryColor
                                          : Colors.white,
                                      border: Border.all(
                                          color: _selectedIndex == index
                                              ? secondaryColor
                                              : Colors.white),
                                    )
                                  : BoxDecoration(
                                      color: mainColor,
                                      border: Border.all(color: mainColor),
                                    ),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Icon(
          size: 50,
          Icons.arrow_drop_up_rounded,
          color: secondaryColor,
        ),
        Text(
          textAlign: TextAlign.center,
          "${(_selectedIndex - 10) / 10}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          textAlign: TextAlign.center,
          "( ${intensityGuage((_selectedIndex - 10) / 10)} )",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );
  }
}

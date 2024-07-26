import 'package:flutter/material.dart';

Widget buildElevatedButton({
  required BuildContext context,
  required String label,
  required Map<String, dynamic> colorSet,
  required double textSizeModifierIndividual,
  required Function func,
  bool isCustom = false,
  optionalModif = 0.8,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  dynamic textsize = textSizeModifierIndividual;
  textsize = textsize * screenWidth;

  dynamic buttonSizeX = screenWidth * 0.35 * optionalModif;
  dynamic buttonSizeY = screenHeight * 0.008 * optionalModif;

  Size minSize = Size(buttonSizeX, buttonSizeY);

  return Padding(
    padding: EdgeInsets.only(
      left: 0.05 * buttonSizeX,
      right: 0.05 * buttonSizeX,
      top: 0.05 * buttonSizeX,
      bottom: 0.05 * buttonSizeX,
    ),
    child: Align(
      alignment: const Alignment(1.0, 0.8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isCustom ? colorSet['tertiaryColor'] : null,
          fixedSize: minSize,
        ),
        onPressed: () {
          func();
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: textsize,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/provider/main_settings.dart';

class InputField extends StatelessWidget {
  String inputName;
  TextEditingController textController;
  bool obscureText;
  bool isParagraph;
  bool isNumber;
  bool isEnabled;

  InputField({
    super.key,
    required this.inputName,
    required this.textController,
    this.obscureText = false,
    this.isParagraph = false,
    this.isNumber = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          inputName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w100,
            fontSize: 14,
          ),
        ),
        Container(
            decoration: BoxDecoration(
              color: mainColor,
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            height: isParagraph ? 150 : 45,
            width: MediaQuery.of(context).size.width * 0.9,
            child: isParagraph
                ? TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(500),
                    ],
                    enabled: isEnabled,
                    obscureText: obscureText,
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText:
                          "Give an instruction 500 characters maximum (OPTIONAL)",
                    ),
                  )
                : TextField(
                    enabled: isEnabled,
                    obscureText: obscureText,
                    controller: textController,
                    inputFormatters: isNumber
                        ? [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(36),
                          ]
                        : [
                            LengthLimitingTextInputFormatter(36),
                          ],
                    keyboardType: isNumber ? TextInputType.number : null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  )),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

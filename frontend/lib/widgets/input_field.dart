import 'package:flutter/material.dart';

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
            fontSize: 14,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          height: isParagraph ? 150 : 38,
          width: MediaQuery.of(context).size.width * 0.9,
          child: !isParagraph
              ? TextField(
                  enabled: isEnabled,
                  obscureText: obscureText,
                  controller: textController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                )
              : TextField(
                  enabled: isEnabled,
                  obscureText: obscureText,
                  controller: textController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null, // Allow unlimited lines
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Give an instruction (OPTIONAL)",
                  ),
                ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

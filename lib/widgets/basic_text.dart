import 'package:flutter/material.dart';

class BasicText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  const BasicText({
    super.key, required this.text, required this.fontSize, required this.color, required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'CustomFont',
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
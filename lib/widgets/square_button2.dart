import 'package:flutter/material.dart';

class SquareButton2 extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;

  const SquareButton2({super.key, required this.color, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          minimumSize: const Size(200, 80),
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 50, fontFamily: 'CustomFont', fontWeight: FontWeight.w600),),
      ),
    );
  }
}

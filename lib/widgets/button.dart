import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final IconData image;
  final VoidCallback onPressed;

  const Button ({
    super.key, required this.image, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          minimumSize: const Size(100, 100),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.black,
          shape: const CircleBorder(side: BorderSide(color: Colors.black, width: 2)),
        ),
        onPressed: onPressed,
        child: Icon(image, size: 60,),
      ),
    );
  }
}
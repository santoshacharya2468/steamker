// @dart=2.9
import 'package:flutter/material.dart';

import 'colors.dart';

class MainButton extends StatelessWidget {
  final double height;
  final double width;
  final Function onPressed;
  final String text;
  final double fontSize;
  MainButton({
    this.onPressed,
    this.text,
    this.height = 40,
    this.width = 120,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: pink,
        ),
        child: Center(
          child: Text(text,
              style: TextStyle(color: Colors.white, fontSize: fontSize)),
        ),
      ),
    );
  }
}

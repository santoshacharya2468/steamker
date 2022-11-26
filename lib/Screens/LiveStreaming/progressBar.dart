import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: Center(
        child: CircularProgressIndicator(
            backgroundColor: Colors.pink, strokeWidth: 4),
      ),
    );
  }
}

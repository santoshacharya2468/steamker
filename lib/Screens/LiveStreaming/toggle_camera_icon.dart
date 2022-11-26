// @dart=2.9
import 'package:flutter/material.dart';

class ToggleCamera extends StatelessWidget {
  final Function onToggle;
  ToggleCamera({@required this.onToggle});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        height: 40,
        width: 40,
        decoration:
            BoxDecoration(color: Colors.grey[900], shape: BoxShape.circle),
        child: Icon(Icons.switch_camera_rounded, color: Colors.white),
      ),
    );
  }
}

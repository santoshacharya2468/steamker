import 'package:flutter/material.dart';
import 'package:streamkar/utils/colors.dart';

class FollowButton extends StatelessWidget {
  ///id of the user to be followed by current user
  final String userId;
  final double height;
  final double width;
  FollowButton(this.userId, {this.height = 30, this.width = 90});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          //  gradient: gradient,
          color: purple,
          borderRadius: BorderRadius.circular(height / 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Text(
            'Follow',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

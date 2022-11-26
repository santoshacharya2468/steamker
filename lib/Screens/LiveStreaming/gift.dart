// @dart=2.9
import 'package:flutter/material.dart';

class Gift {
  String name;
  Widget icon;
  String image;
  int points;
  String sentBy;
  Gift({this.name, this.icon, this.points, this.sentBy, this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'points': this.points,
      'sentBy': this.sentBy,
    };
  }
}

// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';

class PkDetails {
  ///durations of pk in minutes like 5min,2 min etc;
  int pkTime = 5;
  DateTime startedAt = DateTime.now();
  DateTime endAt = DateTime.now().add(Duration(minutes: 5));
  bool pkStarted = true;

  bool pkEnded = true;
  String winerId = "";
  int numberOfRounds = 1;
  bool isDraw = true;
  PkDetails(
      {this.pkTime,
      this.startedAt,
      this.endAt,
      this.pkStarted,
      this.pkEnded,
      this.winerId,
      this.numberOfRounds,
      this.isDraw});
  PkDetails.fromMap(Map<String, dynamic> map) {
    this.pkTime = map['pkTime'];
    if (map['startedAt'] != null) {
      this.startedAt = (map['startedAt'] as Timestamp).toDate();
      this.endAt = (map['endAt'] as Timestamp).toDate();
      pkStarted = true;
    } else {
      pkStarted = false;
    }
    this.pkEnded = map['pkEnded'] ?? false;
    this.winerId = map['winnerId'];
    this.isDraw = map['isDraw'] ?? false;
  }
  Map<String, dynamic> toMap() {
    return {
      'pkTime': this.pkTime,
      'startedAt': this.startedAt,
      'endAt': this.endAt,
      'pkEnded': this.pkEnded ?? false,
      'winnerId': this.winerId,
      'isDraw': this.isDraw ?? false,
    };
  }
}

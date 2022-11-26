// @dart=2.9

import 'package:streamkar/Models/userModel.dart';

class SquadsCard {
  String id;
  String image;
  DateTime time;
  String name;
  String description;
  List<SquadMember> members;
  List<Status> status;
  List<String> joinRequests;
  int points;

  SquadsCard({
    this.id,
    this.image,
    this.time,
    this.name,
    this.description,
    this.members,
    this.status,
    this.points,
    this.joinRequests,
  });
}

class SquadMember {
  String userId;
  String type;
  SquadMember({
    this.userId,
    this.type,
  });
}

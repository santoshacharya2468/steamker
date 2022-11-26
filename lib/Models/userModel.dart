// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelSettings {
  Map<String, bool> appAlerts;
  Map<String, bool> roomEffects;
  String language;
  Map<String, dynamic> inbox;
  UserModelSettings({
    this.appAlerts,
    this.roomEffects,
    this.language,
    this.inbox,
  });
}

class UserModel {
  String id;
  String name;
  String description;
  String gender;
  String place;
  String photoURL;
  String equipedItem;
  String email;
  int phone;
  bool isLoggedIn;
  DateTime dob;
  UserModelSettings settings;
  int beans;
  int diamonds;

  List<Badge> badges;
  List<Baggage> baggages;
  List<FeedBack> feedbacks;
  List<Moments> moments;
  List<Status> status;
  List<Connection> connection;
  UserModel({
    this.id,
    this.name,
    this.description,
    this.gender,
    this.place,
    this.photoURL,
    this.equipedItem,
    this.email,
    this.phone,
    this.isLoggedIn,
    this.dob,
    this.baggages,
    this.badges,
    this.feedbacks,
    this.moments,
    this.status,
    this.settings,
    this.beans,
    this.diamonds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        gender: json["gender"],
        phone: json["phone"],
        place: json["place"],
        photoURL: json["photoUrl"],
        equipedItem: json["equipedItem"],
        email: json["email"],
        isLoggedIn: json["isLoggedIn"],
        // dob: (json["dob"] as Timestamp).toDate(),
        // badges: json["badges"],
        // baggages: json["baggages"],
        // feedbacks: json["feedbacks"],
        // moments: json["moments"],
        // settings: json["settings"],
        // status: json["status"],
      );
}

class Badge {
  String id;
  String category;
  String image;
  String name;
  String type;
  Badge({
    this.id,
    this.category,
    this.image,
    this.name,
    this.type,
  });
}

class Connection {
  String type;
  String userID;
  Connection({
    this.type,
    this.userID,
  });
}

class Baggage {
  String id;
  String category;
  String image;
  String name;
  String description;
  int time;
  int value;
  Baggage({
    this.id,
    this.category,
    this.image,
    this.name,
    this.description,
    this.time,
    this.value,
  });
}

class FeedBack {
  String id;
  String contact;
  String description;
  String raisedBy;
  String type;
  bool resolution;
  DateTime time;

  FeedBack({
    this.id,
    this.contact,
    this.description,
    this.raisedBy,
    this.type,
    this.resolution,
    this.time,
  });
}

class Moments {
  String id;
  String image;
  DateTime time;
  Moments({
    this.id,
    this.image,
    this.time,
  });
}

class Status {
  String id;
  List<dynamic> image;
  String description;
  String userID;
  DateTime time;

  List<Reports> reports;
  List<Comments> comments;
  List<Likes> likes;

  Status({
    this.id,
    this.image,
    this.description,
    this.userID,
    this.time,
    this.reports,
    this.comments,
    this.likes,
  });
}

class Reports {
  String id;
  String reason;
  Reports({
    this.id,
    this.reason,
  });
}

class Likes {
  String id;
  DateTime time;
  Likes({
    this.id,
    this.time,
  });
}

class Comments {
  String id;
  String userID;
  DateTime time;
  String comment;
  int likes;
  Comments({
    this.id,
    this.userID,
    this.time,
    this.comment,
    this.likes,
  });
}

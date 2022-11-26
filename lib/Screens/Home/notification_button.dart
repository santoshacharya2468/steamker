// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';

class NotificationButton extends StatefulWidget {
  final GlobalKey<ScaffoldState> key1;

  const NotificationButton({Key key, this.key1}) : super(key: key);
  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  Api notificationsController;
  @override
  Widget build(BuildContext context) {
    notificationsController = Provider.of<Api>(context);
    notificationsController.listenNotifications();
    return GestureDetector(
      onTap: () {
        print("hello");
        // widget.key1.currentState.openEndDrawer();
        Scaffold.of(context).openEndDrawer();
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          if (notificationsController.notificationCount > 0)
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ),
          Icon(Icons.notifications, color: Colors.white),
        ],
      ),
    );
  }
}

class UserNotification {
  String id;
  String body;
  String collectionName;
  String collecionId;
  DateTime date;
  bool seen;
  String from;
  String title;
  UserNotification(
      {this.body, this.collectionName, this.collecionId, this.title});
  UserNotification.fromMap(Map<String, dynamic> map, String id) {
    this.id = id;
    this.body = map['body'];
    this.collecionId = map['collectionId'];
    this.collectionName = map['collection'];
    this.date = (map['date'] as Timestamp).toDate();
    this.seen = map['seen'];
    this.from = map['from'];
    this.title = map['title'];
  }
}

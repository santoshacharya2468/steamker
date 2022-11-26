// @dart=2.9

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/Common/userProfile.dart';
import 'package:streamkar/Services/api.dart';

class ChatScreenSettings extends StatefulWidget {
  final UserModel userModel;
  final String chatID;

  const ChatScreenSettings(
      {Key key, @required this.userModel, @required this.chatID})
      : super(key: key);

  @override
  State<ChatScreenSettings> createState() => _ChatScreenSettingsState();
}

class _ChatScreenSettingsState extends State<ChatScreenSettings> {
  bool stick = true;
  bool block = true;
  Api obj;

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Inbox",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Container(
                height: 7,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: widget.userModel.id == obj.userModel.id
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => UserProfile(
                              userModel: widget.userModel,
                            ),
                          ),
                        );
                      },
                child: Container(
                  height: 65,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(
                              widget.userModel.photoURL,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userModel.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: Colors.green),
                                      child: Text(
                                        "Lv.1",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: Colors.orange[300]),
                                      child: Text(
                                        "❤️ 0",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 7,
                color: Colors.grey.withOpacity(0.2),
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Stick on top",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) {
                          setState(() {
                            stick = e;
                          });
                        },
                        value: stick,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Block User",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) {
                          setState(() {
                            block = e;
                          });
                        },
                        value: block,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Report",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 7,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () async {
                  await clearHistory();
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        "Clear History",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 7,
                color: Colors.grey.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> clearHistory() async {
    final collection = await FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatID)
        .collection("history")
        .get();
    final batch = FirebaseFirestore.instance.batch();

    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }

    return batch.commit();
  }
}

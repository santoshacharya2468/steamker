// @dart=2.9
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/Chat/chatScreen.dart';
import 'package:streamkar/Screens/Profile/Menus/badge.dart' as bs;
import 'package:streamkar/Screens/Profile/Menus/bag.dart';
import 'package:streamkar/Screens/Profile/Menus/connections.dart';
import 'package:streamkar/Screens/StatusAndSquad/statusHome.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';

class UserProfile extends StatefulWidget {
  UserModel userModel;
  UserProfile({Key key, @required this.userModel}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Api obj;
  bool loading = true;
  bool first = true;
  UserModel userModel;

  Future<void> fetchData() async {
    userModel = UserModel();
    userModel = await obj.getUser(id: widget.userModel.id);
    if (userModel.id != null) {
      setState(() {
        loading = false;
        widget.userModel = userModel;
        obj.notify();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBar,
    ));
    obj = Provider.of<Api>(context);
    if (first) {
      first = false;
      fetchData();
    }
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: profileGradient,
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(0.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute<dynamic>(
                                        //     builder: (BuildContext context) => Settings(),
                                        //   ),
                                        // );
                                      },
                                      child: Icon(
                                        Icons.more_horiz,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  widget.userModel.photoURL,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                widget.userModel.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "ID:${widget.userModel.id.substring(0, 10)}   |   ${widget.userModel.place}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${widget.userModel.description}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        color: Colors.green),
                                    child: Text(
                                      "Lv.1",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        color: Colors.orange[300]),
                                    child: Text(
                                      "❤️ 0",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Connections(
                                          title: "Friends",
                                          userModel: widget.userModel,
                                          showAppBar: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        Text(
                                          userModel.connection
                                              .where((e) => e.type == "friends")
                                              .toList()
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Text(
                                          "Friends",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Connections(
                                          title: "Followers",
                                          userModel: widget.userModel,
                                          showAppBar: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        Text(
                                          userModel.connection
                                              .where(
                                                  (e) => e.type == "followers")
                                              .toList()
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Text(
                                          "Followers",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Connections(
                                          title: "Following",
                                          userModel: widget.userModel,
                                          showAppBar: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        Text(
                                          userModel.connection
                                              .where(
                                                  (e) => e.type == "following")
                                              .toList()
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Text(
                                          "Following",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 0.5,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => Bag(),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                color: Colors.red,
                                              ),
                                              child: Icon(
                                                FontAwesomeIcons.shoppingBag,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Baggage",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                letterSpacing: 0,
                                              ),
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
                            Container(
                              height: 0.5,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        bs.Badge(),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                color: Colors.deepOrange,
                                              ),
                                              child: Icon(
                                                FontAwesomeIcons.idBadge,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Badges (${userModel.badges.length})",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                letterSpacing: 0,
                                              ),
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
                            Container(color: Colors.grey[300], height: 5),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Moments",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 100,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: userModel.moments.length,
                                itemBuilder: (context, i) {
                                  return Card(
                                    elevation: 0,
                                    shadowColor: Colors.grey,
                                    child: new GestureDetector(
                                      onTap: () async {},
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          color: Colors.transparent,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          child: Image.network(
                                            userModel.moments[i].image,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Status",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // height: 100,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: userModel.status.length,
                                itemBuilder: (context, i) {
                                  return Post(
                                    showBar: true,
                                    status: obj.appStatus
                                        .where((e) =>
                                            e.id == userModel.status[i].id)
                                        .toList()
                                        .first,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 70),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: obj.userModel.connection
                                    .where(
                                        (e) => e.userID == widget.userModel.id)
                                    .toList()
                                    .isNotEmpty
                                ? null
                                : () async {
                                    await follow();
                                  },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: 40,
                                decoration: obj.userModel.connection
                                        .where((e) =>
                                            e.userID == widget.userModel.id)
                                        .toList()
                                        .isNotEmpty
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            width: 2, color: Colors.grey),
                                        color: Colors.grey[400],
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border:
                                            Border.all(width: 2, color: pink),
                                      ),
                                child: Center(
                                  child: Text(
                                    obj.userModel.connection
                                            .where((e) =>
                                                e.userID == widget.userModel.id)
                                            .toList()
                                            .isNotEmpty
                                        ? "Followed"
                                        : "Follow",
                                    style: TextStyle(
                                      color: obj.userModel.connection
                                              .where((e) =>
                                                  e.userID ==
                                                  widget.userModel.id)
                                              .toList()
                                              .isNotEmpty
                                          ? Colors.grey
                                          : pink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) => ChatScreen(
                                    user: widget.userModel,
                                    chatID: obj.myChats
                                            .where((e) =>
                                                e.userID == widget.userModel.id)
                                            .toList()
                                            .isEmpty
                                        ? ""
                                        : obj.myChats
                                            .where((e) =>
                                                e.userID == widget.userModel.id)
                                            .toList()
                                            .first
                                            .id,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(width: 2, color: pink),
                                ),
                                child: Center(
                                  child: Text(
                                    "Chat",
                                    style: TextStyle(
                                      color: pink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> follow() async {
    final collection = await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.id)
        .collection("connections");
    final collection1 = await FirebaseFirestore.instance
        .collection("users")
        .doc(obj.userModel.id)
        .collection("connections");
    final batch = FirebaseFirestore.instance.batch();

    if (userModel.connection
        .where((e) => e.userID == obj.userModel.id)
        .toList()
        .isNotEmpty) {
      batch.set(collection.doc(obj.userModel.id),
          {"userID": obj.userModel.id, "type": "friends"});

      batch.set(collection1.doc(userModel.id),
          {"userID": userModel.id, "type": "friends"});
    } else {
      batch.set(collection.doc(obj.userModel.id),
          {"userID": obj.userModel.id, "type": "followers"});

      batch.set(collection1.doc(userModel.id),
          {"userID": userModel.id, "type": "following"});
    }

    return batch.commit().then((value) {
      if (userModel.connection
          .where((e) => e.userID == obj.userModel.id)
          .toList()
          .isNotEmpty) {
        setState(() {
          userModel.connection.removeWhere((e) => e.userID == obj.userModel.id);
          obj.userModel.connection.removeWhere((e) => e.userID == userModel.id);
          userModel.connection
              .add(Connection(type: "friends", userID: obj.userModel.id));
          obj.userModel.connection
              .add(Connection(type: "friends", userID: userModel.id));
          obj.notify();
        });
      } else {
        setState(() {
          userModel.connection.removeWhere((e) => e.userID == obj.userModel.id);
          obj.userModel.connection.removeWhere((e) => e.userID == userModel.id);
          userModel.connection
              .add(Connection(type: "followers", userID: obj.userModel.id));
          obj.userModel.connection
              .add(Connection(type: "following", userID: userModel.id));
          obj.notify();
        });
      }
    });
  }
}

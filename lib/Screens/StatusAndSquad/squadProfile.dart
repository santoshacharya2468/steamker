// @dart=2.9
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/squadsCard.dart';
import 'package:streamkar/Screens/StatusAndSquad/addRemovePeople.dart';
import 'package:streamkar/Screens/StatusAndSquad/squadStatus.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';

class SquadProfile extends StatefulWidget {
  final SquadsCard squadsCard;
  final bool showJoin;
  const SquadProfile(
      {Key key, @required this.squadsCard, @required this.showJoin})
      : super(key: key);

  @override
  State<SquadProfile> createState() => _SquadProfileState();
}

class _SquadProfileState extends State<SquadProfile> {
  Api obj;

  bool loading = true;

  Future<void> joinSquad() async {
    setState(() {
      loading = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("squad")
        .doc(widget.squadsCard.id)
        .collection("joinRequests")
        .doc(obj.userModel.id)
        .set({"userID": obj.userModel.id}).then((value) async {
      CustomSnackBar(
        context,
        Text("Requested to Join"),
      );
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      CustomSnackBar(
        context,
        Text("Error Occured.. try again !!"),
      );
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBar,
    ));
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.squadsCard.image,
                        ),
                      ),
                      color: Colors.black,
                    ),
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                widget.squadsCard.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                              SizedBox(height: 10),
                              Text(
                                "${widget.squadsCard.time.toString().split(" ").first}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "Squad Intro",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "${widget.squadsCard.description}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 0.5,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Squad Members (${widget.squadsCard.members.length})",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 0.5,
                              ),
                            ),
                            widget.squadsCard.members
                                    .where((e) =>
                                        e.type == "ceo" &&
                                        e.userId == obj.userModel.id)
                                    .toList()
                                    .isEmpty
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              AddRemovePeople(
                                            squadsCard: widget.squadsCard,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.add_circle, color: pink),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            height: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.squadsCard.members.length,
                              itemBuilder: (context, i) {
                                return Card(
                                  elevation: 0,
                                  shadowColor: Colors.grey,
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: NetworkImage(
                                      obj.appUsers
                                          .where((e) =>
                                              e.id ==
                                              widget
                                                  .squadsCard.members[i].userId)
                                          .toList()
                                          .first
                                          .photoURL,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(color: Colors.grey[300], height: 5),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "Squad Status",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => SquadStatus(
                                  status: widget.squadsCard.status,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.squadsCard.status.length,
                              itemBuilder: (context, i) {
                                return Card(
                                  elevation: 0,
                                  shadowColor: Colors.grey,
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
                                        widget.squadsCard.status[i].image.first,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 0.5,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
              ],
            ),
          ),
          !widget.showJoin
              ? Container()
              : Positioned(
                  bottom: 0,
                  child: InkWell(
                    onTap: () async {
                      await joinSquad();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 46,
                        decoration: BoxDecoration(
                          color: pink,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Join Squad",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

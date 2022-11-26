// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/squadsCard.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/Common/userProfile.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';

class AddRemovePeople extends StatefulWidget {
  final SquadsCard squadsCard;
  const AddRemovePeople({Key key, @required this.squadsCard}) : super(key: key);

  @override
  State<AddRemovePeople> createState() => _AddRemovePeopleState();
}

class _AddRemovePeopleState extends State<AddRemovePeople> {
  Api obj;
  List<UserModel> users = [];

  bool loading = true;

  Future<void> approve(String userID) async {
    setState(() {
      loading = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("squad")
        .doc(widget.squadsCard.id)
        .collection("members")
        .doc(userID)
        .set({"id": userID, "type": "member"}).then((value) async {
      await firestore
          .collection("squad")
          .doc(widget.squadsCard.id)
          .collection("joinRequests")
          .doc(userID)
          .delete()
          .then((value) async {
        CustomSnackBar(
          context,
          Text("Approved Join Request"),
        );
        bool m = await obj.getSquad();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        setState(() {
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    users = [];
    widget.squadsCard.joinRequests.forEach((m) {
      users.add(obj.appUsers.where((e) => e.id == m).toList().first);
    });
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
          "Join Requests",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: listOfUsers(),
      ),
    );
  }

  Widget listOfUsers() {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: users[i].id == obj.userModel.id
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => UserProfile(
                          userModel: users[i],
                        ),
                      ),
                    );
                  },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                Container(
                  height: 60,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 23,
                                backgroundImage: NetworkImage(
                                  users[i].photoURL,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    users[i].name,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
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
                                            fontSize: 8,
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
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Last online:2 day(s) ago",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await approve(users[i].id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 60,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: pink,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Approve",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
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
                        Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        });
  }
}

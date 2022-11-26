// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/Common/userProfile.dart';
import 'package:streamkar/Services/api.dart';

class Connections extends StatefulWidget {
  final UserModel userModel;
  final String title;
  final bool showAppBar;
  const Connections(
      {Key key,
      @required this.title,
      @required this.userModel,
      @required this.showAppBar})
      : super(key: key);

  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  Api obj;
  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return Scaffold(
      appBar: !widget.showAppBar
          ? PreferredSize(
              preferredSize: Size.fromHeight(0), // here the desired height
              child: Container(),
            )
          : AppBar(
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
                widget.title,
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
        itemCount: widget.userModel.connection
            .where((e) => e.type.toUpperCase() == widget.title.toUpperCase())
            .toList()
            .length,
        itemBuilder: (context, i) {
          UserModel userModel = UserModel();
          userModel = obj.appUsers
              .where((e) =>
                  e.id ==
                  (widget.userModel.connection
                      .where((e) =>
                          e.type.toUpperCase() == widget.title.toUpperCase())
                      .toList()[i]
                      .userID))
              .toList()
              .first;

          return InkWell(
            onTap: userModel.id == obj.userModel.id
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => UserProfile(
                          userModel: userModel,
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
                                  userModel.photoURL,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userModel.name,
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

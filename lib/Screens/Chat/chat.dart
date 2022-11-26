// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Chat/chatScreen.dart';
import 'package:streamkar/Screens/Profile/Menus/connections.dart';
import 'package:streamkar/Screens/Profile/Settings/inbox.dart';
import 'package:streamkar/Services/api.dart';

import '../../utils/colors.dart';

class Chat extends StatefulWidget {
  const Chat({Key key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Api obj;
  bool first = true;
  bool loading = true;
  Future<void> fetchData() async {
    bool k = await obj.getChats();
    if (k) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      first = false;
      fetchData();
    }
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 0.5, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Inbox",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => Connections(
                                title: "Friends",
                                userModel: obj.userModel,
                                showAppBar: true,
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.group,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => Inbox(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : listOfChats(),
        ),
      ),
    );
  }

  Widget listOfChats() {
    return ListView.builder(
        itemCount: obj.myChats.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => ChatScreen(
                    user: obj.appUsers
                        .where((e) => e.id == obj.myChats[i].userID)
                        .toList()
                        .first,
                    chatID: obj.myChats[i].id,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                                  obj.appUsers
                                      .where(
                                          (e) => e.id == obj.myChats[i].userID)
                                      .toList()
                                      .first
                                      .photoURL,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      obj.appUsers
                                          .where((e) =>
                                              e.id == obj.myChats[i].userID)
                                          .toList()
                                          .first
                                          .name,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Recent message",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          "1 hour(s) ago",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
                SizedBox(height: 5),
              ],
            ),
          );
        });
  }
}

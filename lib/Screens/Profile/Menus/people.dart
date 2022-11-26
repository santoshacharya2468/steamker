// @dart=2.9
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Profile/Menus/connections.dart';
import 'package:streamkar/Services/api.dart';

import '../../../utils/colors.dart';

class People extends StatefulWidget {
  const People({Key key}) : super(key: key);

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
  }

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
          "My People",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        height: 40,
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(width: 2.0, color: pink),
                            insets: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 0),
                          ),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorPadding: EdgeInsets.all(5),
                          labelColor: Colors.black,
                          labelStyle: TextStyle(fontSize: 16),
                          unselectedLabelColor: Colors.grey[400],
                          unselectedLabelStyle: TextStyle(fontSize: 16),
                          tabs: <Widget>[
                            Tab(
                              text: "Following",
                            ),
                            Tab(
                              text: "Followers",
                            ),
                            Tab(
                              text: "Friends",
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
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Connections(
                      showAppBar: false,
                      title: "Following",
                      userModel: obj.userModel,
                    ),
                    Connections(
                      showAppBar: false,
                      title: "Followers",
                      userModel: obj.userModel,
                    ),
                    Connections(
                      showAppBar: false,
                      title: "Friends",
                      userModel: obj.userModel,
                    ),
                    // listOfUsers(),
                    // listOfUsers(),
                    // listOfUsers(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listOfUsers() {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) {
          return Column(
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
                                obj
                                    .pexel
                                    .photos[Random()
                                        .nextInt(obj.pexel.photos.length)]
                                    .src
                                    .small,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  obj
                                      .pexel
                                      .photos[Random()
                                          .nextInt(obj.pexel.photos.length)]
                                      .photographer,
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
          );
        });
  }
}

// @dart=2.9
import 'package:flutter/material.dart';
import 'package:streamkar/utils/validators.dart';

import '../../../utils/colors.dart';

class Invites extends StatefulWidget {
  const Invites({Key key}) : super(key: key);

  @override
  State<Invites> createState() => _InvitesState();
}

class _InvitesState extends State<Invites> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  Widget build(BuildContext context) {
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
          "My Invites",
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
                            borderSide: BorderSide(width: 2.0, color: purple),
                            insets: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 0),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.all(5),
                          labelColor: purple,
                          labelStyle: TextStyle(fontSize: 16),
                          unselectedLabelColor: Colors.grey[400],
                          unselectedLabelStyle: TextStyle(fontSize: 16),
                          tabs: <Widget>[
                            Tab(
                              text: "Invite a Friend",
                            ),
                            Tab(
                              text: "My Invitees",
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
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/images/inviteBanner.jpeg",
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: RichText(
                                  text: TextSpan(
                                    text: "My Collected Bonus:",
                                    style: TextStyle(
                                      color: pink,
                                      fontSize: 14,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' 0 beans',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            child: Image.asset(
                              "assets/images/newComers.jpeg",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      child: Image.network(
                                        'https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/Purchasable%2Fsvip.jpg?alt=media&token=b45a8942-6c66-41b8-ad94-bc6b03768a17',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Newbee gift",
                                    style: TextStyle(
                                      color: pink,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      child: Image.network(
                                        'https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/Purchasable%2Fvip.jpg?alt=media&token=fae86da7-0424-4e99-b377-ad42b112fa6b',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "3 days VIP",
                                    style: TextStyle(
                                      color: pink,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 5),
                            child: InkWell(
                              onTap: () async {
                                await launchSupport();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.pinkAccent.shade400,
                                ),
                                child: Center(
                                  child: Text(
                                    "Invite",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    listOfUsers(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
                            backgroundImage: AssetImage(
                              'assets/$logoStreamkar',
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Captain Sparrow",
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

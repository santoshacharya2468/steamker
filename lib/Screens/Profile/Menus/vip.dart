// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Profile/Menus/vipDetails.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

import '../../../utils/colors.dart';

class VIP extends StatefulWidget {
  const VIP({Key key}) : super(key: key);

  @override
  State<VIP> createState() => _VIPState();
}

class _VIPState extends State<VIP> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Map vip = {
    "Limitless Chat": "assets/icons/chats.jpeg",
    "Video Chat": "assets/icons/videoChat.jpeg",
    "Safety": "assets/icons/safety.jpeg",
    "Mute": "assets/icons/mute.jpeg",
    "Badge": "assets/icons/badge.jpeg",
    "Rank Boost": "assets/icons/rankBoost.jpeg",
    "Profile Edits": "assets/icons/profileEdits.jpeg",
  };
  Map svip = {
    "Limitless Chat": "assets/icons/chats.jpeg",
    "Video Chat": "assets/icons/videoChat.jpeg",
    "Safety": "assets/icons/safety.jpeg",
    "Mute": "assets/icons/mute.jpeg",
    "Badge": "assets/icons/badge.jpeg",
    "Rank Boost": "assets/icons/rankBoost.jpeg",
    "Special Nickname": "assets/icons/specialNickName.jpeg",
    "Profile Edits": "assets/icons/profileEdits.jpeg",
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  Api obj;

  @override
  Widget build(BuildContext context) {
    print(_tabController.index);
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
          "VIP",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                          height: 30,
                          child: TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: pink,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            labelStyle: TextStyle(fontSize: 14),
                            unselectedLabelColor: Colors.grey[400],
                            unselectedLabelStyle: TextStyle(fontSize: 14),
                            tabs: <Widget>[
                              Tab(
                                text: "     VIP     ",
                              ),
                              Tab(
                                text: "     SVIP     ",
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
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 12),
                            Container(
                              height: 80,
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
                                  'https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/Purchasable%2Fvip.jpg?alt=media&token=fae86da7-0424-4e99-b377-ad42b112fa6b',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "10,000 beans/month",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 24),
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed("/vipDetails");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        VipDetails(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Privileged Features",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "View Detail >",
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
                                // Navigator.of(context).pushNamed("/vipDetails");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        VipDetails(),
                                  ),
                                );
                              },
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                childAspectRatio: 1,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                                children: List.generate(vip.keys.length, (i) {
                                  return Card(
                                    elevation: 0,
                                    shadowColor: Colors.grey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(
                                            vip.values.toList()[i],
                                          ),
                                        ),
                                        Text(
                                          vip.keys.toList()[i],
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 12),
                            Container(
                              height: 80,
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
                                  'https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/Purchasable%2Fsvip.jpg?alt=media&token=b45a8942-6c66-41b8-ad94-bc6b03768a17',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "25,000 beans/month",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 12),
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed("/vipDetails");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        VipDetails(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Privileged Features",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "View Detail >",
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
                                // Navigator.of(context).pushNamed("/vipDetails");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        VipDetails(),
                                  ),
                                );
                              },
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                childAspectRatio: 1,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                                children: List.generate(svip.keys.length, (i) {
                                  return Card(
                                    elevation: 0,
                                    shadowColor: Colors.grey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(
                                            svip.values.toList()[i],
                                          ),
                                        ),
                                        Text(
                                          svip.keys.toList()[i],
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: InkWell(
                  onTap: () async {
                    int index = _tabController.index;
                    if (index == 0) {
                      if (obj.userModel.beans >= 10000) {
                        bool k = await obj.updateBeans(by: -10000);
                        if (k) {
                          CustomSnackBar(
                            context,
                            Text("Bought VIP membership Successfully"),
                          );
                        } else {
                          CustomSnackBar(
                            context,
                            Text("Insufficient Balance"),
                          );
                        }
                      }
                    } else {
                      if (obj.userModel.beans >= 25000) {
                        bool k = await obj.updateBeans(by: -25000);
                        if (k) {
                          CustomSnackBar(
                            context,
                            Text("Bought SVIP membership Successfully"),
                          );
                        } else {
                          CustomSnackBar(
                            context,
                            Text("Insufficient Balance"),
                          );
                        }
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.pinkAccent.shade400,
                    ),
                    child: Center(
                      child: Text(
                        "Buy Now",
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
      ),
    );
  }
}

Widget inaamGhar(
    {String name,
    String points,
    String image =
        "https://w7.pngwing.com/pngs/151/1005/png-transparent-brown-ribbon-badge-coffee-badge-ribbon.png"}) {
  return Column(
    children: [
      Container(
        height: 65,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: pink,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: Image.network(
                    image,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$name",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "$points Points",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          border: Border.all(
                            color: pink,
                          ),
                        ),
                        child: Text(
                          "Exchange",
                          style: TextStyle(
                            color: pink,
                          ),
                        ),
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
        height: 0.5,
        color: Colors.grey.withOpacity(0.2),
      ),
    ],
  );
}

Widget giftInstruction() {
  return Container(
    height: 200,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Gift Instructions",
            style: TextStyle(color: purple, fontSize: 18),
          ),
          Flexible(
            child: Text(
              "1. After exchange, any gifts recieved shall be immediately delivered to the user's backpack.",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Flexible(
            child: Text(
              "2. After exchange, any gifts recieved shall be immediately delivered to the user's backpack.",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Flexible(
            child: Text(
              "3. After exchange, any gifts recieved shall be immediately delivered to the user's backpack.",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Flexible(
            child: Text(
              "4. After exchange, any gifts recieved shall be immediately delivered to the user's backpack.",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

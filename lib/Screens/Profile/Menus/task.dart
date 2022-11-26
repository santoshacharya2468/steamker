// @dart=2.9
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Chat/chat.dart';
import 'package:streamkar/Screens/Home/menus/luckyDraw.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

import '../../../utils/colors.dart';

class Task extends StatefulWidget {
  const Task({Key key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Api obj;
  bool first = true;
  bool loading = true;
  String luckyDraw =
      "https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/App-Assets%2FluckyDraw.jpeg?alt=media&token=f30e0e8a-6cdd-41f3-b0c8-786859cde1e4";
  String other =
      "https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/App-Assets%2Fothers.jpeg?alt=media&token=ad6cac8d-bd04-4f90-86d7-6d745dcca679";
  String star =
      "https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/App-Assets%2Fstar.jpeg?alt=media&token=a7e53b5a-6886-4a3b-9522-5079ed2b86c0";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  Future<void> fetchData() async {
    bool k = await obj.getStore();
    print('came return here : $k');
    print(obj.appStore);
    if (k) {
      setState(() {
        loading = false;
        obj.notify();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (obj.appStore.length == 0) first = true;
    if (first) {
      loading = true;
      first = false;
      fetchData();
    }
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
          "My Task",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: loading
            ? Container()
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: TabBar(
                              isScrollable: true,
                              controller: _tabController,
                              indicator: UnderlineTabIndicator(
                                borderSide:
                                    BorderSide(width: 2.0, color: purple),
                                insets: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 0),
                              ),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorPadding: EdgeInsets.all(5),
                              labelColor: purple,
                              labelStyle: TextStyle(fontSize: 18),
                              unselectedLabelColor: Colors.grey[400],
                              unselectedLabelStyle: TextStyle(fontSize: 18),
                              tabs: <Widget>[
                                Tab(
                                  text: "Daily Task",
                                ),
                                Tab(
                                  text: "Inaam Ghar",
                                ),
                              ],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GridView.count(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 5,
                                    childAspectRatio: 0.8,
                                    mainAxisSpacing: 0,
                                    crossAxisSpacing: 0,
                                    children: List.generate(10, (i) {
                                      return Card(
                                        elevation: 0,
                                        shadowColor: Colors.grey,
                                        child: new GestureDetector(
                                          onTap: () async {},
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                  color: pink,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                  child: Image.network(
                                                    star,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 2,
                                                left: 2,
                                                child: Text(
                                                  "${(i + 1) * 50}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: InkWell(
                                      onTap: () async {
                                        var list = [
                                          50,
                                          100,
                                          150,
                                          200,
                                          250,
                                          300,
                                          350,
                                          400,
                                          450,
                                          500,
                                        ];

                                        final _random = new Random();
                                        var element =
                                            list[_random.nextInt(list.length)];
                                        bool m = await obj.updateDiamonds(
                                            by: element);
                                        if (m) {
                                          CustomSnackBar(
                                            context,
                                            Text(
                                                "Congratulation !! You Got $element Diamonds"),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: pink,
                                        ),
                                        child: Text(
                                          "Claim",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Tasks",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 65,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 65,
                                            width: 50,
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
                                                luckyDraw,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "   Lucky Draw",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute<
                                                          dynamic>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            LuckyDraw(
                                                          show: false,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 25,
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(30),
                                                        ),
                                                        border: Border.all(
                                                          color: pink,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "To Do",
                                                        style: TextStyle(
                                                          color: pink,
                                                        ),
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
                                  Container(
                                    height: 65,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 65,
                                            width: 50,
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
                                                other,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "   Send message 1x",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute<
                                                          dynamic>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Chat(),
                                                      ),
                                                    );
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 25,
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(30),
                                                        ),
                                                        border: Border.all(
                                                          color: pink,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "To Do",
                                                        style: TextStyle(
                                                          color: pink,
                                                        ),
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
                                  Container(
                                    height: 65,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 65,
                                            width: 50,
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
                                                other,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "   Send 1x gift",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 25,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                      border: Border.all(
                                                        color: pink,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "To Do",
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
                                  Container(
                                    height: 65,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 65,
                                            width: 50,
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
                                                other,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "   Follow 1x talent",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 25,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                      border: Border.all(
                                                        color: pink,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "To Do",
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
                                  Container(
                                    height: 65,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 65,
                                            width: 50,
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
                                                other,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "   Give us a good revieew!",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 25,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                      border: Border.all(
                                                        color: pink,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "To Do",
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
                                    height: 5,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var i = 0; i < obj.appStore.length; i++)
                                    inaamGhar(
                                      name: obj.appStore[i].name,
                                      points: obj.appStore[i].value.toString(),
                                      image: obj.appStore[i].image,
                                    ),
                                  // inaamGhar(
                                  //     name: "Porsche 911 (3 days)", points: "30000"),
                                  // inaamGhar(name: "VIP (3 days)", points: "5000"),
                                  // inaamGhar(name: "Rose(Points)", points: "100"),
                                  // inaamGhar(name: "Cupcake(Points)", points: "200"),
                                  // inaamGhar(name: "Pearl(Points)", points: "1000"),
                                  Container(
                                    height: 3,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  giftInstruction(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                obj.userModel.photoURL,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "   ${obj.userModel.name}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "${obj.userModel.diamonds} 💎   ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
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
                    color: Colors.transparent,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: Image.network(
                      image,
                      width: 80,
                      fit: BoxFit.contain,
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
                        child: InkWell(
                          onTap: () async {
                            if (obj.userModel.diamonds >= int.parse(points)) {
                              bool m = await obj.updateDiamonds(
                                  by: -1 * int.parse(points));
                              if (m) {
                                CustomSnackBar(
                                  context,
                                  Text("Hurray !! You just got $name"),
                                );
                              }
                            } else {
                              CustomSnackBar(
                                context,
                                Text("Insufficient Balance"),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
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

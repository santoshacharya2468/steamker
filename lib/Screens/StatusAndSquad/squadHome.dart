// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/squadsCard.dart';
import 'package:streamkar/Screens/StatusAndSquad/createSquad.dart';
import 'package:streamkar/Screens/StatusAndSquad/squadProfile.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

import '../../utils/colors.dart';

class SquadHome extends StatefulWidget {
  const SquadHome({Key key}) : super(key: key);
  @override
  _SquadHomeState createState() => _SquadHomeState();
}

class _SquadHomeState extends State<SquadHome> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBar,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
          child: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 0.5, 1.0],
                tileMode: TileMode.clamp,
              ),
              borderRadius: BorderRadius.circular(50),
              color: Colors.redAccent,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 12),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(fontSize: 12),
            labelPadding: EdgeInsets.all(0),
            tabs: <Widget>[
              Tab(
                text: "    Popular    ",
              ),
              Tab(
                text: "    My Squad    ",
              ),
              Tab(
                text: "   Rank    ",
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Popular(),
            MySquad(),
            Rank(),
          ],
        ),
      ),
    );
  }
}

class Popular extends StatefulWidget {
  const Popular({Key key}) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  Future<void> initialize() async {
    bool success = await obj.getSquad();
    if (success) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> initialize2() async {
    if (obj.appSquad.length > 0) {
      setState(() {
        loading = false;
      });
    } else {
      bool success = await obj.getSquad();
      if (success) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Api obj;
  bool first = true;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      initialize2();
      first = false;
    }
    return RefreshIndicator(
      onRefresh: initialize,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 1000),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: obj.appSquad.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => SquadProfile(
                              squadsCard: obj.appSquad[i],
                              showJoin: true,
                            ),
                          ),
                        );
                      },
                      child: SquadCard(
                        showJoin: obj.appSquad[i].members
                            .where((e) => e.userId == obj.userModel.id)
                            .toList()
                            .isEmpty,
                        squadsCard: obj.appSquad[i],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class MySquad extends StatefulWidget {
  const MySquad({Key key}) : super(key: key);

  @override
  State<MySquad> createState() => _MySquadState();
}

class _MySquadState extends State<MySquad> {
  Future<void> initialize2() async {
    if (obj.appSquad.length > 0) {
      setState(() {
        loading = false;
      });
    } else {
      bool success = await obj.getSquad();
      if (success) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> initialize() async {
    bool success = await obj.getSquad();
    if (success) {
      setState(() {
        loading = false;
      });
    }
  }

  Api obj;
  bool first = true;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      initialize2();
      first = false;
    }
    return RefreshIndicator(
      onRefresh: initialize,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 1000),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        decoration: BoxDecoration(
                          color: purple,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2, color: Colors.white),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.groups_sharp,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Join now or Create your own !",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                                CreateSquad(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: pink,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Create Squad",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: obj.appSquad
                          .where((e) => e.members
                              .where((m) => m.userId == obj.userModel.id)
                              .toList()
                              .isNotEmpty)
                          .toList()
                          .length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => SquadProfile(
                                  squadsCard: obj.appSquad
                                      .where((e) => e.members
                                          .where((m) =>
                                              m.userId == obj.userModel.id)
                                          .toList()
                                          .isNotEmpty)
                                      .toList()[i],
                                  showJoin: false,
                                ),
                              ),
                            );
                          },
                          child: SquadCard(
                            showJoin: false,
                            squadsCard: obj.appSquad
                                .where((e) => e.members
                                    .where((m) => m.userId == obj.userModel.id)
                                    .toList()
                                    .isNotEmpty)
                                .toList()[i],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class Rank extends StatefulWidget {
  const Rank({Key key}) : super(key: key);

  @override
  State<Rank> createState() => _RankState();
}

class _RankState extends State<Rank> {
  Future<void> initialize2() async {
    if (obj.appSquad.length > 0) {
      setState(() {
        loading = false;
      });
    } else {
      bool success = await obj.getSquad();
      if (success) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> initialize() async {
    bool success = await obj.getSquad();
    if (success) {
      setState(() {
        loading = false;
      });
    }
  }

  Api obj;
  bool first = true;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      initialize2();
      first = false;
    }
    return RefreshIndicator(
      onRefresh: initialize,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 1000),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: obj.appSquad.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => SquadProfile(
                              squadsCard: obj.appSquad[i],
                              showJoin: obj.appSquad[i].members
                                  .where((e) => e.userId == obj.userModel.id)
                                  .toList()
                                  .isEmpty,
                            ),
                          ),
                        );
                      },
                      child: SquadRankCard(
                        rank: i + 1,
                        squadsCard: obj.appSquad[i],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class SquadCard extends StatefulWidget {
  final bool showJoin;
  final SquadsCard squadsCard;
  const SquadCard({Key key, @required this.showJoin, @required this.squadsCard})
      : super(key: key);

  @override
  State<SquadCard> createState() => _SquadCardState();
}

class _SquadCardState extends State<SquadCard> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 5),
        Container(
          height: 100,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 95,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          widget.squadsCard.image,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.squadsCard.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
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
                              ],
                            ),
                            Text(
                              "Last online:2 day(s) ago",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      !widget.showJoin
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                await joinSquad();
                              },
                              child: Container(
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: pink,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                ),
                                child: Center(
                                  child: Text(
                                    "Join",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
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
  }
}

class SquadRankCard extends StatefulWidget {
  final SquadsCard squadsCard;
  final int rank;
  const SquadRankCard({Key key, @required this.squadsCard, @required this.rank})
      : super(key: key);

  @override
  State<SquadRankCard> createState() => _SquadRankCardState();
}

class _SquadRankCardState extends State<SquadRankCard> {
  Api obj;
  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 5),
        Container(
          height: 70,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 25,
                        child: Text(
                          widget.rank.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          widget.squadsCard.image,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.squadsCard.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
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
                              ],
                            ),
                            Text(
                              "Last online:2 day(s) ago",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.squadsCard.points.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Points",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
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
  }
}

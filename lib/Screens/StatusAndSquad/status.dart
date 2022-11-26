// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/StatusAndSquad/squadHome.dart';
import 'package:streamkar/Screens/StatusAndSquad/statusHome.dart';
import 'package:streamkar/Services/api.dart';

import '../../utils/colors.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  Future<void> initialize() async {
    if (obj.appUsers.length > 0) {
      setState(() {
        loading = false;
      });
    } else {
      bool success = await obj.getUsers();
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
      initialize();
      first = false;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBar,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
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
          child: Container(
            width: MediaQuery.of(context).size.width - 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.white,
                labelStyle: TextStyle(fontSize: 18),
                unselectedLabelColor: Colors.white54,
                unselectedLabelStyle: TextStyle(fontSize: 14),
                tabs: <Widget>[
                  Tab(
                    text: "Status",
                  ),
                  Tab(
                    text: "Squad",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                StatusHome(),
                SquadHome(),
              ],
            ),
    );
  }
}

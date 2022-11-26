// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Home/editorsChoice.dart';
import 'package:streamkar/Screens/Home/freshers.dart';
import 'package:streamkar/Screens/Home/notification_button.dart';
import 'package:streamkar/Screens/Home/notifications_drawer.dart';
import 'package:streamkar/Screens/Home/popular.dart';
import 'package:streamkar/Screens/Home/spotlight.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/Services/searchBox.dart';

import '../../utils/colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Api obj;
  bool loading = true;
  bool first = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 1, length: 4);
  }

  Future<void> fetchData() async {
    bool k = await obj.getBanners();
    print('came return here : $k');
    print(obj.appBanners);
    if (k) {
      setState(() {
        loading = false;
        obj.notify();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBar,
    ));
    obj = Provider.of<Api>(context);
    if (obj.appBanners.length == 0) first = true;
    if (first) {
      loading = true;
      first = false;
      fetchData();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      endDrawer: NotificationDrawer(),
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
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 90,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2.0, color: Colors.white),
                      insets:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.white,
                    labelStyle: TextStyle(fontSize: 18),
                    unselectedLabelColor: Colors.white54,
                    unselectedLabelStyle: TextStyle(fontSize: 14),
                    tabs: <Widget>[
                      Tab(
                        text: "Freshers",
                      ),
                      Tab(
                        text: "Popular",
                      ),
                      Tab(
                        text: "Spotlight",
                      ),
                      Tab(
                        text: "Editors's Pick",
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: Datasearch(),
                  );
                },
                child: Container(
                  width: 40,
                  child: Center(
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              Center(child: NotificationButton(key1: _scaffoldKey)),
            ],
          ),
        ),
      ),
      body: loading
          ? Center(
              child: RefreshProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                Freshers(),
                Popular(),
                SpotLight(),
                EditorsChoice(
                  showAppBar: false,
                ),
              ],
            ),
    );
  }
}

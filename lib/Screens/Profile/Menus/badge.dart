// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';

class Badge extends StatefulWidget {
  const Badge({Key key}) : super(key: key);

  @override
  State<Badge> createState() => _BadgeState();
}

class _BadgeState extends State<Badge> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> types = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  Future<void> initialize() async {
    if (obj.appBadges.length > 0) {
      setState(() {
        obj.appBadges.forEach((e) {
          if (!types.contains(e.type)) {
            types.add(e.type);
          }
        });
        types.remove('all');
        loading = false;
      });
    } else {
      bool success = await obj.getBadge();
      if (success) {
        setState(() {
          obj.appBadges.forEach((e) {
            if (!types.contains(e.type)) {
              types.add(e.type);
            }
          });
          types.remove('all');
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
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: purple,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "My Badge",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/Badge%2Fbadge4.jpg?alt=media&token=15ca19e5-680e-4e6f-935a-b738452aa65d",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
                                  borderSide:
                                      BorderSide(width: 2.0, color: pink),
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
                                    text: "Honor Badge",
                                  ),
                                  Tab(
                                    text: "Event Badge",
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
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: types.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 12),
                                    Text(
                                      types[index].toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    GridView.count(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                      mainAxisSpacing: 0,
                                      crossAxisSpacing: 0,
                                      children: List.generate(
                                          obj.appBadges
                                              .where((e) =>
                                                  e.category == 'HONORBADGE' &&
                                                  e.type == types[index])
                                              .toList()
                                              .length, (i) {
                                        bool iHave = obj.userModel.badges
                                            .where((e) =>
                                                e.id ==
                                                (obj.appBadges
                                                    .where((e) =>
                                                        e.category ==
                                                            'HONORBADGE' &&
                                                        e.type == types[index])
                                                    .toList()[i]
                                                    .id))
                                            .toList()
                                            .isNotEmpty;
                                        return Card(
                                          elevation: 0,
                                          shadowColor: Colors.grey,
                                          child: Container(
                                            decoration: !iHave
                                                ? BoxDecoration()
                                                : BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                            child: new GestureDetector(
                                              onTap: () async {},
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      obj.appBadges
                                                          .where((e) =>
                                                              e.category ==
                                                                  'HONORBADGE' &&
                                                              e.type ==
                                                                  types[index])
                                                          .toList()[i]
                                                          .image,
                                                    ),
                                                  ),
                                                  Text(
                                                    obj.appBadges
                                                        .where((e) =>
                                                            e.category ==
                                                                'HONORBADGE' &&
                                                            e.type ==
                                                                types[index])
                                                        .toList()[i]
                                                        .name,
                                                    style: TextStyle(
                                                      color: iHave
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                );
                              },
                            ),
                          ),
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 12),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("/vipDetails");
                                  },
                                  child: GridView.count(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    mainAxisSpacing: 0,
                                    crossAxisSpacing: 0,
                                    children: List.generate(
                                        obj.appBadges
                                            .where((e) =>
                                                e.category == 'EVENTBADGE')
                                            .toList()
                                            .length, (i) {
                                      print(obj.userModel.badges);
                                      bool iHave = obj.userModel.badges
                                          .where((e) =>
                                              e.id ==
                                              (obj.appBadges
                                                  .where((e) =>
                                                      e.category ==
                                                      'EVENTBADGE')
                                                  .toList()[i]
                                                  .id))
                                          .toList()
                                          .isNotEmpty;
                                      return Card(
                                        elevation: 0,
                                        shadowColor: Colors.grey,
                                        child: Container(
                                          decoration: !iHave
                                              ? BoxDecoration()
                                              : BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                          child: new GestureDetector(
                                            onTap: () async {},
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                    obj.appBadges
                                                        .where((e) =>
                                                            e.category ==
                                                            'EVENTBADGE')
                                                        .toList()[i]
                                                        .image,
                                                  ),
                                                ),
                                                Text(
                                                  obj.appBadges
                                                      .where((e) =>
                                                          e.category ==
                                                          'EVENTBADGE')
                                                      .toList()[i]
                                                      .name,
                                                  style: TextStyle(
                                                    color: iHave
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                ],
              ),
      ),
    );
  }
}

// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Chat/chat.dart';
import 'package:streamkar/Screens/Home/home.dart';
import 'package:streamkar/Screens/Profile/profile.dart';
import 'package:streamkar/Screens/StatusAndSquad/status.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/Screens/LiveStreaming/live_mode_selection_screen.dart';
import 'package:streamkar/utils/colors.dart';

class BottomNavigationPage extends StatefulWidget {
  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int index = 0;
  Api obj;
  bool loading = true;
  bool first = true;
  void changeIndex(int i) {
    setState(() {
      index = i;
    });
  }

  Future<void> fetchData() async {
    bool k = await obj.getoverview();
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
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.pink,
      //   child: Center(
      //     // child: Icon(
      //     //   FontAwesomeIcons.video,
      //     //   size: 20,
      //     // ),
      //     child: Image.asset(
      //       "assets/icons/liveStream.jpeg",
      //     ),
      //   ),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute<dynamic>(
      //         builder: (BuildContext context) => LiveModeSelectionScreen(),
      //       ),
      //     );
      //   },
      // ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedFontSize: 16,
        unselectedFontSize: 16,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                  "assets/icons/home.jpeg",
                  height: 30,
                ),
                if (index == 0)
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: pink.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                  "assets/icons/statusSquad.jpeg",
                  height: 30,
                ),
                if (index == 1)
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: pink.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/liveStream.jpeg",
              height: 35,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                  "assets/icons/chat.jpeg",
                  height: 30,
                ),
                if (index == 3)
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: pink.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                  "assets/icons/profile.jpeg",
                  height: 30,
                ),
                if (index == 4)
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: pink.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ),
              ],
            ),
            label: '',
          )
        ],
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: loading
            ? null
            : (int ind) {
                if (ind == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          LiveModeSelectionScreen(),
                    ),
                  );
                } else
                  setState(() {
                    index = ind;
                  });
              },
      ),
      body: loading
          ? Center(
              child: RefreshProgressIndicator(),
            )
          : SafeArea(
              child: IndexedStack(
                index: index,
                children: [
                  Home(),
                  Status(),
                  Container(),
                  Chat(),
                  Profile(),
                ],
              ),
            ),
    );
  }
}

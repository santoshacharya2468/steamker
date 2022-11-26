// @dart=2.9
import 'package:flutter/material.dart';
import 'package:streamkar/Screens/LiveStreaming/follow_button.dart';
import 'package:streamkar/Screens/LiveStreaming/streamingmodel.dart';
import 'package:streamkar/Screens/NavigationBar/bottomnavigation.dart';

import '../../utils/colors.dart';

class StreamingEnded extends StatelessWidget {
  final UserStream stream;
  StreamingEnded({@required this.stream});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [purple, pink]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            BottomNavigationPage(),
                      ),
                      (route) =>
                          false, //if you want to disable back feature set to false
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Live Ended',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                // fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 30),
            CircleAvatar(
              radius: 40,
              backgroundImage: stream.streamer.photoURL != null &&
                      stream.streamer.photoURL.isNotEmpty
                  ? NetworkImage(stream.streamer.photoURL)
                  : AssetImage('assets/images/gigo.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                stream.streamer.name ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: FollowButton(''),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';

class AppAlerts extends StatefulWidget {
  const AppAlerts({Key key}) : super(key: key);

  @override
  State<AppAlerts> createState() => _AppAlertsState();
}

class _AppAlertsState extends State<AppAlerts> {
  bool appAlerts = true;
  bool voice = true;
  bool vibrate = true;
  bool allUsers = true;
  bool followedUsers = true;
  bool talents = true;
  bool comments = true;
  bool likes = true;

  Api obj;
  bool first = true;
  Future<bool> changeSettings() async {
    Map settings = {
      'appAlerts': {
        'voice': voice,
        'receiveAppAlerts': appAlerts,
        'comments': comments,
        'like': likes,
        'allUsers': allUsers,
        'vibrate': vibrate,
        'talents': talents,
        'followed': followedUsers,
      },
      'roomEffects': {
        'entranceSoundEffects':
            obj.userModel.settings.roomEffects['entranceSoundEffects'],
        'giftSoundEffect':
            obj.userModel.settings.roomEffects['giftSoundEffect'],
        'giftEffect': obj.userModel.settings.roomEffects['giftEffect'],
        'entranceEffects':
            obj.userModel.settings.roomEffects['entranceEffects'],
      },
      'language': obj.userModel.settings.language,
      'inbox': {
        'talentLevel': obj.userModel.settings.inbox['talentLevel'],
        'userLevel': obj.userModel.settings.inbox['userLevel'],
        'selected': obj.userModel.settings.inbox['selected'],
      },
    };
    bool k = await obj.editSettings(settings: settings);
    return k;
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      first = false;
      setState(() {
        appAlerts = obj.userModel.settings.appAlerts['receiveAppAlerts'];
        voice = obj.userModel.settings.appAlerts['voice'];
        vibrate = obj.userModel.settings.appAlerts['vibrate'];
        allUsers = obj.userModel.settings.appAlerts['allUsers'];
        followedUsers = obj.userModel.settings.appAlerts['followed'];
        talents = obj.userModel.settings.appAlerts['talents'];
        comments = obj.userModel.settings.appAlerts['comments'];
        likes = obj.userModel.settings.appAlerts['likes'];
      });
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
          "App Alerts",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Container(
                height: 3,
                color: Colors.grey.withOpacity(0.2),
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Receive app alerts",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          appAlerts = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              appAlerts = e;
                            });
                          } else {
                            setState(() {
                              appAlerts = !e;
                            });
                          }
                        },
                        value: appAlerts,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[400].withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Tourn on to recieve message notifications",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Voice",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          voice = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              voice = e;
                            });
                          } else {
                            setState(() {
                              voice = !e;
                            });
                          }
                        },
                        value: voice,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Vibrate",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          vibrate = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              vibrate = e;
                            });
                          } else {
                            setState(() {
                              vibrate = !e;
                            });
                          }
                        },
                        value: vibrate,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[400].withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Recieve alerts from",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "All users",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          allUsers = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              allUsers = e;
                            });
                          } else {
                            setState(() {
                              allUsers = !e;
                            });
                          }
                        },
                        value: allUsers,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Just followed users",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          followedUsers = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              followedUsers = e;
                            });
                          } else {
                            setState(() {
                              followedUsers = !e;
                            });
                          }
                        },
                        value: followedUsers,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Just talents",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          talents = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              talents = e;
                            });
                          } else {
                            setState(() {
                              talents = !e;
                            });
                          }
                        },
                        value: talents,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[400].withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Status Alerts",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Comments",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          comments = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              comments = e;
                            });
                          } else {
                            setState(() {
                              comments = !e;
                            });
                          }
                        },
                        value: comments,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Like",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          likes = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              likes = e;
                            });
                          } else {
                            setState(() {
                              likes = !e;
                            });
                          }
                        },
                        value: likes,
                        activeColor: Colors.pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
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
      ),
    );
  }
}

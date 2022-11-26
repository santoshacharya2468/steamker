// @dart=2.9
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Profile/Settings/userLevel.dart';
import 'package:streamkar/Services/api.dart';

class Inbox extends StatefulWidget {
  const Inbox({Key key}) : super(key: key);

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  Api obj;
  bool first = true;
  String selected = "all";
  int talentLevel = 1;
  int userLevel = 1;

  Future<bool> changeSettings() async {
    Map settings = {
      'appAlerts': {
        'voice': obj.userModel.settings.appAlerts['voice'],
        'receiveAppAlerts':
            obj.userModel.settings.appAlerts['receiveAppAlerts'],
        'comments': obj.userModel.settings.appAlerts['comments'],
        'like': obj.userModel.settings.appAlerts['like'],
        'allUsers': obj.userModel.settings.appAlerts['allUsers'],
        'vibrate': obj.userModel.settings.appAlerts['vibrate'],
        'talents': obj.userModel.settings.appAlerts['talents'],
        'followed': obj.userModel.settings.appAlerts['followed'],
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
        'talentLevel': talentLevel,
        'userLevel': userLevel,
        'selected': selected,
      },
    };
    bool k = await obj.editSettings(settings: settings);
    if (k) {
      obj.notify();
    }
    return k;
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      first = false;
      setState(() {
        selected = obj.userModel.settings.inbox['selected'];
        talentLevel = obj.userModel.settings.inbox['talentLevel'];
        userLevel = obj.userModel.settings.inbox['userLevel'];
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
          "Inbox",
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
                        "Accept private messages from",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  String m = selected;
                  selected = "all";
                  bool success = await changeSettings();
                  if (success) {
                    setState(() {
                      selected = "all";
                    });
                  } else {
                    setState(() {
                      selected = m;
                    });
                  }
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
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
                        selected == "all"
                            ? Icon(
                                FontAwesomeIcons.check,
                                size: 16,
                                color: Colors.orange,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () async {
                  String m = selected;
                  selected = "followed";
                  bool success = await changeSettings();
                  if (success) {
                    setState(() {
                      selected = "all";
                    });
                  } else {
                    setState(() {
                      selected = m;
                    });
                  }
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Users on followed list",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: 0,
                          ),
                        ),
                        selected == "followed"
                            ? Icon(
                                FontAwesomeIcons.check,
                                size: 16,
                                color: Colors.orange,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () async {
                  String m = selected;
                  selected = "highLevel";
                  bool success = await changeSettings();
                  if (success) {
                    setState(() {
                      selected = "highLevel";
                    });
                  } else {
                    setState(() {
                      selected = m;
                    });
                  }
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Higher level users",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: 0,
                          ),
                        ),
                        selected == "highLevel"
                            ? Icon(
                                FontAwesomeIcons.check,
                                size: 16,
                                color: Colors.orange,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => UserLevel(),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "User Level",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey,
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
              // Card(
              //   elevation: 0,
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //         left: 15, right: 15, top: 10, bottom: 10),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 30),
              //           child: Text(
              //             "Talent Level",
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 14,
              //               letterSpacing: 0,
              //             ),
              //           ),
              //         ),
              //         Icon(
              //           Icons.arrow_forward_ios,
              //           size: 18,
              //           color: Colors.grey,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "User can still recieve private message from friends",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
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

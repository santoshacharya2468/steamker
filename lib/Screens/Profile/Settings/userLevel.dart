// @dart=2.9
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';

class UserLevel extends StatefulWidget {
  const UserLevel({Key key}) : super(key: key);

  @override
  State<UserLevel> createState() => _UserLevelState();
}

class _UserLevelState extends State<UserLevel> {
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
              for (var i = 1; i <= 25; i++)
                InkWell(
                  onTap: () async {
                    int m = userLevel;
                    userLevel = i;
                    bool success = await changeSettings();
                    if (success) {
                      setState(() {
                        userLevel = i;
                      });
                    } else {
                      setState(() {
                        userLevel = m;
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
                            "Level : " + i.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              letterSpacing: 0,
                            ),
                          ),
                          userLevel == i
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
            ],
          ),
        ),
      ),
    );
  }
}

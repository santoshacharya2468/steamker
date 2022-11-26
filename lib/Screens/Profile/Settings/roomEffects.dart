// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';

class RoomEffects extends StatefulWidget {
  const RoomEffects({Key key}) : super(key: key);

  @override
  State<RoomEffects> createState() => _RoomEffectsState();
}

class _RoomEffectsState extends State<RoomEffects> {
  bool giftEffect = true;
  bool giftSoundEffect = true;
  bool entranceEffect = true;
  bool entranceSoundEffect = true;
  Api obj;
  bool first = true;

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
        'entranceSoundEffects': entranceSoundEffect,
        'giftSoundEffect': giftSoundEffect,
        'giftEffect': giftEffect,
        'entranceEffects': entranceEffect
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
    print(obj.userModel.settings.appAlerts);
    print(obj.userModel.settings.roomEffects);
    if (first) {
      first = false;
      setState(() {
        giftEffect = obj.userModel.settings.roomEffects['giftEffect'];
        giftSoundEffect = obj.userModel.settings.roomEffects['giftSoundEffect'];
        entranceEffect = obj.userModel.settings.roomEffects['entranceEffects'];
        entranceSoundEffect =
            obj.userModel.settings.roomEffects['entranceSoundEffects'];
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
          "Room Effects",
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
                height: 5,
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
                        "Gift Effects (Animation + Sound)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          giftEffect = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              giftEffect = e;
                            });
                          } else {
                            setState(() {
                              giftEffect = !e;
                            });
                          }
                        },
                        value: giftEffect,
                        activeColor: pink,
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
                        "Gift Sound Effects",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          giftSoundEffect = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              giftSoundEffect = e;
                            });
                          } else {
                            setState(() {
                              giftSoundEffect = !e;
                            });
                          }
                        },
                        value: giftSoundEffect,
                        activeColor: pink,
                        activeTrackColor: Colors.pink[100],
                        inactiveThumbColor: Colors.grey[200],
                        inactiveTrackColor: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 7,
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
                        "Entrance Effects (Animation + Sound)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          entranceEffect = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              entranceEffect = e;
                            });
                          } else {
                            setState(() {
                              entranceEffect = !e;
                            });
                          }
                        },
                        value: entranceEffect,
                        activeColor: pink,
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
                        "Entrance Sound Effects",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          letterSpacing: 0,
                        ),
                      ),
                      Switch(
                        onChanged: (e) async {
                          entranceSoundEffect = e;
                          bool m = await changeSettings();
                          if (m) {
                            setState(() {
                              entranceSoundEffect = e;
                            });
                          } else {
                            setState(() {
                              entranceSoundEffect = !e;
                            });
                          }
                        },
                        value: entranceSoundEffect,
                        activeColor: pink,
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
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        "Note: Above special effects will not appear in the app after being turned off. Using these special effects results in better user experience",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          letterSpacing: 0,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// @dart=2.9
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';

import '../../../utils/colors.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  Api obj;
  bool first = true;
  String language = "";

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
      'language': language,
      'inbox': {
        'talentLevel': obj.userModel.settings.inbox['talentLevel'],
        'userLevel': obj.userModel.settings.inbox['userLevel'],
        'selected': obj.userModel.settings.inbox['selected'],
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
        language = obj.userModel.settings.language;
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
          "Language",
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
              InkWell(
                onTap: () async {
                  String m = language;
                  language = "English";
                  bool success = await changeSettings();
                  if (success) {
                    setState(() {
                      language = "English";
                    });
                  } else {
                    setState(() {
                      language = m;
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
                          "English",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: 0,
                          ),
                        ),
                        language == "English"
                            ? Icon(
                                FontAwesomeIcons.check,
                                size: 10,
                                color: pink,
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
                  String m = language;
                  language = "Hindi";
                  bool success = await changeSettings();
                  if (success) {
                    setState(() {
                      language = "Hindi";
                    });
                  } else {
                    setState(() {
                      language = m;
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
                          "Hindi",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: 0,
                          ),
                        ),
                        language == "Hindi"
                            ? Icon(
                                FontAwesomeIcons.check,
                                size: 10,
                                color: pink,
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
                  String m = language;
                  language = "العربية";
                  bool success = await changeSettings();
                  if (success) {
                    setState(() {
                      language = "العربية";
                    });
                  } else {
                    setState(() {
                      language = m;
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
                          "العربية",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: 0,
                          ),
                        ),
                        language == "العربية"
                            ? Icon(
                                FontAwesomeIcons.check,
                                size: 10,
                                color: pink,
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

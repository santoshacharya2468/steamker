// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Profile/Settings/aboutUs.dart';
import 'package:streamkar/Screens/Profile/Settings/appAlerts.dart';
import 'package:streamkar/Screens/Profile/Settings/contactUs.dart';
import 'package:streamkar/Screens/Profile/Settings/faqs.dart';
import 'package:streamkar/Screens/Profile/Settings/inbox.dart';
import 'package:streamkar/Screens/Profile/Settings/language.dart';
import 'package:streamkar/Screens/Profile/Settings/roomEffects.dart';
import 'package:streamkar/Screens/Profile/Settings/security.dart';
import 'package:streamkar/Screens/Splash_Screen/splash_screen.dart';
import 'package:streamkar/Services/api.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Api obj;
  Future<void> logout() async {
    // await Authentication.signOut(context: context);
    bool k = await obj.removeLoginStatus();
    if (k) {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => Splash(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
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
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => SecurityPage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Security",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
                height: 5,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => RoomEffects(),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Room Effects",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
                height: 5,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => Inbox(),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Inbox",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
                height: 5,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => LanguagePage(),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Language",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
                height: 5,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => AppAlerts(),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "App Alerts",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
                height: 5,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("/review");
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Review us!",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("/facebook");
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Facebook",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
              InkWell(
                onTap: () {
                  // Navigator.of(context).pushNamed("/faq");
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => Faqs(),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "FAQ",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
              InkWell(
                onTap: () {
                  // Navigator.of(context).pushNamed("/connect");
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => ContactUs(),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Connect With Us",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
              InkWell(
                onTap: () {
                  // Navigator.of(context).pushNamed("/about");
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => AboutUs(),
                    ),
                  );
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w400,
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
                height: 5,
                color: Colors.grey.withOpacity(0.2),
              ),
              InkWell(
                onTap: () async {
                  // Navigator.pushAndRemoveUntil<dynamic>(
                  //   context,
                  //   MaterialPageRoute<dynamic>(
                  //     builder: (BuildContext context) => Splash(),
                  //   ),
                  //   (route) =>
                  //       false, //if you want to disable back feature set to false
                  // );
                  await logout();
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Center(
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 5,
                color: Colors.grey.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

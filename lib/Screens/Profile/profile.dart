// @dart=2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Profile/Menus/badge.dart';
import 'package:streamkar/Screens/Profile/Menus/bag.dart';
import 'package:streamkar/Screens/Profile/Menus/connections.dart';
import 'package:streamkar/Screens/Profile/Menus/earnings.dart';
import 'package:streamkar/Screens/Profile/Menus/exchangeBees.dart';
import 'package:streamkar/Screens/Profile/Menus/help.dart';
import 'package:streamkar/Screens/Profile/Menus/invites.dart';
import 'package:streamkar/Screens/Profile/Menus/level.dart';
import 'package:streamkar/Screens/Profile/Menus/people.dart';
import 'package:streamkar/Screens/Profile/Menus/task.dart';
import 'package:streamkar/Screens/Profile/Menus/topUp.dart';
import 'package:streamkar/Screens/Profile/Menus/vip.dart';
import 'package:streamkar/Screens/Profile/Settings/settings.dart';
import 'package:streamkar/Screens/Profile/editProfile.dart';
import 'package:streamkar/Screens/StatusAndSquad/statusHome.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  Api obj;
  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBar,
    ));
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: profileGradient,
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            EditProfile(),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Settings(),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              obj.userModel.photoURL,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            obj.userModel.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 25,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            "ID:${obj.userModel.id.substring(0, 10)}   |   ${obj.userModel.place}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${obj.userModel.description}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.green),
                                child: Text(
                                  "Lv.1",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.orange[300]),
                                child: Text(
                                  "❤️ 0",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => TopUp(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/beans.png",
                                      height: 40,
                                    ),
                                    Text(
                                      "${obj.userModel.beans ?? 0}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        ExchangeBees(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: Text(
                                  "💎  ${obj.userModel.diamonds ?? 0}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        Connections(
                                      title: "Friends",
                                      userModel: obj.userModel,
                                      showAppBar: true,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: Column(
                                  children: [
                                    Text(
                                      obj.userModel.connection
                                          .where((e) => e.type == "friends")
                                          .toList()
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Text(
                                      "Friends",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        Connections(
                                      title: "Followers",
                                      userModel: obj.userModel,
                                      showAppBar: true,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: Column(
                                  children: [
                                    Text(
                                      obj.userModel.connection
                                          .where((e) => e.type == "followers")
                                          .toList()
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Text(
                                      "Followers",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        Connections(
                                      title: "Following",
                                      userModel: obj.userModel,
                                      showAppBar: true,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                child: Column(
                                  children: [
                                    Text(
                                      obj.userModel.connection
                                          .where((e) => e.type == "following")
                                          .toList()
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Text(
                                      "Following",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            TopUp(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.pink,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.bolt,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/topup.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "Top-up",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Earnings(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.orange,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.gem,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/earnings.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "Earnings",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Task(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.blue,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.dailymotion,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/myTask.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "My Tasks",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            VIP(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.purple,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.crown,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/vip.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "Vip",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Bag(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.blue,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.shoppingBag,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/myBag.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "My Bag",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            MyLevel(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.pinkAccent,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.star,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/myLevel.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "My Level",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Badge(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.orangeAccent,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.idBadge,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/myBadge.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "My Badge",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Help(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.green,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.userFriends,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/helpSupport.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "Help",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            People(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.deepPurpleAccent,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.user,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/myPeople.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "My People",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Invites(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height: 50,
                                        //   width: 50,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.all(
                                        //       Radius.circular(15),
                                        //     ),
                                        //     color: Colors.black,
                                        //   ),
                                        //   child: Icon(
                                        //     FontAwesomeIcons.mailBulk,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        Image.asset(
                                          "assets/icons/myInvites.jpeg",
                                          height: 55,
                                          width: 55,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "My Invites",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "      ",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "      ",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(color: Colors.grey[300], height: 5),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 5),
                            Text(
                              "Moments",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: obj.userModel.moments.length,
                            itemBuilder: (context, i) {
                              return Card(
                                elevation: 0,
                                shadowColor: Colors.grey,
                                child: new GestureDetector(
                                  onTap: () async {},
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        obj.userModel.moments[i].image,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 0.5,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Status",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        obj.appStatus.isEmpty || obj.userModel.status.isEmpty
                            ? SizedBox()
                            : Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: obj.userModel.status.length,
                                  itemBuilder: (context, i) {
                                    return Post(
                                      showBar: true,
                                      status: obj.appStatus
                                          .where((e) =>
                                              e.id ==
                                              obj.userModel.status[i].id)
                                          .toList()
                                          .first,
                                    );
                                  },
                                ),
                              ),
                        SizedBox(height: 70),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  IgnorePointer(
                    child: Container(
                      color: Colors.transparent,
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(270),
                        degOneTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: Card(
                        elevation: 15,
                        child: CircularButton(
                          color: Colors.white,
                          width: 35,
                          height: 35,
                          icon: Icon(
                            Icons.camera_alt,
                            color: purple,
                          ),
                          onClick: () async {
                            bool k = await getImage(ImageSource.camera);
                            if (k) {
                              bool success = await obj.postMoments(_image);
                              if (success) {
                                CustomSnackBar(
                                  context,
                                  Text("Moments Added"),
                                );
                              } else {
                                CustomSnackBar(
                                  context,
                                  Text("Some Error Occured, Try Again !!"),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(225),
                        degTwoTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degTwoTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: Card(
                        elevation: 15,
                        child: CircularButton(
                          color: Colors.white,
                          width: 35,
                          height: 35,
                          icon: Icon(
                            Icons.video_call,
                            color: purple,
                          ),
                          onClick: () async {
                            bool k = await getImage(ImageSource.gallery,
                                type: "video");
                            if (k) {
                              bool success = await obj.postMoments(_image);
                              if (success) {
                                CustomSnackBar(
                                  context,
                                  Text("Moments Added"),
                                );
                              } else {
                                CustomSnackBar(
                                  context,
                                  Text("Some Error Occured, Try Again !!"),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset.fromDirection(getRadiansFromDegree(180),
                        degThreeTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degThreeTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: Card(
                        elevation: 15,
                        child: CircularButton(
                          color: Colors.white,
                          width: 35,
                          height: 35,
                          icon: Icon(
                            Icons.image,
                            color: purple,
                          ),
                          onClick: () async {
                            bool k = await getImage(ImageSource.gallery);
                            if (k) {
                              bool success = await obj.postMoments(_image);
                              if (success) {
                                CustomSnackBar(
                                  context,
                                  Text("Moments Added"),
                                );
                              } else {
                                CustomSnackBar(
                                  context,
                                  Text("Some Error Occured, Try Again !!"),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value)),
                    alignment: Alignment.center,
                    child: Card(
                      elevation: 15,
                      child: CircularButton(
                        color: Colors.white,
                        width: 40,
                        height: 40,
                        icon: Icon(
                          Icons.add,
                          color: purple,
                        ),
                        onClick: () {
                          if (animationController.isCompleted) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  File _image;
  Future<bool> getImage(ImageSource source, {type = "image"}) async {
    ImagePicker imagePicker = ImagePicker();
    if (type == "image") {
      var image = await imagePicker.getImage(
          source: source, maxHeight: 200, maxWidth: 200);
      setState(() {
        _image = File(image.path);
      });
    } else {
      var image = await imagePicker.getVideo(
          source: source, maxDuration: Duration(seconds: 300));
      setState(() {
        _image = File(image.path);
      });
    }

    if (_image != null)
      return true;
    else
      return false;
  }
}

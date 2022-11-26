// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Profile/Menus/earnings.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

import '../../../utils/colors.dart';

class ExchangeBees extends StatefulWidget {
  const ExchangeBees({Key key}) : super(key: key);

  @override
  State<ExchangeBees> createState() => _ExchangeBeesState();
}

class _ExchangeBeesState extends State<ExchangeBees> {
  Api obj;
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
          "Balance",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 150,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
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
                        SizedBox(height: 10),
                        Text(
                          "Beans Balance",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "💎  ${obj.userModel.diamonds ?? 0}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Gems Balance",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Exchange Gems to Beans",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "10 💎 = 4 ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Image.asset(
                          "assets/icons/beans.png",
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "400 ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Image.asset(
                            "assets/icons/beans.png",
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (obj.userModel.diamonds >= 1000) {
                          bool k = await obj.updateBeans(by: 400);
                          bool m = await obj.updateDiamonds(by: -1000);
                          if (k && m) {
                            CustomSnackBar(
                              context,
                              Text("Updated Balance"),
                            );
                          }
                        } else {
                          CustomSnackBar(
                            context,
                            Text("Insufficient Balance"),
                          );
                        }
                      },
                      child: Center(
                        child: Container(
                          width: 120,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "1000 💎",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "4000 ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Image.asset(
                            "assets/icons/beans.png",
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (obj.userModel.diamonds >= 10000) {
                          bool k = await obj.updateBeans(by: 4000);
                          bool m = await obj.updateDiamonds(by: -10000);
                          if (k && m) {
                            CustomSnackBar(
                              context,
                              Text("Updated Balance"),
                            );
                          }
                        } else {
                          CustomSnackBar(
                            context,
                            Text("Insufficient Balance"),
                          );
                        }
                      },
                      child: Center(
                        child: Container(
                          width: 120,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "10,000 💎",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "40,000 ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Image.asset(
                            "assets/icons/beans.png",
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (obj.userModel.diamonds >= 100000) {
                          bool k = await obj.updateBeans(by: 40000);
                          bool m = await obj.updateDiamonds(by: -100000);
                          if (k && m) {
                            CustomSnackBar(
                              context,
                              Text("Updated Balance"),
                            );
                          }
                        } else {
                          CustomSnackBar(
                            context,
                            Text("Insufficient Balance"),
                          );
                        }
                      },
                      child: Center(
                        child: Container(
                          width: 120,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "100,000 💎",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "What is the Gem balance ?",
                  style: TextStyle(
                    color: pink,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              for (var i = 0; i < 2; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: MyBullet(),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Text(
                          "Gems can be exchanged for gold bees, used to buy gifts, cars and other props",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
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

// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter/animation.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Animations {
//   static fromBottom(Animation<double> _animation,
//       Animation<double> _secondaryanimation, Widget _child) {
//     return SlideTransition(
//       child: _child,
//       position: Tween<Offset>(end: Offset.zero, begin: Offset(0.0, 1.0))
//           .animate(_animation),
//     );
//   }
// }

// final String _url = 'https://wa.me/96565005196';
// final String _accepturl = 'https://tryingredients.com/en/default/terms';

// void launchURL() async =>
//     await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

// void launchAcceptURL() async => await canLaunch(_accepturl)
//     ? await launch(_accepturl)
//     : throw 'Could not launch $_accepturl';

void progressok(BuildContext context, bool k, String msg, String amt) {
  if (k) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          elevation: 10,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    msg,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    amt + " KD",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  msg == "Payment UnSuccessful"
                      ? Icon(Icons.info_outline, size: 40, color: Colors.red)
                      : Icon(
                          Icons.done_all,
                          size: 40,
                          color: Colors.blue,
                        )
                ],
              ),
            ),
          ],
        );
      },
    );
  } else {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}

class CustomSnackBar {
  CustomSnackBar(BuildContext context, Widget content,
      {SnackBarAction snackBarAction,
      Color backgroundColor = const Color(0xffFF745C)}) {
    final SnackBar snackBar = SnackBar(
        action: snackBarAction,
        backgroundColor: backgroundColor,
        content: content,
        behavior: SnackBarBehavior.floating);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

void loginQuit(BuildContext context) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (a1, a2, child) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: Text("Are you sure to quit login?")),
                  SizedBox(height: 5),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.4,
                    // ignore: deprecated_member_use
                    child: OutlinedButton(
                      // disabledColor: Colors.white,
                      // color: Colors.white,
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => RenewPackage(),
                        //   ),
                        // );
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // textColor: Colors.black,
                      // shape: RoundedRectangleBorder(
                      //   side: BorderSide(
                      //       color: Colors.grey[350],
                      //       width: 1,
                      //       style: BorderStyle.solid),
                      //   borderRadius: BorderRadius.circular(25),
                      // ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.4,
                    // ignore: deprecated_member_use
                    child: OutlinedButton(
                      // disabledColor: Colors.white,
                      // color: Colors.white,
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SubscriptionPage(
                        //       pass1: widget.pass1,
                        //       renew: true,
                        //       isChangePlan: true,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      // textColor: Colors.black,
                      // shape: RoundedRectangleBorder(
                      //   side: BorderSide(
                      //       color: Colors.grey[350],
                      //       width: 1,
                      //       style: BorderStyle.solid),
                      //   borderRadius: BorderRadius.circular(25),
                      // ),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 5,
                              child: Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                              ),
                            ),
                            Text(
                              "  or  ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 5,
                              child: Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Center(child: Text("Other login methods")),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.facebookF,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.google,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton(
      {this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: Center(
        child: InkWell(
          onTap: onClick,
          child: icon,
        ),
      ),
    );
  }
}

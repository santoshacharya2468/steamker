// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/LoginSignUp/generalLogin.dart';
import 'package:streamkar/Screens/LoginSignUp/phoneLogin.dart';
import 'package:streamkar/Screens/NavigationBar/bottomnavigation.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/authentication.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({Key key}) : super(key: key);

  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  bool isExpanded = false;
  Api obj;

  Future signUp(String email, String name, String password) async {
    bool isNew = await obj.isNewUser(email, type: 'email');
    if (isNew) {
      bool done = await obj.addUserToDb(
          name: name,
          email: email,
          password: password,
          phoneNumber: 0,
          photoURL:
              "https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/App-Assets%2FappLogo.png?alt=media&token=3470d1c0-2cb2-40c0-abb4-867b23c77fd7");
      if (done) {
        signIn(email, false);
      } else {
        CustomSnackBar(
          context,
          Text("Error Occured, Try Again"),
        );
      }
    } else {
      signIn(email, false);
    }
  }

  Future signIn(String email, bool isPasswordRequired) async {
    bool success = await obj.login(
          email: email,
          password: 'facebook',
        ) ??
        false;
    if (success) {
      CustomSnackBar(
        context,
        Text("Login SuccessFull"),
      );
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => BottomNavigationPage(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } else {
      CustomSnackBar(
        context,
        Text("Invalid Credentials, Try Again"),
      );
    }
  }

  Future<void> facebookSignIn() async {
    User user = await Authentication.signInWithFacebook(context: context);
    if (user != null) {
      signUp(user.email, user.displayName, "facebook");
    }
  }

  Future<void> googleSignIn() async {
    User user = await Authentication.signInWithGoogle(context: context);
    if (user != null) {
      // socialLogin('google', user.uid);
      // await Authentication.signOut(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/party-time-disco-lights.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/$appLogo',
                      width: 250,
                      // height: 70,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Text(
                  //   "StreamKar",
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 25,
                  //     letterSpacing: 1,
                  //   ),
                  // )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.35,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            // foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(78, 111, 198, 0.7)),
                            elevation: MaterialStateProperty.all<double>(4),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.white,
                                size: 22,
                              ),
                              Text(
                                'Facebook',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              Container()
                            ],
                          ),
                          onPressed: () async {
                            facebookSignIn();
                          },
                        ),
                      ),
                      SizedBox(height: 7),
                      // Container(
                      //   width: MediaQuery.of(context).size.width / 1.35,
                      //   child: ElevatedButton(
                      //     style: ButtonStyle(
                      //       alignment: Alignment.centerLeft,
                      //       // foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      //       backgroundColor: MaterialStateProperty.all<Color>(
                      //           Color.fromRGBO(216, 61, 56, 0.9)),
                      //       elevation: MaterialStateProperty.all<double>(4),
                      //       shape: MaterialStateProperty.all<
                      //           RoundedRectangleBorder>(
                      //         RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(30.0),
                      //         ),
                      //       ),
                      //       padding: MaterialStateProperty.all(
                      //           EdgeInsets.symmetric(
                      //               vertical: 12, horizontal: 20)),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Icon(
                      //           FontAwesomeIcons.google,
                      //           color: Colors.white,
                      //           size: 22,
                      //         ),
                      //         Text(
                      //           'Google',
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.normal,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //         Container()
                      //       ],
                      //     ),
                      //     onPressed: () {
                      //       googleSignIn();
                      //       // Navigator.push(
                      //       //   context,
                      //       //   MaterialPageRoute<dynamic>(
                      //       //     builder: (BuildContext context) =>
                      //       //         BottomNavigationPage(),
                      //       //   ),
                      //       // );
                      //     },
                      //   ),
                      // ),
                      // SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                          Text(
                            "   or   ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      isExpanded
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            PhoneLogin(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(26, 164, 249, 1),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.mobileAlt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            GeneralLogin(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: lightPink,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.userAlt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(8, 187, 191, 1),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.ellipsisH,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Login means you agree to our Terms & Privacy Policy",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

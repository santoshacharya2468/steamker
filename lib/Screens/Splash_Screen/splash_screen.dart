// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkar/Screens/LoginSignUp/loginHome.dart';
import 'package:streamkar/Screens/NavigationBar/bottomnavigation.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';
import 'package:streamkar/utils/loginCheck.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool first = true;
  Api obj;
  bool firstTimeUser;

  Future signIn() async {
    bool success = await obj.login(
            email: (obj.globalPhone != null && obj.globalPhone != 0)
                ? obj.globalPhone.toString()
                : obj.globalEmail,
            password: obj.globalPassword,
            type: (obj.globalPhone != null && obj.globalPhone != 0)
                ? "phone"
                : "email") ??
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
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => LoginHome(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    }
  }

  void gotohome() async {
    bool k = await isFirstTime();

    if (k == true) {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => LoginHome(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } else {
      bool k = await obj.getLoginStatus();
      if (k &&
          (obj.globalEmail != null ||
              (obj.globalPhone != null && obj.globalPhone != 0))) {
        signIn();
      } else {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => LoginHome(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      }
    }
  }

  Future<bool> isFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    firstTimeUser = !prefs.containsKey('FirstTimeUser');
    prefs.setBool('FirstTimeUser', false);
    if (firstTimeUser == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      first = false;
      gotohome();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: statusBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/$appLogo',
                height: 250,
                fit: BoxFit.fill,
              ),
            ),
            // Text(
            //   "B4 Live",
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontWeight: FontWeight.w400,
            //     fontSize: 25,
            //     letterSpacing: 1,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

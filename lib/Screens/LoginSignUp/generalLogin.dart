// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/LoginSignUp/signUp.dart';
import 'package:streamkar/Screens/NavigationBar/bottomnavigation.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';
import 'package:streamkar/utils/validators.dart';

import '../../utils/colors.dart';

class GeneralLogin extends StatefulWidget {
  const GeneralLogin({Key key}) : super(key: key);

  @override
  _GeneralLoginState createState() => _GeneralLoginState();
}

class _GeneralLoginState extends State<GeneralLogin> {
  bool obsecure = true;
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  final FocusNode idFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    idFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  // Future signIn() async {
  //   await FirebaseAuth.instance
  //       .signInWithEmailAndPassword(
  //     email: idController.text.trim(),
  //     password: passwordController.text.trim(),
  //   )
  //       .then((value) {
  //     CustomSnackBar(
  //       context,
  //       Text("Login SuccessFull"),
  //     );
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (context) => BottomNavigationPage(),
  //       ),
  //       (route) => false,
  //     );
  //   }).onError((error, stackTrace) {
  //     CustomSnackBar(
  //       context,
  //       Text(error.toString()),
  //     );
  //   });
  // }
  Future signIn() async {
    setState(() {
      loading = true;
    });
    bool success = await obj.login(
            email: idController.text, password: passwordController.text) ??
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
      setState(() {
        loading = false;
      });
    }
  }

  Api obj;
  @override
  Widget build(BuildContext context) {
    // loading = false;
    obj = Provider.of<Api>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back_ios,
                              size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "$appName Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Enter your account and password",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 20.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          validator: (e) => validateEmail(e),
                          focusNode: idFocus,
                          controller: idController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            filled: true,
                            fillColor: loginFill,
                            hintText: "Email ID",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30)),
                            hintStyle:
                                TextStyle(fontSize: 17.0, color: loginHint),
                          ),
                          onFieldSubmitted: (_) {
                            passwordFocus.requestFocus();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          validator: (e) => otherValidator(e),
                          focusNode: passwordFocus,
                          controller: passwordController,
                          obscureText: obsecure,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            filled: true,
                            fillColor: loginFill,
                            hintText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30)),
                            hintStyle:
                                TextStyle(fontSize: 17.0, color: loginHint),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  obsecure = !obsecure;
                                });
                              },
                              child: Icon(
                                obsecure
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            // idFocus.requestFocus();
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 30.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       InkWell(
                      //         onTap: () {},
                      //         child: Text(
                      //           "Forgot password?",
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.w400,
                      //             fontSize: 14,
                      //             letterSpacing: 1,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 50),
                      InkWell(
                        onTap: loading
                            ? null
                            : () async {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  setState(() {
                                    loading = true;
                                  });
                                  await signIn();
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 20.0, left: 20.0, right: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 50,
                            height: 46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(width: 2, color: Colors.white),
                            ),
                            child: Center(
                              child: loading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => SignUp(),
                        ),
                      );
                    },
                    child: Text(
                      "Don't have Account ?",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

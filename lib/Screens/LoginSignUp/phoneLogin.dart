// @dart=2.9
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/NavigationBar/bottomnavigation.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';
import 'package:streamkar/utils/validators.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({Key key}) : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  bool resend = true;
  String countryCode = "+39";
  final FocusNode phoneFocus = FocusNode();
  final FocusNode otpFocus = FocusNode();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  String verificationId;
  bool disableButton = false;
  bool invalidOtp = false;

  // Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber() async {
    if (phoneController.text.isEmpty) {
      CustomSnackBar(context, Text("Plzz Enter Valid Number"));
      return;
    }
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) {
      setState(() {
        print(
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $credential');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        CustomSnackBar(
            context,
            Text(
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}'));
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print(verificationId);
      CustomSnackBar(
          context,
          Text(
              "Otp Sent to ${countryCode + phoneController.text} SuccessFully"));
      setState(() {
        resend = false;
        disableButton = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode + phoneController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  void dispose() {
    phoneFocus.dispose();
    otpFocus.dispose();
    super.dispose();
  }

  Api obj;
  @override
  Widget build(BuildContext context) {
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
            physics: BouncingScrollPhysics(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: InkWell(
                        onTap: () {
                          loginQuit(context);
                          // Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back_ios,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Phone Number",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Enter your mobile number",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              letterSpacing: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0,
                                bottom: 20.0,
                                left: 20.0,
                                right: 20.0),
                            child: TextFormField(
                              validator: (e) => numberValidator(e),
                              focusNode: phoneFocus,
                              controller: phoneController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                              decoration: InputDecoration(
                                prefixIcon: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Container(
                                        width: 60,
                                        // height: 30,
                                        // color: Colors.pink,
                                        child: Center(
                                          child: Text(
                                            countryCode + "   |",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      // color: Colors.red,
                                      child: CountryListPick(
                                        appBar: AppBar(
                                          backgroundColor: Colors.white,
                                          leading: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                size: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            'Select Country/Region',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        theme: CountryTheme(
                                          isShowFlag: false,
                                          isShowTitle: false,
                                          isShowCode: false,
                                          isDownIcon: false,
                                          showEnglishName: true,
                                        ),
                                        initialSelection: countryCode,
                                        onChanged: (CountryCode code) {
                                          setState(() {
                                            countryCode = code.dialCode;
                                          });
                                        },
                                        // Whether to allow the widget to set a custom UI overlay
                                        useUiOverlay: true,
                                        // Whether the country list should be wrapped in a SafeArea
                                        useSafeArea: true,
                                      ),
                                    ),
                                  ],
                                ),
                                contentPadding: EdgeInsets.only(left: 20),
                                filled: true,
                                fillColor: loginFill,
                                hintText: "Phone Number",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(30)),
                                hintStyle: TextStyle(
                                  fontSize: 17.0,
                                  color: loginHint,
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                otpFocus.requestFocus();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0,
                                bottom: 20.0,
                                left: 20.0,
                                right: 20.0),
                            child: TextFormField(
                              validator: (e) => numberValidator(e),
                              focusNode: otpFocus,
                              controller: otpController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 20),
                                filled: true,
                                fillColor: loginFill,
                                hintText: "Verification code",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(30)),
                                hintStyle:
                                    TextStyle(fontSize: 17.0, color: loginHint),
                                suffixIcon: InkWell(
                                  onTap: !resend
                                      ? () {
                                          CustomSnackBar(
                                            context,
                                            Text("Wait Until Time Out"),
                                          );
                                        }
                                      : () async {
                                          if (resend == true) {
                                            await _sendCodeToPhoneNumber();
                                          }
                                        },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      width: 70,
                                      child: Center(
                                        child: !resend
                                            ? TweenAnimationBuilder(
                                                onEnd: () {
                                                  setState(() {
                                                    resend = true;
                                                  });
                                                },
                                                curve: Curves.linear,
                                                tween: Tween(
                                                    begin: 60.0, end: 0.0),
                                                duration: Duration(seconds: 60),
                                                builder: (_, value, child) =>
                                                    Text(
                                                  "00:${value.toInt()}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              )
                                            : Text(
                                                "Send",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onFieldSubmitted: (_) {
                                // idFocus.requestFocus();
                              },
                            ),
                          ),
                          SizedBox(height: 50),
                          InkWell(
                            onTap: disableButton || otpController.text == null
                                ? () {
                                    // setState(() {
                                    //   disableButton = false;
                                    // });
                                  }
                                : () async {
                                    setState(() {
                                      disableButton = true;
                                    });

                                    try {
                                      // Sign in using an sms code as input.
                                      final AuthCredential credential =
                                          PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: otpController.text,
                                      );

                                      FirebaseAuth _auth =
                                          FirebaseAuth.instance;
                                      UserCredential userCredential =
                                          await _auth
                                              .signInWithCredential(credential);
                                      print(userCredential.user);
                                      if (userCredential.user != null) {
                                        bool isNewUser = await obj.isNewUser(
                                            phoneController.text,
                                            type: "phone");
                                        if (isNewUser) {
                                          bool m = await obj
                                              .addUserToDb(
                                                  name: userCredential
                                                          .user.displayName ??
                                                      "User",
                                                  email: "b4live@gmail.com",
                                                  password: "password",
                                                  phoneNumber: int.parse(
                                                      phoneController.text),
                                                  photoURL:
                                                      "https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/App-Assets%2FappLogo.png?alt=media&token=3470d1c0-2cb2-40c0-abb4-867b23c77fd7")
                                              .then((value) async {
                                            return await obj.login(
                                                email: phoneController.text,
                                                password: "password",
                                                type: "phone");
                                          });
                                          if (m) {
                                            CustomSnackBar(
                                              context,
                                              Text("Login SuccessFull"),
                                            );
                                            Navigator.pushAndRemoveUntil<
                                                dynamic>(
                                              context,
                                              MaterialPageRoute<dynamic>(
                                                builder:
                                                    (BuildContext context) =>
                                                        BottomNavigationPage(),
                                              ),
                                              (route) =>
                                                  false, //if you want to disable back feature set to false
                                            );
                                          }
                                        } else {
                                          bool m = await obj.login(
                                              email:
                                                  phoneController.text.trim(),
                                              password: "password",
                                              type: "phone");

                                          if (m) {
                                            CustomSnackBar(
                                              context,
                                              Text("Login SuccessFull"),
                                            );
                                            Navigator.pushAndRemoveUntil<
                                                dynamic>(
                                              context,
                                              MaterialPageRoute<dynamic>(
                                                builder:
                                                    (BuildContext context) =>
                                                        BottomNavigationPage(),
                                              ),
                                              (route) =>
                                                  false, //if you want to disable back feature set to false
                                            );
                                          } else {
                                            CustomSnackBar(
                                              context,
                                              Text("Something Went Wrong"),
                                            );
                                          }
                                        }
                                      }
                                    } catch (e) {
                                      setState(() {
                                        invalidOtp = true;
                                      });
                                      CustomSnackBar(
                                        context,
                                        Text(e.toString()),
                                      );
                                    }

                                    setState(() {
                                      invalidOtp = false;
                                      disableButton = false;
                                    });
                                  },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 20.0,
                                  left: 20.0,
                                  right: 20.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 50,
                                height: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                ),
                                child: Center(
                                  child: disableButton
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 90),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 0.5,
                                ),
                              ),
                              Text(
                                "   Continue with   ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 0.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
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
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.facebookF,
                                    color: Colors.blue,
                                    size: 20,
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
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.google,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

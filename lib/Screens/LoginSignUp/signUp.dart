// @dart=2.9
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';
import 'package:streamkar/utils/validators.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  bool obsecure = true;
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmpasswordFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameFocus.dispose();
    emailFocus.dispose();
    confirmpasswordFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  Future signUp() async {
    bool isNew =
        await obj.isNewUser(emailController.text.trim(), type: 'email');
    if (isNew) {
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(
      //   email: emailController.text.trim(),
      //   password: passwordController.text.trim(),
      // )
      //     // ignore: missing_return
      //     .onError((error, stackTrace) {
      //   CustomSnackBar(
      //     context,
      //     Text(error.toString()),
      //   );
      // });
      // if (userCredential.user != null) {
      bool done = await obj.addUserToDb(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          phoneNumber: 0,
          photoURL:
              "https://firebasestorage.googleapis.com/v0/b/de-dating-9b6b6.appspot.com/o/App-Assets%2FappLogo.png?alt=media&token=3470d1c0-2cb2-40c0-abb4-867b23c77fd7");
      if (done) {
        CustomSnackBar(
          context,
          Text("User Registered SuccessFully"),
        );
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => BottomNavigationPage(),
        //   ),
        //   (route) => false,
        // );
        Navigator.of(context).pop();
      } else {
        CustomSnackBar(
          context,
          Text("Error Occured, Try Again"),
        );
        // obj.signOut();
        setState(() {
          loading = false;
        });
      }
      // }
    } else {
      CustomSnackBar(
        context,
        Text("User Already Exists"),
      );
      setState(() {
        loading = false;
      });
    }
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
                        "Register For Your Account",
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
                          validator: (e) => otherValidator(e),
                          focusNode: nameFocus,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            filled: true,
                            fillColor: loginFill,
                            hintText: "Name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30)),
                            hintStyle: TextStyle(
                              fontSize: 17.0,
                              color: loginHint,
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            emailFocus.requestFocus();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          validator: (e) => validateEmail(e),
                          focusNode: emailFocus,
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            filled: true,
                            fillColor: loginFill,
                            hintText: "Email",
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
                            hintStyle: TextStyle(
                              fontSize: 17.0,
                              color: loginHint,
                            ),
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
                            confirmpasswordFocus.requestFocus();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          validator: (e) => otherValidator(e),
                          focusNode: confirmpasswordFocus,
                          controller: confirmpasswordController,
                          obscureText: obsecure,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            filled: true,
                            fillColor: loginFill,
                            hintText: "Confirm Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30)),
                            hintStyle: TextStyle(
                              fontSize: 17.0,
                              color: loginHint,
                            ),
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
                      SizedBox(height: 50),
                      InkWell(
                        onTap: loading
                            ? null
                            : () async {
                                if (passwordController.text !=
                                    confirmpasswordController.text) {
                                  CustomSnackBar(
                                    context,
                                    Text("Password Do Not Match"),
                                  );
                                  return;
                                } else if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  setState(() {
                                    loading = true;
                                  });
                                  await signUp();
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
                                      "Register",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

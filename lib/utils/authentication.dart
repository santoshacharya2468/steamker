// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:streamkar/Screens/LoginSignUp/loginHome.dart';

class Authentication {
  static SnackBar customSnackBar({String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User user = FirebaseAuth.instance.currentUser;

    if (user != null) {}

    return firebaseApp;
  }

  static Future<User> signInWithGoogle({BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e is FirebaseAuthException) {
            showMessage(e, context);
          }
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

  static Future<void> signOut({BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut().then(
            (value) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoginHome(),
              ),
              (route) => false,
            ),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static Future<User> signInWithFacebook({BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken.token);
          final userCredential =
              await auth.signInWithCredential(facebookCredential);
          user = userCredential.user;
          Authentication.customSnackBar(
            content: 'Token: ${result.accessToken.token}',
          );
          break;

        case LoginStatus.cancelled:
          Authentication.customSnackBar(
            content: 'Login cancelled by the user.',
          );
          break;
        case LoginStatus.failed:
          Authentication.customSnackBar(
            content: 'Something went wrong with the login process.\n'
                'Here\'s the error Facebook gave us: ${result.message}',
          );
          break;
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e is FirebaseAuthException) {
        showMessage(e, context);
      }
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'The account already exists with a different credential',
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred using Facebook Sign In. Try again.',
        ),
      );
    }

    return user;
  }

  // static Future<void> facebookLogOut() async {
  //   final FacebookLogin facebookSignIn = new FacebookLogin();
  //   await facebookSignIn.logOut();
  //   await FirebaseAuth.instance.signOut();
  //   _showMessage('Logged out.');
  // }

  static void showMessage(FirebaseAuthException e, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                  print(e.code);
                  if (e.code == 'account-exists-with-different-credential') {
                    List<String> emailList = await FirebaseAuth.instance
                        .fetchSignInMethodsForEmail(e.email);
                    if (emailList.first == "google.com") {
                      await signInwithGoogle(true, e.credential);
                    }
                  }
                },
              )
            ],
          );
        });
  }

  static Future<String> signInwithGoogle(
      [bool link = false, AuthCredential authCredential]) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      if (link) {
        await linkProviders(userCredential, authCredential);
      }
      return userCredential.user.displayName;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<UserCredential> linkProviders(
      UserCredential userCredential, AuthCredential newCredential) async {
    return await userCredential.user.linkWithCredential(newCredential);
  }

  // static Future<void> signOutFromApple() async {
  //   await FirebaseAuth.instance.signOut();
  // }

  // /// Generates a cryptographically secure random nonce, to be included in a
  // /// credential request.
  // static String generateNonce([int length = 32]) {
  //   final charset =
  //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }

  // /// Returns the sha256 hash of [input] in hex notation.
  // static String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // static Future<User> signInWithApple({BuildContext context}) async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);

  //   try {
  //     // Request credential for the currently signed in Apple account.
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: nonce,
  //     );

  //     print(appleCredential.authorizationCode);

  //     // Create an `OAuthCredential` from the credential returned by Apple.
  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       rawNonce: rawNonce,
  //     );

  //     // Sign in the user with Firebase. If the nonce we generated earlier does
  //     // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //     try {
  //       final authResult =
  //           await FirebaseAuth.instance.signInWithCredential(oauthCredential);

  //       final displayName =
  //           '${appleCredential.givenName} ${appleCredential.familyName}';

  //       final firebaseUser = authResult.user;
  //       print(displayName);
  //       await firebaseUser.updateDisplayName(displayName);

  //       // if(appleCredential.email!=null){
  //       //   final userEmail = '${appleCredential.email}';
  //       //   await firebaseUser.updateEmail(userEmail);
  //       // }
  //       return firebaseUser;
  //     } on FirebaseAuthException catch (e) {
  //       if (e is FirebaseAuthException) {
  //         showMessage(e, context);
  //       }
  //       if (e.code == 'account-exists-with-different-credential') {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           Authentication.customSnackBar(
  //             content: 'The account already exists with a different credential',
  //           ),
  //         );
  //       } else if (e.code == 'invalid-credential') {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           Authentication.customSnackBar(
  //             content: 'Error occurred while accessing credentials. Try again.',
  //           ),
  //         );
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         Authentication.customSnackBar(
  //           content: 'Error occurred using Google Sign In. Try again.',
  //         ),
  //       );
  //     }
  //   } catch (exception) {
  //     print(exception);
  //   }

  //   return null;
  // }

}

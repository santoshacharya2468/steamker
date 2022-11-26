// // @dart=2.9
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:streamkar/Screens/LoginSignUp/loginHome.dart';
// import 'package:streamkar/Screens/NavigationBar/bottomnavigation.dart';

// class LoginCheck extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.active) {
//               if (snapshot.hasData)
//                 return BottomNavigationPage();
//               else
//                 return LoginHome();
//             } else
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//           },
//         ),
//       );
// }

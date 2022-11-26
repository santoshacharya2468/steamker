import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/Splash_Screen/splash_screen.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: statusBar));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Api>(create: (_) => Api()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.black,
        title: appName,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => Splash(),
          '/faq': (context) => new WebviewScaffold(
                url: "https://www.streamkar.com/streamkar/faq/",
                initialChild: Center(
                  child: CircularProgressIndicator(
                    color: pink,
                  ),
                ),
                withJavascript: true,
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
                    "FAQ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
          '/review': (context) => new WebviewScaffold(
                url: "https://play.google.com/store/",
                initialChild: Center(
                  child: CircularProgressIndicator(
                    color: pink,
                  ),
                ),
                withJavascript: true,
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
                    "Review Us",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
          '/facebook': (context) => new WebviewScaffold(
                url: "https://www.facebook.com/GamePlays1989/",
                initialChild: Center(
                  child: CircularProgressIndicator(
                    color: pink,
                  ),
                ),
                withJavascript: true,
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
                    "Facebook",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
          '/connect': (context) => new WebviewScaffold(
                url: "https://www.streamkar.com/streamkar/faq/",
                initialChild: Center(
                  child: CircularProgressIndicator(
                    color: pink,
                  ),
                ),
                withJavascript: true,
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
                    "Connect With Us",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
          '/about': (context) => new WebviewScaffold(
                url: "https://www.streamkar.com/streamkar/faq/",
                initialChild: Center(
                  child: CircularProgressIndicator(
                    color: pink,
                  ),
                ),
                withJavascript: true,
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
                    "About Us",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
        },
      ),
    );
  }
}

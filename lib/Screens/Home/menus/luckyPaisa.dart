import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/starAnimations.dart';

class LuckyPaisa extends StatefulWidget {
  const LuckyPaisa({Key? key}) : super(key: key);

  @override
  State<LuckyPaisa> createState() => _LuckyPaisaState();
}

class _LuckyPaisaState extends State<LuckyPaisa> {
  Api? obj;
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
          "Lucky Paisa",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: Sparkling(),
    );
  }
}

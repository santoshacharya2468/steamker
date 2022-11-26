// @dart=2.9

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';

class LuckyDraw extends StatefulWidget {
  final bool show;
  const LuckyDraw({Key key, @required this.show}) : super(key: key);

  @override
  State<LuckyDraw> createState() => _LuckyDrawState();
}

class _LuckyDrawState extends State<LuckyDraw> {
  bool show = false;
  StreamController<int> selected = StreamController<int>();
  Api obj;

  Future<void> update() async {
    var list = [
      20,
      50,
      10,
    ];

    final _random = new Random();
    var element = list[_random.nextInt(list.length)];
    bool m = await obj.updateBeans(by: element);
    if (m) {
      setState(() {
        show = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => LuckyDraw(show: true),
        ),
      );
      // try {
      //   Navigator.of(context).pop();
      //   CustomSnackBar(
      //     context,
      //     Text("Congratulation !! You Got $element Beans"),
      //   );
      // } catch (e) {
      //   print(e);
      //   CustomSnackBar(
      //     context,
      //     Text("Congratulation !! You Got $element Beans"),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    final items = <String>[
      'Aeroplane',
      'Bhangra',
      '20 beans',
      'Love-cano',
      '50 beans',
      'Fireworks',
      'Pearl',
      '10 beans',
    ];
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
          "Lucky Draw",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        color: Colors.yellow.shade200,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Take a shot at lucky draws daily, be ready to win big daily.",
                    style: TextStyle(
                      color: Color.fromARGB(255, 199, 131, 30),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        show = true;
                        selected.add(
                          Fortune.randomInt(0, items.length),
                        );
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Image.asset(
                        "assets/images/draw.jpeg",
                      ),
                    ),
                  ),
                  Text(
                    "1x daily if you top-up a single transaction of 1000+ beans to win a lucky draw",
                    style: TextStyle(
                      color: Color.fromARGB(255, 199, 131, 30),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "........................................................................",
                    style: TextStyle(
                      color: Color.fromARGB(255, 199, 131, 30),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        "Prize instructions",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "🔴 Any prize gifts recieved will be immediately delivered to your 'Backpack.'",
                        style: TextStyle(
                          color: Color.fromARGB(255, 199, 131, 30),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "🔴 Any gifts recieved can be counted towards user wealth level, talent star level, talent income",
                        style: TextStyle(
                          color: Color.fromARGB(255, 199, 131, 30),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              show
                  ? Container(
                      child: FortuneWheel(
                        onAnimationEnd: () async {
                          await update();
                        },
                        selected: selected.stream,
                        items: [
                          for (var it in items) FortuneItem(child: Text(it)),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

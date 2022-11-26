// @dart=2.9
import 'package:flutter/material.dart';
import 'package:streamkar/Screens/LiveStreaming/gift.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

class GiftButton extends StatelessWidget {
  final void Function(Gift) onGiftPicked;
  final String selectedUserId;
  GiftButton(this.selectedUserId, {@required this.onGiftPicked});
  final List<Gift> gifts = [
    Gift(
      name: 'Love',
      image: "assets/gifts/love.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/love.gif"),
      ),
      points: 3000,
    ),
    Gift(
      name: 'Red Heart',
      image: "assets/gifts/heartred.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/heartred.gif"),
      ),
      points: 2000,
    ),
    Gift(
      name: 'Cool',
      image: "assets/gifts/cool.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/cool.gif"),
      ),
      points: 1200,
    ),
    Gift(
      name: 'Kiss',
      image: "assets/gifts/kiss.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/kiss.gif"),
      ),
      points: 1200,
    ),
    Gift(
      name: 'Car',
      image: "assets/gifts/car.svga",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        child: SVGASimpleImage(assetsName: "assets/gifts/car.svga"),
      ),
      points: 5000,
    ),
    Gift(
      name: 'Love',
      image: "assets/gifts/love.svga",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        child: SVGASimpleImage(assetsName: "assets/gifts/love.svga"),
      ),
      points: 2500,
    ),
    Gift(
      name: 'Star',
      image: "assets/gifts/star.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/star.gif"),
      ),
      points: 1000,
    ),
    Gift(
      name: 'Twinkle',
      image: "assets/gifts/spark.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/spark.gif"),
      ),
      points: 1000,
    ),
    Gift(
      name: 'Spark',
      image: "assets/gifts/pinkFire.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/pinkFire.gif"),
      ),
      points: 1500,
    ),
    Gift(
      name: 'Heart',
      image: "assets/gifts/heart.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/heart.gif"),
      ),
      points: 2500,
    ),
    Gift(
      name: 'Golden Eagle',
      image: "assets/gifts/goldenEagle.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/goldenEagle.gif"),
      ),
      points: 5000,
    ),
    Gift(
      name: 'Dragon',
      image: "assets/gifts/dragon.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/dragon.gif"),
      ),
      points: 6500,
    ),
    Gift(
      image: "assets/gifts/butterfly.gif",
      name: 'Butterfly',
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/butterfly.gif"),
      ),
      points: 3000,
    ),
    Gift(
      name: 'Blue ball',
      image: "assets/gifts/blueBall.gif",
      icon: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/gifts/blueBall.gif"),
      ),
      points: 2000,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
          // context and builder are
          // required properties in this widget
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: gifts
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            child: Column(
                              children: [
                                e.icon,
                                Text(
                                  e.name,
                                ),
                                Text("${e.points} 🌟 Beans"),
                              ],
                            ),
                            onTap: () {
                              onGiftPicked(e);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        );
      },
      child: Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration:
              BoxDecoration(color: Colors.grey[900], shape: BoxShape.circle),
          child: Image.asset('assets/images/gift.png', fit: BoxFit.cover)),
    );
  }
}

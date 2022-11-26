// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/Common/userProfile.dart';
import 'package:streamkar/Screens/StatusAndSquad/addStatus.dart';
import 'package:streamkar/Screens/StatusAndSquad/hashtag.dart';
import 'package:streamkar/Screens/StatusAndSquad/postDetails.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

import '../../utils/colors.dart';

class StatusHome extends StatefulWidget {
  @override
  _StatusHomeState createState() => _StatusHomeState();
}

class _StatusHomeState extends State<StatusHome> with TickerProviderStateMixin {
  TabController _tabController;
  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    animationController.addListener(() {
      setState(() {});
    });
  }

  File _image;
  Future<bool> getImage(ImageSource source, {type = "image"}) async {
    ImagePicker imagePicker = ImagePicker();
    if (type == "image") {
      var image = await imagePicker.getImage(
          source: source, maxHeight: 200, maxWidth: 200);
      setState(() {
        _image = File(image.path);
      });
    } else {
      var image = await imagePicker.getVideo(
          source: source, maxDuration: Duration(seconds: 300));
      setState(() {
        _image = File(image.path);
      });
    }

    if (_image != null)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBar,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
          child: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 0.5, 1.0],
                tileMode: TileMode.clamp,
              ),
              borderRadius: BorderRadius.circular(50),
              color: Colors.redAccent,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 12),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(fontSize: 12),
            labelPadding: EdgeInsets.all(0),
            tabs: <Widget>[
              Tab(
                text: "    Hot    ",
              ),
              Tab(
                text: "    New    ",
              ),
              Tab(
                text: "   Followed    ",
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            TabBarView(
              controller: _tabController,
              children: <Widget>[
                Hot(),
                New(),
                Followed(),
              ],
            ),
            Positioned(
                right: 10,
                bottom: 10,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    IgnorePointer(
                      child: Container(
                        color: Colors.transparent,
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(270),
                          degOneTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 15,
                          child: CircularButton(
                            color: Colors.white,
                            width: 35,
                            height: 35,
                            icon: Icon(
                              Icons.camera_alt,
                              color: purple,
                            ),
                            onClick: () async {
                              print('First Button');
                              bool k = await getImage(ImageSource.camera);
                              if (k) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        AddStatus(image: _image),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(225),
                          degTwoTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degTwoTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 15,
                          child: CircularButton(
                            color: Colors.white,
                            width: 35,
                            height: 35,
                            icon: Icon(
                              Icons.video_call,
                              color: purple,
                            ),
                            onClick: () async {
                              print('Second button');
                              bool k = await getImage(ImageSource.gallery,
                                  type: "video");
                              if (k) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        AddStatus(image: _image),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(180),
                          degThreeTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degThreeTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 15,
                          child: CircularButton(
                            color: Colors.white,
                            width: 35,
                            height: 35,
                            icon: Icon(
                              Icons.image,
                              color: purple,
                            ),
                            onClick: () async {
                              bool k = await getImage(ImageSource.gallery);
                              if (k) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        AddStatus(image: _image),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value)),
                      alignment: Alignment.center,
                      child: Card(
                        elevation: 15,
                        child: CircularButton(
                          color: Colors.white,
                          width: 40,
                          height: 40,
                          icon: Icon(
                            Icons.add,
                            color: purple,
                          ),
                          onClick: () {
                            if (animationController.isCompleted) {
                              animationController.reverse();
                            } else {
                              animationController.forward();
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class Hot extends StatefulWidget {
  const Hot({Key key}) : super(key: key);

  @override
  State<Hot> createState() => _HotState();
}

class _HotState extends State<Hot> {
  Future<void> initialize() async {
    bool success = await obj.getStatus();
    if (success) {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> initialize2() async {
    if (obj.appStatus.length > 0) {
      setState(() {
        loading = false;
      });
    } else {
      bool success = await obj.getStatus();
      if (success) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Api obj;
  bool first = true;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      loading = true;
      initialize2();
      first = false;
    }
    obj.appStatus
        .sort((b, a) => a.comments.length.compareTo(b.comments.length));
    return RefreshIndicator(
      onRefresh: initialize,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Trending",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 135,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("hashtags")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text(
                              'No Posts !!',
                            ),
                          );
                        } else {
                          var myChats = snapshot.data.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: myChats.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              return Card(
                                elevation: 0,
                                shadowColor: Colors.grey,
                                child: new GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            HashTag(
                                          hashTagId: myChats[i]["hashTag"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(2),
                                          ),
                                          color: Colors.transparent,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(2),
                                          ),
                                          child: Image.network(
                                            myChats[i]["image"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          myChats[i]["hashTag"],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),

                  // StreamBuilder(
                  //   stream: _controller.stream,
                  //   builder: (context, snapdata) {
                  //     switch (snapdata.connectionState) {
                  //       case ConnectionState.waiting:
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       default:
                  //         if (snapdata.hasError) {
                  //           return Text('Please Wait....');
                  //         } else {
                  //           return
                  //           ListView.builder(
                  //             shrinkWrap: true,
                  //             physics: NeverScrollableScrollPhysics(),
                  //             itemCount: obj.appStatus.length,
                  //             itemBuilder: (context, i) {
                  //               return Post(
                  //                 showBar: true,
                  //                 status: obj.appStatus[i],
                  //               );
                  //             },
                  //           );
                  //         }
                  //     }
                  //   },
                  // ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: obj.appStatus.length,
                    itemBuilder: (context, i) {
                      return Post(
                        showBar: true,
                        status: obj.appStatus[i],
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class New extends StatefulWidget {
  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  Future<void> initialize() async {
    bool success = await obj.getStatus();
    if (success) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> initialize2() async {
    if (obj.appStatus.length > 0) {
      setState(() {
        loading = false;
      });
    } else {
      bool success = await obj.getStatus();
      if (success) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Api obj;
  bool first = true;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      initialize2();
      first = false;
    }

    obj.appStatus.sort((b, a) => a.time.compareTo(b.time));
    return RefreshIndicator(
      onRefresh: initialize,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: obj.appStatus.length,
                itemBuilder: (context, i) {
                  return Post(
                    showBar: true,
                    status: obj.appStatus[i],
                  );
                },
              ),
      ),
    );
  }
}

class Followed extends StatefulWidget {
  @override
  State<Followed> createState() => _FollowedState();
}

class _FollowedState extends State<Followed> {
  Future<void> initialize() async {
    bool success = await obj.getStatus();
    if (success) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> initialize2() async {
    if (obj.appStatus.length > 0) {
      setState(() {
        loading = false;
      });
    } else {
      bool success = await obj.getStatus();
      if (success) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Api obj;
  bool first = true;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      initialize2();
      first = false;
    }
    return RefreshIndicator(
      onRefresh: initialize,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: obj.appStatus
                    .where((e) => obj.userModel.connection
                        .where((m) => m.type == "following")
                        .toList()
                        .where((connection) => connection.userID == e.userID)
                        .toList()
                        .isNotEmpty)
                    .toList()
                    .length,
                itemBuilder: (context, i) {
                  return Post(
                    showBar: true,
                    status: obj.appStatus
                        .where((e) => obj.userModel.connection
                            .where((m) => m.type == "following")
                            .toList()
                            .where(
                                (connection) => connection.userID == e.userID)
                            .toList()
                            .isNotEmpty)
                        .toList()[i],
                  );
                },
              ),
      ),
    );
  }
}

class Post extends StatefulWidget {
  final bool showBar;
  final Status status;
  const Post({Key key, @required this.status, @required this.showBar})
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  Api obj;
  bool liked;

  Future<void> like() async {
    if (liked) {
      final collection = await FirebaseFirestore.instance
          .collection("status")
          .doc(widget.status.id)
          .collection("likes")
          .doc(obj.userModel.id)
          .delete();

      setState(() {
        obj.appStatus
            .where((e) => e.id == widget.status.id)
            .toList()
            .first
            .likes
            .removeWhere((e) => e.id == obj.userModel.id);
        liked = !liked;
        obj.notify();
      });
    } else {
      final collection = await FirebaseFirestore.instance
          .collection("status")
          .doc(widget.status.id)
          .collection("likes")
          .doc(obj.userModel.id)
          .set({
        "time": DateTime.now(),
        "userID": obj.userModel.id,
      });
      setState(() {
        obj.appStatus
            .where((e) => e.id == widget.status.id)
            .toList()
            .first
            .likes
            .add(Likes(id: obj.userModel.id));

        obj.notify();
        liked = !liked;
      });
    }
  }

  bool first = true;

  void initialize() {
    setState(() {
      liked = widget.status.likes
          .where((e) => e.id == obj.userModel.id)
          .toList()
          .isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of(context);

    initialize();
    if (first) {
      first = false;
      initialize();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: obj.appUsers
                          .where((e) => e.id == widget.status.userID)
                          .toList()
                          .first
                          .id ==
                      obj.userModel.id
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => UserProfile(
                              userModel: obj.appUsers
                                  .where((e) => e.id == widget.status.userID)
                                  .toList()
                                  .first),
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        obj.appUsers
                            .where((e) => e.id == widget.status.userID)
                            .toList()
                            .first
                            .photoURL,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      obj.appUsers
                          .where((e) => e.id == widget.status.userID)
                          .toList()
                          .first
                          .name,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.status.description,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: ImageSlideshow(
                  width: double.infinity,
                  height: 200,
                  initialPage: 0,
                  indicatorColor: Colors.white,
                  indicatorBackgroundColor: Colors.grey,
                  children: [
                    for (var i = 0; i < widget.status.image.length; i++)
                      Image.network(
                        widget.status.image[i],
                        fit: BoxFit.contain,
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${DateTime.now().difference(widget.status.time).inDays} day(s) ago",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  widget.status.likes.length < 5
                      ? Container()
                      : Row(
                          children: [
                            Container(
                              width: 60,
                              height: 20,
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        obj.appUsers
                                            .where((e) =>
                                                e.id ==
                                                widget.status.likes[0].id)
                                            .toList()
                                            .first
                                            .photoURL,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        obj.appUsers
                                            .where((e) =>
                                                e.id ==
                                                widget.status.likes[1].id)
                                            .toList()
                                            .first
                                            .photoURL,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 20,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        obj.appUsers
                                            .where((e) =>
                                                e.id ==
                                                widget.status.likes[2].id)
                                            .toList()
                                            .first
                                            .photoURL,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 30,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        obj.appUsers
                                            .where((e) =>
                                                e.id ==
                                                widget.status.likes[3].id)
                                            .toList()
                                            .first
                                            .photoURL,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Likes",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            ),
                          ],
                        )
                ],
              ),
            ),
            !widget.showBar
                ? Container()
                : Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),
            !widget.showBar
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        like();
                                      },
                                      child: Icon(
                                        liked
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color:
                                            liked ? Colors.red : Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      widget.status.likes.length == 0
                                          ? ""
                                          : widget.status.likes.length
                                              .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          PostDetails(
                                        status: widget.status,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(FontAwesomeIcons.comment),
                                      SizedBox(width: 5),
                                      Text(
                                        widget.status.comments.length == 0
                                            ? ""
                                            : widget.status.comments.length
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(FontAwesomeIcons.whatsapp),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.more_horiz),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

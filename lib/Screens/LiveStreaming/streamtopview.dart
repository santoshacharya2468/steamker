// @dart=2.9
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/Common/userProfile.dart';
import 'package:streamkar/Screens/LiveStreaming/streaming_bottom_view.dart';
import 'package:streamkar/Screens/LiveStreaming/streamingmodel.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/starAnimations.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

class StreamingTopView extends StatefulWidget {
  final UserStream stream;
  final Function onEnd;
  final ClientRole role;
  final RtcEngine engine;
  final String callType;
  final int agoraId;
  final String selectedUserId;
  StreamingTopView(this.selectedUserId, this.stream, this.onEnd, this.role,
      this.engine, this.callType, this.agoraId);

  @override
  _StreamingTopViewState createState() => _StreamingTopViewState();
}

class _StreamingTopViewState extends State<StreamingTopView> {
  final _firestore = FirebaseFirestore.instance;
  bool showStack = true;

  Api streamController;
  Widget _buildOtherUsers(List otherUsers) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      reverse: true,
      itemCount: otherUsers.length,
      itemBuilder: (context, int index) {
        String pp = otherUsers[index]['profilePicture'];
        return CircleAvatar(
          radius: 15,
          backgroundImage: pp != null && pp.length > 10
              ? NetworkImage(pp)
              : AssetImage('assets/images/gigo.png'),
        );
      },
    );
  }

  Widget _buildStreamerProfile(UserStream stream, int listeners) {
    UserModel user = stream.streamer;
    List<UserModel> m = streamController.appUsers.where((e) {
      return e.id == user.id;
    }).toList();
    if (m.isNotEmpty) user = m.first;

    return InkWell(
      onTap: () {
        Scaffold.of(context).showBottomSheet(
          (context) => Container(
            height: 300,
            child: UserProfile(
              userModel: user,
            ),
          ),
        );
      },
      child: Container(
        height: 35,
        width: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.fromBorderSide(BorderSide(color: purple))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 5),
            CircleAvatar(
                radius: 15,
                backgroundImage:
                    user.photoURL != null && user.photoURL.isNotEmpty
                        ? NetworkImage(user.photoURL)
                        : AssetImage('assets/images/gigo.png')),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                children: [
                  Builder(
                    builder: (_) {
                      var name = '';
                      if (user.name != null && user.name.length > 0) {
                        if (user.name.length > 6) {
                          name = user.name.substring(0, 5);
                        } else {
                          name = user.name;
                        }
                      } else if (user.name != null && user.name.length > 0) {
                        if (user.name.length > 6) {
                          name = user.name.substring(0, 5);
                        } else {
                          name = user.name;
                        }
                      }
                      return Text(
                        name,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      );
                    },
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5),
                      Icon(
                        Icons.group,
                        size: 12,
                        color: Colors.white,
                      ),
                      SizedBox(width: 2),
                      Text(
                        listeners.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  )
                ],
              ),
            ),
            streamController.userModel != null &&
                    streamController.userModel.id == stream.streamer.id
                ? Expanded(child: Container())
                : Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: purple,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String imagePopUp;

  @override
  Widget build(BuildContext context) {
    streamController = Provider.of<Api>(context);

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStreamerProfile(widget.stream,
                                  widget.stream.listeners.length),
                              Expanded(
                                  child: _buildOtherUsers(
                                      widget.stream.listeners)),
                              IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  widget.onEnd();
                                  streamController.showVideoStack = false;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                streamController.showVideoStack
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          height: 250,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.stream != null &&
                                        widget.stream.chatTitle != null &&
                                        widget.stream.chatTitle.isNotEmpty
                                    ? widget.stream.chatTitle
                                    : '',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: StreamBuilder(
                                    stream: _firestore
                                        .collection("liveStreamings")
                                        .doc(widget.stream.docId)
                                        .collection('comments')
                                        .orderBy('date', descending: true)
                                        .snapshots(),
                                    builder: (_,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          itemCount:
                                              snapshot.data.docs.length + 1,
                                          physics: BouncingScrollPhysics(),
                                          reverse: true,
                                          itemBuilder: (_, index) {
                                            if (index ==
                                                snapshot.data.docs.length)
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    right: 10,
                                                    left: 10),
                                                child: Container(
                                                  // height: 50,
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                  ),
                                                  child: Text(
                                                    "sexual and violent content is strictly prohibited. All violators will be banned. Do not expose your personal info such as phone or location",
                                                    style: TextStyle(
                                                      color: Colors
                                                          .lightBlue.shade400,
                                                    ),
                                                  ),
                                                ),
                                              );

                                            var doc = snapshot.data.docs[index]
                                                .data();
                                            if (doc['image'] != null) {
                                              Future.delayed(
                                                      Duration(seconds: 1))
                                                  .then((value) {
                                                int seconds = -1 *
                                                    (doc['date'] as Timestamp)
                                                        .toDate()
                                                        .difference(
                                                            DateTime.now())
                                                        .inSeconds;

                                                if (seconds <= 1) {
                                                  Future.delayed(
                                                          Duration(seconds: 0))
                                                      .then((value) {
                                                    setState(() {
                                                      imagePopUp = doc['image'];
                                                    });
                                                    Timer(Duration(seconds: 8),
                                                        () {
                                                      setState(() {
                                                        imagePopUp = null;
                                                      });
                                                    });
                                                  });
                                                }
                                              });
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, right: 10, left: 10),
                                              child: Container(
                                                // height: 50,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        streamController
                                                                    .appUsers
                                                                    .where((e) =>
                                                                        e.id ==
                                                                        doc['by']
                                                                            [
                                                                            'uid'])
                                                                    .toList()
                                                                    .length ==
                                                                0
                                                            ? Icon(
                                                                Icons.star,
                                                                size: 18,
                                                                color: pink,
                                                              )
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                child: Image
                                                                    .network(
                                                                  streamController
                                                                      .appUsers
                                                                      .where((e) =>
                                                                          e.id ==
                                                                          doc['by']
                                                                              [
                                                                              'uid'])
                                                                      .toList()
                                                                      .first
                                                                      .photoURL,
                                                                  height: 18,
                                                                  width: 18,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                        SizedBox(width: 5),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                      color: Colors
                                                                          .green),
                                                              child: Text(
                                                                "Lv.1",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 9,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            5),
                                                                      ),
                                                                      color: Colors
                                                                              .orange[
                                                                          300]),
                                                              child: Text(
                                                                "❤️ 0",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 9,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            "  " +
                                                                doc['by']
                                                                        ['name']
                                                                    .toString()
                                                                    .toUpperCase(),
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              color: pink,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.card_giftcard,
                                                          size: 16,
                                                          color: pink,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            ' : ' + doc['body'],
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              if (widget.stream != null)
                                StreamingBottomView(
                                    widget.selectedUserId,
                                    widget.role,
                                    widget.engine,
                                    widget.callType == 'Video' ? true : false,
                                    widget.stream,
                                    widget.agoraId)
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            imagePopUp == null
                ? Container()
                : Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Sparkling(),
                          !imagePopUp.contains("svga")
                              ? Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Center(
                                    child: Image.asset(
                                      imagePopUp,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height - 250,
                                  // width: MediaQuery.of(context).size.width,
                                  width: double.infinity,
                                  child: FittedBox(
                                    child: Center(
                                      child: SVGASimpleImage(
                                        assetsName: imagePopUp,
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

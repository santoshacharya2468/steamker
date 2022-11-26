// @dart=2.9

// ignore_for_file: missing_required_param

import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as localview;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as remoteview;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/LiveStreaming/agora_cofig.dart';
import 'package:streamkar/Screens/LiveStreaming/agora_permission.dart';
import 'package:streamkar/Screens/LiveStreaming/agora_token.dart';
import 'package:streamkar/Screens/LiveStreaming/live_video_model.dart';
import 'package:streamkar/Screens/LiveStreaming/pkdetails.dart';
import 'package:streamkar/Screens/LiveStreaming/progressBar.dart';
import 'package:streamkar/Screens/LiveStreaming/streaming_ended.dart';
import 'package:streamkar/Screens/LiveStreaming/streamingmodel.dart';
import 'package:streamkar/Screens/LiveStreaming/streamtopview.dart';
import 'package:streamkar/Screens/NavigationBar/bottomnavigation.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';

var defaultUid = 'cHvFVaDNcNT6dNrN61q5Apls1y72';

class LiveStreaming extends StatefulWidget {
  final ClientRole role;
  final String channelName;
  final String callType;
  final UserModel joinedUser;
  final streamingId;
  final UserStream oldStream;

  LiveStreaming(this.oldStream,
      {@required this.streamingId,
      @required this.role,
      @required this.channelName,
      @required this.callType,
      @required this.joinedUser});
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LiveStreaming> {
  static final _users = <int>[];
  bool muted = false;
  bool disable = true;
  RtcEngine engine;
  String callDoc;
  Api obj;

  ///this id is used to send gift to selected user on pk [battle]
  String selectedUserId;
  Stream<DocumentSnapshot<Map<String, dynamic>>> docStream;
  Api streamController;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> sub;
  UserStream stream;
  int myId;
  bool callEnded = false;
  String winerUid;
  int pkInviteSentSeconds = 0;
  var scoreMap = Map();

  @override
  void initState() {
    super.initState();
  }

  void initializeSomeInits() {
    if (widget.role == ClientRole.Broadcaster)
      handleCameraAndMic(widget.callType);
    initialize();
    listenStreamEvent();

    if (widget.role != ClientRole.Broadcaster) {
      streamController.joinOrLeaveStream(widget.streamingId);
    }
    docStream = FirebaseFirestore.instance
        .collection("liveStreamings")
        .doc(widget.streamingId)
        .snapshots();
    streamController.micState = false;
    streamController.showVideoStack = true;
    loading = false;
  }

  Future<void> initialize() async {
    await _initRtcEngine();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    await engine.setVideoEncoderConfiguration(configuration);
    bool isPublisher = widget.role == ClientRole.Broadcaster ? true : false;
    final token = await getToken(widget.channelName, isPublisher);
    await engine?.joinChannel(token.token, widget.channelName, null, 0);
  }

  Future<void> _initRtcEngine() async {
    // ignore: deprecated_member_use
    engine = await RtcEngine.createWithConfig(RtcEngineConfig(APP_ID));
    widget.callType == "Video"
        ? await engine.enableVideo()
        : await engine.enableAudio();

    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.setClientRole(widget.role);
    setState(() {});
    _addListeners();
  }

  _addListeners() {
    engine?.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, ellapsed) {
        if (widget.role == ClientRole.Broadcaster &&
            widget.oldStream.streamer.id != obj.userModel.id) {
          streamController.postComment(widget.streamingId, 'Joined live');
        } else if (widget.oldStream.streamer.id != obj.userModel.id) {
          streamController.postComment(widget.streamingId, 'Joined live');
        }
        if (widget.role == ClientRole.Broadcaster &&
            (widget.oldStream.allowMutiple || widget.oldStream.isPk)) {
          streamController.addorRemoveBroadCaster(widget.oldStream, uid);
        }

        setState(() {
          myId = uid;
        });
        //here we have to match firebase userid with agora uid to know whose uid corresponds to whom
      },
      userJoined: (uid, elapsed) {
        _users.add(uid);
        if (widget.callType == 'Audio') {
          engine.setEnableSpeakerphone(true);
        }
        setState(() {});
      },
    ));
  }

  listenStreamEvent() async {
    sub = await FirebaseFirestore.instance
        .collection("liveStreamings")
        .doc(widget.streamingId)
        .snapshots()
        .listen((doc) {
      if (doc.data != null) {
        bool state = doc.data()['isStreaming'];

        setState(() {
          stream = UserStream();
          stream.ack = doc.data()['ack'];
          stream.allowFreeSpeak = doc.data()['allowFreeSpeak'];
          stream.allowMutiple = doc.data()['allowMutiples'];
          stream.channelName = doc.data()['channelName'];
          stream.chatTitle = doc.data()['chatTitle'];
          stream.docId = doc.data()['docId'];
          stream.isPk = doc.data()['isPk'];
          stream.isStreaming = doc.data()['isStreaming'];
          stream.listeners = doc.data()['listeners'];
          stream.maxAllow = doc.data()['maxAllow'];
          stream.members = doc.data()['members'];
          stream.pkDetails =
              doc.data()['pkDetails'] == {} || doc.data()['pkDetails'] == null
                  ? PkDetails()
                  : PkDetails.fromMap(doc.data()['pkDetails']);
          stream.roomMode = doc.data()['roomMode'];
          stream.streamer = UserModel();
          stream.streamer.id = doc.data()['streamer'];
          stream.streamingPhoto = doc.data()['streamingPhoto'];
          stream.type = doc.data()['type'];
        });
        if (!state && !callEnded) {
          disposeAll(true);
          callEnded = true;
        }
        if (doc.data()['ack'] == 1 &&
            widget.role == ClientRole.Broadcaster &&
            widget.oldStream.streamer.id == obj.userModel.id) {
          streamController.ackBackToServer(widget.streamingId);
        }
      }
    });
  }

  @override
  void dispose() {
    _users.clear();
    sub?.cancel();
    super.dispose();
  }

  disposeAll(bool ended, {bool reJoin = false}) async {
    try {
      print("called 1");
      await engine?.leaveChannel();
      await engine?.destroy();
    } catch (e) {}
    if (widget.role == ClientRole.Broadcaster &&
        widget.oldStream.streamer.id == obj.userModel.id) {
      print("called 2");
      await streamController.endStream(widget.streamingId);
      // if (!ended) {
      //   return;
      // }
    } else if (widget.role == ClientRole.Audience) {
      print("called 3");
      await streamController.joinOrLeaveStream(widget.streamingId, join: false);
    } else {
      print("called 4");
      //for other boradcaster;
      streamController.addorRemoveBroadCaster(stream ?? widget.oldStream, myId,
          remove: true);
    }
    if (widget.role == ClientRole.Audience && ended) {
      print("called 5");
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => StreamingEnded(
            stream: widget.oldStream,
          ),
        ),
      );
    } else {
      if (widget.role == ClientRole.Audience && reJoin) {
        print("called 6");
        return;
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => StreamingEnded(
              stream: widget.oldStream,
            ),
          ),
        );
      }
    }
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(localview.SurfaceView());
    }
    _users.forEach((int uid) => list.add(remoteview.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]]),
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 1)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  void _onStreamEnd(BuildContext context) async {
    disposeAll(false);
  }

  controlGuest(UserStream stream) {
    if (widget.role == ClientRole.Broadcaster &&
        stream.streamer.id != obj.userModel.id) {
      engine.muteLocalAudioStream(!stream.allowFreeSpeak);
      streamController.micState = !stream.allowFreeSpeak;
    }
    if (widget.role == ClientRole.Broadcaster) {
      var myDoc = stream.members
          .where((element) => element['id'] == obj.userModel.id)
          .toList();
      if (myDoc.length < 0) {
        CustomSnackBar(context, Text("You are removed from members"));
        disposeAll(false);
      }
    }
  }

  Widget multipleGuestView(bool video) {
    return StreamBuilder(
      stream: docStream,
      builder:
          (_, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          UserStream stream = UserStream();
          stream.ack = snapshot.data.data()['ack'];
          stream.allowFreeSpeak = snapshot.data.data()['allowFreeSpeak'];
          stream.allowMutiple = snapshot.data.data()['allowMutiples'];
          stream.channelName = snapshot.data.data()['channelName'];
          stream.chatTitle = snapshot.data.data()['chatTitle'];
          stream.docId = snapshot.data.data()['docId'];
          stream.isPk = snapshot.data.data()['isPk'];
          stream.isStreaming = snapshot.data.data()['isStreaming'];
          stream.listeners = snapshot.data.data()['listeners'];
          stream.maxAllow = snapshot.data.data()['maxAllow'];
          stream.members = snapshot.data.data()['members'];
          stream.pkDetails = snapshot.data.data()['pkDetails'] == {} ||
                  snapshot.data.data()['pkDetails'] == null
              ? PkDetails()
              : PkDetails.fromMap(snapshot.data.data()['pkDetails']);
          stream.roomMode = snapshot.data.data()['roomMode'];
          stream.streamer = UserModel();
          stream.streamer.id = snapshot.data.data()['streamer'];
          stream.streamingPhoto = snapshot.data.data()['streamingPhoto'];
          stream.type = snapshot.data.data()['type'];
          List<LiveVideoModel> members =
              stream.members.map((e) => LiveVideoModel.fromMap(e)).toList();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            controlGuest(stream);
          });
          return Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: stream.maxAllow > 6 ? 3 : 2,
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing: 0.0),
                    itemCount: stream.maxAllow,
                    itemBuilder: (_, index) {
                      if (members.length > index) {
                        var vm = members[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: purple),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              if (!video)
                                Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.black,
                                  ),
                                ),
                              if (video)
                                obj.userModel != null &&
                                        vm.uid == obj.userModel.id
                                    ? localview.SurfaceView()
                                    : remoteview.SurfaceView(uid: vm.videoId),
                              Positioned(
                                bottom: 0,
                                left: 10,
                                child: Text(
                                  vm.name,
                                  style: TextStyle(color: purple),
                                ),
                              ),
                              if (vm.uid == stream.channelName)
                                Positioned(
                                  top: 2,
                                  left: 2,
                                  child: Container(
                                    height: 18,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 8),
                                      child: Text(
                                        'Host',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: purple.withOpacity(0.8)),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }
                      return Container(
                        //  color: AppColors.PRIMARY_COLOR,
                        decoration:
                            BoxDecoration(border: Border.all(color: purple)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Spacer(),
                            Center(
                              child: Builder(
                                builder: (context) => Container(
                                  child:
                                      stream.roomMode ||
                                              stream.streamer.id ==
                                                  obj.userModel.id
                                          ? InkWell(
                                              child: Icon(Icons.add,
                                                  size: 30,
                                                  color: Colors.white),
                                              onTap: () async {
                                                if (widget.role ==
                                                    ClientRole.Audience) {
                                                  disposeAll(
                                                    false,
                                                    reJoin: true,
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          LiveStreaming(
                                                        stream,
                                                        streamingId:
                                                            stream.docId,
                                                        role: ClientRole
                                                            .Broadcaster,
                                                        joinedUser:
                                                            obj.userModel,
                                                        callType: stream.type,
                                                        channelName:
                                                            stream.channelName,
                                                      ),
                                                    ),
                                                  );
                                                  //     Get.off(() => LiveStreaming(
                                                  //   stream,
                                                  //   streamingId: stream.docId,
                                                  //   role: ClientRole.Broadcaster,
                                                  //   joinedUser: _authController.currentUser,
                                                  //   callType: stream.type,
                                                  //   channelName: stream.channelName,
                                                  // ));
                                                } else {
                                                  Scaffold.of(context)
                                                      .showBottomSheet(
                                                    (context) => Container(
                                                      height: 400,
                                                      child:
                                                          DefaultTabController(
                                                        length: 2,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              child: TabBar(
                                                                  tabs: [
                                                                'Invite',
                                                                'Remove',
                                                              ]
                                                                      .map((e) =>
                                                                          Text(
                                                                            e,
                                                                            style:
                                                                                TextStyle(color: Colors.black),
                                                                          ))
                                                                      .toList()),
                                                            ),
                                                            Expanded(
                                                              child: TabBarView(
                                                                children: [
                                                                  FutureBuilder(
                                                                    future: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "users")
                                                                        .get(),
                                                                    builder: (context,
                                                                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                                                            snashot) {
                                                                      if (snashot
                                                                          .hasData) {
                                                                        var users = snashot
                                                                            .data
                                                                            .docs
                                                                            .map((e) => UserModel.fromJson(e
                                                                                .data()))
                                                                            .where((element) =>
                                                                                element.id !=
                                                                                obj.userModel.id)
                                                                            .toList();

                                                                        return ListView
                                                                            .builder(
                                                                          itemCount:
                                                                              users.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            var user =
                                                                                users[index];
                                                                            return Card(
                                                                              child: ListTile(
                                                                                onTap: () async {
                                                                                  await FirebaseFirestore.instance.collection("users").doc(user.id).collection('notifications').add({
                                                                                    'body': '${obj.userModel.name} invited you to join a live',
                                                                                    'from': obj.userModel.id,
                                                                                    'collection': "liveStreamings",
                                                                                    'collectionId': widget.streamingId,
                                                                                    'title': 'Invite Alert',
                                                                                    'date': FieldValue.serverTimestamp(),
                                                                                    'seen': false,
                                                                                  });

                                                                                  Navigator.pop(context);
                                                                                  CustomSnackBar(context, Text("Invite Sent"));
                                                                                },
                                                                                leading: CircleAvatar(radius: 35, backgroundImage: NetworkImage(user.photoURL)),
                                                                                title: Text(user.name ?? user.id),
                                                                                subtitle: Text(user.name ?? ''),
                                                                                trailing: Text(
                                                                                  'Invite',
                                                                                  style: TextStyle(color: pink, fontSize: 18),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      }
                                                                      return ProgressBar();
                                                                    },
                                                                  ),
                                                                  FutureBuilder(
                                                                    future: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "users")
                                                                        .get(),
                                                                    builder: (context,
                                                                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                                                            snashot) {
                                                                      if (snashot
                                                                          .hasData) {
                                                                        var users = snashot
                                                                            .data
                                                                            .docs
                                                                            .map((e) => UserModel.fromJson(e
                                                                                .data()))
                                                                            .where((element) =>
                                                                                element.id !=
                                                                                obj.userModel.id)
                                                                            .toList();
                                                                        List<UserModel>
                                                                            userList =
                                                                            [];
                                                                        users.forEach(
                                                                            (u) {
                                                                          if (stream
                                                                              .members
                                                                              .where((m) => u.id == m['uid'])
                                                                              .toList()
                                                                              .isNotEmpty) {
                                                                            userList.add(u);
                                                                          }
                                                                        });
                                                                        userList.removeWhere((e) =>
                                                                            e.id ==
                                                                            stream.streamer.id);
                                                                        users =
                                                                            userList;
                                                                        return ListView
                                                                            .builder(
                                                                          itemCount:
                                                                              users.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            var user =
                                                                                users[index];
                                                                            return Card(
                                                                              child: ListTile(
                                                                                onTap: () async {
                                                                                  var data = stream.members.where((e) => e['uid'] == user.id).toList().first;
                                                                                  FirebaseFirestore.instance.collection("liveStreamings").doc(stream.docId).update({
                                                                                    'members': FieldValue.arrayRemove([data])
                                                                                  });

                                                                                  obj.notify();
                                                                                  Navigator.pop(context);
                                                                                  CustomSnackBar(context, Text("User Removed"));
                                                                                },
                                                                                leading: CircleAvatar(radius: 35, backgroundImage: NetworkImage(user.photoURL)),
                                                                                title: Text(user.name ?? user.id),
                                                                                subtitle: Text(user.name ?? ''),
                                                                                trailing: Text(
                                                                                  'Remove',
                                                                                  style: TextStyle(color: pink, fontSize: 18),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      }
                                                                      return ProgressBar();
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            )
                                          : SizedBox(),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          );
        } else {
          return ProgressBar();
        }
      },
    );
  }

  Widget pKView() {
    List<LiveVideoModel> members =
        stream.members.map((e) => LiveVideoModel.fromMap(e)).toList();
    if (!stream.pkDetails.pkStarted && widget.role == ClientRole.Audience) {
      return remoteview.SurfaceView(uid: members[0].videoId);
    }
    final List<Color> colors = [
      Colors.red,
      Colors.green,
    ];
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ...members
                          .map((vm) => Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedUserId = vm.uid;
                                            CustomSnackBar(context,
                                                Text("${vm.name} Selected"),
                                                backgroundColor: Colors.pink);
                                          });
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: obj.userModel != null &&
                                                      vm.uid == obj.userModel.id
                                                  ? localview.SurfaceView()
                                                  : remoteview.SurfaceView(
                                                      uid: vm.videoId),
                                            ),
                                            if (stream.pkDetails.pkEnded &&
                                                winerUid == vm.uid &&
                                                winerUid != null)
                                              Container(
                                                height: 30,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Transform.rotate(
                                                  angle: 45,
                                                  child: Text(
                                                    'WINNER',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: pink),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          vm.name,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                      if (members.length == 1)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: pink.withOpacity(0.5),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Waiting for invite to be  accepted',
                                ),
                              ),
                              SizedBox(height: 20),
                              StreamBuilder(
                                stream: Stream.periodic(
                                    Duration(seconds: 1), (e) => e),
                                builder: (_, snapshot) {
                                  if (pkInviteSentSeconds > 59) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                            (timeStamp) async {
                                      await FirebaseFirestore.instance
                                          .collection("liveStreamings")
                                          .doc(stream.docId)
                                          .update({
                                        'isPk': false,
                                      });
                                      pkInviteSentSeconds = 0;
                                    });
                                  }
                                  if (snapshot.hasData) {
                                    pkInviteSentSeconds++;
                                  }
                                  return Text(
                                    '$pkInviteSentSeconds seconds',
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                if (stream.pkDetails != null && stream.pkDetails.pkStarted)
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("liveStreamings")
                          .doc(widget.oldStream.docId)
                          .collection('gifts')
                          .doc('count')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data.data();
                          members.forEach((element) {
                            var score = 0;
                            if (data != null && data.containsKey(element.uid)) {
                              score = data[element.uid];
                            }
                            scoreMap[element.uid] = score;
                          });
                          return Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Container(
                              height: 25,
                              width: MediaQuery.of(context).size.width - 10,
                              child: Row(
                                children: members
                                    .map(
                                      (e) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            members.indexOf(e) == 0
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    colors[members.indexOf(e)],
                                              ),
                                              width: (scoreMap[scoreMap.keys.elementAt(0)] ==
                                                          scoreMap[scoreMap.keys
                                                              .elementAt(1)]
                                                      ? (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2)
                                                      : members.indexOf(e) == 0
                                                          ? (scoreMap[scoreMap.keys.elementAt(0)] /
                                                                  (scoreMap[scoreMap.keys.elementAt(0)] +
                                                                      scoreMap[scoreMap.keys.elementAt(
                                                                          1)])) *
                                                              MediaQuery.of(context)
                                                                  .size
                                                                  .width
                                                          : (scoreMap[scoreMap.keys.elementAt(1)] /
                                                                  (scoreMap[scoreMap.keys.elementAt(0)] +
                                                                      scoreMap[scoreMap.keys.elementAt(1)])) *
                                                              MediaQuery.of(context).size.width) -
                                                  5,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    members.indexOf(e) == 0
                                                        ? MainAxisAlignment
                                                            .start
                                                        : MainAxisAlignment.end,
                                                children: [
                                                  Icon(Icons.star,
                                                      size: 15,
                                                      color: colors[
                                                          members.indexOf(e)]),
                                                  Text(
                                                    '${scoreMap[e.uid]}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      }),
              ],
            )),
        if (stream.pkDetails.pkStarted)
          Positioned(
            bottom: 25,
            child: Container(
              height: 25,
              width: 70,
              decoration: BoxDecoration(
                  color: pink,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Builder(
                builder: (context) {
                  var nowDate = DateTime.now();
                  var startedTime = stream.pkDetails.startedAt;
                  int pkseconds = stream.pkDetails.pkTime * 60;
                  var diif = nowDate.difference(startedTime).inSeconds;
                  var durationLeftInSeconds =
                      pkseconds - nowDate.difference(startedTime).inSeconds;
                  int pkTimeEllapsed = 0;
                  return StreamBuilder(
                    stream: Stream.periodic(Duration(seconds: 1), (s) => s),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int durationLeftStream =
                            durationLeftInSeconds - pkTimeEllapsed;
                        pkTimeEllapsed++;
                        if (durationLeftStream > 0) {
                          var inMinutes = (durationLeftStream / 60.0)
                              .toString()
                              .split('.')[0]
                              .padLeft(2, '0');
                          var inSeconds = durationLeftStream % 60;
                          return Center(
                            child: Text(
                              '$inMinutes:${inSeconds.toString().padLeft(2, '0')}',
                            ),
                          );
                        } else {
                          if (stream.pkDetails != null &&
                              !stream.pkDetails.pkEnded &&
                              widget.role == ClientRole.Broadcaster &&
                              stream.streamer.id == obj.userModel.id)
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              bool isDraw = false;
                              setState(() {
                                var score1 =
                                    scoreMap[scoreMap.keys.elementAt(0)];
                                var score2 =
                                    scoreMap[scoreMap.keys.elementAt(1)];
                                if (score1 > score2) {
                                  winerUid = scoreMap.keys.elementAt(0);
                                } else if (score1 == score2) {
                                  isDraw = true;
                                  winerUid = null;
                                } else {
                                  winerUid = scoreMap.keys.elementAt(1);
                                }
                              });
                              var pkd = stream.pkDetails;
                              pkd.pkEnded = true;
                              stream.isStreaming = false;
                              pkd.winerId = winerUid;
                              pkd.isDraw = isDraw;
                              FirebaseFirestore.instance
                                  .collection("liveStreamings")
                                  .doc(widget.oldStream.docId)
                                  .update({'pkDetails': pkd.toMap()});
                            });
                          return Center(
                            child: Text(
                              'Ended',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                      }
                      return Text('...');
                    },
                  );
                },
              ),
            ),
          ),
        if (!stream.pkDetails.pkEnded &&
            (stream.pkDetails.pkStarted ||
                widget.role == ClientRole.Broadcaster))
          Container(
            child: Transform.rotate(
              angle: 45,
              child: Text(
                'VS',
                style: TextStyle(fontSize: 30, color: pink),
              ),
            ),
          ),
        if (stream.pkDetails.pkEnded && stream.pkDetails.isDraw)
          Container(
            child: Transform.rotate(
              angle: 45,
              child: Text(
                'Draw',
                style: TextStyle(fontSize: 30, color: pink),
              ),
            ),
          ),
      ],
    );
  }

  bool first = true;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    streamController = Provider.of<Api>(context);
    if (first) {
      first = false;
      loading = true;
      initializeSomeInits();
    }
    return stream == null || loading == true
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            children: [
              WillPopScope(
                onWillPop: () async {
                  if (widget.role == ClientRole.Audience) {
                    await disposeAll(false);
                  } else {
                    await disposeAll(true);
                  }
                  return true;
                },
                child: GestureDetector(
                  onHorizontalDragEnd: (detail) {
                    if (detail.primaryVelocity > 1500) {
                      streamController.showVideoStack = true;
                    } else if (detail.primaryVelocity < -1500) {
                      streamController.showVideoStack = false;
                    }
                  },
                  child: Scaffold(
                    body: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: liveStreamGradient,
                        // [Colors.blueGrey, Colors.pink[300]]
                      )),
                      child: Stack(
                        children: [
                          Stack(
                            children: <Widget>[
                              stream.isPk != null && stream.isPk
                                  ? Positioned(top: 100, child: pKView())
                                  : widget.callType == "Video" &&
                                          !stream.allowMutiple
                                      ? _viewRows()
                                      : (widget.callType == "Video" ||
                                                  widget.callType == 'Audio') &&
                                              stream.allowMutiple
                                          ? multipleGuestView(
                                              widget.callType == 'Video'
                                                  ? true
                                                  : false)
                                          : Container(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.person,
                                                size: 60,
                                                color: Colors.black,
                                              ),
                                            ),
                              // _panel(),
                            ],
                          ),
                          if (stream != null)
                            StreamingTopView(
                                selectedUserId ?? stream.streamer.id, stream,
                                () {
                              _onStreamEnd(context);
                            }, widget.role, engine, widget.callType, myId),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.channelName == defaultUid)
                Positioned(
                  top: 20,
                  left: 0,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      height: 20,
                      width: 70,
                      child: Center(
                        child: Text(
                          'Development',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      color: Colors.deepOrange[900],
                    ),
                  ),
                ),
            ],
          );
  }
}

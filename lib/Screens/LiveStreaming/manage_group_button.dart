// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/LiveStreaming/pkdetails.dart';
import 'package:streamkar/Screens/LiveStreaming/streamingmodel.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';

class ManageGroupButton extends StatefulWidget {
  final UserStream stream;
  ManageGroupButton({Key key, this.stream}) : super(key: key);

  @override
  State<ManageGroupButton> createState() => _ManageGroupButtonState();
}

class _ManageGroupButtonState extends State<ManageGroupButton> {
  Api streamController;

  final _auth = FirebaseAuth.instance;

  final textStyle = TextStyle(color: Colors.grey, fontSize: 15);

  Widget _buildWaitingSection(UserStream stream, setState) {
    return Text('No Waiting ');
  }

  Widget _buildGuestSection(BuildContext context, UserStream stream, setState) {
    var members = stream.members
        .where((element) => element['uid'] != _auth.currentUser.uid)
        .toList();
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (_, index) {
        final member = members[index];
        var name = member['name'];
        return Card(
          child: ListTile(
            title: Text(name),
            trailing: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () async {
                  await streamController.addorRemoveBroadCaster(stream, null,
                      oldData: member, remove: true);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }),
          ),
        );
      },
    );
  }

  Widget _buildModeSection(BuildContext context, UserStream stream, setState) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Room Mode',
        style: textStyle,
      ),
      Container(
        decoration: BoxDecoration(
            color: stream.roomMode ? pink.withOpacity(0.1) : Colors.grey,
            borderRadius: BorderRadius.circular(5),
            border: Border.fromBorderSide(BorderSide(
                width: stream.roomMode ? 2 : 0,
                color: stream.roomMode ? pink : Colors.grey))),
        child: ListTile(
          onTap: () {
            if (!stream.roomMode) {
              stream.roomMode = true;
              setState(() {});
              streamController.updateSingleFieldOnStream(stream.docId,
                  key: 'roomMode', value: stream.roomMode);
            }
          },
          leading: Icon(Icons.emoji_emotions, color: pink),
          title: Text('Open Mode'),
          subtitle: Text(
              'Viewers can be guest freely,and more people can chat with you.'),
          trailing:
              stream.roomMode ? Icon(Icons.check, color: pink) : SizedBox(),
        ),
      ),
      SizedBox(height: 5),
      Container(
        decoration: BoxDecoration(
            color: !stream.roomMode ? pink.withOpacity(0.1) : Colors.grey,
            borderRadius: BorderRadius.circular(5),
            border: Border.fromBorderSide(BorderSide(
                width: !stream.roomMode ? 2 : 0,
                color: !stream.roomMode ? pink : Colors.grey))),
        child: ListTile(
          onTap: () {
            if (stream.roomMode) {
              stream.roomMode = false;
              setState(() {});
              streamController.updateSingleFieldOnStream(stream.docId,
                  key: 'roomMode', value: stream.roomMode);
            }
          },
          leading: Icon(Icons.email, color: pink),
          title: Text('Invitation mode'),
          subtitle: Text('Viewers can be guest by invitaion or application.'),
          trailing:
              !stream.roomMode ? Icon(Icons.check, color: pink) : SizedBox(),
        ),
      ),
      SizedBox(height: 5),
      Text(
        'Room seats',
        style: textStyle,
      ),
      Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [4, 6, 9]
                .map((e) => GestureDetector(
                      onTap: () {
                        if (e != stream.maxAllow) {
                          setState(() {
                            stream.maxAllow = e;
                          });
                          streamController.updateSingleFieldOnStream(
                              stream.docId,
                              key: 'maxAllow',
                              value: e);
                        }
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width / 3) - 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.5),
                            border: Border.fromBorderSide(BorderSide(
                                color:
                                    stream.maxAllow == e ? pink : Colors.grey,
                                width: stream.maxAllow == e ? 2 : 0))),
                        child: Center(
                          child: Text(
                            e.toString(),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          )),
      SizedBox(height: 5),
      Text(
        'Speaking Mode',
        style: textStyle,
      ),
      Container(
          height: 40,
          // padding: const EdgeInsets.symmetric(horizontal:5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Guest can speak freely',
              ),
              CupertinoSwitch(
                value: stream.allowFreeSpeak,
                activeColor: Colors.pink,
                onChanged: (b) {
                  if (b != stream.allowFreeSpeak) {
                    setState(() {
                      stream.allowFreeSpeak = b;
                    });
                    streamController.updateSingleFieldOnStream(stream.docId,
                        key: 'allowFreeSpeak', value: b);
                  }
                },
              )
            ],
          ))
    ]);
  }

  Api obj;

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);

    streamController = Provider.of<Api>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("liveStreamings")
          .doc(widget.stream.docId)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) return SizedBox();
        print(snapshot.data.data());
        print(widget.stream.docId);
        print("cameeee herreee");
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

        // if (stream == null ||
        //     stream.streamer.id != obj.userModel.id ||
        //     !stream.allowMutiple) {
        //   print("ttttttttttttttttttt");
        //   return SizedBox();
        // }

        return GestureDetector(
          onTap: () {
            Scaffold.of(context).showBottomSheet(
              (context) => StatefulBuilder(
                builder: (context, setState) => Container(
                  height: 400,
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: DefaultTabController(
                      length: 3,
                      initialIndex: 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width - 100,
                              child: TabBar(
                                indicatorColor: Colors.pink,
                                unselectedLabelColor: Colors.grey,
                                labelColor: Colors.black,
                                tabs: ['Waiting', 'Guest', 'Mode']
                                    .map((e) => Text(
                                          e,
                                          style: TextStyle(
                                              // color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ))
                                    .toList(),
                              ),
                            ),
                            Expanded(
                                child: TabBarView(
                              children: [
                                _buildWaitingSection(stream, setState),
                                _buildGuestSection(context, stream, setState),
                                _buildModeSection(context, stream, setState),
                              ],
                            )),
                          ])),
                ),
              ),
              backgroundColor: Colors.transparent,
            );
          },
          child: Container(
            height: 30,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Text(
                'Manage',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

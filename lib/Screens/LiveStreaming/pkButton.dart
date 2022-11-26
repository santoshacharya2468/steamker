// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/LiveStreaming/pkdetails.dart';
import 'package:streamkar/Screens/LiveStreaming/streamingmodel.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

class PkButton extends StatefulWidget {
  final UserStream stream;
  final int agoraId;
  PkButton(this.stream, this.agoraId);

  @override
  _PkButtonState createState() => _PkButtonState();
}

class _PkButtonState extends State<PkButton> {
  Api obj;

  Widget _buildFamilyPk() {
    return Center(child: Text('Family pk'));
  }

  _buildInviteButton(UserModel user) {
    return InkWell(
      onTap: () async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.id)
            .collection('notifications')
            .add({
          'body': '${obj.userModel.name} invited you to join a pk',
          'from': obj.userModel.id,
          'collection': "liveStreamings",
          'collectionId': stream.docId,
          'title': 'Pk Invite',
          'date': FieldValue.serverTimestamp(),
          'seen': false,
        });
        await FirebaseFirestore.instance
            .collection("liveStreamings")
            .doc(stream.docId)
            .update({
          'isPk': true,
          'pkDetails': stream.pkDetails.toMap(),
          'members': [
            {
              'name': obj.userModel.name,
              'videoId': widget.agoraId,
              'uid': obj.userModel.id
            }
          ]
        }).then((value) {
          CustomSnackBar(
            context,
            Text("Invite Sent"),
          );
        });

        // showSnackBar(title: 'Done', body: 'Invite sent');
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Container(
        height: 30,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text('Invite'),
        ),
      ),
    );
  }

  Widget _buildFriendPk() {
    final friends = obj.appUsers;
    return Container(
      height: 250,
      child: ListView.builder(
        itemCount: friends.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final friend = friends[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  friend.photoURL != null && friend.photoURL.isNotEmpty
                      ? NetworkImage(friend.photoURL)
                      : AssetImage('assets/images/gigo.png'),
            ),
            title: Text(friend.name),
            trailing: _buildInviteButton(friend),
          );
        },
      ),
    );
  }

  // Widget _buildPkSettings() {
  //   return Container(
  //     child: Text('Settings'),
  //   );
  // }

  Widget _buildPkTimer() {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        child: Wrap(
          spacing: 3,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Time',
              ),
            ),
            ...[5, 10, 15, 20]
                .map(
                  (e) => InkWell(
                    onTap: () {
                      setState(() {
                        stream.pkDetails.pkTime = e;
                      });
                    },
                    child: Chip(
                      label: Text('$e min'),
                      backgroundColor: stream.pkDetails.pkTime == e
                          ? Colors.pink
                          : Colors.grey[350],
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }

  UserStream stream;
  @override
  void initState() {
    super.initState();
    stream = widget.stream;
  }

  @override
  Widget build(BuildContext context) {
    Widget selectedWidget;
    obj = Provider.of<Api>(context);
    return InkWell(
      onTap: () {
        stream.isPk = true;
        stream.pkDetails = PkDetails();
        stream.pkDetails.pkTime = 5;
        showModalBottomSheet<void>(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) => Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left),
                            iconSize: 40,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedWidget = null;
                              });
                            },
                            child: Text(
                              'Team Pk',
                            ),
                          ),
                          Row(
                            children: [
                              // IconButton(
                              //   icon: Icon(Icons.settings),
                              //   onPressed: () {
                              //     setState(() {
                              //       selectedWidget = _buildPkSettings();
                              //     });
                              //   },
                              // ),
                              IconButton(
                                icon: Icon(Icons.timer),
                                onPressed: () {
                                  setState(() {
                                    selectedWidget = _buildPkTimer();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // selectedWidget == null
                    //     ? Container(
                    //         height: 50,
                    //         width: MediaQuery.of(context).size.width,
                    //         child: TabBar(
                    //           unselectedLabelColor: Colors.grey,
                    //           labelColor: Colors.black,
                    //           indicatorSize: TabBarIndicatorSize.label,
                    //           indicatorColor: Colors.black,
                    //           tabs:
                    //               ['Friend Pk'].map((e) => Text(e)).toList(),
                    //         ),
                    //       )
                    //     : SizedBox(),
                    Container(
                        height: 250,
                        child: selectedWidget == null
                            ?
                            // TabBarView(children: [
                            // _buildFamilyPk(),
                            _buildFriendPk()
                            // ])
                            : selectedWidget),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Center(
          child: Image.asset(
            'assets/pkicons/teampk.png',
            height: 110,
            width: 110,
          ),
        ),
      ),
    );
  }
}

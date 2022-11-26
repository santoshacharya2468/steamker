// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/StatusAndSquad/statusHome.dart';
import 'package:streamkar/Services/api.dart';

class HashTag extends StatefulWidget {
  final String hashTagId;
  const HashTag({Key key, @required this.hashTagId}) : super(key: key);

  @override
  State<HashTag> createState() => _HashTagState();
}

class _HashTagState extends State<HashTag> {
  Api obj;
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
          widget.hashTagId,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("hashtags")
                  .doc(widget.hashTagId)
                  .collection("status")
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
                    itemBuilder: (context, i) {
                      return Post(
                        showBar: true,
                        status: obj.appStatus
                            .where((e) => e.id == myChats[i]['id'])
                            .toList()
                            .first,
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

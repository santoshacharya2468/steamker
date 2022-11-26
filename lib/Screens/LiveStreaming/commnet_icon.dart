// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';

class CommentIcon extends StatelessWidget {
  final String streamId;
  CommentIcon(this.streamId);
  final _firestore = FirebaseFirestore.instance;
  final commentController = TextEditingController();
  Api obj;
  Future<void> _postComment() async {
    _firestore
        .collection("liveStreamings")
        .doc(streamId)
        .collection('comments')
        .add({
      'body': commentController.text,
      'date': FieldValue.serverTimestamp(),
      'by': {
        'id': obj.userModel.id,
        'name': obj.userModel.name,
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return InkWell(
      onTap: () {
        Scaffold.of(context).showBottomSheet(
            (context) => Container(
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      color: Colors.white),
                  child: DefaultTabController(
                    length: 1,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          child: TabBar(
                            tabs: ['Comments']
                                .map((e) => Text(
                                      e,
                                      style: TextStyle(color: Colors.black),
                                    ))
                                .toList(),
                            indicatorColor: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Container(
                                height: 130,
                                child: Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          // border: Border.fromBorderSide(
                                          //     BorderSide(
                                          //   width: 2,
                                          // ))
                                        ),
                                        child: TextField(
                                          controller: commentController,
                                          decoration: InputDecoration(
                                            // border: InputBorder.none,
                                            hintText: 'Comment ....',
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (commentController.text.isNotEmpty) {
                                          await _postComment();
                                          commentController.text = '';
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: purple,
                                        ),
                                        child: Center(
                                          child: Icon(Icons.send,
                                              color: Colors.white),
                                        ),
                                      ),
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
                ),
            backgroundColor: Colors.transparent);
      },
      child: Container(
        height: 40,
        width: 40,
        decoration:
            BoxDecoration(color: Colors.grey[900], shape: BoxShape.circle),
        child: Icon(Icons.comment, color: Colors.white),
      ),
    );
  }
}

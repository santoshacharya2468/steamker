// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart' as um;
import 'package:streamkar/Screens/StatusAndSquad/statusHome.dart';
import 'package:streamkar/Services/api.dart';
import 'package:uuid/uuid.dart';

class PostDetails extends StatefulWidget {
  final um.Status status;
  const PostDetails({Key key, @required this.status}) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  Api obj;

  TextEditingController messageController = TextEditingController();
  Future<void> sendComment() async {
    if (messageController.text.length > 0) {
      String id = Uuid().v1();
      final collection = await FirebaseFirestore.instance
          .collection("status")
          .doc(widget.status.id)
          .collection("comments")
          .doc(id)
          .set({
        "time": DateTime.now(),
        "userID": obj.userModel.id,
        "likes": 0,
        "comment": messageController.text,
      });
      setState(() {
        obj.appStatus
            .where((e) => e.id == widget.status.id)
            .toList()
            .first
            .comments
            .add(um.Comments(
                time: DateTime.now(),
                userID: obj.userModel.id,
                likes: 0,
                comment: messageController.text));
        messageController.text = "";
        obj.notify();
      });
    }
  }

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
          "Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Post(
                      status: widget.status,
                      showBar: false,
                    ),
                    Comments(
                      status: widget.status,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add a comment',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                        suffixIcon: Container(
                          width: 10,
                          height: 50,
                          child: InkWell(
                            onTap: () async {
                              if (messageController.text.length > 0)
                                await sendComment();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.send,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                      controller: messageController,
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
}

class Comments extends StatefulWidget {
  final um.Status status;
  const Comments({Key key, @required this.status}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  Api obj;

  Future<void> like(String id, bool liked) async {
    final collection = await FirebaseFirestore.instance
        .collection("status")
        .doc(widget.status.id)
        .collection("comments")
        .doc(id)
        .update({
      "likes": FieldValue.increment(liked ? -1 : 1),
    });
    setState(() {
      if (liked) {
        obj.appStatus
            .where((e) => e.id == widget.status.id)
            .toList()
            .first
            .comments
            .where((e) => e.id == id)
            .toList()
            .first
            .likes -= 1;
      } else {
        obj.appStatus
            .where((e) => e.id == widget.status.id)
            .toList()
            .first
            .comments
            .where((e) => e.id == id)
            .toList()
            .first
            .likes += 1;
      }
      obj.notify();
    });
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Comments (${widget.status.comments.length})",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          for (var i = 0; i < widget.status.comments.length; i++)
            Container(
              // height: 65,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        obj.appUsers
                            .where(
                                (e) => e.id == widget.status.comments[i].userID)
                            .toList()
                            .first
                            .photoURL,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            obj.appUsers
                                .where((e) =>
                                    e.id == widget.status.comments[i].userID)
                                .toList()
                                .first
                                .name,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          Text(""),
                          Text(
                            widget.status.comments[i].comment,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "${-1 * widget.status.comments[i].time.difference(DateTime.now()).inHours} hour(s) ago",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(right: 5),
                    //       child: Text(
                    //         widget.status.comments[i].likes.toString(),
                    //         style: TextStyle(
                    //           color: Colors.grey,
                    //           fontSize: 12,
                    //         ),
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () async {
                    //         await like(widget.status.comments[i].id, false);
                    //       },
                    //       child: Icon(
                    //         Icons.favorite,
                    //         size: 16,
                    //         color: Colors.red,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          Container(
            height: 7,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}

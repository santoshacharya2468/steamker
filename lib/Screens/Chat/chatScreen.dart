// @dart=2.9

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/chatModel.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/Chat/chatScreenSetings.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;
  String chatID;
  ChatScreen({Key key, @required this.user, @required this.chatID})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController;
  Api obj;
  TextEditingController messageController = TextEditingController();

  void scrollToBottom() {
    // print(_scrollController.position);
    // _scrollController.jumpTo(
    //   _scrollController.position.maxScrollExtent,
    // );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          widget.user.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => ChatScreenSettings(
                    userModel: widget.user,
                    chatID: widget.chatID,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(
                Icons.settings,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            widget.chatID == ""
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(
                        bottom: _image != null
                            ? MediaQuery.of(context).size.height * 0.12 +
                                MediaQuery.of(context).size.width / 3.5
                            : MediaQuery.of(context).size.height * 0.12),
                    child: chats(),
                  ),
            Positioned(
              bottom: 0,
              child: keypad(),
            ),
          ],
        ),
      ),
    );
  }

  Widget chats() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(widget.chatID)
            .collection("history")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No Chat History !!',
              ),
            );
          } else {
            var myChats = snapshot.data.docs;
            List<ChatHistory> chatHistory = [];
            for (var i = 0; i < myChats.length; i++) {
              ChatHistory chat = ChatHistory();
              Map data = myChats[i].data() as Map;
              chat.userId = data['userID'];
              chat.message = data['message'];
              chat.type = data['type'] ?? "text";
              chat.time = (data['time'] as Timestamp).toDate();
              chatHistory.add(chat);
            }
            chatHistory.sort((a, b) => a.time.compareTo(b.time));
            return ListView.builder(
              shrinkWrap: true,
              itemCount: chatHistory.length,
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                scrollToBottom();
                return chatHistory[i].userId == obj.userModel.id
                    ? Padding(
                        padding:
                            const EdgeInsets.only(right: 12, top: 12, left: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            chatHistory[i].message.length > 25
                                ? Flexible(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                        color: chatHistory[i].type == "text"
                                            ? pink
                                            : Colors.white,
                                      ),
                                      child: Center(
                                        child: chatHistory[i].type == "text"
                                            ? Text(
                                                chatHistory[i].message,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Image.network(
                                                chatHistory[i].message,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      color: chatHistory[i].type == "text"
                                          ? pink
                                          : Colors.white,
                                    ),
                                    child: Center(
                                      child: chatHistory[i].type == "text"
                                          ? Text(
                                              chatHistory[i].message,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : Image.network(
                                              chatHistory[i].message,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                  obj.userModel.photoURL,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding:
                            const EdgeInsets.only(left: 12, top: 12, right: 12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                obj.appUsers
                                    .where((e) => e.id == chatHistory[i].userId)
                                    .toList()
                                    .first
                                    .photoURL,
                              ),
                            ),
                            SizedBox(width: 10),
                            chatHistory[i].message.length > 25
                                ? Flexible(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                        color: chatHistory[i].type == "text"
                                            ? Colors.grey[300]
                                            : Colors.white,
                                      ),
                                      child: Center(
                                        child: chatHistory[i].type == "text"
                                            ? Text(
                                                chatHistory[i].message,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            : Image.network(
                                                chatHistory[i].message,
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      color: chatHistory[i].type == "text"
                                          ? Colors.grey[300]
                                          : Colors.white,
                                    ),
                                    child: Center(
                                      child: chatHistory[i].type == "text"
                                          ? Text(
                                              chatHistory[i].message,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : Image.network(
                                              chatHistory[i].message,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  )
                          ],
                        ),
                      );
              },
            );
          }
        });
  }

  Widget keypad() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: _image != null
          ? MediaQuery.of(context).size.height * 0.12 +
              MediaQuery.of(context).size.width / 3.5
          : MediaQuery.of(context).size.height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (_image != null)
            Stack(
              children: [
                ClipRRect(
                  child: Image.file(
                    _image,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3.5,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _image = null;
                      });
                    },
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () async {
                    bool k = await getImage(ImageSource.gallery);
                  },
                  child: Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () async {
                    bool k = await getImage(ImageSource.camera);
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[300],
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type Something here...!',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          letterSpacing: 1,
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
              InkWell(
                onTap: () async {
                  if (messageController.text.length > 0 || _image != null)
                    await sendMessage();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.send,
                    color: Colors.grey,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage() async {
    if (widget.chatID == "") {
      String id = Uuid().v1();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(obj.userModel.id)
          .collection("chats")
          .doc(id)
          .set({
        "id": id,
        "userID": widget.user.id,
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.id)
          .collection("chats")
          .doc(id)
          .set({
        "id": id,
        "userID": obj.userModel.id,
      });
      String idm = Uuid().v1();
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(id)
          .collection("history")
          .doc(idm)
          .set({
        "message": _image != null
            ? await obj.uploadProductImage(_image, 'chats/$id$idm.png')
            : messageController.text,
        "time": DateTime.now(),
        "userID": obj.userModel.id,
        "type": _image != null ? "media" : "text",
      });
      obj.myChats.add(ChatModel(id: id, userID: widget.user.id));
      widget.chatID = id;
      obj.notify();
      setState(() {
        messageController.text = "";
        _image = null;
      });
    } else {
      String id = Uuid().v1();
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.chatID)
          .collection("history")
          .doc(id)
          .set({
        "message": _image != null
            ? await obj.uploadProductImage(
                _image, 'chats/${widget.chatID}$id.png')
            : messageController.text,
        "time": DateTime.now(),
        "userID": obj.userModel.id,
        "type": _image != null ? "media" : "text",
      });
      setState(() {
        messageController.text = "";
        _image = null;
      });
    }
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
}

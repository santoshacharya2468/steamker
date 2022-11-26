// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/colors.dart';

class Help extends StatefulWidget {
  const Help({Key key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String selected = "topup";
  String contact = "Email";
  TextEditingController contactController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  bool loadingSubmit = false;

  Future<void> submitFeedBack() async {
    setState(() {
      loadingSubmit = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String id = Uuid().v1();
    await firestore.collection("feedback").doc(id).set({
      "description": descriptionController.text,
      "id": id,
      "raisedBy": obj.userModel.id,
      "resolution": false,
      "time": DateTime.now(),
      "type": selected,
      "contact": contactController.text,
    }).then((value) async {
      var m = await firestore
          .collection("users")
          .doc(obj.userModel.id)
          .collection("feedback")
          .doc(id)
          .set({
        "id": id,
      });
      CustomSnackBar(
        context,
        Text("Feedback Submitted SuccessFully"),
      );
      FeedBack feedBack = FeedBack(id: id);
      FeedBack feedBack1 = FeedBack(
        id: id,
        description: descriptionController.text,
        raisedBy: obj.userModel.id,
        resolution: false,
        time: DateTime.now(),
        type: selected,
        contact: contactController.text,
      );
      obj.userModel.feedbacks.add(feedBack);
      obj.appFeedback.add(feedBack1);
      obj.notify();
      setState(() {
        loadingSubmit = false;
      });
    }).onError((error, stackTrace) {
      CustomSnackBar(
        context,
        Text("Error Occured.. try again !!"),
      );

      setState(() {
        loadingSubmit = false;
      });
    });
  }

  Future<void> fetchData() async {
    bool k = await obj.getFeedBack();
    if (k) {
      setState(() {
        loading = false;
        obj.notify();
      });
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
      first = false;
      fetchData();
    }
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
          "Feedback",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                              height: 40,
                              child: TabBar(
                                isScrollable: true,
                                controller: _tabController,
                                indicator: UnderlineTabIndicator(
                                  borderSide:
                                      BorderSide(width: 2.0, color: pink),
                                  insets: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 0),
                                ),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorPadding: EdgeInsets.all(5),
                                labelColor: Colors.black,
                                labelStyle: TextStyle(fontSize: 16),
                                unselectedLabelColor: Colors.grey[400],
                                unselectedLabelStyle: TextStyle(fontSize: 16),
                                tabs: <Widget>[
                                  Tab(
                                    text: "Feedback",
                                  ),
                                  Tab(
                                    text: "My Feedback",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 0.5,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          Column(
                            children: [
                              Expanded(
                                flex: 8,
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selected = "topup";
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: selected == "topup"
                                                      ? pink
                                                      : Colors.grey,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Top Up",
                                                  style: TextStyle(
                                                    color: selected == "topup"
                                                        ? pink
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selected = "earnings";
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: selected == "earnings"
                                                      ? pink
                                                      : Colors.grey,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Earning Info",
                                                  style: TextStyle(
                                                    color:
                                                        selected == "earnings"
                                                            ? Colors.pink
                                                            : Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selected = "suggestion";
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color:
                                                      selected == "suggestion"
                                                          ? pink
                                                          : Colors.grey,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Suggestion",
                                                  style: TextStyle(
                                                    color:
                                                        selected == "suggestion"
                                                            ? pink
                                                            : Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selected = "other";
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: selected == "other"
                                                      ? pink
                                                      : Colors.grey,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Others",
                                                  style: TextStyle(
                                                    color: selected == "other"
                                                        ? pink
                                                        : Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.grey[400]
                                                .withOpacity(0.1),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "Choose your contact Information",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ListTile(
                                        title: const Text('Email'),
                                        leading: Radio(
                                          activeColor: pink,
                                          value: "Email",
                                          groupValue: contact,
                                          onChanged: (String value) {
                                            setState(() {
                                              contact = value;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Telephone'),
                                        leading: Radio(
                                          activeColor: pink,
                                          value: "Telephone",
                                          groupValue: contact,
                                          onChanged: (String value) {
                                            setState(() {
                                              contact = value;
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                        height: 5,
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                      Container(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter your $contact',
                                            contentPadding:
                                                EdgeInsets.only(left: 20),
                                            // labelText: 'Introduction',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              letterSpacing: 1,
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            enabledBorder:
                                                new UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey[300],
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                          ),
                                          controller: contactController,
                                        ),
                                      ),
                                      Container(
                                        height: 5,
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                      Container(
                                        child: TextFormField(
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Explain your issue in detail...',
                                            contentPadding: EdgeInsets.only(
                                                left: 20, top: 10),
                                            // labelText: 'Introduction',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              letterSpacing: 1,
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            enabledBorder:
                                                new UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey[300],
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                          ),
                                          controller: descriptionController,
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: InkWell(
                                    onTap: () async {
                                      await submitFeedBack();
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.pinkAccent.shade400,
                                      ),
                                      child: Center(
                                        child: loadingSubmit
                                            ? CircularProgressIndicator()
                                            : Text(
                                                "Submit",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              color: Colors.grey.withOpacity(0.1),
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                children: [
                                  for (var i = 0;
                                      i < obj.userModel.feedbacks.length;
                                      i++)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 5),
                                        Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      obj.appFeedback
                                                          .where((e) =>
                                                              e.id ==
                                                              obj
                                                                  .userModel
                                                                  .feedbacks[i]
                                                                  .id)
                                                          .toList()
                                                          .first
                                                          .type,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      obj.appFeedback
                                                              .where((e) =>
                                                                  e.id ==
                                                                  obj
                                                                      .userModel
                                                                      .feedbacks[
                                                                          i]
                                                                      .id)
                                                              .toList()
                                                              .first
                                                              .resolution
                                                          ? "Closed"
                                                          : "Open",
                                                      style: TextStyle(
                                                        color: obj.appFeedback
                                                                .where((e) =>
                                                                    e.id ==
                                                                    obj
                                                                        .userModel
                                                                        .feedbacks[
                                                                            i]
                                                                        .id)
                                                                .toList()
                                                                .first
                                                                .resolution
                                                            ? Colors.red
                                                            : Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      obj.appFeedback
                                                          .where((e) =>
                                                              e.id ==
                                                              obj
                                                                  .userModel
                                                                  .feedbacks[i]
                                                                  .id)
                                                          .toList()
                                                          .first
                                                          .description,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      obj.appFeedback
                                                          .where((e) =>
                                                              e.id ==
                                                              obj
                                                                  .userModel
                                                                  .feedbacks[i]
                                                                  .id)
                                                          .toList()
                                                          .first
                                                          .time
                                                          .toString()
                                                          .split(" ")
                                                          .first,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                ],
                              ),
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

// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamkar/Models/banners.dart';
import 'package:streamkar/Models/chatModel.dart';
import 'package:streamkar/Models/pexel.dart';
import 'package:streamkar/Models/squadsCard.dart';
import 'package:streamkar/Models/stores.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/Home/notification_button.dart';
import 'package:streamkar/Screens/LiveStreaming/gift.dart';
import 'package:streamkar/Screens/LiveStreaming/pkdetails.dart';
import 'package:streamkar/Screens/LiveStreaming/streamingmodel.dart';
import 'package:uuid/uuid.dart';

class Api extends ChangeNotifier {
  Pexel pexel;
  String globalPassword;
  String globalEmail;
  int globalPhone;
  UserModel userModel;
  List<Badge> appBadges = [];
  List<Status> appStatus = [];
  List<UserModel> appUsers = [];
  List<Banners> appBanners = [];
  List<ChatModel> myChats = [];
  List<SquadsCard> appSquad = [];
  List<Stores> appStore = [];
  List<FeedBack> appFeedback = [];

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void notify() {
    notifyListeners();
  }

  changeLoginStatus(String email, String password, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var k = await prefs.setString(type, email);
    k = await prefs.setString("password", password);
    print("set success");
    notifyListeners();
    return true;
  }

  Future<bool> removeLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("password");
    await prefs.clear();
    notifyListeners();
    return true;
  }

  Future<bool> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    bool e = await prefs.containsKey('email');
    bool h = await prefs.containsKey('phone');
    // ignore: await_only_futures
    bool p = await prefs.containsKey('password');
    print(e);
    print(p);
    if ((e || h) && p) {
      print("yes contains");
      globalEmail = prefs.getString("email");
      try {
        globalPhone = int.parse(prefs.getString("phone").toString());
      } catch (e) {
        globalPhone = 0;
      }
      globalPassword = prefs.getString("password");
      notifyListeners();
      return true;
    } else {
      print("doesn't contains");
      return false;
    }
  }

  Future<bool> getoverview() async {
    try {
      Response response = await Dio().get(
        'https://api.pexels.com/v1/search?query=girl&per_page=30',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader:
                "563492ad6f91700001000001eb943188832c4dae90d91d7ba82490f7"
          },
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        this.pexel = Pexel.fromJson(response.data);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> isNewUser(String typeData, {String type = 'email'}) async {
    bool isNew = true;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot result = await firestore.collection("users").get();
    final List<DocumentSnapshot> docs = result.docs;
    for (var i = 0; i < docs.length; i++) {
      Map data = docs[i].data() as Map;
      if (data[type].toString() == typeData) {
        isNew = false;
        break;
      }
    }
    return isNew;
  }

  Future<bool> addUserToDb(
      {String name,
      String email,
      String password,
      int phoneNumber,
      String photoURL}) async {
    bool success;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String id = Uuid().v1();
    await firestore.collection("users").doc(id).set({
      "id": id,
      "dob": DateTime(2000, 1, 1),
      "name": name,
      "password": password,
      "loggedIn": false,
      "place": "india",
      "description": "Available",
      "gender": "male",
      "email": email,
      "phone": phoneNumber,
      "photoUrl": photoURL,
      "beans": 1000,
      "diamonds": 500,
    }).onError((error, stackTrace) {
      print(error);
      success = false;
    }).then((value) {
      print('Success');
      success = true;
    });
    return success;
  }

  Future<bool> login(
      {String email, String password, String type = 'email'}) async {
    bool success = false;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("users")
        .where(type,
            isEqualTo: type == "phone" ? int.parse(email.toString()) : email)
        .get()
        .then((value) async {
      var docs = value.docs;
      if (docs.isEmpty) {
        success = false;
      } else {
        for (var i = 0; i < docs.length; i++) {
          Map data = docs[i].data();
          bool condition =
              (data[type].toString() == email && data['password'] == password);
          if (type == "phone") condition = true;
          if (condition) {
            success = true;
            userModel = UserModel();
            userModel.settings = UserModelSettings();

            try {
              userModel.settings.appAlerts = {
                "voice": data['settings']['appAlerts']['voice'] ?? true,
                "receiveAppAlerts":
                    data['settings']['appAlerts']['receiveAppAlerts'] ?? true,
                "comments": data['settings']['appAlerts']['comments'] ?? true,
                "like": data['settings']['appAlerts']['like'] ?? true,
                "allUsers": data['settings']['appAlerts']['allUsers'] ?? true,
                "vibrate": data['settings']['appAlerts']['vibrate'] ?? true,
                "talents": data['settings']['appAlerts']['talents'] ?? true,
                "followed": data['settings']['appAlerts']['followed'] ?? true,
              };
              userModel.settings.inbox = {
                "talentLevel": data['settings']['inbox']['talentLevel'] ?? 1,
                "userLevel": data['settings']['inbox']['userLevel'] ?? 1,
                "selected": data['settings']['inbox']['selected'] ?? 'all',
              };
              userModel.settings.roomEffects = {
                "entranceSoundEffects": data['settings']['roomEffects']
                        ['entranceSoundEffects'] ??
                    true,
                "giftSoundEffect":
                    data['settings']['roomEffects']['giftSoundEffect'] ?? true,
                "giftEffect":
                    data['settings']['roomEffects']['giftEffect'] ?? true,
                "entranceEffects":
                    data['settings']['roomEffects']['entranceEffects'] ?? true,
              };
              userModel.settings.language =
                  data['settings']['language'] ?? "english";
            } catch (e) {
              userModel.settings.appAlerts = {
                "voice": true,
                "receiveAppAlerts": true,
                "comments": true,
                "like": true,
                "allUsers": true,
                "vibrate": true,
                "talents": true,
                "followed": true,
              };
              userModel.settings.inbox = {
                "talentLevel": 1,
                "userLevel": 1,
                "selected": 'all',
              };
              userModel.settings.roomEffects = {
                "entranceSoundEffects": true,
                "giftSoundEffect": true,
                "giftEffect": true,
                "entranceEffects": true,
              };
              userModel.settings.language = "english";
              notifyListeners();
            }

            userModel.id = data['id'];
            userModel.name = data['name'];
            userModel.description = data['description'];
            userModel.gender = data['gender'];
            userModel.place = data['place'];
            userModel.photoURL = data['photoUrl'];
            userModel.equipedItem = data['equipedItem'] ?? "";
            userModel.email = data['email'];
            userModel.phone = data['phone'] ?? 0;
            userModel.beans = data['beans'] ?? 0;
            userModel.diamonds = data['diamonds'] ?? 0;
            userModel.isLoggedIn = true;
            userModel.dob = (data['dob'] as Timestamp).toDate();
            userModel.moments = [];
            userModel.feedbacks = [];
            userModel.badges = [];
            userModel.baggages = [];
            userModel.status = [];
            userModel.connection = [];
            var m = await firestore
                .collection("users")
                .doc(userModel.id)
                .collection('moments')
                .get()
                .then((m) {
              var docc = m.docs;
              if (docc.isNotEmpty) {
                for (var i = 0; i < docc.length; i++) {
                  Map data = docc[i].data();
                  Moments moments = Moments();
                  moments.id = data['id'];
                  moments.time = (data['time'] as Timestamp).toDate();
                  moments.image = data['image'];
                  userModel.moments.add(moments);
                  notifyListeners();
                }
              }
            });
            m = await firestore
                .collection("users")
                .doc(userModel.id)
                .collection('status')
                .get()
                .then((m) {
              var docc = m.docs;
              if (docc.isNotEmpty) {
                for (var i = 0; i < docc.length; i++) {
                  Map data = docc[i].data();
                  Status moments = Status();
                  moments.id = data['id'];
                  moments.time = (data['time'] as Timestamp).toDate();
                  userModel.status.add(moments);
                  notifyListeners();
                }
              }
            });
            m = await firestore
                .collection("users")
                .doc(userModel.id)
                .collection('connections')
                .get()
                .then((m) {
              var docc = m.docs;
              if (docc.isNotEmpty) {
                for (var i = 0; i < docc.length; i++) {
                  Map data = docc[i].data();
                  Connection connection = Connection();
                  connection.userID = data['userID'];
                  connection.type = data['type'];
                  userModel.connection.add(connection);
                  notifyListeners();
                }
              }
            });
            m = await firestore
                .collection("users")
                .doc(userModel.id)
                .collection('badges')
                .get()
                .then((m) {
              var docc = m.docs;
              if (docc.isNotEmpty) {
                for (var i = 0; i < docc.length; i++) {
                  Map data = docc[i].data();
                  Badge badge = Badge();
                  badge.id = data['id'];
                  userModel.badges.add(badge);
                  notifyListeners();
                }
              }
            });
            m = await firestore
                .collection("users")
                .doc(userModel.id)
                .collection('feedback')
                .get()
                .then((m) {
              var docc = m.docs;
              if (docc.isNotEmpty) {
                for (var i = 0; i < docc.length; i++) {
                  Map data = docc[i].data();
                  FeedBack moments = FeedBack();
                  moments.id = data['id'];
                  userModel.feedbacks.add(moments);
                  notifyListeners();
                }
              }
            });
            notifyListeners();
            break;
          }
        }
      }
    }).then((value) async {
      await changeLoginStatus(email, password, type);
    });
    return success;
  }

  Future<UserModel> getUser({
    String id,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    UserModel m =
        await firestore.collection("users").doc(id).get().then((value) async {
      Map data = value.data();
      UserModel userModel = UserModel();
      userModel.id = data['id'];
      userModel.name = data['name'];
      userModel.description = data['description'];
      userModel.gender = data['gender'];
      userModel.place = data['place'];
      userModel.photoURL = data['photoUrl'];
      userModel.equipedItem = data['equipedItem'] ?? "";
      userModel.email = data['email'];
      userModel.phone = data['phone'] ?? 0;
      userModel.beans = data['beans'] ?? 0;
      userModel.diamonds = data['diamonds'] ?? 0;
      userModel.isLoggedIn = true;
      userModel.dob = (data['dob'] as Timestamp).toDate();
      userModel.moments = [];
      userModel.feedbacks = [];
      userModel.badges = [];
      userModel.baggages = [];
      userModel.connection = [];
      userModel.status = [];
      var m = await firestore
          .collection("users")
          .doc(userModel.id)
          .collection('moments')
          .get()
          .then((m) {
        var docc = m.docs;
        if (docc.isNotEmpty) {
          for (var i = 0; i < docc.length; i++) {
            Map data = docc[i].data();
            Moments moments = Moments();
            moments.id = data['id'];
            moments.time = (data['time'] as Timestamp).toDate();
            moments.image = data['image'];
            userModel.moments.add(moments);
            notifyListeners();
          }
        }
      });
      m = await firestore
          .collection("users")
          .doc(userModel.id)
          .collection('status')
          .get()
          .then((m) {
        var docc = m.docs;
        if (docc.isNotEmpty) {
          for (var i = 0; i < docc.length; i++) {
            Map data = docc[i].data();
            Status moments = Status();
            moments.id = data['id'];
            moments.time = (data['time'] as Timestamp).toDate();
            userModel.status.add(moments);
            notifyListeners();
          }
        }
      });
      m = await firestore
          .collection("users")
          .doc(userModel.id)
          .collection('connections')
          .get()
          .then((m) {
        var docc = m.docs;
        if (docc.isNotEmpty) {
          for (var i = 0; i < docc.length; i++) {
            Map data = docc[i].data();
            Connection connection = Connection();
            connection.userID = data['userID'];
            connection.type = data['type'];
            userModel.connection.add(connection);
            notifyListeners();
          }
        }
      });

      m = await firestore
          .collection("users")
          .doc(userModel.id)
          .collection('badges')
          .get()
          .then((m) {
        var docc = m.docs;
        if (docc.isNotEmpty) {
          for (var i = 0; i < docc.length; i++) {
            Map data = docc[i].data();
            Badge badge = Badge();
            badge.id = data['id'];
            userModel.badges.add(badge);
            notifyListeners();
          }
        }
      });
      notifyListeners();
      return userModel;
    });
    return m;
  }

  Future<bool> getUsers() async {
    bool success;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("users").get().then((value) async {
      var docs = value.docs;
      if (docs.isEmpty) {
        success = false;
      } else {
        appUsers = [];
        for (var i = 0; i < docs.length; i++) {
          success = true;
          Map data = docs[i].data();
          UserModel userModel = UserModel();
          userModel.id = data['id'];
          userModel.name = data['name'];
          userModel.description = data['description'];
          userModel.gender = data['gender'];
          userModel.place = data['place'];
          userModel.photoURL = data['photoUrl'];
          userModel.equipedItem = data['equipedItem'] ?? "";
          userModel.email = data['email'];
          userModel.phone = data['phone'] ?? 0;
          userModel.beans = data['beans'] ?? 0;
          userModel.diamonds = data['diamonds'] ?? 0;
          userModel.isLoggedIn = true;
          userModel.dob = (data['dob'] as Timestamp).toDate();
          userModel.moments = [];
          userModel.feedbacks = [];
          userModel.badges = [];
          userModel.baggages = [];
          appUsers.add(userModel);
          notifyListeners();
        }
      }
    });
    return success;
  }

  Future<bool> getBadge() async {
    bool success = true;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("badge").get().then((value) {
      var docs = value.docs;
      appBadges = [];
      for (var i = 0; i < docs.length; i++) {
        Map data = docs[i].data();
        Badge badge = Badge();
        badge.id = data['id'];
        badge.name = data['name'];
        badge.image = data['image'];
        badge.type = data['type'];
        badge.category = data['category'];
        appBadges.add(badge);
        notifyListeners();
      }
    });
    return success;
  }

  Future<bool> getBanners() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      var m = await firestore.collection("banners").get().then((value) {
        var docs = value.docs;
        appBanners = [];
        for (var i = 0; i < docs.length; i++) {
          Map data = docs[i].data();
          Banners banners = Banners();
          banners.id = data['id'];
          banners.image = data['image'];
          banners.type = data['type'];
          banners.time = (data['time'] as Timestamp).toDate();
          appBanners.add(banners);
          notifyListeners();
        }
        notifyListeners();
        return true;
      });
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getStore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      var m = await firestore.collection("store").get().then((value) {
        var docs = value.docs;
        appStore = [];
        for (var i = 0; i < docs.length; i++) {
          Map data = docs[i].data();
          Stores stores = Stores();
          stores.category = data["category"];
          stores.description = data["description"];
          stores.id = data['id'];
          stores.image = data['image'];
          stores.name = data['name'];
          stores.time = data['time'];
          stores.value = data['value'];
          appStore.add(stores);
          notifyListeners();
        }
        notifyListeners();
        return true;
      });
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getFeedBack() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      var m = await firestore.collection("feedback").get().then((value) {
        var docs = value.docs;
        appFeedback = [];
        for (var i = 0; i < docs.length; i++) {
          Map data = docs[i].data();
          FeedBack feedback = FeedBack();
          feedback.contact = data["contact"];
          feedback.id = data["id"];
          feedback.raisedBy = data["raisedBy"];
          feedback.resolution = data["resolution"];
          feedback.type = data["type"];
          feedback.description = data["description"];
          feedback.time = (data["time"] as Timestamp).toDate();
          appFeedback.add(feedback);
          notifyListeners();
        }
        notifyListeners();
        return true;
      });
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getChats() async {
    bool success = true;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("users")
        .doc(userModel.id)
        .collection("chats")
        .get()
        .then((value) {
      var docs = value.docs;
      myChats = [];
      for (var i = 0; i < docs.length; i++) {
        Map data = docs[i].data();
        ChatModel chatModel = ChatModel();
        chatModel.id = data['id'];
        chatModel.userID = data['userID'];
        myChats.add(chatModel);
        notifyListeners();
      }
    });
    return success;
  }

  Future<bool> getStatus() async {
    bool success = true;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("status").get().then((value) async {
      var docs = value.docs;
      appStatus = [];
      for (var i = 0; i < docs.length; i++) {
        Map data = docs[i].data();
        Status status = Status();
        status.id = data['id'];
        status.description = data['description'];
        status.image = data['image'];
        status.time = (data['time'] as Timestamp).toDate();
        status.userID = data['userID'];
        status.comments = [];
        status.likes = [];
        await firestore
            .collection("status")
            .doc(status.id)
            .collection('comments')
            .get()
            .then((e) {
          var docc = e.docs;
          for (var i = 0; i < docc.length; i++) {
            Map data = docc[i].data();
            Comments comments = Comments();
            comments.userID = data['userID'];
            comments.comment = data['comment'];
            comments.likes = data['likes'];
            comments.id = data['id'];
            comments.time = (data['time'] as Timestamp).toDate();
            status.comments.add(comments);
          }
        });
        await firestore
            .collection("status")
            .doc(status.id)
            .collection('likes')
            .get()
            .then((e) {
          var docc = e.docs;
          for (var i = 0; i < docc.length; i++) {
            Map data = docc[i].data();
            Likes likes = Likes();
            likes.id = data['userID'];
            likes.time = (data['time'] as Timestamp).toDate();
            status.likes.add(likes);
          }
        });
        appStatus.add(status);
        notifyListeners();
      }
    });
    return success;
  }

  Future<bool> getSquad() async {
    bool success = true;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var k = await firestore.collection("squad").get().then((value) async {
      var docs = value.docs;
      appSquad = [];
      for (var i = 0; i < docs.length; i++) {
        Map data = docs[i].data();
        SquadsCard squadsCard = SquadsCard();
        squadsCard.id = data['id'];
        squadsCard.description = data['description'];
        squadsCard.image = data['image'];
        squadsCard.time = (data['time'] as Timestamp).toDate();
        squadsCard.points = data['points'];
        squadsCard.name = data['name'];
        squadsCard.members = [];
        squadsCard.status = [];
        squadsCard.joinRequests = [];
        var k = await firestore
            .collection("squad")
            .doc(squadsCard.id)
            .collection('members')
            .get()
            .then((e) {
          var docc = e.docs;
          for (var i = 0; i < docc.length; i++) {
            Map data = docc[i].data();
            SquadMember member = SquadMember();
            member.userId = data['id'];
            member.type = data['type'];
            squadsCard.members.add(member);
            notifyListeners();
          }
        });
        k = await firestore
            .collection("squad")
            .doc(squadsCard.id)
            .collection('status')
            .get()
            .then((e) {
          var docc = e.docs;
          for (var i = 0; i < docc.length; i++) {
            Map data = docc[i].data();
            squadsCard.status
                .add(appStatus.where((e) => e.id == data['id']).toList().first);
            notifyListeners();
          }
        });
        k = await firestore
            .collection("squad")
            .doc(squadsCard.id)
            .collection('joinRequests')
            .get()
            .then((e) {
          var docc = e.docs;
          for (var i = 0; i < docc.length; i++) {
            Map data = docc[i].data();
            squadsCard.joinRequests.add(data["userID"]);
            notifyListeners();
          }
        });
        appSquad.add(squadsCard);
        notifyListeners();
      }
    });
    return success;
  }

  Future<bool> postMoments(File image) async {
    bool success = true;
    String imageUrl = "";
    String path = 'moments/${userModel.id}/${Uuid().v1()}.png';

    imageUrl = await uploadProductImage(image, path);
    String id = Uuid().v1();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("users")
        .doc(userModel.id)
        .collection('moments')
        .doc(id)
        .set({
      "id": id,
      "time": DateTime.now(),
      "image": imageUrl,
    }).then((value) {
      userModel.moments
          .add(Moments(id: id, image: imageUrl, time: DateTime.now()));
      notifyListeners();
    });
    return success;
  }

  Future<bool> changePhoto(File image) async {
    bool success = true;
    String imageUrl = "";
    String path = 'users/${userModel.id}/profile.png';

    imageUrl = await uploadProductImage(image, path);
    String id = Uuid().v1();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("users").doc(userModel.id).update({
      "photoUrl": imageUrl,
    }).then((value) {
      userModel.photoURL = imageUrl;
      notifyListeners();
    });
    return success;
  }

  Future<bool> postStatus(List<File> image, String description) async {
    bool success = true;
    List<String> imageUrl = [];
    List<String> hashTags = [];

    var m = description.split(" ");
    for (var i = 0; i < m.length; i++) {
      if (m[i].split("").toList().first == "#") {
        if (!hashTags.contains(m[i].toUpperCase()))
          hashTags.add(m[i].toUpperCase());
      }
    }

    String id = Uuid().v1();
    for (var i = 0; i < image.length; i++) {
      String sid = Uuid().v1();
      String path = 'status/$id/$sid.png';
      String url = await uploadProductImage(image[i], path);
      imageUrl.add(url);
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var h = await firestore.collection("status").doc(id).set({
      "id": id,
      "time": DateTime.now(),
      "userID": userModel.id,
      "description": description,
      "image": imageUrl,
    }).then((value) async {
      var m = await firestore
          .collection("users")
          .doc(userModel.id)
          .collection("status")
          .doc(id)
          .set({
        "id": id,
        "time": DateTime.now(),
      }).then((value) {
        Status status = Status(
          id: id,
          time: DateTime.now(),
          userID: userModel.id,
          description: description,
          image: imageUrl,
          reports: [],
          comments: [],
          likes: [],
        );
        appStatus.add(status);
        userModel.status.add(status);
        notifyListeners();
      });
      for (var i = 0; i < hashTags.length; i++)
        var m = await firestore
            .collection("hashtags")
            .doc(hashTags[i].toUpperCase())
            .collection("status")
            .doc(id)
            .set({
          "id": id,
          "time": DateTime.now(),
        });

      for (var i = 0; i < hashTags.length; i++)
        var h = await firestore
            .collection("hashtags")
            .doc(hashTags[i].toUpperCase())
            .set({
          "image": imageUrl.first,
          "hashTag": hashTags[i].toUpperCase(),
        });
    });
    return success;
  }

  uploadProductImage(File image, String path) async {
    final filePath = path;
    try {
      Reference storageReference = FirebaseStorage.instance
          .refFromURL('gs://de-dating-9b6b6.appspot.com')
          .child(filePath);
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);
      print('Product Image Uploaded');
      return await storageReference.getDownloadURL();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> updateBeans({int by}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return await firestore.collection("users").doc(userModel.id).update({
      "beans": FieldValue.increment(by),
    }).then((value) {
      userModel.beans = userModel.beans + by;
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<bool> updateDiamonds({int by}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return await firestore.collection("users").doc(userModel.id).update({
      "diamonds": FieldValue.increment(by),
    }).then((value) {
      userModel.diamonds = userModel.diamonds + by;
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<bool> editSettings({Map settings}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return await firestore.collection("users").doc(userModel.id).update({
      "settings": settings,
    }).then((value) {
      userModel.settings.appAlerts = {
        "voice": settings['appAlerts']['voice'],
        "receiveAppAlerts": settings['appAlerts']['receiveAppAlerts'],
        "comments": settings['appAlerts']['comments'],
        "like": settings['appAlerts']['like'],
        "allUsers": settings['appAlerts']['allUsers'],
        "vibrate": settings['appAlerts']['vibrate'],
        "talents": settings['appAlerts']['talents'],
        "followed": settings['appAlerts']['followed'],
      };
      userModel.settings.inbox = {
        "talentLevel": settings['inbox']['talentLevel'],
        "userLevel": settings['inbox']['userLevel'],
        "selected": settings['inbox']['selected'],
      };
      userModel.settings.roomEffects = {
        "entranceSoundEffects": settings['roomEffects']['entranceSoundEffects'],
        "giftSoundEffect": settings['roomEffects']['giftSoundEffect'],
        "giftEffect": settings['roomEffects']['giftEffect'],
        "entranceEffects": settings['roomEffects']['entranceEffects'],
      };
      userModel.settings.language = settings['language'];
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

//-------------------------------------  Live Streaming  ---------------------------------------

  ///clears all old stream  for the user
  Future<void> _clearOldStream() async {
    var result = await FirebaseFirestore.instance
        .collection("liveStreamings")
        .where('id', isEqualTo: userModel.id)
        .get();
    result.docs.forEach((element) {
      element.reference.update({
        'isStreaming': false,
      });
    });
  }

  ///INSERT THE NEW STREAM TO DATABASE AND RETURNS THE STREAM DOC ID
  Future<String> insert(UserStream stream) async {
    await _clearOldStream();
    String id = Uuid().v1();
    var doc = await FirebaseFirestore.instance
        .collection("liveStreamings")
        .doc(id)
        .set({
      'ack': stream.ack ?? 0,
      'allowFreeSpeak': stream.allowFreeSpeak,
      'allowMutiples': stream.allowMutiple,
      'channelName': stream.channelName,
      'chatTitle': stream.chatTitle,
      'docId': id,
      'isPk': stream.isPk ?? false,
      'isStreaming': stream.isStreaming,
      'listeners': stream.listeners,
      'maxAllow': stream.maxAllow,
      'members': stream.members,
      'pkDetails': stream.isPk == null || stream.isPk == false
          ? {}
          : {
              "endAt": stream.pkDetails.endAt,
              "startedAt": stream.pkDetails.startedAt,
              "winerId": stream.pkDetails.winerId,
              "isDraw": stream.pkDetails.isDraw,
              "numberOfRounds": stream.pkDetails.numberOfRounds,
              "pkEnded": stream.pkDetails.pkEnded,
              "pkStarted": stream.pkDetails.pkStarted,
              "pkTime": stream.pkDetails.pkTime,
            },
      'roomMode': stream.roomMode,
      'streamer': stream.streamer.id,
      'streamingPhoto': stream.streamingPhoto,
      'type': stream.type,
    });
    return id;
  }

//----------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------
  List<String> filterContents = [
    'For you',
    'Nearby',
    'Dating',
    'Random',
  ];
  final _firestore = FirebaseFirestore.instance;
  final collectionName = "liveStreamings";
  var showVideoStack = true;
  // var tags = List<String>.empty(growable: true);
  var _streams = List<UserStream>.empty(growable: true);
  var micState = false;
  var isLoadingStreamingList = true;
  // _fetchAllTags() async {
  //   var tagdoc =
  //       await _firestore.collection('tags').doc('bxTI19U90pzRLhXCei9D').get();
  //   List<String> allTags = [];
  //   if (tagdoc.exists) {
  //     for (var t in tagdoc.data()['tags']) {
  //       allTags.add(t);
  //     }
  //     tags.addAll(allTags);
  //   }
  // }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> streamListSubs;
  clearSteramListSubs() {
    streamListSubs?.cancel();
    notifyListeners();
  }

  fetchStreams() {
    isLoadingStreamingList = true;
    var query = _firestore
        .collection(collectionName)
        .where('isStreaming', isEqualTo: true);
    streamListSubs = query.snapshots().listen((event) {
      _streams = [];
      _streams.addAll(event.docs.map((e) {
        UserStream stream = UserStream();
        stream.ack = e.data()['ack'];
        stream.allowFreeSpeak = e.data()['allowFreeSpeak'];
        stream.allowMutiple = e.data()['allowMutiples'];
        stream.channelName = e.data()['channelName'];
        stream.chatTitle = e.data()['chatTitle'];
        stream.docId = e.data()['docId'];
        stream.isPk = e.data()['isPk'];
        stream.isStreaming = e.data()['isStreaming'];
        stream.listeners = e.data()['listeners'];
        stream.maxAllow = e.data()['maxAllow'];
        stream.members = e.data()['members'];
        stream.pkDetails =
            e.data()['pkDetails'] == {} || e.data()['pkDetails'] == null
                ? PkDetails()
                : PkDetails.fromMap(e.data()['pkDetails']);
        stream.roomMode = e.data()['roomMode'];
        stream.streamer = UserModel();
        stream.streamer.id = e.data()['streamer'];
        stream.streamingPhoto = e.data()['streamingPhoto'];
        stream.type = e.data()['type'];
        return stream;
      }).toList());
      print("came here..........");
      print(streams.length);
      isLoadingStreamingList = false;
      notifyListeners();
    });
  }

  ///send response to server ack
  ackBackToServer(String id) {
    updateSingleFieldOnStream(
      id,
      key: 'ack',
      value: 0,
    );

    notifyListeners();
  }

  ///added when user  accept the invite from other user
  Future<void> addorRemoveBroadCaster(
    UserStream stream,
    int agorauid, {
    bool remove = false,
    bool isPk = false,
    var oldData,
  }) async {
    var data = oldData ??
        {'name': userModel.name, 'videoId': agorauid, 'uid': userModel.id};
    if (remove) {
      _firestore.collection(collectionName).doc(stream.docId).update({
        'members': FieldValue.arrayRemove([data])
      });

      notifyListeners();
    } else {
      var pkDetils = stream.pkDetails;
      if (isPk) {
        var nowDate = DateTime.now();

        pkDetils.startedAt = nowDate;
        pkDetils.endAt =
            nowDate.add(Duration(minutes: stream.pkDetails.pkTime));

        notifyListeners();
      }
      _firestore.collection(collectionName).doc(stream.docId).update({
        'members': FieldValue.arrayUnion([data]),
        'pkDetails': pkDetils == null ? null : pkDetils.toMap()
      });

      notifyListeners();
    }
  }

  List<UserStream> get streams => _streams;

  Future<void> endStream(String id) async {
    await _firestore.collection(collectionName).doc(id).update({
      'isStreaming': false,
    });

    notifyListeners();
  }

  Future<bool> sendGift(
      Gift pickedGift, String userId, String streamId, bool ispk) async {
    if (!ispk) {
      try {
        await _firestore.collection("users").doc(userId).update({
          "beans":
              FieldValue.increment(int.parse(pickedGift.points.toString())),
        }).then((value) async {
          try {
            await _firestore.collection("users").doc(userModel.id).update({
              "beans": FieldValue.increment(
                  -1 * int.parse(pickedGift.points.toString())),
            });
            userModel.beans =
                userModel.beans - int.parse(pickedGift.points.toString());
            notifyListeners();
          } catch (e) {
            await _firestore.collection("users").doc(userModel.id).update({
              "beans": 0,
            });
          }
        });
      } catch (e) {
        await _firestore.collection("users").doc(userId).update({
          "beans": int.parse(pickedGift.points.toString()),
        }).then((value) async {
          try {
            await _firestore.collection("users").doc(userModel.id).update({
              "beans": FieldValue.increment(
                  -1 * int.parse(pickedGift.points.toString())),
            });
          } catch (e) {
            await _firestore.collection("users").doc(userModel.id).update({
              "beans": 0,
            });
          }
        });
      }

      notifyListeners();
      return true;
    } else {
      var giftref = _firestore
          .collection(collectionName)
          .doc(streamId)
          .collection("gifts");
      _firestore.runTransaction((txn) async {
        txn.set(
          giftref.doc('count'),
          {'$userId': FieldValue.increment(1)},
          SetOptions(
            merge: true,
          ),
        );
        pickedGift.sentBy = userModel.id;
        try {
          await _firestore.collection("users").doc(userId).update({
            "beans":
                FieldValue.increment(int.parse(pickedGift.points.toString())),
          }).then((value) async {
            try {
              await _firestore.collection("users").doc(userModel.id).update({
                "beans": FieldValue.increment(
                    -1 * int.parse(pickedGift.points.toString())),
              });
            } catch (e) {
              await _firestore.collection("users").doc(userModel.id).update({
                "beans": 0,
              });
            }
          });
        } catch (e) {
          await _firestore.collection("users").doc(userId).update({
            "beans": int.parse(pickedGift.points.toString()),
          }).then((value) async {
            try {
              await _firestore.collection("users").doc(userModel.id).update({
                "beans": FieldValue.increment(
                    -1 * int.parse(pickedGift.points.toString())),
              });
            } catch (e) {
              await _firestore.collection("users").doc(userModel.id).update({
                "beans": 0,
              });
            }
          });
        }
      });

      notifyListeners();
      return true;
    }
  }

  Future<void> joinOrLeaveStream(String streamid, {bool join = true}) async {
    if (join) {
      _firestore.collection(collectionName).doc(streamid).update({
        'listeners': FieldValue.arrayUnion([
          {
            'name': userModel.name,
            'uid': userModel.id,
            'profilePicture': userModel.photoURL,
          }
        ]),
      });

      notifyListeners();
    } else {
      _firestore.collection(collectionName).doc(streamid).update({
        'listeners': FieldValue.arrayRemove([
          {
            'name': userModel.name,
            'uid': userModel.id,
            'profilePicture': userModel.photoURL,
          }
        ]),
      });

      notifyListeners();
    }
  }

  Future<void> postComment(String streamId, String comment,
      {String giftUrl = ""}) async {
    _firestore
        .collection("liveStreamings")
        .doc(streamId)
        .collection('comments')
        .add({
      'body': comment,
      'date': FieldValue.serverTimestamp(),
      'by': {
        'uid': userModel.id,
        'name': userModel.name,
      },
      'image': giftUrl == "" ? null : giftUrl,
    });

    notifyListeners();
  }

  Future<UserStream> getStreamById(String id) async {
    var sdoc = await _firestore.collection("liveStreamings").doc(id).get();
    if (!sdoc.exists) return null;
    UserStream stream = UserStream();
    stream.ack = sdoc.data()['ack'];
    stream.allowFreeSpeak = sdoc.data()['allowFreeSpeak'];
    stream.allowMutiple = sdoc.data()['allowMutiples'];
    stream.channelName = sdoc.data()['channelName'];
    stream.chatTitle = sdoc.data()['chatTitle'];
    stream.docId = sdoc.data()['docId'];
    stream.isPk = sdoc.data()['isPk'];
    stream.isStreaming = sdoc.data()['isStreaming'];
    stream.listeners = sdoc.data()['listeners'];
    stream.maxAllow = sdoc.data()['maxAllow'];
    stream.members = sdoc.data()['members'];
    stream.pkDetails =
        sdoc.data()['pkDetails'] == {} || sdoc.data()['pkDetails'] == null
            ? PkDetails()
            : PkDetails.fromMap(sdoc.data()['pkDetails']);
    stream.roomMode = sdoc.data()['roomMode'];
    stream.streamer = UserModel();
    stream.streamer.id = sdoc.data()['streamer'];
    stream.streamingPhoto = sdoc.data()['streamingPhoto'];
    stream.type = sdoc.data()['type'];

    notifyListeners();
    return stream;
  }

  Future<void> updateSingleFieldOnStream(String streamId,
      {@required String key, @required dynamic value}) async {
    _firestore.collection(collectionName).doc(streamId).update({
      key: value,
    });

    notifyListeners();
  }

  Future<bool> isAllowedToOpenMic(String streamId, ClientRole role) async {
    var stream = await getStreamById(streamId);
    if (stream.allowFreeSpeak) {
      return true;
    } else if (stream.streamer.id != userModel.id) {
      return false;
    } else {
      return true;
    }
  }

  // Future<void> enterRandomCallRoom(RandomCall randomCall) async {
  //   await _firestore
  //       .collection("FirebaseCollections.RANDOM_CALL_USER_COLLECTIONS")
  //       .doc("_authController.currentUser.uid")
  //       .set(randomCall.toMap());
  // }

  Future<void> leaveRandomCallRoom() async {
    await _firestore
        .collection("FirebaseCollections.RANDOM_CALL_USER_COLLECTIONS")
        .doc(userModel.id)
        .delete();

    notifyListeners();
  }

  Future<void> editRandomCall(Map<String, dynamic> map, String id) async {
    await _firestore
        .collection("FirebaseCollections.RANDOM_CALL_USER_COLLECTIONS")
        .doc(id)
        .update(map);

    notifyListeners();
  }

//------------------------------------Notifications------------------------------------------------

  var _notifications = List<UserNotification>.empty(growable: true);
  int get notificationCount =>
      _notifications.where((e) => e.seen == false).toList().length;
  listenNotifications() {
    _firestore
        .collection("users")
        .doc(userModel.id)
        .collection("notifications")
        .orderBy('date', descending: true)
        .snapshots()
        .listen((event) {
      _notifications = [];
      _notifications.addAll(
          event.docs.map((e) => UserNotification.fromMap(e.data(), e.id)));
    });
  }

  List<UserNotification> get notifications => _notifications;
  void makeSeen(String id) {
    _firestore
        .collection("users")
        .doc(userModel.id)
        .collection("notifications")
        .doc(id)
        .update({'seen': true});
  }
}

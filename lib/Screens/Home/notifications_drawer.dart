// @dart=2.9

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/LiveStreaming/live_streaming.dart';
import 'package:streamkar/Screens/LiveStreaming/pkdetails.dart';
import 'package:streamkar/Screens/LiveStreaming/streamingmodel.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

class NotificationDrawer extends StatefulWidget {
  @override
  State<NotificationDrawer> createState() => _NotificationDrawerState();
}

class _NotificationDrawerState extends State<NotificationDrawer> {
  Api notificationController;
  @override
  Widget build(BuildContext context) {
    notificationController = Provider.of<Api>(context);
    notificationController.listenNotifications();
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notificationController.notifications.length,
                itemBuilder: (_, index) {
                  final notification =
                      notificationController.notifications[index];
                  return Card(
                    child: ListTile(
                      onTap: () async {
                        if (notification.collectionName == "liveStreamings") {
                          var streamDoc = await FirebaseFirestore.instance
                              .collection("liveStreamings")
                              .doc(notification.collecionId)
                              .get();
                          if (streamDoc.exists) {
                            UserStream stream = UserStream();
                            stream.ack = streamDoc.data()['ack'];
                            stream.allowFreeSpeak =
                                streamDoc.data()['allowFreeSpeak'];
                            stream.allowMutiple =
                                streamDoc.data()['allowMutiples'];
                            stream.channelName =
                                streamDoc.data()['channelName'];
                            stream.chatTitle = streamDoc.data()['chatTitle'];
                            stream.docId = streamDoc.data()['docId'];
                            stream.isPk = streamDoc.data()['isPk'];
                            stream.isStreaming =
                                streamDoc.data()['isStreaming'];
                            stream.listeners = streamDoc.data()['listeners'];
                            stream.maxAllow = streamDoc.data()['maxAllow'];
                            stream.members = streamDoc.data()['members'];
                            stream.pkDetails =
                                streamDoc.data()['pkDetails'] == {}
                                    ? PkDetails()
                                    : PkDetails.fromMap(
                                        streamDoc.data()['pkDetails']);
                            stream.roomMode = streamDoc.data()['roomMode'];
                            stream.streamer = UserModel();
                            stream.streamer.id = streamDoc.data()['streamer'];
                            stream.streamingPhoto =
                                streamDoc.data()['streamingPhoto'];
                            stream.type = streamDoc.data()['type'];
                            if (stream.isStreaming) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LiveStreaming(
                                    stream,
                                    streamingId: stream.docId,
                                    role: ClientRole.Broadcaster,
                                    joinedUser:
                                        notificationController.userModel,
                                    callType: stream.type,
                                    channelName: stream.channelName,
                                  ),
                                ),
                              );
                            } else {
                              CustomSnackBar(
                                  context, Text("Streaming is ended"));
                            }
                            if (!notification.seen) {
                              notificationController.makeSeen(notification.id);
                            }
                          }
                          return;
                        }
                      },
                      title: Text(notification.title),
                      subtitle: Text(notification.body),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

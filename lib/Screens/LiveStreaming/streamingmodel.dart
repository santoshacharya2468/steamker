// @dart=2.9

import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/LiveStreaming/pkdetails.dart';

class UserStream {
  String docId;

  ///first user to initiate the streaming
  UserModel streamer;
  String chatTitle;
  bool allowMutiple = true;
  int maxAllow = 0;
  // List<String> tags;
  bool isPk;

  ///this field is present only if [isPK==true]
  PkDetails pkDetails;

  ///audience
  List listeners = [];

  ///may be multiple steramer
  List members = [];

  ///thumbnails to be appears on home screen where user select the stramer
  String streamingPhoto;
  bool isStreaming;
  String channelName;

  ///video or audios
  String type;

  ///room mode like open  anyone can be guest or only with invitation link they can be guest
  bool roomMode;

  ///either guest can speak freely or not
  bool allowFreeSpeak;

  ///helps in filter the content  for user like filter by nearby,celeb,party,dating etc;
  // List<String> contentFilter = [];

  ///acknowledgment is used to clear failure network connction live streaming
  ///server trigger the [isStreaming=true] live streaming every 5 minutes and change this variable to 1
  ///for next five minutes if clinet failed to change this variable to 0 then streaming will closed
  ///indicating as network failure or somethings else
  int ack = 0;
  UserStream(
      // this.contentFilter,
      {
    this.channelName,
    this.type,
    this.isStreaming,
    this.docId,
    this.allowMutiple,
    this.maxAllow,
    this.roomMode = true,
    this.allowFreeSpeak = true,
    this.streamer,
    this.chatTitle,
    this.listeners,
    this.members,
    this.isPk,
    this.streamingPhoto,
    // this.tags,
  });
}

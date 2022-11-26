// @dart=2.9

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Screens/LiveStreaming/commnet_icon.dart';
import 'package:streamkar/Screens/LiveStreaming/gift.dart';
import 'package:streamkar/Screens/LiveStreaming/giftbutton.dart';
import 'package:streamkar/Screens/LiveStreaming/interactive_mode.dart';
import 'package:streamkar/Screens/LiveStreaming/manage_group_button.dart';
import 'package:streamkar/Screens/LiveStreaming/streamingmodel.dart';
import 'package:streamkar/Screens/LiveStreaming/toggle_camera_icon.dart';
import 'package:streamkar/Screens/LiveStreaming/toggle_microphone_icon.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

///icons at bottom like camera,mic,manage and pk etc
class StreamingBottomView extends StatefulWidget {
  final ClientRole role;
  final RtcEngine engine;
  final bool isVideoCall;
  final UserStream stream;
  final int agoraID;
  final String selectedUserId;
  StreamingBottomView(this.selectedUserId, this.role, this.engine,
      this.isVideoCall, this.stream, this.agoraID);

  @override
  _StreamingBottomViewState createState() => _StreamingBottomViewState();
}

class _StreamingBottomViewState extends State<StreamingBottomView> {
  List<Widget> actions = [];
  Api streamController;
  bool first = true;
  bool loading = true;

  initialize() {
    actions = [
      CommentIcon(widget.stream.docId),
    ];
    if (widget.role == ClientRole.Broadcaster && widget.isVideoCall) {
      actions.addAll([
        ToggleCamera(
          onToggle: () {
            widget.engine?.switchCamera();
          },
        ),
        ToggleMicroPhone(
          onToggle: () async {
            var isAllowedToOpenMic = await streamController.isAllowedToOpenMic(
                widget.stream.docId, widget.role);
            if (isAllowedToOpenMic) {
              widget.engine?.muteLocalAudioStream(!streamController.micState);
              streamController.micState = !streamController.micState;
            }
          },
        ),
      ]);
    } else if (widget.role == ClientRole.Broadcaster) {
      actions.addAll([
        ToggleMicroPhone(
          onToggle: () async {
            var isAllowedToOpenMic = await streamController.isAllowedToOpenMic(
                widget.stream.docId, widget.role);
            if (isAllowedToOpenMic) {
              widget.engine?.muteLocalAudioStream(!streamController.micState);
              streamController.micState = !streamController.micState;
            }
          },
        ),
      ]);
    }
    loading = false;
  }

  Api obj;
  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    streamController = Provider.of<Api>(context);
    first = true;
    if (first) {
      first = false;
      initialize();
    }
    return loading
        ? Container()
        : Container(
            height: 60,
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: actions.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: actions[index],
                      );
                    },
                  ),
                ),
                if (widget.role == ClientRole.Audience)
                  if (widget.stream.pkDetails == null ||
                      widget.stream.pkDetails.pkEnded != null)
                    GiftButton(widget.selectedUserId,
                        onGiftPicked: (Gift pickedGift) async {
                      if (widget.selectedUserId != null) {
                        if (obj.userModel.beans >= pickedGift.points) {
                          bool m = await streamController.sendGift(
                              pickedGift,
                              widget.selectedUserId,
                              widget.stream.docId,
                              widget.stream.isPk);
                          if (m) {
                            streamController.postComment(
                              widget.stream.docId,
                              '✨✨ Gifted ${pickedGift.name} worth ${pickedGift.points} ✨✨',
                              giftUrl: pickedGift.image,
                            );
                            CustomSnackBar(
                                context,
                                Text(
                                    "${pickedGift.name} worth ${pickedGift.points} beans Sent Successfully"));
                          }
                        } else {
                          CustomSnackBar(context,
                              Text("Insufficient Beans.. Please Purchase"));
                        }
                      } else {
                        CustomSnackBar(
                            context, Text("Select a user to send gift"));
                      }
                    }),
                if (widget.role == ClientRole.Broadcaster &&
                    widget.stream.allowMutiple &&
                    widget.stream.streamer.id == obj.userModel.id &&
                    !widget.stream.isPk)
                  ManageGroupButton(
                    stream: widget.stream,
                  ),
                if (widget.role == ClientRole.Broadcaster &&
                    !widget.stream.allowMutiple &&
                    widget.stream.streamer.id == obj.userModel.id &&
                    !widget.stream.isPk)
                  // PkButton(widget.stream,widget.agoraID),
                  InterActiveMode(widget.stream, widget.agoraID)
              ],
            ),
          );
  }
}

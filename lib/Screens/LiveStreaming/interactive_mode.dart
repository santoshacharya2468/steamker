// @dart=2.9
import 'package:flutter/material.dart';
import 'package:streamkar/Screens/LiveStreaming/pkButton.dart';
import 'package:streamkar/Screens/LiveStreaming/streamingmodel.dart';

class InterActiveMode extends StatefulWidget {
  final UserStream stream;
  final int agoraId;
  InterActiveMode(this.stream, this.agoraId);

  @override
  _InterActiveModeState createState() => _InterActiveModeState();
}

class _InterActiveModeState extends State<InterActiveMode> {
  List<Widget> _actions = [];
  @override
  void initState() {
    super.initState();
    _actions = [PkButton(widget.stream, widget.agoraId)];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 250,
                margin: const EdgeInsets.only(top: 40),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Wrap(
                  children: _actions,
                  spacing: 5,
                ),
              );
            });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Image.asset('assets/pkicons/battle.png'),
      ),
    );
  }
}

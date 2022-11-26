// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';

class ToggleMicroPhone extends StatefulWidget {
  final Function onToggle;
  ToggleMicroPhone({@required this.onToggle});

  @override
  State<ToggleMicroPhone> createState() => _ToggleMicroPhoneState();
}

class _ToggleMicroPhoneState extends State<ToggleMicroPhone> {
  @override
  Widget build(BuildContext context) {
    Api streamController = Provider.of<Api>(context);
    return GestureDetector(
      onTap: widget.onToggle,
      child: Container(
        height: 40,
        width: 40,
        decoration:
            BoxDecoration(color: Colors.grey[900], shape: BoxShape.circle),
        child: Icon(!streamController.micState ? Icons.mic : Icons.mic_off,
            color: Colors.white),
      ),
    );
  }
}

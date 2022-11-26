import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/starAnimations.dart';

import '../../../utils/colors.dart';

class VipDetails extends StatefulWidget {
  const VipDetails({Key? key}) : super(key: key);

  @override
  State<VipDetails> createState() => _VipDetailsState();
}

class _VipDetailsState extends State<VipDetails> {
  Api? obj;
  Map<String, String> myStringWithLinebreaks = {
    "Limitless Chat": '''
VIP and SVIP users can send chat messages without limits. Regular users can only send messages with a limit of 60 characters; VIP users can send messages with a limit of 150 characters; SVIP users can send messages with a limit of 300 characters.
      ''',
    "Video Chat": '''
Do you want to take your relationship with your fave talent to the next level? Simple! Join VIP/SVIP now and you can do video chats with everyone!     
 ''',
    "Mute & Safety": '''
In a showroom, some users can mute other users if they have attained a certain status.

Additionally, some users can even not be muted by others as per their status.

VIP users can only be muted by SVIP users and SVIP users can only be muted by the talent (and no one else!)
''',
    "Badge": '''
After you have purchased VIP/SVIP, you will get an exclusive badge displayed on your profile page, on your messages sent in showroom chat, next to your information on the showroom user list, on your in-showroom profile card, etc.
      ''',
    "Rank Boost": '''
As a VIP/SVIP user, your profile will appear in a special area in the showroom user list. This way, the talent will know you are a very important person.
      ''',
    "Profile Edits": '''
A normal user can modify his/her avatar or nickname at most once per natural month.

By becoming a VIP or SVIP user,a user may increase the limit to 5 times/30 times,respectively.

     ''',
    "Cool Emojis": '''
As an SVIP user, you will receive a whole batch of exclusive SVIP emoijs to send to your favourite talents!
      ''',
    "Special Name": '''
After becoming an SVIP, your user name will appear highlighted in red in the showroom. This shows you are unparalled in status!
      ''',
  };

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
          "View Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: myStringWithLinebreaks.length,
        itemBuilder: ((context, index) {
          return ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                myStringWithLinebreaks.keys.toList()[index],
                style: TextStyle(color: pink, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: LineSplitter.split(
                        myStringWithLinebreaks.values.toList()[index])
                    .map((o) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          o,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                          ),
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ),
    );
  }
}

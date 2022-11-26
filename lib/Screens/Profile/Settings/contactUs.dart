import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/starAnimations.dart';

import '../../../utils/colors.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  Api? obj;
  Map<String, String> myStringWithLinebreaks = {
    "Contact US": '''
Call : +31 6 44654929
Mail : ahmadwaqas1991989@gmail.com
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
          "Contact Us",
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

// @dart=2.9

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

class AddStatus extends StatefulWidget {
  final File image;
  const AddStatus({Key key, @required this.image}) : super(key: key);

  @override
  State<AddStatus> createState() => _AddStatusState();
}

class _AddStatusState extends State<AddStatus> {
  Api obj;
  bool loading = false;
  TextEditingController messageController = TextEditingController();
  List<File> files = [];

  @override
  void initState() {
    files = [widget.image];
    super.initState();
  }

  Future<void> getImage() async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    setState(() {
      files.add(File(image.path));
    });
  }

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
          "Add Status",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
        actions: [
          InkWell(
            onTap: loading || files.length == 0
                ? null
                : () async {
                    setState(() {
                      loading = true;
                    });
                    bool success =
                        await obj.postStatus(files, messageController.text);
                    if (success) {
                      CustomSnackBar(
                        context,
                        Text("Status Added"),
                      );
                      Navigator.of(context).pop();
                    } else {
                      CustomSnackBar(
                        context,
                        Text("Some Error Occured, Try Again !!"),
                      );
                      setState(() {
                        loading = false;
                      });
                    }
                  },
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Center(
                child: loading
                    ? CircularProgressIndicator()
                    : Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                child: HashTagTextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Want to share a status?',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: InputBorder.none,
                  ),
                  basicStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                  controller: messageController,
                  decoratedStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                children: [
                  for (var i = 0; i < files.length; i++)
                    Stack(
                      children: [
                        ClipRRect(
                          child: Image.file(
                            files[i],
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
                                files.removeAt(i);
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
                  files.length < 3
                      ? Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.width / 3.5,
                          color: Colors.grey[100],
                          child: InkWell(
                            onTap: () async {
                              await getImage();
                            },
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

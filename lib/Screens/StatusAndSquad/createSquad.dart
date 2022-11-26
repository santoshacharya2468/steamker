// @dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/colors.dart';
import 'package:streamkar/utils/dialog.dart';
import 'package:streamkar/utils/validators.dart';
import 'package:uuid/uuid.dart';

class CreateSquad extends StatefulWidget {
  const CreateSquad({Key key}) : super(key: key);

  @override
  _CreateSquadState createState() => _CreateSquadState();
}

class _CreateSquadState extends State<CreateSquad> {
  bool loading = false;
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode confirmpasswordFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameFocus.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  Api obj;
  File _image;
  Future<bool> getImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(
        source: source, maxHeight: 200, maxWidth: 200);
    setState(() {
      _image = File(image.path);
    });
    if (_image != null)
      return true;
    else
      return false;
  }

  Future<void> createSquad() async {
    setState(() {
      loading = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String id = Uuid().v1();
    await firestore.collection("squad").doc(id).set({
      "id": id,
      "image": await obj.uploadProductImage(_image, 'squad/$id.png'),
      "name": nameController.text,
      "description": emailController.text,
      "points": 0,
      "time": DateTime.now(),
    }).then((value) async {
      var m = await firestore
          .collection("squad")
          .doc(id)
          .collection("members")
          .doc(obj.userModel.id)
          .set({
        "id": obj.userModel.id,
        "type": "ceo",
      });
      CustomSnackBar(
        context,
        Text("Squad created SuccessFully"),
      );
      bool success = await obj.getSquad();
      obj.notify();

      setState(() {
        loading = false;
        _image = null;
      });
      Navigator.of(context).pop();
    }).onError((error, stackTrace) {
      CustomSnackBar(
        context,
        Text("Error Occured.. try again !!"),
      );

      setState(() {
        loading = false;
      });
    });
  }

  bool imageLoad = false;
  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back_ios,
                              size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "$appName Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Create Squad",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 20),
                      imageLoad
                          ? CircleAvatar(
                              radius: 50,
                              child: CircularProgressIndicator(),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: Image.file(
                                _image,
                              ).image,
                            ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          bool k = await getImage(ImageSource.gallery);
                          if (k) {
                            setState(() {
                              imageLoad = false;
                            });
                          }
                        },
                        child: Text(
                          "Upload Photo",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 20.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          validator: (e) => otherValidator(e),
                          focusNode: nameFocus,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            filled: true,
                            fillColor: lightPink,
                            hintText: "Name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30)),
                            hintStyle: TextStyle(
                              fontSize: 17.0,
                              color: deepLightPink,
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            emailFocus.requestFocus();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          validator: (e) => otherValidator(e),
                          focusNode: emailFocus,
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            filled: true,
                            fillColor: lightPink,
                            hintText: "Description",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30)),
                            hintStyle: TextStyle(
                              fontSize: 17.0,
                              color: deepLightPink,
                            ),
                          ),
                          onFieldSubmitted: (_) {},
                        ),
                      ),
                      SizedBox(height: 50),
                      InkWell(
                        onTap: loading
                            ? null
                            : () async {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();

                                  if (_image == null) {
                                    CustomSnackBar(
                                      context,
                                      Text("Please Upload Image"),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    loading = true;
                                  });
                                  await createSquad();
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 20.0, left: 20.0, right: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 50,
                            height: 46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(width: 2, color: Colors.white),
                            ),
                            child: Center(
                              child: loading
                                  ? CircularProgressIndicator()
                                  : Text(
                                      "Register Squad",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

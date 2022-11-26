// @dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Services/api.dart';
import 'package:streamkar/utils/dialog.dart';

import '../../utils/colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool first = true;
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController introductionController = TextEditingController();
  DateTime dob = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void initialize() {
    idController.text = obj.userModel.id.substring(0, 10);
    nameController.text = obj.userModel.name;
    genderController.text = obj.userModel.gender;
    regionController.text = obj.userModel.place;
    birthdayController.text = obj.userModel.dob.toString().split(" ").first;
    introductionController.text = obj.userModel.description;
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

  Future<void> editProfile() async {
    setState(() {
      loading = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("users").doc(obj.userModel.id).update({
      "gender": genderController.text,
      "place": regionController.text,
      "dob": dob,
      "description": introductionController.text,
    }).then((value) {
      CustomSnackBar(
        context,
        Text("Profile Edited SuccessFully"),
      );
      obj.userModel.gender = genderController.text;
      obj.userModel.place = regionController.text;
      obj.userModel.dob = dob;
      obj.userModel.description = introductionController.text;
      obj.notify();

      setState(() {
        loading = false;
      });
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

  bool loading = false;
  bool imageLoad = false;
  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      initialize();
      first = false;
    }
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
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          InkWell(
            onTap: loading
                ? null
                : () async {
                    await editProfile();
                  },
            child: Center(
              child: loading
                  ? CircularProgressIndicator()
                  : Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          Container(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              imageLoad
                  ? CircleAvatar(
                      radius: 50,
                      child: CircularProgressIndicator(),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        obj.userModel.photoURL,
                      ),
                    ),
              SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  bool k = await getImage(ImageSource.gallery);
                  if (k) {
                    setState(() {
                      imageLoad = true;
                    });
                    bool success = await obj.changePhoto(_image);
                    if (success) {
                      CustomSnackBar(
                        context,
                        Text("Profile Photo Updated"),
                      );
                      setState(() {
                        imageLoad = false;
                      });
                    } else {
                      CustomSnackBar(
                        context,
                        Text("Some Error Occured, Try Again !!"),
                      );
                      setState(() {
                        imageLoad = false;
                      });
                    }
                  }
                },
                child: Text(
                  "Change Photo",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffix: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                          labelText: 'Nickname',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[300],
                              width: 1.0,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                        controller: nameController,
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffix: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                color: pink,
                              ),
                              child: Text(
                                "Copy",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          labelText: 'ID',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                          enabled: false,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[300],
                              width: 1.0,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                        controller: idController,
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 65,
                          child: TextFormField(
                            decoration: InputDecoration(
                              suffix: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              labelText: 'Gender',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                letterSpacing: 1,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[300],
                                  width: 1.0,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                            controller: genderController,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _openDialog(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 65,
                            width: MediaQuery.of(context).size.width,
                          ),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 65,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Region',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                letterSpacing: 1,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[300],
                                  width: 1.0,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                            controller: regionController,
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          height: 65,
                          width: MediaQuery.of(context).size.width,
                          child: CountryListPick(
                            appBar: AppBar(
                              backgroundColor: Colors.white,
                              leading: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              title: Text(
                                'Select Country/Region',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            theme: CountryTheme(
                              isShowFlag: false,
                              isShowTitle: false,
                              isShowCode: false,
                              isDownIcon: false,
                              showEnglishName: true,
                            ),
                            onChanged: (CountryCode code) {
                              setState(() {
                                regionController.text = code.name;
                              });
                            },
                            // Whether to allow the widget to set a custom UI overlay
                            useUiOverlay: true,
                            // Whether the country list should be wrapped in a SafeArea
                            useSafeArea: true,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 65,
                          child: TextFormField(
                            decoration: InputDecoration(
                              suffix: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              labelText: 'Birthday',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                letterSpacing: 1,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[300],
                                  width: 1.0,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                            controller: birthdayController,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 65,
                            width: MediaQuery.of(context).size.width,
                          ),
                        )
                      ],
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Introduction',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[300],
                              width: 1.0,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          letterSpacing: 1,
                        ),
                        controller: introductionController,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  String gender = "Male";
  void _openDialog(BuildContext context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (a1, a2, child) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            title: const Text('Male'),
                            leading: Radio(
                              value: "Male",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                  genderController.text = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Female'),
                            leading: Radio(
                              value: "Female",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                  genderController.text = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.red.shade500,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.clear,
                                size: 26.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: dob,
        locale: Locale('en', 'EN'),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != dob)
      setState(() {
        dob = pickedDate;
        birthdayController.text = dob.toString().split(" ").first;
      });
  }
}

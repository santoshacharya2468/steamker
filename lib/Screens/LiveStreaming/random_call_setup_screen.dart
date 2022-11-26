// // @dart=2.9

// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:streamkar/Screens/LiveStreaming/agora_permission.dart';
// import 'package:streamkar/Screens/LiveStreaming/streamController.dart';

// class RandomCallSetupScreen extends StatefulWidget {
//   @override
//   _LiveModeSelectionScreenState createState() =>
//       _LiveModeSelectionScreenState();
// }

// class _LiveModeSelectionScreenState extends State<RandomCallSetupScreen> {
//   List<CameraDescription> cameras;
//   CameraController controller;
//   final streamController = UserStreamController();
//   RandomCall randomCall;
//   getCamera() async {
//     await handleCameraAndMic('Video');
//     cameras = await availableCameras();
//     controller = CameraController(cameras[1], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     randomCall = RandomCall(
//         preferredGender: [
//           obj.currentUser.gender == 'Female' ? 'Male' : 'Female'
//         ],
//         preferredLocation: Country.ALL.map((e) => e.name).toList(),
//         user: authController.currentUser);

//     getCamera();
//     streamController.enterRandomCallRoom(randomCall);
//   }

//   bool pushed = false;
//   Future<void> makeCall(
//       Call call, RandomCall rcall, BuildContext context) async {
//     if (!pushed) {
//       pushed = true;
//       var ref = await _firestore
//           .collection(FirebaseCollections.CALL_COLLECTIONS)
//           .add(call.toMap());
//       call.docId = ref.id;
//       streamController.editRandomCall({
//         'call': call.toMap(),
//         'callId': call.docId,
//       }, rcall.docId);

//       await streamController.leaveRandomCallRoom();
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => CallPage(
//                     call: call,
//                     randomCall: rcall,
//                   )));
//     }
//     // Get.offAll(()=>CallPage(call:call,
//     //   randomCall: rcall,
//     //   ));
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   final List<Map<String, dynamic>> genderSelections = [
//     {
//       'name': 'Male',
//       'image': 'assets/images/male.png',
//       'value': ['Male']
//     },
//     {
//       'name': 'Female',
//       'image': 'assets/images/woman.png',
//       'value': ['Female']
//     },
//     {
//       'name': 'Both',
//       'image': 'assets/images/male-and-female.png',
//       'value': ['Male', 'Female']
//     },
//   ];
//   final _firestore = FirebaseFirestore.instance;
//   @override
//   Widget build(BuildContext context) {
//     if (controller == null || !controller.value.isInitialized) {
//       return Container();
//     }
//     return WillPopScope(
//       onWillPop: () async {
//         await streamController.leaveRandomCallRoom();
//         return true;
//       },
//       child: PageView.builder(
//         itemCount: 2,
//         onPageChanged: (index) {
//           bool isSearching = index == 1 ? true : false;
//           streamController.editRandomCall({
//             'isSearching': isSearching,
//           }, authController.currentUser.uid);
//         },
//         itemBuilder: (context, index) {
//           if (index == 0) {
//             return Scaffold(
//               body: Container(
//                   height: double.infinity,
//                   width: Get.width,
//                   child: CameraPreview(
//                     controller,
//                     child: Container(
//                       height: double.infinity,
//                       width: Get.width,
//                       child: Stack(
//                         children: [
//                           //SizedBox(height:100),
//                           Positioned(
//                             top: 50,
//                             left: Get.width / 2 - 15,
//                             child: Container(
//                               child: StreamBuilder(
//                                 stream: _firestore
//                                     .collection(FirebaseCollections
//                                         .RANDOM_CALL_USER_COLLECTIONS)
//                                     .doc(authController.currentUser.uid)
//                                     .snapshots(),
//                                 builder: (_,
//                                     AsyncSnapshot<
//                                             DocumentSnapshot<
//                                                 Map<String, dynamic>>>
//                                         snapshot) {
//                                   if (snapshot.hasData &&
//                                       snapshot.data.data() != null) {
//                                     var matchRandomCall = RandomCall.fromMap(
//                                         snapshot.data.data(), snapshot.data.id);
//                                     if (matchRandomCall.call != null) {
//                                       WidgetsBinding.instance
//                                           .addPostFrameCallback(
//                                               (timeStamp) async {
//                                         await streamController
//                                             .leaveRandomCallRoom();
//                                         Navigator.pushReplacement(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (_) => CallPage(
//                                                       call:
//                                                           matchRandomCall.call,
//                                                     )));
//                                       });
//                                     }
//                                   }
//                                   return Center(
//                                       child: CupertinoActivityIndicator());
//                                 },
//                               ),
//                             ),
//                           ),
//                           buildStackItems(context),
//                         ],
//                       ),
//                     ),
//                   )),
//             );
//           } else {
//             return Scaffold(
//               body: Container(
//                 height: double.infinity,
//                 width: Get.width,
//                 decoration: BoxDecoration(gradient: gradient),
//                 child: Column(
//                   children: [
//                     StreamBuilder(
//                       stream: _firestore
//                           .collection(
//                               FirebaseCollections.RANDOM_CALL_USER_COLLECTIONS)
//                           .where('isSearching', isEqualTo: false)
//                           .where('preferredGender',
//                               arrayContainsAny: randomCall.preferredGender)
//                           .where('user.uid',
//                               isNotEqualTo: authController.currentUser.uid)
//                           .limit(20)
//                           .snapshots(),
//                       builder: (context,
//                           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                               snapshot) {
//                         if (snapshot.hasData && snapshot.data.docs.length > 0) {
//                           var randomCalls = snapshot.data.docs
//                               .map((e) => RandomCall.fromMap(e.data(), e.id))
//                               .toList();
//                           randomCalls = randomCalls
//                               .where((element) => element.preferredLocation
//                                   .includes(randomCall.preferredLocation))
//                               .toList();
//                           var randomNumber =
//                               Random().nextInt(randomCalls.length);
//                           var selectedCall = randomCalls[randomNumber];
//                           WidgetsBinding.instance
//                               .addPostFrameCallback((timeStamp) async {
//                             var call = Call(
//                                 channelId:
//                                     '${selectedCall.user.uid}_${authController.currentUser.uid}',
//                                 type: 'video',
//                                 response: 1,
//                                 caller: authController.currentUser,
//                                 callerId: authController.currentUser.uid,
//                                 receiver: selectedCall.user,
//                                 receiverId: selectedCall.user.uid,
//                                 isRandom: true);
//                             makeCall(call, selectedCall, context);
//                           });
//                           // return Text('Connecting');

//                         }
//                         return Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CupertinoActivityIndicator(),
//                               SizedBox(height: 50),
//                               Container(
//                                 height: 100,
//                                 width: Get.width - 100,
//                                 decoration: BoxDecoration(
//                                     gradient: gradient,
//                                     borderRadius: BorderRadius.circular(20)),
//                                 child: Center(
//                                     child: Text(
//                                   'Searching For new Friends',
//                                   style: TextStyle(
//                                       color: Colors.white70, fontSize: 18),
//                                 )),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     buildStackItems(
//                       context,
//                       height: 100,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget buildStackItems(
//     BuildContext context, {
//     double height,
//   }) {
//     return Container(
//       height: height ?? Get.height,
//       width: Get.width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Builder(
//             builder: (context) => Container(
//               height: 45,
//               width: 280,
//               margin: const EdgeInsets.only(bottom: 20),
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(22.5),
//                   color: Colors.white),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildSelection(
//                     icon: Icons.people,
//                     title: 'Gender',
//                     onPressed: _buildGenderSelectionMenu,
//                   ),
//                   _buildSelection(
//                       icon: Icons.place,
//                       title: 'Region',
//                       onPressed: _buildRegionSelectionMenu),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSelection(
//       {@required IconData icon,
//       @required String title,
//       @required Function onPressed}) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: AppColors.PRIMARY_COLOR,
//             ),
//             Text(
//               title,
//               style: Get.textTheme.button,
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   itemChanged() {
//     setState(() {});
//   }

//   _buildGenderSelectionMenu() {
//     Get.bottomSheet(
//         Container(
//           height: 400,
//           width: Get.width,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: StatefulBuilder(builder: (context, setState) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child:
//                       Text('Preferred Gender', style: Get.textTheme.headline6),
//                 ),
//                 Expanded(
//                   child: GridView(
//                     physics: NeverScrollableScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 20,
//                         crossAxisSpacing: 20,
//                         childAspectRatio: 120 / 100),
//                     children: genderSelections.map((e) {
//                       bool isSelected = false;

//                       isSelected = e['value'] == randomCall.preferredGender;

//                       return InkWell(
//                         onTap: () {
//                           setState(() {
//                             randomCall.preferredGender = e['value'];
//                           });
//                           streamController.enterRandomCallRoom(randomCall);
//                           itemChanged();
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 border: Border.fromBorderSide(BorderSide(
//                                     width: isSelected ? 2 : 0,
//                                     color: isSelected
//                                         ? AppColors.PRIMARY_COLOR
//                                         : Colors.white))),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   e['image'],
//                                   height: 80,
//                                   width: 80,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 Text(
//                                   e['name'],
//                                   style: Get.textTheme.headline6.copyWith(
//                                       color: isSelected
//                                           ? Colors.black
//                                           : Colors.grey),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 )
//               ],
//             );
//           }),
//         ),
//         backgroundColor: Colors.white);
//   }

//   _buildRegionSelectionMenu() {
//     var locations = ['Global'];
//     if (authController.currentUser.country != null &&
//         authController.currentUser.country.isNotEmpty) {
//       locations.add(authController.currentUser.country);
//     }
//     Get.bottomSheet(
//         Container(
//           height: 250,
//           width: Get.width,
//           padding: const EdgeInsets.all(8),
//           child: StatefulBuilder(
//             builder: (context, setState) => Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child:
//                       Text('Preferred Region', style: Get.textTheme.headline6),
//                 ),
//                 ...(locations.map((e) {
//                   bool isSelected = false;
//                   if (e == 'Global') {
//                     isSelected = randomCall.preferredLocation.length ==
//                         Country.ALL.length;
//                   } else {
//                     isSelected = randomCall.preferredLocation.length == 1 &&
//                         randomCall.preferredLocation.contains(e);
//                   }

//                   return InkWell(
//                     onTap: () {
//                       if (e == 'Global') {
//                         randomCall.preferredLocation =
//                             Country.ALL.map((e) => e.name).toList();
//                       } else {
//                         randomCall.preferredLocation = [e];
//                       }
//                       setState(() {});
//                       streamController.enterRandomCallRoom(randomCall);
//                       itemChanged();
//                     },
//                     child: Container(
//                       height: 45,
//                       margin: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                           border: Border.fromBorderSide(BorderSide(
//                               width: isSelected ? 2 : 2.0,
//                               color: isSelected
//                                   ? AppColors.PRIMARY_COLOR
//                                   : Colors.grey))),
//                       child: Center(
//                           child: Text(
//                         e,
//                         style: Get.textTheme.button,
//                       )),
//                     ),
//                   );
//                 }).toList())
//               ],
//             ),
//           ),
//         ),
//         backgroundColor: Colors.white);
//   }
// }

// extension Includes on List<String> {
//   bool includes(List<String> searchSet) {
//     for (String e in this) {
//       if (searchSet.contains(e)) {
//         return true;
//       }
//     }
//     return false;
//   }
// }

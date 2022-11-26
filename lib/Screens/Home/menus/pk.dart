// @dart=2.9

import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkar/Models/userModel.dart';
import 'package:streamkar/Screens/LiveStreaming/live_streaming.dart';
import 'package:streamkar/Screens/LiveStreaming/progressBar.dart';
import 'package:streamkar/Services/api.dart';

class PkScreen extends StatefulWidget {
  final bool showAppBar;
  const PkScreen({Key key, @required this.showAppBar}) : super(key: key);

  @override
  State<PkScreen> createState() => _PkScreenState();
}

class _PkScreenState extends State<PkScreen> {
  Api obj;
  bool first = true;
  @override
  Widget build(BuildContext context) {
    obj = Provider.of<Api>(context);
    if (first) {
      first = false;
      obj.fetchStreams();
    }
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
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
                "Pk Streams",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              obj.isLoadingStreamingList
                  ? ProgressBar()
                  : Container(
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        children: List.generate(
                            obj.streams
                                .where((e) => e.isPk == true)
                                .toList()
                                .length, (i) {
                          var stream = obj.streams
                              .where((e) => e.isPk == true)
                              .toList()[i];

                          List<UserModel> m = obj.appUsers.where((e) {
                            return e.id == stream.streamer.id;
                          }).toList();
                          if (m.isNotEmpty) stream.streamer = m.first;
                          String photo =
                              'https://1.bp.blogspot.com/-siEMkijJ33w/X_as1EqQ7JI/AAAAAAAAETk/pmQ0eR31h_oeT8ONRhOIuBxlHPha93oxgCEwYBhgLKtQDAL1OcqxobF1wN1T7ePZR8syDu10paifExJiElT8TOFEyBU5AdVqZmJi8SyXHMJNoIvkZy1Bk5Ya8TYAVd07EwuNxUJBic7eJ7WBAAdwNtMEYcVp4qnNk-_ihpLoZupuNCG3Txyrj6K3VW2C4UB_AvxMk_4Z2rKZK9faQkco9ulNQJBksnqJvI5z4IPlrz-c8x0kHgfl6qcl0-0jv14qC64sUh8yAY9n37Ago4I0QsU2AUMhGUWy2p4kHUDGyM8b0ZFssEtXgD9Y_HUlMp3IiW6vTS1cDYTRWTWSdfYfXQ2R4daG74fhrTSSo9SPdscSBx83DBWZn8MMAA3gK7KwXiu4gODyZhfXRZBZN7VErNSfkfNd9bxSLH9FF9q5I_o9OrfVjQX0O0OBiA0IMe7mQn1V1tRhx2xjzAUAUx3MIuryQZO-8r-zsewmGP9G47GL3AOGH5ddK-op8ExrNkuae_MeKM_QaCd6r0Y_dwiTEkNauFdq6jiEkWbcTtuca1cNoVZ7QQRmEfvwF_iCWixbFAOvcoNHZVrkv2MHclH3zwvH68tdI3-sP8nbrqhhiYak_uqerMPFYl3h9_8BF6NFpjX7lQjy2ZYkuZIP20TAV5MuaPSH7MMDe2v8F/s1280/awesome%2Bbeautiful%2Bgirl%2Bimage%2Bfor%2Bprofile%2Bpicture.jpg';

                          if (stream.streamingPhoto != null &&
                              stream.streamingPhoto.isNotEmpty) {
                            photo = stream.streamingPhoto;
                          } else if (stream.streamer.photoURL != null &&
                              stream.streamer.photoURL.isNotEmpty) {
                            photo = stream.streamer.photoURL;
                          }
                          return Stack(
                            children: [
                              Card(
                                elevation: 0,
                                shadowColor: Colors.grey,
                                child: new GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            LiveStreaming(
                                          stream,
                                          streamingId: stream.docId,
                                          role: ClientRole.Audience,
                                          joinedUser: obj.userModel,
                                          callType: stream.type,
                                          channelName: stream.channelName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        photo,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${Random().nextInt(100)}.${Random().nextInt(10)}K",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        stream.streamer.name ??
                                            stream.streamer.name ??
                                            "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// @dart=2.9

import 'dart:convert';
import 'package:http/http.dart' as http;

class Token {
  int uid;
  String token;
  Token({this.uid, this.token});
  Token.fromMap(Map<String, dynamic> map) {
    this.token = map['token'];
    this.uid = map['uid'];
  }
}

Future<Token> getToken(String channelName, bool isPublisher) async {
  var apiUrl =
      'https://us-central1-adalee-b8ac5.cloudfunctions.net/getAgoraToken';
  var response = await http.post(Uri.parse(apiUrl),
      body: {'channel': channelName, 'isPublisher': '$isPublisher'});
  if (response.statusCode == 200) {
    return Token.fromMap(json.decode(response.body));
  }
  return null;
}

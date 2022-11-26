// @dart=2.9

class LiveVideoModel {
  String name;
  String uid;
  int videoId;
  LiveVideoModel(this.name, this.uid, this.videoId);
  LiveVideoModel.fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
    this.uid = map['uid'];
    this.videoId = map['videoId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'uid': this.uid,
      'videoId': this.videoId,
    };
  }
}

// @dart=2.9

class ChatModel {
  String id;
  String userID;
  List<ChatHistory> chatHistory;

  ChatModel({
    this.id,
    this.userID,
    this.chatHistory,
  });
}

class ChatHistory {
  String userId;
  String message;
  DateTime time;
  String type;
  ChatHistory({
    this.userId,
    this.message,
    this.time,
    this.type,
  });
}

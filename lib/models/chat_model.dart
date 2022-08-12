import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  int? id;
  String? username;
  int? status;
  String? userpic;
  DateTime? lastOnline;
  DateTime? sentAt;
  String message;
  String senderID;
  String receiverID;
  String chatID;
  int isSeen;

  ChatModel({
    this.id,
    this.username,
    this.status,
    this.userpic,
    this.lastOnline,
    this.sentAt,
    required this.chatID,
    required this.message,
    required this.senderID,
    required this.receiverID,
    required this.isSeen,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        username: json["username"],
        status: json["status"],
        userpic: json["user_pic"],
        lastOnline: DateTime.tryParse(json["last_online"]),
        sentAt: DateTime.tryParse(json["sent_at"]),
        message: json["message"],
        senderID: json["sender_id"],
        receiverID: json["receiver_id"],
        chatID: json["chat_id"],
        isSeen: json["is_seen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "status": status,
        "user_pic": userpic,
        "last_online": lastOnline,
        "sent_at": sentAt,
        "message": message,
        "sender_id": senderID,
        "receiver_id": receiverID,
        "chat_id": chatID,
        "is_seen": isSeen,
      };
}

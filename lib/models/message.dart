import 'dart:convert';
import 'dart:ffi';

Message chatModelFromJson(String str) => Message.fromJson(json.decode(str));

String chatModelToJson(Message data) => json.encode(data.toJson());

class Message {
  int? id;
  DateTime? sentAt;
  String message;
  String senderID;
  String receiverID;
  String chatID;
  bool isDivider;
  int isSeen;

  Message({
    this.id,
    this.sentAt,
    this.isDivider = false,
    required this.chatID,
    required this.message,
    required this.senderID,
    required this.receiverID,
    required this.isSeen,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        sentAt: DateTime.tryParse(json["sent_at"]),
        message: json["message"],
        senderID: json["sender_id"],
        receiverID: json["receiver_id"],
        chatID: json["chat_id"],
        isSeen: json["is_seen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sent_at": sentAt,
        "message": message,
        "sender_id": senderID,
        "receiver_id": receiverID,
        "chat_id": chatID,
        "is_seen": isSeen,
      };
}

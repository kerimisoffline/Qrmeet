import 'dart:convert';

Message chatModelFromJson(String str) => Message.fromJson(json.decode(str));

String chatModelToJson(Message data) => json.encode(data.toJson());

class Message {
  int? id;
  DateTime? sentAt;
  String message;
  String senderID;
  String receiverID;
  String chatID;

  Message({
    this.id,
    this.sentAt,
    required this.chatID,
    required this.message,
    required this.senderID,
    required this.receiverID,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        sentAt: DateTime.tryParse(json["sent_at"]),
        message: json["message"],
        senderID: json["sender_id"],
        receiverID: json["receiver_id"],
        chatID: json["chat_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sent_at": sentAt,
        "message": message,
        "sender_id": senderID,
        "receiver_id": receiverID,
        "chat_id": chatID,
      };
}

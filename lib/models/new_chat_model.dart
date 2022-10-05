class NewChatId {
  String chatId;
  NewChatId({
    required this.chatId,
  });

  factory NewChatId.fromJson(Map<String, dynamic> json) {
    return NewChatId(
      chatId: json["chat_id"],
    );
  }
}
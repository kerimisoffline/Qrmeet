import 'dart:convert';

import 'package:qrmeet/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/models/message.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatChannelController extends GetxController {
  dynamic argumentData = Get.arguments;
  var channelChatId = "".obs;
  var mainUserId = "".obs;
  var friendUserId = "".obs;
  late Socket socketIO;
  final _messages = <Message>[].obs;
  final _isLoading = true.obs;

  void fetchSocket(String chatID) {
    try {
      debugPrint('mesaj cihaza geldi $chatID');

      socketIO = io(
          'http://89.252.153.250:8081/',
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setQuery({'chatID': chatID})
              .build());

      /*
      socketIO = io("http://89.252.153.250:8081/", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
        "chatID": chatID,
      });
      */

      socketIO.connect();

      socketIO.on('receive_message', (jsonData) {
        debugPrint('mesaj cihaza geldi $jsonData');
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(jsonData));
        _messages.add(Message(
            chatID: data['chatID'],
            sentAt: DateTime.tryParse(data['sentAt']),
            message: data['content'],
            senderID: data['senderChatID'],
            receiverID: data['receiverChatID']));
      });
    } catch (e) {
      print(e);
    }
  }

  void fetchMessageChannel(String chatID) async {
    try {
      _isLoading.value = true;
      var sources = await HttpServices.fetchMessageChannel(chatID);
      if (sources != null) {
        _isLoading.value = false;
        _messages.clear();
        _messages.value = sources;
      } else {
        _isLoading.value = false;
      }
    } catch (err) {
      _isLoading.value = false;
      debugPrint('Caught error: $err');
    }
  }

  void sendMessage(String text, String myChatId, String receiverChatID) {
    Message msg = Message(
        chatID: channelChatId.value,
        message: text,
        senderID: myChatId,
        receiverID: receiverChatID,
        sentAt: DateTime.now());

    _messages.add(msg);
    debugPrint('mesaj cihaza gönderildi $text');
    socketIO.emit('send_message', {
      'chatID': channelChatId.value,
      'receiverChatID': receiverChatID,
      'senderChatID': myChatId,
      'content': text,
    });
    postNewMessage(msg);
  }

  void postNewMessage(Message message) async {
    try {
      var sources = await HttpServices.postNewMessage(message);
      if (sources != null) {
        debugPrint('Message send success: $sources');
      }
    } catch (err) {
      debugPrint('Caught error postNew Message: $err');
    }
  }

  @override
  void onInit() {
    channelChatId.value = argumentData[0]['channelChatId'];
    mainUserId.value = argumentData[1]['mainUserId'];
    friendUserId.value = argumentData[2]['friendUserId'];
    if (argumentData[0]['channelChatId'] != "") {
      fetchMessageChannel(argumentData[0]['channelChatId']);
      fetchSocket(argumentData[0]['channelChatId']);
    }
    super.onInit();
  }

  @override
  void dispose() {
    socketIO.disconnect();
    super.dispose();
  }
}

class ChatChannel extends StatelessWidget {
  final ChatChannelController chatPageController =
      Get.put(ChatChannelController());
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatChannel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Chat Screen'),
            backgroundColor: Colors.blue),
        body: Obx(
          () => SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        reverse:
                            chatPageController._messages.isEmpty ? false : true,
                        itemCount: 1,
                        shrinkWrap: false,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 3),
                            child: Column(
                              mainAxisAlignment:
                                  chatPageController._messages.isEmpty
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: chatPageController._messages
                                        .map((message) {
                                      print(message.message);
                                      return ChatBubble(
                                        date: DateTime.now(),
                                        message: message.message,
                                        isMe: message.senderID ==
                                            chatPageController.mainUserId.value,
                                      );
                                    }).toList()),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        bottom: 10, left: 20, right: 10, top: 5),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 5,
                            controller: _messageController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration.collapsed(
                              hintText: "Type a message",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 43,
                          width: 42,
                          child: FloatingActionButton(
                            backgroundColor: Colors.blue,
                            onPressed: () async {
                              if (_messageController.text.trim().isNotEmpty) {
                                String message = _messageController.text.trim();
                                chatPageController.sendMessage(
                                    message,
                                    chatPageController.mainUserId.value,
                                    chatPageController.friendUserId.value);
                                _messageController.clear();
                              }
                            },
                            mini: true,
                            child: Transform.rotate(
                                angle: 5.79449,
                                child: const Icon(Icons.send, size: 20)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final DateTime date;

  ChatBubble({
    required this.message,
    this.isMe = true,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            constraints: BoxConstraints(maxWidth: size.width * .5),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFE3D8FF) : const Color(0xFFFFFFFF),
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(11),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                      bottomLeft: Radius.circular(0),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style:
                      const TextStyle(color: Color(0xFF2E1963), fontSize: 14),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      "$date",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Color(0xFF594097), fontSize: 9),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

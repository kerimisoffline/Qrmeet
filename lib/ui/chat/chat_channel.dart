import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:qrmeet/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrmeet/models/message.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:qrmeet/utils/converter.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qrmeet/utils/get_screensize.dart';

class ChatChannelController extends GetxController {
  dynamic argumentData = Get.arguments;
  var chatBubbleIsSeen = false.obs;
  var channelChatId = "".obs;
  var mainUserId = "".obs;
  var friendUserId = "".obs;
  var friendUserPic = "".obs;
  var friendUserName = "".obs;
  var friendUserLastSeen = "".obs;

  late Socket socketIO;
  final _messages = <Message>[].obs;
  final _isLoading = true.obs;

  void fetchSocket(String chatID) {
    try {
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
        Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(jsonData));
        _messages.add(Message(
          id: data['messageID'],
          chatID: data['chatID'],
          sentAt: DateTime.tryParse(data['sentAt'])!.toLocal(),
          message: data['content'],
          senderID: data['senderChatID'],
          receiverID: data['receiverChatID'],
          isSeen: 1,
        ));
        socketIO.emit('sendStatus', {});
      });

      socketIO.on('getStatus', (jsonData) {
        debugPrint("mesaj görüldü");
        debugPrint("seen status " + _messages.last.message);
        chatBubbleIsSeen.value = true;
        fetchMessageSeenStatus(channelChatId.value);
        /* 
            for(var i=0;i<_messages.length;i++){
              if(_messages[i].id==data['seenMessageID']){
                _messages[i].isSeen = 1;
                debugPrint("mesaj görülmesi değişti");
              }
            } 
              */
      });
    } catch (e) {
      //
    }
  }

  void fetchMessageSeenStatus(String chatID) async {
    try {
      await HttpServices.fetchMessageSeenStatus(chatID, mainUserId.value);
    } catch (err) {
      //
    }
  }

  void fetchChatFriendInfo(
      String userpic, String userName, String lastSeen) async {
    friendUserPic.value = userpic;
    friendUserName.value = userName;
    friendUserLastSeen.value = lastSeen;
  }

  void fetchMessageChannel(String chatID) async {
    try {
      _isLoading.value = true;
      var sources = await HttpServices.fetchMessageChannel(chatID);
      if (sources != null) {
        _isLoading.value = false;
        _messages.clear();
        Message? tempMsg;
        var tempSource = sources.reversed;
        for (Message msg in tempSource) {
          if (tempMsg != null) {
            var tempDate = msg.sentAt!.subtract(const Duration(days: 1));
            if (tempMsg.sentAt!.isBefore(tempDate) ||
                _messages.last.sentAt!.toLocal().day !=
                    msg.sentAt!.toLocal().day) {
              var newMsg = Message(
                  sentAt: msg.sentAt,
                  chatID: msg.chatID,
                  message: msg.message,
                  receiverID: msg.receiverID,
                  senderID: msg.senderID,
                  id: msg.id,
                  isDivider: true,
                  isSeen: msg.isSeen);
              _messages.add(newMsg);
            }
          }
          tempMsg = msg;
          _messages.add(msg);
        }
        //_messages.value = sources;
      } else {
        _isLoading.value = false;
      }
    } catch (err) {
      _isLoading.value = false;
    }
  }

  void sendMessage(String text, String myChatId, String receiverChatID) {
    Message msg = Message(
        chatID: channelChatId.value,
        message: text,
        senderID: myChatId,
        receiverID: receiverChatID,
        isSeen: 0,
        sentAt: DateTime.now().toLocal());

    if (_messages.isNotEmpty) {
      var tempDate = msg.sentAt!.subtract(const Duration(days: 1));
      if (_messages.last.sentAt!.isBefore(tempDate) ||
          _messages.last.sentAt!.toLocal().day != msg.sentAt!.toLocal().day) {
        var newMsg = Message(
            sentAt: msg.sentAt,
            chatID: msg.chatID,
            message: msg.message,
            receiverID: msg.receiverID,
            senderID: msg.senderID,
            id: msg.id,
            isDivider: true,
            isSeen: msg.isSeen);
        _messages.add(newMsg);
      }
    }

    _messages.add(msg);
    socketIO.emit('send_message', {
      'chatID': channelChatId.value,
      'receiverChatID': receiverChatID,
      'senderChatID': myChatId,
      'content': text,
    });
    chatBubbleIsSeen.value = false;
    postNewMessage(msg);
  }

  static Future<Message?> postNewMessage(Message message) async {
    try {
      var sources = await HttpServices.postNewMessage(message);
      return sources;
    } catch (err) {
      return null;
    }
  }

  @override
  void onInit() {
    channelChatId.value = argumentData[0]['channelChatId'];
    mainUserId.value = argumentData[1]['mainUserId'];
    friendUserId.value = argumentData[2]['friendUserId'];
    if (argumentData[0]['channelChatId'] != "") {
      fetchChatFriendInfo(
          argumentData[3]['friendUserPic'],
          argumentData[4]['friendUserName'],
          argumentData[5]['friendUserLastSeen']);
      fetchMessageSeenStatus(argumentData[0]['channelChatId']);
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
  final LandingController landingController = Get.find();
  ChatChannel({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        landingController
            .fetchChatList(int.parse(chatPageController.mainUserId.value));
        Get.back();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
              leading: BackButton(
                  onPressed: () => {
                        landingController.fetchChatList(
                            int.parse(chatPageController.mainUserId.value)),
                        Get.back()
                      }),
              centerTitle: true,
              title: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.dynamicWidth(0.03),
                    vertical: context.dynamicHeight(0.001)),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundImage: NetworkImage(
                            chatPageController.friendUserPic.value),
                        backgroundColor: const Color.fromRGBO(0, 0, 0, 0)),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            chatPageController.friendUserName.value,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: context.dynamicWidth(0.05),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal),
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: context.dynamicWidth(0.5),
                                child: Text(
                                    chatPageController.friendUserLastSeen.value,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: context.dynamicWidth(0.04),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                          reverse: chatPageController._messages.isEmpty
                              ? false
                              : true,
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
                                        return ChatBubble(
                                          date: message.isDivider
                                              ? message.sentAt!
                                                      .toLocal()
                                                      .isToday()
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .today
                                                  : message.sentAt!
                                                          .toLocal()
                                                          .isYesterday()
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .yesterday
                                                      : DateFormat(
                                                              "d MMMM",
                                                              Localizations
                                                                      .localeOf(
                                                                          context)
                                                                  .toString())
                                                          .format(
                                                              message.sentAt!)
                                              : DateFormat.Hm().format(
                                                  message.sentAt!.toLocal()),
                                          message: message.message,
                                          isMe: message.senderID ==
                                              chatPageController
                                                  .mainUserId.value,
                                          isDivider: message.isDivider,
                                          isSeen: message.isSeen,
                                        );
                                      }).toList()),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1.5,
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
                              decoration: InputDecoration.collapsed(
                                hintText:
                                    AppLocalizations.of(context)!.type_message,
                                hintStyle: const TextStyle(
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
                                  String message =
                                      _messageController.text.trim();
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
          )),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String date;
  final bool isDivider;
  final int isSeen;

  ChatBubble({
    required this.message,
    this.isMe = true,
    required this.date,
    required this.isDivider,
    required this.isSeen,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: isDivider ? dividerContainer(date) : messageContainer(size));
  }

  Widget dividerContainer(String date) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(date)]);
  }

  Widget messageContainer(Size size) {
    ChatChannelController chController = Get.find();
    return Column(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          constraints: BoxConstraints(maxWidth: size.width * .5),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFFE3D8FF) : const Color(0xFFe8e7d5),
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
                style: const TextStyle(color: Color(0xFF2E1963), fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    date,
                    textAlign: TextAlign.end,
                    style:
                        const TextStyle(color: Color(0xFF594097), fontSize: 9),
                  ),
                  Visibility(
                      visible: isMe,
                      child: SizedBox(
                        width: size.width * .05,
                        height: size.height * .04,
                        child: IconButton(
                            onPressed: null,
                            icon: Icon(
                              isSeen == 1 || chController.chatBubbleIsSeen.value
                                  ? Icons.done_all
                                  : Icons.done,
                              size: 16,
                            )),
                      ))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

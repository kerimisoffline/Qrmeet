import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qrmeet/main.dart';
import 'package:qrmeet/models/chat_model.dart';
import 'package:qrmeet/services/http_services.dart';
import 'package:qrmeet/models/user.dart';
import 'package:qrmeet/ui/chat/chat_channel.dart';
import 'package:qrmeet/utils/get_screensize.dart';
import 'package:qrmeet/ui/landing/landing_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:qrmeet/utils/converter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPage extends StatelessWidget {
  final LandingController _landingController = Get.find();

  ChatPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
        child: chatPageView(context, _landingController.chatList,
            _landingController.mainUser)));
  }
}

Widget chatPageView(
    BuildContext context, List<ChatModel> chatList, User mainUser) {
  return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: ((BuildContext context, int index) =>
          chatPageItem(context, chatList[index], mainUser)));
}

Widget chatPageItem(BuildContext context, ChatModel chatUser, User mainUser) {
  bool isTickVisible = chatUser.senderID == mainUser.id.toString() ? true : false;
  return InkWell(
    onTap: () => {
      
      Get.to(() => ChatChannel(), arguments: [
        {"channelChatId": chatUser.chatID},
        {"mainUserId": mainUser.id.toString()},
        {"friendUserId": chatUser.id.toString()},
        {"friendUserPic": chatUser.userpic.toString()},
        {"friendUserName": chatUser.username.toString()},
        {"friendUserLastSeen": 
        chatUser.lastOnline!.toLocal().isToday()
                      ? AppLocalizations.of(context)!.today
                      : chatUser.lastOnline!.toLocal().isYesterday()
                          ? AppLocalizations.of(context)!.yesterday
                          : DateFormat("d MMMM",
                                  Localizations.localeOf(context).toString())
                              .format(chatUser.lastOnline!.toLocal()).toString() + " " +
        DateFormat.Hm().format(chatUser.lastOnline!.toLocal()).toString()}
      ])
    },
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.dynamicWidth(0.03),
          vertical: context.dynamicHeight(0.001)),
      child: Row(
        children: [
          CircleAvatar(
              backgroundImage: NetworkImage(chatUser.userpic!),
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chatUser.username!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: context.dynamicWidth(0.05),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: context.dynamicWidth(0.12),
                      child: Text(DateFormat.Hm().format(chatUser.sentAt!.toLocal()),
                          style: TextStyle(
                              color: (chatUser.isSeen == 1 || chatUser.senderID == mainUser.id.toString())
                                  ? Colors.grey
                                  : Colors.black,
                              fontSize: context.dynamicWidth(0.04),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.dynamicWidth(0.05)),
                      child: SizedBox(
                        width: context.dynamicWidth(0.5),
                        child: Text(chatUser.message,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: (chatUser.isSeen == 1 || chatUser.senderID == mainUser.id.toString())
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: context.dynamicWidth(0.04),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.normal)),
                      ),
                    ),
                    Visibility(
                      visible: isTickVisible,
                      child: SizedBox(
                        width: context.dynamicWidth(0.05),
                        child: IconButton(onPressed: null, icon: Icon(chatUser.isSeen == 0 ? Icons.done : Icons.done_all))),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

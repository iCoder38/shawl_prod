// import 'package:anamak_two/classes/headers/utils/utils.dart';
// import 'package:anamak_two/classes/public_chat_room/public_room_chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:my_new_orange/classes/all_chat_list/all_chats_list.dart';
// import 'package:my_new_orange/classes/public_chat/public_room_chats.dart';
// import 'package:my_new_orange/header/utils/Utils.dart';
// import 'package:shaawl/classes/headers/utils/utils.dart';
// import 'package:shaawl/classes/tabbar/chat/all_chat_list/all_chats_list.dart';
// import 'package:shaawl/classes/tabbar/chat/public_chat_room/public_room_header/public_chat_room_chats/public_room_chats.dart';
// import 'package:shaawl/classes/tabbar/chat/public_chat_room/public_room_header/public_room_header.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:shawl_prod/classes/public_chat_dialog/all_chats_list.dart';
import 'package:shawl_prod/classes/public_chat_room/public_room_chats.dart';

import '../Utils/utils.dart';

class PublicChatRoomScreen extends StatefulWidget {
  const PublicChatRoomScreen(
      {super.key,
      required this.strSenderName,
      required this.strSenderChatId,
      required this.strSenderGender});

  final String strSenderName;
  final String strSenderChatId;
  final String strSenderGender;

  @override
  State<PublicChatRoomScreen> createState() => _PublicChatRoomScreenState();
}

class _PublicChatRoomScreenState extends State<PublicChatRoomScreen> {
  //
  final formGlobalKey = GlobalKey<FormState>();
  ScrollController controller = ScrollController();
  //
  TextEditingController contTextSendMessage = TextEditingController();
  //

  @override
  void initState() {
    super.initState();
    /*******************************************/
    /*******************************************/
    if (kDebugMode) {
      print(widget.strSenderName);
    }
    if (kDebugMode) {
      print(widget.strSenderChatId);
    }
    /*******************************************/
    /*******************************************/

    //
    // controller.jumpTo(controller.position.maxScrollExtent);
    //
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: textWithBoldStyle(
            'Public Room',
            Colors.black,
            18.0,
          ),
          leading: SizedBox(
            height: 40,
            width: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeoPopButton(
                color: navigationColor,
                // onTapUp: () => HapticFeedback.vibrate(),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                onTapUp: () {
                  //
                  popupExitPublicGroup(context, 'Exit public chat ?');
                  // Navigator.pop(context);
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                // width: 50,
                child: NeoPopButton(
                  color: navigationColor,
                  // onTapUp: () => HapticFeedback.vibrate(),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  onTapUp: () {
                    //
                    FocusScope.of(context).requestFocus(FocusNode());
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllChatsListScreen(
                            str_dialog_login_user_chat_id:
                                widget.strSenderChatId),
                      ),
                    );
                    //
                  },
                  onTapDown: () => HapticFeedback.vibrate(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: textWithRegularStyle(
                          'All Chats',
                          Colors.black,
                          14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: navigationColor,
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                // ======> ALL CHATS LIST <======
                // ========================
                PublicChatRoomChats(
                  strLoginSenderChatIdForPublic:
                      widget.strSenderChatId.toString(),
                  strLoginSenderNameForPublic: widget.strSenderName.toString(),
                ),
                // ========================
                // ========================

                // ======> SEND MESSAGE UI <======
                // ========================
                Align(
                  alignment: Alignment.bottomCenter,
                  child: sendMessageUI(),
                ),
                // ========================
                // ========================
                //
              ],
            ),

            // ======> SECOND TAB <======
            // ========================
            // textWithRegularStyle('all chatts', Colors.black, 14.0)
            AllChatsListScreen(
              str_dialog_login_user_chat_id: widget.strSenderChatId,
              // str_dialog_login_user_gender: 'g',
            ),
            // ========================
            // ========================
          ],
        ),
      ),
    );
  }

  Container sendMessageUI() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      // height: 60,
      // width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                controller: contTextSendMessage,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  // border: Border(),
                  // labelText: '',
                  hintText: 'write something',
                ),
              ),
            ),
          ),
          //
          SizedBox(
            height: 50,
            width: 50,
            child: NeoPopButton(
              color: navigationColor,
              // onTapUp: () => HapticFeedback.vibrate(),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              onTapUp: () {
                //
                sendMessageViaFirebase(contTextSendMessage.text);
                contTextSendMessage.text = '';
                //
              },
              onTapDown: () => HapticFeedback.vibrate(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          //
          const SizedBox(
            width: 10,
            height: 10,
          ),
          //
        ],
      ),
    );
  }

  //
  // send message
  sendMessageViaFirebase(strLastMessageEntered) {
    // print(cont_txt_send_message.text);
    // setState(() {});
    // controller.animateTo(

    // controller.animateTo(
    //   controller.position.maxScrollExtent + 300,
    //   duration: const Duration(
    //     milliseconds: 200,
    //   ),
    //   curve: Curves.easeInOut,
    // );

    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}message/India/public_chats',
    );

    users
        .add(
          {
            'sender_chat_user_id': widget.strSenderChatId.toString(),
            'sender_name': widget.strSenderName.toString(),
            'sender_gender': widget.strSenderGender.toString(),
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'message': strLastMessageEntered.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'public',
            'type': 'text_message',
          },
        )
        .then(
          (value) => print(
              "Message send successfully. Message id is =====> ${value.id}"),
          // func_scroll_to_bottom(),

          // func_check_scrolling(),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }
  //
}

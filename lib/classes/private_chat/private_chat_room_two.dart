// import 'package:anamak_two/classes/headers/custom/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

import '../Utils/utils.dart';

// import '../headers/utils/utils.dart';
// import 'package:my_new_orange/header/utils/Utils.dart';
// import 'package:my_new_orange/header/utils/custom/app_bar.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:my_new_orange/header/utils/Utils.dart';

class PrivateChatScreenTwo extends StatefulWidget {
  const PrivateChatScreenTwo(
      {super.key,
      required this.strSenderName,
      required this.strReceiverName,
      required this.strReceiverFirebaseId,
      required this.strSenderChatId,
      required this.strReceiverChatId});

  // sender
  final String strSenderChatId;
  final String strSenderName;

  // receiver
  final String strReceiverName;
  final String strReceiverFirebaseId;
  final String strReceiverChatId;

  @override
  State<PrivateChatScreenTwo> createState() => _PrivateChatScreenTwoState();
}

class _PrivateChatScreenTwoState extends State<PrivateChatScreenTwo> {
  //
  bool _needsScroll = false;
  final ScrollController _scrollController = ScrollController();
  //
  TextEditingController contTextSendMessage = TextEditingController();
  //
  int _currentItem = 0;
  var strScrollOnlyOneTime = '1';
  //
  var roomId;
  var reverseRoomId;
  var lastMessage = '';
  //
  @override
  void initState() {
    super.initState();

    // print(FirebaseAuth.instance.currentUser!.uid);
    if (kDebugMode) {
      print('SENDER CHAT ID =====>${widget.strSenderChatId}');
      print('SENDER NAME =====>${widget.strSenderName}');
      print('SENDER RECEIVER NAME =====>${widget.strReceiverName}');
      print('SENDER RECEIVER FID =====>${widget.strReceiverFirebaseId}');
      print('SENDER RECEIVER CHAT ID =====>${widget.strReceiverChatId}');
    }
    //
    roomId = '${widget.strSenderChatId}+${widget.strReceiverChatId}';
    reverseRoomId = '${widget.strReceiverChatId}+${widget.strSenderChatId}';

    if (kDebugMode) {
      print(roomId);
      print(reverseRoomId);
    }

    //
  }

  //
  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithBoldStyle(
          'Private',
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
                Navigator.pop(context);
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
        backgroundColor: navigationColor,
      ),
      body: GestureDetector(
        onTap: () {
          // keyboard dismiss when click outside
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 0, bottom: 60),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(
                        "${strFirebaseMode}message/India/private_chats",
                      )
                      .orderBy('time_stamp', descending: true)
                      .where(
                        'room_id',
                        whereIn: [
                          roomId,
                          reverseRoomId,
                        ],
                      )
                      .limit(40)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (kDebugMode) {
                        print('=====> YES, DATA');
                      }
                      //
                      if (strScrollOnlyOneTime == '1') {
                        _needsScroll = true;
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _scrollToEnd());
                      }
                      //

                      var getSnapShopValue =
                          snapshot.data!.docs.reversed.toList();
                      if (kDebugMode) {
                        // print(getSnapShopValue);
                      }
                      return Stack(
                        children: [
                          if (strScrollOnlyOneTime == '1') ...[
                            const SizedBox(
                              height: 0,
                            )
                          ] else ...[
                            Align(
                              alignment: Alignment.topCenter,
                              child: InkWell(
                                onTap: () {
                                  _needsScroll = true;
                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => _scrollToEnd());
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  width: 120,
                                  height: 40,
                                  child: Center(
                                    child: textWithSemiBoldStyle(
                                      'New message',
                                      14.0,
                                      Colors.black,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      250,
                                      247,
                                      247,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      14.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                          0,
                                          3,
                                        ), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          ListView.builder(
                            // controller: controller,
                            controller: _scrollController,
                            itemCount: getSnapShopValue.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(
                                  left: 14,
                                  right: 14,
                                  //
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Align(
                                  alignment: (getSnapShopValue[index]
                                                  ['sender_firebase_id']
                                              .toString() ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Alignment.topRight
                                      : Alignment.topLeft),
                                  child: (getSnapShopValue[index]
                                                  ['sender_firebase_id']
                                              .toString() ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? senderUI(getSnapShopValue, index)
                                      : receiverUI(getSnapShopValue, index),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      // return Center(
                      //   child: Text(
                      //     'Error: ${snapshot.error}',
                      //   ),

                      // );
                      if (kDebugMode) {
                        print(snapshot.error);
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            //
            // ======> SEND MESSAGE UI <======
            // ===============================
            Align(
              alignment: Alignment.bottomCenter,
              child: sendMessageUI(),
            ),
            // ================================
            // ================================
            //
          ],
        ),
      ),
    );
  }

  //
//  Column receiverUI() {
  Column receiverUI(getSnapshot, int index) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.only(
              right: 40,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  16,
                ),
                bottomRight: Radius.circular(
                  16,
                ),
                topRight: Radius.circular(
                  16,
                ),
              ),
              color: Colors.blue[200],
            ),
            padding: const EdgeInsets.all(
              16,
            ),
            child: textWithRegularStyleLeft(
              getSnapshot[index]['message'].toString(),
              14.0,
              Colors.black,
              'left',
            ),
          ),
        ),
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: textWithRegularStyleLeft(
            // getSnapshot[index]['time_stamp'].toString(),
            // '123',
            funcConvertTimeStampToDateAndTime(
              getSnapshot[index]['time_stamp'],
            ),
            12.0,
            Colors.black,
            'left',
          ),
        ),
        //
      ],
    );
  }

  //
  // Column senderUI() {
  Column senderUI(getSnapshot, int index) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.only(
              left: 40,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  16,
                ),
                bottomLeft: Radius.circular(
                  16,
                ),
                topRight: Radius.circular(
                  16,
                ),
              ),
              color: navigationColor,
            ),
            padding: const EdgeInsets.all(
              16,
            ),
            child: textWithRegularStyleLeft(
              //
              getSnapshot[index]['message'].toString(),
              //
              16.0,
              Colors.black,
              'right',
            ),
            // Text(
            //   //
            //   'a',
            //   // getSnapshot[index]['message'].toString(),
            //   //
            //   style: const TextStyle(
            //     fontSize: 15,
            //   ),
            // ),
          ),
        ),
        //
        Align(
          alignment: Alignment.bottomRight,
          child: textWithRegularStyleLeft(
            // getSnapshot[index]['time_stamp'].toString(),
            // '123',
            funcConvertTimeStampToDateAndTime(
              getSnapshot[index]['time_stamp'],
            ),
            12.0,
            Colors.black,
            'right',
          ),
        ),
        //
      ],
    );
  }

  //
  Container sendMessageUI() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color.fromARGB(
        255,
        60,
        182,
        195,
      ),
      // height: 60,
      // width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: contTextSendMessage,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  // labelText: '',
                  hintText: 'write something',
                ),
              ),
            ),
          ),
          //
          IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('send');
              }
              //

              sendMessageViaFirebase(contTextSendMessage.text);
              lastMessage = contTextSendMessage.text.toString();
              contTextSendMessage.text = '';

              // }
            },
            icon: const Icon(
              Icons.send,
            ),
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

    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}message/India/private_chats',
    );

    /*
    if (kDebugMode) {
      print('SENDER CHAT ID =====>${widget.strSenderChatId}');
      print('SENDER NAME =====>${widget.strSenderName}');
      print('SENDER RECEIVER NAME =====>${widget.strReceiverName}');
      print('SENDER RECEIVER FID =====>${widget.strReceiverFirebaseId}');
      print('SENDER RECEIVER CHAT ID =====>${widget.strReceiverChatId}');
    }
    */

    users
        .add(
          {
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'sender_chat_user_id': widget.strSenderChatId,
            'sender_name': widget.strSenderName,
            'receiver_name': widget.strReceiverName,
            'receiver_firebase_id': widget.strReceiverFirebaseId,
            'receiver_chat_user_id': widget.strReceiverChatId,
            'message': strLastMessageEntered.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'private',
            'type': 'text_message',

            // save room id
            'room_id': roomId.toString(),
            'users': [
              roomId,
              reverseRoomId,
            ]
          },
        )
        .then(
          (value) =>
              //
              funcCheckUsersIsAlreadyChatWithEachOther(),
          //
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  //
  funcCheckUsersIsAlreadyChatWithEachOther() {
    if (kDebugMode) {
      print('bottle');
    }
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .where(
          "users",
          arrayContainsAny: [roomId, reverseRoomId],
        )
        .get()
        .then(
          (value) {
            if (kDebugMode) {
              print(value.docs.length);
            }

            if (value.docs.isEmpty) {
              if (kDebugMode) {
                print('======> NO, DIALOG NOT CREATED <======');
              }

              //
              funcCreateDialog();
              //
            } else {
              if (kDebugMode) {
                print('===> YES, THEY ALREADY CHATTED <===');
              }
              for (var element in value.docs) {
                if (kDebugMode) {
                  print(element.id);
                }
                //
                funcEditDialogWithTimeStamp(element.id);
                return;
              }
              //
              //
              //
            }
          },
        );
  }

  //
  funcCreateDialog() {
    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}dialog/India/details',
    );
    /*
    if (kDebugMode) {
      print('SENDER CHAT ID =====>${widget.strSenderChatId}');
      print('SENDER NAME =====>${widget.strSenderName}');
      print('SENDER RECEIVER NAME =====>${widget.strReceiverName}');
      print('SENDER RECEIVER FID =====>${widget.strReceiverFirebaseId}');
      print('SENDER RECEIVER CHAT ID =====>${widget.strReceiverChatId}');
    }
    */
    users
        .add(
          {
            // sender
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'sender_name': widget.strSenderName,
            'sender_chat_user_id': widget.strSenderChatId,
            //time stamp
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            //receiver
            'receiver_name': widget.strReceiverName,
            'receiver_firebase_id': widget.strReceiverFirebaseId,
            'receiver_chat_user_id': widget.strReceiverChatId,
            'message': lastMessage,
            'users': [
              roomId,
              reverseRoomId,
            ],
            'match': [
              widget.strSenderChatId,
              widget.strReceiverChatId,
            ]
          },
        )
        .then(
          (value) => print("==> DIALOG CREATED SUCCESSFULLY ==> ${value.id}"),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  // UPDATE DIALOG AFTER SEND MESSAGE
  funcEditDialogWithTimeStamp(
    elementWithId,
  ) {
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}dialog')
        .doc('India')
        .collection('details')
        .doc(elementWithId.toString())
        .set(
      {
        'time_stamp': DateTime.now().millisecondsSinceEpoch,
        'message': lastMessage,
      },
      SetOptions(merge: true),
    ).then(
      (value) {
        if (kDebugMode) {
          print('value 1.0');
        }
        //
        // setState(() {
        // strSetLoader = '1';
        // });
        //
      },
    );
  }
}

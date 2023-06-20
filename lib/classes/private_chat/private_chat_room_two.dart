// import 'package:anamak_two/classes/headers/custom/app_bar.dart';
// import 'dart:js_interop';

// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:shawl_prod/classes/private_chat/private_chat_image_accept.dart/private_chat_image_accept.dart';
import 'package:shawl_prod/classes/private_chat/private_chat_image_decline/private_chat_image_decline.dart';
import 'package:shawl_prod/classes/private_chat/private_chat_receiver/private_chat_receiver_image_accept/private_chat_receiver_image_accept.dart';
import 'package:shawl_prod/classes/private_chat/private_chat_setting/private_chat_settings.dart';

import '../Utils/utils.dart';
import 'private_chat_receiver/private_chat_receiver_image_decline/private_chat_receiver_image_decline.dart';

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
  var str_image_processing = '0';
  File? imageFile;
  bool? strAppBarPermissionStatus;
  bool light = false;
  //
  bool _needsScroll = false;
  final ScrollController _scrollController = ScrollController();
  //
  TextEditingController contTextSendMessage = TextEditingController();
  //
  // int _currentItem = 0;
  var strScrollOnlyOneTime = '1';
  //
  var roomId;
  var reverseRoomId;
  var lastMessage = '';
  //
  var loginUserFirebaseId = '';
  var arrSaveOnlyYesData = [];
  var strHideSwitch = '0';
  var strSaveDialogFirestoreId = '';
  var strImagePermissionStatus = '0';
  var arrSaveImagePermissionDataInArray = [];
  //
  @override
  void initState() {
    super.initState();

    // print(FirebaseAuth.instance.currentUser!.uid);
    if (kDebugMode) {
      print('SENDER CHAT ID =====>${widget.strSenderChatId}');
      print('SENDER NAME =====>${widget.strSenderName}');
      print('SENDER RECEIVER NAME =====>${widget.strReceiverName}');
      print(
          'SENDER FIREBASE ID =====>${FirebaseAuth.instance.currentUser!.uid}');
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
    // funcDummy();
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
        backgroundColor: navigationColor,
        actions: [
          //
          appBarActionSettingUI(),
          //
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // keyboard dismiss when click outside
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          //
        },
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 0, bottom: 60),
              child:
                  // showPrivateChatUI(),
                  StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('${strFirebaseMode}dialog')
                    .doc('India')
                    .collection('details')
                    .orderBy('time_stamp', descending: true)
                    .where('users', arrayContainsAny: [
                  roomId,
                  reverseRoomId,
                ]).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot2) {
                  if (snapshot2.hasData) {
                    // if (kDebugMode) {

                    var saveSnapshotValue2 = snapshot2.data!.docs;
                    //
                    if (kDebugMode) {
                      // print('VEDICA');
                      // print(snapshot2.hasData);

                      // print('rajputana rifle');
                      // print(snapshot2.data!.docs.length);
                      // print(saveSnapshotValue2[0]['image_permission'].length);
                    }
                    // GET DATA WHEN IMAGE PERMISSION IS NOT EMPTY
                    if (snapshot2.data!.docs.isNotEmpty) {
                      //
                      (snapshot2.data!.docs.isEmpty)
                          ? const SizedBox(
                              height: 0,
                            )
                          :
                          // save firestore id
                          strSaveDialogFirestoreId =
                              '${saveSnapshotValue2[0]['firestoreId']}';
                      //
                      if (saveSnapshotValue2[0]['image_permission'].length ==
                          0) {
                        if (kDebugMode) {
                          // print('0');
                        }
                      } else if (saveSnapshotValue2[0]['image_permission']
                              .length ==
                          1) {
                        // save firestore id

                        // }
                      } else {
                        strImagePermissionStatus = saveSnapshotValue2[0]
                                ['image_permission']
                            .length
                            .toString();
                        //
                        if (kDebugMode) {
                          // print('PERMISSION FIREBASE IDs ====>'
                          //     " ${saveSnapshotValue2[0]['image_permission']}");
                          // print('PERMISSION FIREBASE LENGTH ====>'
                          //     " ${saveSnapshotValue2[0]['image_permission'].length}");
                          // print(
                          // 'IMAGE PERMISSION STATUS IS =====> $strImagePermissionStatus');
                          // print(
                          // 'DIALOG FIREBSTORE ID =====> ${saveSnapshotValue2[0]['firestoreId']}');
                          // print(snapshot2.data!.docs.length);
                        }
                      }

                      //
                    }
                    //
                    return showPrivateChatUI();
                    //
                  } else if (snapshot2.hasError) {
                    if (kDebugMode) {
                      print(snapshot2.error);
                    }
                    return Center(
                      child: Text('Error: ${snapshot2.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              //
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
            (str_image_processing == '1')
                ? Container(
                    // margin: const EdgeInsets.all(10.0),
                    color: const Color.fromRGBO(
                      246,
                      248,
                      253,
                      1,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 48.0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: navigationColor,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          textWithRegularStyle(
                            'processing...',
                            Colors.black,
                            14.0,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> appBarActionSettingUI() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('${strFirebaseMode}dialog')
          .doc('India')
          .collection('details')
          .orderBy('time_stamp', descending: true)
          .where('users', arrayContainsAny: [
        roomId,
        reverseRoomId,
      ]).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
        if (snapshot2.hasData) {
          // if (kDebugMode) {

          var saveSnapshotValue2 = snapshot2.data!.docs;

          // GET DATA WHEN IMAGE PERMISSION IS NOT EMPTY
          if (snapshot2.data!.docs.isNotEmpty) {
            //
            (snapshot2.data!.docs.isEmpty)
                ? const SizedBox(
                    height: 0,
                  )
                :
                // save firestore id
                strSaveDialogFirestoreId =
                    '${saveSnapshotValue2[0]['firestoreId']}';
            //
          }
          //
          return (strSaveDialogFirestoreId == '')
              ? const SizedBox(
                  height: 0,
                )
              : IconButton(
                  onPressed: () {
                    //
                    pushToChatSettings(
                      context,
                      saveSnapshotValue2[0]['image_permission'],
                    );
                    //
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                );
          //
        } else if (snapshot2.hasError) {
          if (kDebugMode) {
            print(snapshot2.error);
          }
          return Center(
            child: Text('Error: ${snapshot2.error}'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> showPrivateChatUI() {
    return StreamBuilder(
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
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (kDebugMode) {
            print('=====> YES, DATA');
          }
          //
          if (strScrollOnlyOneTime == '1') {
            _needsScroll = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
          }
          //

          var getSnapShopValue = snapshot.data!.docs.reversed.toList();
          if (kDebugMode) {
            // print(getSnapShopValue);
          }
          //
          return oneToOneChatUI(getSnapShopValue);
          //
        } else if (snapshot.hasError) {
          if (kDebugMode) {
            print(
              'Error =========> ${snapshot.error}',
            );
          }
          if (kDebugMode) {
            print(snapshot.error);
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Stack oneToOneChatUI(List<QueryDocumentSnapshot<Object?>> getSnapShopValue) {
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
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToEnd());
              },
              child: Container(
                margin: const EdgeInsets.all(10.0),
                width: 120,
                height: 40,
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
                child: Center(
                  child: textWithSemiBoldStyle(
                    'New message',
                    14.0,
                    Colors.black,
                  ),
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
                alignment:
                    (getSnapShopValue[index]['sender_firebase_id'].toString() ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? Alignment.topRight
                        : Alignment.topLeft),
                child: Column(
                  children: [
                    if (getSnapShopValue[index]['sender_firebase_id']
                            .toString() ==
                        FirebaseAuth.instance.currentUser!.uid) ...[
                      // sender UI
                      senderUI(getSnapShopValue, index)
                      //
                    ] else ...[
                      // receiver UI
                      receiverUI(getSnapShopValue, index),
                    ],
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  //
//  Column receiverUI() {
  Column receiverUI(getSnapshot, int index) {
    return Column(
      children: [
        //
        if (getSnapshot[index]['type'].toString() ==
            'image_permission_accept') ...[
          //
          PrivateChatReceiverImageAcceptScreen(
            privateChatReceiverImageAccept: getSnapshot[index],
          ),
          //
        ] else if (getSnapshot[index]['type'].toString() ==
            'image_permission_decline') ...[
          //
          PrivateChatReceiverImageDeclineScreen(
            privateChatReceiverImageDecline: getSnapshot[index],
          ),
          //
        ] else ...[
          (getSnapshot[index]['attachment_path'].toString() != '')
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      child: Image.network(
                        getSnapshot[index]['attachment_path'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Align(
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
                      //
                      getSnapshot[index]['message'].toString(),
                      //
                      14.0,
                      Colors.black,
                      'left',
                    ),
                  ),
                ),
        ],

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
        if (getSnapshot[index]['type'].toString() ==
            'image_permission_accept') ...[
          //
          PrivateChatImageAcceptScreen(
              getPrivateChatDataAccept: getSnapshot[index]),
          //
        ] else if (getSnapshot[index]['type'].toString() ==
            'image_permission_decline') ...[
          //
          PrivateChatImageDeclineScreen(
              getPrivateChatDataDecline: getSnapshot[index]),
          //
        ] else ...[
          (getSnapshot[index]['attachment_path'].toString() != '')
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      child: Image.network(
                        getSnapshot[index]['attachment_path'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              :
              //
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
                  ),
                ),
        ],

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
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('${strFirebaseMode}dialog')
                .doc('India')
                .collection('details')
                .where('users', arrayContainsAny: [
              roomId,
              reverseRoomId,
            ]).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
              if (snapshot2.hasData) {
                // if (kDebugMode) {

                var saveSnapshotValue2 = snapshot2.data!.docs;

                if (saveSnapshotValue2.isEmpty) {
                  if (kDebugMode) {
                    print(saveSnapshotValue2);
                    print('=======> DATA IS EMPTY, DO NOT SHOW SHARE <======');
                  }
                } else {
                  //
                  var arrImagePermissionParse = [];
                  var switchImagePermission = false;
                  //
                  arrImagePermissionParse =
                      saveSnapshotValue2[0]['image_permission'];
                  if (kDebugMode) {
                    // print('=======> SYSTEM TO SHARE IMAGE <======');
                    // print(arrImagePermissionParse[0]);

                    // print(arrImagePermissionParse.length);
                    // print('=======================================');
                  }

                  if (arrImagePermissionParse.isEmpty) {
                    const SizedBox(
                      height: 0,
                    );
                  } else if (arrImagePermissionParse.length == 1) {
                    if (kDebugMode) {
                      print('LOTS OF WORK TO DO');
                      print(
                          '=====> RECEIVER ID : ${saveSnapshotValue2[0]['receiver_firebase_id']}');
                      print(
                          '=====> SENDER ID : ${saveSnapshotValue2[0]['sender_firebase_id']}');
                    }
                    //
                    for (int i = 0; i < arrImagePermissionParse.length; i++) {
                      if (arrImagePermissionParse[i].toString() ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        // show receiver's end share button
                        if (kDebugMode) {
                          print("RECEIVER'S END");
                        }
                      } else {
                        // show sender's end share button
                        if (kDebugMode) {
                          print("SENDER'S END");
                        }
                        //
                        /*return IconButton(
                          onPressed: () {
                            //

                            //
                          },
                          icon: const Icon(
                            Icons.share,
                            color: Colors.black,
                          ),
                        );*/
                        //
                      }
                    }
                  } else {
                    // 2
                    return IconButton(
                      onPressed: () {
                        //
                        openGalleryOrCamera(context);
                        //
                      },
                      icon: const Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                    );
                  }

                  /*for (int i = 0; i < arrImagePermissionParse.length; i++) {
                  if (arrImagePermissionParse[i].toString() ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    if (kDebugMode) {
                      print('YES I AM AVAILAIBLE');
                    }
                    //
                    switchImagePermission = true;
                    //
                  } else {
                    //
                    switchImagePermission = false;
                    //
                  }
                }*/
                }

                //
                //
                return const SizedBox(
                  height: 0,
                );
                /*(switchImagePermission == false)
                    ? const SizedBox(
                        height: 0,
                      )
                    : IconButton(
                        onPressed: () {
                          //

                          //
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                      );*/
                //
              } else if (snapshot2.hasError) {
                if (kDebugMode) {
                  print(snapshot2.error);
                }
                return Center(
                  child: Text('Error: ${snapshot2.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              );
            },
          ),
          //
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
              //
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
            'attachment_path': '',
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
    setState(() {
      str_image_processing = '0';
    });
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}dialog")
        .doc("India")
        .collection("details")
        .where(
          "users",
          arrayContainsAny: [
            roomId,
            reverseRoomId,
          ],
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
                  print('DIALOG FIRESTORE ID =====> ${element.id}');
                }
                //
                funcEditDialogWithTimeStamp(element.id);
                // return;
              }
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
            'firestoreId': '0',
            'image_permission': [],

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
          (value) => funcEditDialogAndCreateFirestoreId(value.id),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  // SET FIRESTORE ID WHEN NEW DIALOG CREATE
  funcEditDialogAndCreateFirestoreId(elementWithId) {
    //
    strSaveDialogFirestoreId = elementWithId.toString();
    //
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}dialog')
        .doc('India')
        .collection('details')
        .doc(elementWithId.toString())
        .set(
      {
        'firestoreId': elementWithId,
        // 'dialog_permissions_users': [
        //   roomId,
        //   reverseRoomId,
        // ],
      },
      SetOptions(merge: true),
    ).then(
      (value) {
        if (kDebugMode) {
          print('value 1.0');
        }
        //
        //
      },
    );
  }

  //
  funcSetUpMyAccountForAllAccess(firestoreId) {
    //
    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}dialog_permissions/India/details',
    );

    users
        .add(
          {
            'dialog_permissions_users': [
              roomId,
              reverseRoomId,
            ],
          },
        )
        .then(
          (value) => print(
              '''============================================================
              \n1. DIALOG CREATED 
              \n2. FIRESTORE ID INSERTED 
              \n3. DIALOG PERMISSION CREATED 
              \n============================================================'''),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
    //
  }
  //

  // UPDATE DIALOG AFTER SEND MESSAGE
  funcEditDialogWithTimeStamp(
    elementWithId,
  ) {
    //
    strSaveDialogFirestoreId = elementWithId.toString();
    //
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
        // funcAddMyFirebaseIdToDialogImagePermission('1');
        //
      },
    );
  }

  //
  //
  sendMessageForPermission(strLastMessageEntered, imagePermission) {
    // print(cont_txt_send_message.text);

    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}message/India/private_chats',
    );

    users
        .add(
          {
            'attachment_path': '',
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'sender_chat_user_id': widget.strSenderChatId,
            'sender_name': widget.strSenderName,
            'receiver_name': widget.strReceiverName,
            'receiver_firebase_id': widget.strReceiverFirebaseId,
            'receiver_chat_user_id': widget.strReceiverChatId,
            'message': ''.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'private',
            'type': imagePermission.toString(),

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
  //
  funcGivePermissionAlertMessage(status, strMessage) {
    //
    if (kDebugMode) {
      print('HIDE SWITCH =====> $strHideSwitch');
    }
    /*if (status == '1') {
      sendMessageForPermission(
        'You can share image with me now.',
        'image_permission_accept',
      );
    } else if (status == '2') {
      sendMessageForPermission(
        'You can not share image with me now.',
        'image_permission_decline',
      );
      funcAddMyFirebaseIdToDialogImagePermission('2');
    } else {
      //
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: navigationColor,
          content: textWithBoldStyle(
            //
            strMessage.toString(),
            //
            Colors.white,
            14.0,
          ),
        ),
      );
    }*/
  }

  // update data for switch status
  funcAddMyFirebaseIdToDialogImagePermission(switchStatus) {
    if (switchStatus == '1') {
      if (kDebugMode) {
        print('add my firebase id');
        print(strSaveDialogFirestoreId);
      }
      //
      FirebaseFirestore.instance
          .collection('${strFirebaseMode}dialog')
          .doc('India')
          .collection('details')
          .doc(strSaveDialogFirestoreId.toString())
          .update(
        {
          'image_permission': FieldValue.arrayUnion(
            [FirebaseAuth.instance.currentUser!.uid.toString()],
          )
        },
      );
      //
    } else {
      if (kDebugMode) {
        print('remove my firebase id');
      }
    }
  }

  //
  Future<void> pushToChatSettings(
    BuildContext context,
    imagePermissionData,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivateChatSettingsScreen(
          strFirestoreId: strSaveDialogFirestoreId.toString(),
          arrImagePermission: '',
        ),
      ),
    );

    if (kDebugMode) {
      print('result =====> ' + result);
    }

    if (!mounted) return;

    if (result != '0') {
      setState(() {
        if (kDebugMode) {
          print('====> YEAH REFRESH AFTER POP FROM SETTINGS');
        }
      });
    }
  }

  //
  //
  void openGalleryOrCamera(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Camera option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.camera,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  print('camera');
                  imageFile = File(pickedFile.path);
                });
                //
                str_image_processing = '1';
                //
                uploadImageToFirebase(context);
                //

                //
              }
            },
            child: textWithRegularStyle(
              'Open camera',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );

              if (pickedFile != null) {
                setState(() {
                  if (kDebugMode) {
                    print('gallery');
                  }
                  imageFile = File(pickedFile.path);
                });

                str_image_processing = '1';
                uploadImageToFirebase(context);
              }
            },
            child: textWithRegularStyle(
              'Open gallery',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: textWithRegularStyle(
              'Dismiss',
              Colors.redAccent,
              16.0,
            ),
          ),
        ],
      ),
    );
  }

  //
  // upload image via firebase
  Future uploadImageToFirebase(BuildContext context) async {
    if (kDebugMode) {
      print('dishu');
    }
    // String fileName = basename(imageFile_for_profile!.path);
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child(
          'private_chat/${FirebaseAuth.instance.currentUser!.uid}',
        )
        .child(
          generateRandomString(10),
        );
    await storageRef.putFile(imageFile!);
    return await storageRef.getDownloadURL().then((value) => {
          // print(
          //   '======>$value',
          // )
          sendImageForPermission(value),
        });
  }

  //
  sendImageForPermission(
    strAttachmentPath,
  ) {
    lastMessage = '';
    // print(cont_txt_send_message.text);

    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}message/India/private_chats',
    );

    users
        .add(
          {
            'attachment_path': strAttachmentPath,
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'sender_chat_user_id': widget.strSenderChatId,
            'sender_name': widget.strSenderName,
            'receiver_name': widget.strReceiverName,
            'receiver_firebase_id': widget.strReceiverFirebaseId,
            'receiver_chat_user_id': widget.strReceiverChatId,
            'message': ''.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'private',
            'type': 'image'.toString(),

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
  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
    // below statement will generate a random string of length using the characters
    // and length provided to it
    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString; // return the generated string
  }
  //
}

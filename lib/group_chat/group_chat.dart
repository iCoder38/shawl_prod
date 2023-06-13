// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

import '../classes/Utils/utils.dart';
import '../classes/group_chat/group_chat_details_edit/group_chat_details.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// import '../controllers/database/database_helper.dart';
// import '../header/utils.dart';
// import 'group_chat_details/group_chat_details.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key, this.chatDialogData});

  final chatDialogData;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  //
  // late DataBase handler;
  //
  var strImageLoader = '0';
  var strFriendLoader = '0';
  var strLoginUserName = '';
  var strLoginUserId = '';
  var strLoginUserFirebaseId = '';
  var strloginUserImage = '';
  //
  var strScrollOnlyOneTime = '0';
  var lastMessage = '';
  //
  File? imageFile;
  var str_image_processing = '0';
  //
  bool _needsScroll = false;
  final ScrollController _scrollController = ScrollController();
  //
  TextEditingController contTextSendMessage = TextEditingController();
  //
  var strGroupName = '';
  var strDisableTextField = '1';
  //
  @override
  void initState() {
    if (kDebugMode) {
      print('**************** CHAT DATA ***************************');
      print(widget.chatDialogData);
      print('*******************************************************');
    }
    super.initState();
    //
    strGroupName = widget.chatDialogData['group_name'].toString();
    //
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            (widget.chatDialogData['group_display_image'].toString() == '')
                ? Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: GestureDetector(
                          onTap: () {
                            // print('click 1');
                            //
                            pushToChatDetails(context);
                            //
                          },
                          child: Image.asset(
                            'assets/images/logo.png',
                          ),
                        ),
                      ),
                      //
                      const SizedBox(
                        width: 5,
                      ),
                      //
                      textWithRegularStyle(
                        //
                        strGroupName,
                        //
                        Colors.white,
                        16.0,
                      )
                      //
                    ],
                  )
                : Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              print('click 1');
                              //
                              pushToChatDetails(context);
                              //
                            },
                            child: Image.network(
                              widget.chatDialogData['group_display_image']
                                  .toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      //
                      const SizedBox(
                        width: 10,
                      ),
                      //
                      textWithRegularStyle(
                        //
                        strGroupName,
                        //
                        Colors.white,
                        16.0,
                      )
                      //
                    ],
                  ),
          ],
        ),
        backgroundColor: navigationColor,
        actions: [
          (strImageLoader == '0')
              ? SizedBox(
                  height: 0,
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 80,
                        color: Colors.amber,
                        child: LinearProgressIndicator(),
                      ),
                      //
                      textWithRegularStyle('processing...', Colors.black, 12.0)
                    ],
                  ),
                )
        ],
      ),
      //
      backgroundColor: appDesertColor,
      //
      body: Stack(
        children: [
          Container(
            color: Colors.transparent,
            margin: const EdgeInsets.only(top: 0, bottom: 60),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('${strFirebaseMode}groups')
                  .doc('India')
                  .collection('details')
                  .orderBy('time_stamp', descending: true)
                  .where('group_id',
                      isEqualTo: widget.chatDialogData['group_id'].toString())
                  .where('match', arrayContainsAny: [
                //
                FirebaseAuth.instance.currentUser!.uid,
                //
              ]).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (kDebugMode) {
                    print('=============== DIALOG DATA IN CHAT ==============');
                    print(snapshot);
                    print(snapshot.data!);
                    print(snapshot.data!.docs[0]['group_name']);

                    print(snapshot.data!.docs.length);
                    print('======================================');
                  }
                  //
                  strGroupName = snapshot.data!.docs[0]['group_name'];
                  //

                  var saveSnapshotValue = snapshot.data!.docs;
                  if (kDebugMode) {
                    print('=============== DIALOG ==============');
                    print(saveSnapshotValue);
                    print('======================================');
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    // setState(() {
                    strDisableTextField = '0';
                    // });
                  }
                  return (snapshot.data!.docs.isEmpty)
                      ? AlertDialog(
                          backgroundColor: Colors.redAccent,
                          title: textWithBoldStyle(
                            'Alert',
                            Colors.white,
                            18.0,
                          ),
                          content: textWithRegularStyle(
                            'You are no longer the member of this group. Please contact admin for more info.',
                            Colors.white,
                            14.0,
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: textWithBoldStyle(
                                'Ok',
                                Colors.white,
                                18.0,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.grey,
                            ),
                            controller: _scrollController,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(
                                        "${strFirebaseMode}group_messages/${widget.chatDialogData['group_id'].toString()}/details",
                                      )
                                      .orderBy('time_stamp', descending: true)
                                      .limit(40)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      if (kDebugMode) {
                                        print('=====> YES, DATA');
                                      }
                                      //
                                      // if (strScrollOnlyOneTime == '1') {
                                      // if (kDebugMode) {
                                      // print('=====> YES, DATA 2');
                                      // }
                                      _needsScroll = true;
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                              (_) => _scrollToEnd());
                                      // }
                                      //

                                      var getSnapShopValue =
                                          snapshot.data!.docs.reversed.toList();
                                      // if (kDebugMode) {
                                      // print(getSnapShopValue);
                                      // }
                                      return Stack(
                                        children: [
                                          // if (strImageLoader == '1') ...[
                                          //   SizedBox(
                                          //     height: 0,
                                          //   )
                                          // ] else ...[
                                          //   imageProcessingLoaderUI(),
                                          // ],
                                          ListView.builder(
                                            // controller: _scrollController,
                                            itemCount: getSnapShopValue.length,
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                            ),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return
                                                  // (strImageLoader == '0')
                                                  //     ? imageProcessingLoaderUI()
                                                  //     :
                                                  Container(
                                                padding: const EdgeInsets.only(
                                                  left: 14,
                                                  right: 14,
                                                  //
                                                  top: 10,
                                                  bottom: 10,
                                                ),
                                                child: Align(
                                                    alignment: (getSnapShopValue[index][
                                                                    'sender_firebase_id']
                                                                .toString() ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? Alignment.topRight
                                                        : Alignment.topLeft),
                                                    child: (getSnapShopValue[index]
                                                                    [
                                                                    'sender_firebase_id']
                                                                .toString() ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                        ? senderUI(
                                                            getSnapShopValue, index)
                                                        : receiverUI(
                                                            getSnapShopValue,
                                                            index) //receiverUI(getSnapShopValue, index),
                                                    ),
                                              );
                                            },
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      //
                                      if (kDebugMode) {
                                        print(snapshot.error);
                                      }
                                      //
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                            },
                          ),
                        );
                } else if (snapshot.hasError) {
                  if (kDebugMode) {
                    print(snapshot.error);
                  }
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          //
          // ======> SEND MESSAGE UI <======
          // ===============================
          (strDisableTextField == '0')
              ? const SizedBox(
                  height: 40,
                )
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: sendMessageUI(),
                ),
          // ================================
          // ================================
          //
        ],
      ),
    );
  }

  Align imageProcessingLoaderUI() {
    return Align(
      alignment: Alignment.topCenter,
      child: InkWell(
        onTap: () {
          // _needsScroll = true;
          // WidgetsBinding.instance
          //     .addPostFrameCallback(
          //         (_) =>
          //             _scrollToEnd());
        },
        child: Container(
          margin: const EdgeInsets.all(
            10.0,
          ),
          width: 160,
          height: 40,
          child: Center(
            child: textWithRegularStyle(
              'processing...',
              Colors.black,
              14.0,
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
    );
  }

//
//  Column receiverUI() {
  Column receiverUI(getSnapshot, int index) {
    return Column(
      children: [
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: textWithRegularStyle(
            //
            getSnapshot[index]['sender_name'],
            //
            Colors.black,
            10.0,
          ),
        ),
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: (getSnapshot[index]['message'].toString() == '')
              ? Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: 240,
                  height: 240,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                    child: Image.network(
                      getSnapshot[index]['attachment_path'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(
                    right: 40,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
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
                    color: Colors.lightBlueAccent,
                  ),
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: textWithRegularStyle(
                    getSnapshot[index]['message'].toString(),
                    Colors.black,
                    16.0,
                  ),
                ),
        ),
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: textWithRegularStyle(
            funcConvertTimeStampToDateAndTime(
              getSnapshot[index]['time_stamp'],
            ),
            Colors.black,
            12.0,
          ),
        ),
      ],
    );
  }

// Column senderUI() {
  Column senderUI(getSnapshot, int index) {
    return Column(
      children: [
        //
        Align(
          alignment: Alignment.bottomRight,
          child: textWithRegularStyle(
            //
            getSnapshot[index]['sender_name'],
            //
            Colors.black,
            10.0,
          ),
        ),
        //
        Align(
          alignment: Alignment.bottomRight,
          child: (getSnapshot[index]['message'].toString() == '')
              ? Container(
                  margin: const EdgeInsets.all(10.0),
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(
                      24.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      24,
                    ),
                    child: Image.network(
                      getSnapshot[index]['attachment_path'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(
                    left: 40,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
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
                    color: Color.fromARGB(255, 228, 232, 235),
                  ),
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  child: textWithRegularStyle(
                    getSnapshot[index]['message'].toString(),
                    Colors.black,
                    16.0,
                  ),
                ),
        ),
        //
        Align(
          alignment: Alignment.bottomRight,
          child: textWithRegularStyle(
            funcConvertTimeStampToDateAndTime(
              getSnapshot[index]['time_stamp'],
            ),
            Colors.black,
            10.0,
          ),
        ),
        //
      ],
    );
  }

  //
  //
  Container sendMessageUI() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: NeoPopButton(
                color: navigationColor,
                // onTapUp: () => HapticFeedback.vibrate(),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                onTapUp: () {
                  //
                  openGalleryOrCamera(context);
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.attachment,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
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

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: NeoPopButton(
                color: navigationColor,
                // onTapUp: () => HapticFeedback.vibrate(),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                onTapUp: () {
                  //
                  (contTextSendMessage.text == '')
                      ? SizedBox(
                          height: 0,
                        )
                      : (strDisableTextField == '0')
                          ? contTextSendMessage.text = ''
                          : sendMessageViaFirebase(contTextSendMessage.text);
                  lastMessage = contTextSendMessage.text.toString();
                  contTextSendMessage.text = '';
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*IconButton(
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
          ),*/
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
      '${strFirebaseMode}group_messages/${widget.chatDialogData['group_id'].toString()}/details',
    );

    users
        .add(
          {
            'sender_name': strLoginUserName.toString(),
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'message': strLastMessageEntered.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'group',
            'type': 'text_message',
            'chat_members': ''
          },
        )
        .then(
          (value) =>
              //
              funcEditMessageAndInsertFirestoreId(value.id),
          //
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

//
  funcEditMessageAndInsertFirestoreId(value2) {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}message")
        .doc(widget.chatDialogData['group_id'].toString())
        .collection('details')
        .doc(value2)
        .set(
      {
        'firestore_id': value2.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value1) => funcUpdateDialog(value2),
    );
  }

  //
  funcUpdateDialog(elementId) {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc('India')
        .collection('details')
        //.doc('07f4b2bb-3213-4e3d-85bc-e5645863036e')
        .where('group_id',
            isEqualTo: widget.chatDialogData['group_id'].toString())
        .get()
        .then(
          (value) => {
            if (value.docs.isEmpty)
              {
                if (kDebugMode)
                  {
                    print('======> NO USER FOUND'),
                  }
                // ADD THIS USER TO FIREBASE SERVER

                //
              }
            else
              {
                for (var element in value.docs)
                  {
                    // EDIT USER IF IT ALREADY EXIST
                    funcEditDialog(element.id)
                    //
                  }
              }
          },
        );
  }

  //
  funcEditDialog(elementId) {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc("India")
        .collection("details")
        .doc(elementId)
        .set(
      {
        'time_stamp': DateTime.now().millisecondsSinceEpoch,
        'last_message': lastMessage.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value1) => print(''),
    );
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
                  //
                  strImageLoader = '1';
                  //
                  str_image_processing = '1';
                  print('camera');
                  imageFile = File(pickedFile.path);
                });
                //

                //
                uploadImageToFirebase(context);
                //

                //
              }
            },
            child: textWithRegularStyle('Open Camera', Colors.black, 14.0),
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
                  //
                  strImageLoader = '1';
                  //
                  if (kDebugMode) {
                    print('gallery');
                  }
                  imageFile = File(pickedFile.path);
                });
                str_image_processing = '1';
                uploadImageToFirebase(context);
              }
            },
            child: textWithRegularStyle('Open Gallery', Colors.black, 14.0),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: textWithRegularStyle('Dismiss', Colors.black, 14.0),
          ),
        ],
      ),
    );
  }

  //
  // upload image via firebase
  Future uploadImageToFirebase(BuildContext context) async {
    if (kDebugMode) {
      print('=====> CREATING IMAGE URL <=====');
    }

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
          sendImagViaMessageForGroupChat(value),
        });
  }

  sendImagViaMessageForGroupChat(attachmentPath) {
    // print(cont_txt_send_message.text);

    setState(() {
      strImageLoader = '0';
    });
    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}group_messages/${widget.chatDialogData['group_id'].toString()}/details',
    );

    users
        .add(
          {
            'attachment_path': attachmentPath.toString(),
            'sender_name': strLoginUserName.toString(),
            'sender_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'message': ''.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'group',
            'type': 'image',
            'chat_members': ''
          },
        )
        .then(
          (value) =>
              //
              // strScrollOnlyOneTime = '',

              funcEditMessageAndInsertFirestoreId(value.id),
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
  Future<void> pushToChatDetails(BuildContext context) async {
    //
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupChatDetailsScreen(
            dictGetDataForDetails: widget.chatDialogData,
          ),
        ));

    if (!mounted) return;
    //
    if (result == 'ok') {
      print(result);
      setState(() {
        print('=====> update UI');
        // strGroupName = result;
      });
      // funcGetLocalDBdata();
    }
  }

  funcRemoved() {
    // Navigator.pop(context);
    /*QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: 'message'.toString(),
    );*/
    //
  }
}

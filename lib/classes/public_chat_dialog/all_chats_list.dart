// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

import '../Utils/utils.dart';
import '../private_chat/private_chat_room_two.dart';
// import 'package:my_new_orange/classes/private_chat/private_chat_room_two.dart';
// import 'package:my_new_orange/header/utils/Utils.dart';
// import 'package:shaawl/classes/headers/utils/utils.dart';
// import 'package:shaawl/classes/models/chat_user_model.dart';

class AllChatsListScreen extends StatefulWidget {
  const AllChatsListScreen(
      {super.key, required this.str_dialog_login_user_chat_id});

  final String str_dialog_login_user_chat_id;

  @override
  State<AllChatsListScreen> createState() => _AllChatsListScreenState();
}

class _AllChatsListScreenState extends State<AllChatsListScreen> {
  //

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Dialog',
          Colors.black,
          18.0,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: navigationColor,
        leading: SizedBox(
          height: 40,
          width: 120,
          // color: Colors.amber,
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
                    Icons.arrow_back,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Text(
                    //   "",
                    //   style:
                    //       TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    // ),
                    /*Container(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.pink,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Add New",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )*/
                  ],
                ),
              ),
            ),
            //
            // Padding(
            //   padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: "Search...",
            //       hintStyle: TextStyle(color: Colors.grey.shade600),
            //       prefixIcon: Icon(
            //         Icons.search,
            //         color: Colors.grey.shade600,
            //         size: 20,
            //       ),
            //       filled: false,
            //       fillColor: Colors.grey.shade100,
            //       contentPadding: const EdgeInsets.all(8),
            //       enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(20),
            //           borderSide: BorderSide(color: Colors.grey.shade100)),
            //     ),
            //   ),
            // ),
            //

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('${strFirebaseMode}dialog')
                  .doc('India')
                  .collection('details')
                  .orderBy('time_stamp', descending: true)
                  .where('match', arrayContainsAny: [
                widget.str_dialog_login_user_chat_id,
                // '2'
              ]).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  //
                  var saveSnapshotValue = snapshot.data!.docs;
                  //
                  if (kDebugMode) {
                    print(snapshot.hasData);
                    print(widget.str_dialog_login_user_chat_id);
                    print(snapshot.data!.docs.length);
                    print(saveSnapshotValue);
                  }
                  //
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      for (int i = 0; i < saveSnapshotValue.length; i++) ...[
                        ListTile(
                          onTap: () {
                            //
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrivateChatScreenTwo(
                                  strSenderName: saveSnapshotValue[i]
                                          ['sender_name']
                                      .toString(),
                                  strReceiverName: saveSnapshotValue[i]
                                          ['receiver_name']
                                      .toString(),
                                  strReceiverFirebaseId: saveSnapshotValue[i]
                                          ['receiver_firebase_id']
                                      .toString(),
                                  strSenderChatId: saveSnapshotValue[i]
                                          ['sender_chat_user_id']
                                      .toString(),
                                  strReceiverChatId: saveSnapshotValue[i]
                                          ['receiver_chat_user_id']
                                      .toString(),
                                ),
                              ),
                            );
                            //
                          },
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=930&q=80'),
                            maxRadius: 30,
                          ),
                          //
                          title: (saveSnapshotValue[i]['sender_firebase_id']
                                      .toString() ==
                                  FirebaseAuth.instance.currentUser!.uid
                                      .toString())
                              ? textWithSemiBoldStyle(
                                  //
                                  // 'd',
                                  saveSnapshotValue[i]['receiver_name'],
                                  //
                                  16.0,
                                  Colors.black,
                                )
                              : textWithSemiBoldStyle(
                                  //
                                  // 'd',
                                  saveSnapshotValue[i]['sender_name'],
                                  //
                                  16.0,
                                  Colors.black,
                                ),

                          subtitle: SizedBox(
                            height: 40,
                            child: (saveSnapshotValue[i]['message']
                                        .toString() ==
                                    '')
                                ? Row(
                                    children: [
                                      const Icon(Icons.image),
                                      textWithRegularStyleLeft(
                                        //
                                        'image',
                                        //
                                        14.0,
                                        Colors.black,
                                        'left',
                                      ),
                                    ],
                                  )
                                : textWithRegularStyleLeft(
                                    //

                                    saveSnapshotValue[i]['message'].toString(),
                                    //
                                    14.0,
                                    Colors.black,
                                    'left',
                                  ),
                          ),

                          // dense: true,
                          // isThreeLine: true,

                          trailing: textWithRegularStyle(
                            funcConvertTimeStampToDateAndTime(
                              saveSnapshotValue[i]['time_stamp'],
                            ),
                            Colors.black,
                            14.0,
                          ),
                          /* Text(
                                  funcConvertTimeStampToDateAndTime(
                                    saveSnapshotValue[i]['time_stamp'],
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),*/
                        ),
                        /*InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrivateChatScreenTwo(
                                  strSenderName: saveSnapshotValue[i]
                                          ['sender_name']
                                      .toString(),
                                  strReceiverName: saveSnapshotValue[i]
                                          ['receiver_name']
                                      .toString(),
                                  strReceiverFirebaseId: saveSnapshotValue[i]
                                          ['receiver_firebase_id']
                                      .toString(),
                                  strSenderChatId: saveSnapshotValue[i]
                                          ['sender_chat_user_id']
                                      .toString(),
                                  strReceiverChatId: saveSnapshotValue[i]
                                          ['receiver_chat_user_id']
                                      .toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 100,
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      const CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=930&q=80'),
                                        maxRadius: 30,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              (saveSnapshotValue[i][
                                                              'sender_firebase_id']
                                                          .toString() ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                          .toString())
                                                  ? textWithSemiBoldStyle(
                                                      //
                                                      // 'd',
                                                      saveSnapshotValue[i]
                                                          ['receiver_name'],
                                                      //
                                                      16.0,
                                                      Colors.black,
                                                    )
                                                  : textWithSemiBoldStyle(
                                                      //
                                                      // 'd',
                                                      saveSnapshotValue[i]
                                                          ['sender_name'],
                                                      //
                                                      16.0,
                                                      Colors.black,
                                                    ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              //
                                              SizedBox(
                                                height: 50,
                                                child: textWithRegularStyleLeft(
                                                  //
                                                  // 'd',
                                                  saveSnapshotValue[i]
                                                          ['message']
                                                      .toString(),
                                                  //
                                                  16.0,
                                                  Colors.black,
                                                  'left',
                                                ),
                                              ),
                                              //
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  funcConvertTimeStampToDateAndTime(
                                    saveSnapshotValue[i]['time_stamp'],
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //
                        ),*/
                        //
                        Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          color: Colors.grey,
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          // child: widget
                        ),
                        //
                      ],
                    ],
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
          ],
        ),
      ),
    );
  }
}

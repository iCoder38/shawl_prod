// import 'package:anamak_two/classes/headers/utils/utils.dart';
// import 'package:anamak_two/classes/private_chat/private_chat_room_two.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../Utils/utils.dart';
// import 'package:my_new_orange/classes/private_chat/private_chat_room.dart';
// import 'package:my_new_orange/classes/private_chat/private_chat_room_two.dart';
// import 'package:my_new_orange/header/utils/Utils.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:shaawl/classes/headers/utils/utils.dart';

class PublicChatRoomChats extends StatefulWidget {
  const PublicChatRoomChats({
    super.key,
    required this.strLoginSenderChatIdForPublic,
    required this.strLoginSenderNameForPublic,
  });

  final String strLoginSenderChatIdForPublic;
  final String strLoginSenderNameForPublic;

  @override
  State<PublicChatRoomChats> createState() => _PublicChatRoomChatsState();
}

class _PublicChatRoomChatsState extends State<PublicChatRoomChats> {
  //
  // ScrollController controller = ScrollController();
  //
  bool _needsScroll = false;
  final ScrollController _scrollController = ScrollController();

  //
  int _currentItem = 0;
  var strScrollOnlyOneTime = '1';
  //
  @override
  void initState() {
    super.initState();
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
    return GestureDetector(
      onTap: () {
        // keyboard dismiss when click outside
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(top: 0, bottom: 60),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(
                  "${strFirebaseMode}message/India/public_chats",
                )
                .orderBy('time_stamp', descending: true)
                .limit(40)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                //
                if (kDebugMode) {
                  print('=======> dishant rajput 1.0');
                }
                if (strScrollOnlyOneTime == '1') {
                  _needsScroll = true;
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToEnd());
                }
                //

                if (kDebugMode) {
                  print('=======> dishant rajput 2.0');
                }

                var getSnapShopValue = snapshot.data!.docs.reversed.toList();
                if (kDebugMode) {
                  // print(getSnapShopValue);

                  if (kDebugMode) {
                    print('=======> dishant rajput 3.0');
                  }
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
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _scrollToEnd());
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
                        return VisibilityDetector(
                          key: Key(index.toString()),
                          onVisibilityChanged: (VisibilityInfo info) {
                            if (info.visibleFraction == 1) {
                              // setState(() {
                              if (kDebugMode) {
                                print(info);

                                print('=======> dishant rajput');
                              }

                              _currentItem = index;

                              // print("INDEX =====> $index");
                              // print("CURRENT INDEX =====> $_currentItem");
                              // print(
                              // "SERVER ARRAY INDEX =====> ${getSnapShopValue.length - 1}");

                              if (_currentItem == getSnapShopValue.length - 1) {
                                setState(() {
                                  strScrollOnlyOneTime = '1';
                                });
                              } else {
                                strScrollOnlyOneTime = '0';
                              }
                            }
                          },
                          child: Container(
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
                              child: leftSideUIOnlyForPublicChat(
                                  getSnapShopValue, index),
                              // (getSnapShopValue[index]['sender_firebase_id']
                              //             .toString() ==
                              //         FirebaseAuth.instance.currentUser!.uid)
                              //     ? senderUI(getSnapShopValue, index)
                              //     : receiverUI(index),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  Column leftSideUIOnlyForPublicChat(getSnapshotData, int index) {
    return Column(
      children: [
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              textWithSemiBoldStyle(
                //
                getSnapshotData[index]['sender_name'].toString(),
                //
                16.0,
                Colors.black,
                // 'right',
              ),
              //
              (getSnapshotData[index]['sender_firebase_id'].toString() ==
                      FirebaseAuth.instance.currentUser!.uid)
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print('=====> CHAT WITH OTHERS CLICK <=====');
                        }
                        //
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => PrivateChatScreenTwo(
                        //       strSenderName:
                        //           widget.strLoginSenderNameForPublic.toString(),
                        //       strReceiverName: getSnapshotData[index]
                        //               ['sender_name']
                        //           .toString(),
                        //       strReceiverFirebaseId: getSnapshotData[index]
                        //               ['sender_firebase_id']
                        //           .toString(),
                        //       strSenderChatId: widget
                        //           .strLoginSenderChatIdForPublic
                        //           .toString(),
                        //       strReceiverChatId: getSnapshotData[index]
                        //               ['sender_chat_user_id']
                        //           .toString(),
                        //     ),
                        //   ),
                        // );
                        //
                      },
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.purple,
                      ),
                    ),
            ],
            // 98061311374
            // 8800631774
          ),
        ),
        //
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
                bottomLeft: Radius.circular(
                  0,
                ),
                topRight: Radius.circular(
                  16,
                ),
                bottomRight: Radius.circular(
                  16,
                ),
              ),
              color: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.all(16),
            child: textWithRegularStyleLeft(
              //
              getSnapshotData[index]['message'].toString(),
              //
              16.0,
              Colors.black,
              'left',
            ),
          ),
        ),
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: textWithRegularStyleLeft(
            //
            funcConvertTimeStampToDateAndTime(
              getSnapshotData[index]['time_stamp'],
            ),
            //
            12.0,
            Colors.black,
            'left',
          ),
        ),
        //
      ],
    );
  }
}

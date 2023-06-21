// import 'package:anamak_two/classes/headers/utils/utils.dart';
// import 'package:anamak_two/classes/private_chat/private_chat_room_two.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shawl_prod/classes/private_chat/private_chat_room_two.dart';
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
  // bool _needsScroll = false;
  // final ScrollController _scrollController = ScrollController();

  final ScrollController scrollController = ScrollController();

  //
  int _currentItem = 0;
  var strScrollOnlyOneTime = '0';
  //
  @override
  void initState() {
    super.initState();
  }

  // _scrollToEnd() async {
  //   if (_needsScroll) {
  //     _needsScroll = false;
  //     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  //   }
  // }

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
              // WidgetsBinding.instance.addPostFrameCallback((_) {

              // });
              if (snapshot.hasData) {
                //

                //
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  scrollController.jumpTo(
                    scrollController.position.maxScrollExtent,
                  );
                });
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   scrollController.jumpTo(
                //     scrollController.position.maxScrollExtent,
                //     // duration: const Duration(seconds: 1),
                //     // curve: Curves.fastOutSlowIn,
                //   );
                // });
                // if (scrollController.hasClients) {
                //   scrollController
                //       .jumpTo(scrollController.position.maxScrollExtent);
                //   // setState(() {});
                // }
                //

                var getSnapShopValue = snapshot.data!.docs.reversed.toList();
                if (kDebugMode) {
                  // print(getSnapShopValue);
                }
                return Stack(
                  children: [
                    /*if (strScrollOnlyOneTime == '1') ...[
                      const SizedBox(
                        height: 0,
                      )
                    ] else ...[
                      Align(
                        alignment: Alignment.topCenter,
                        child: InkWell(
                          onTap: () {
                            // _needsScroll = true;
                            // WidgetsBinding.instance
                            // .addPostFrameCallback((_) => _scrollToEnd());
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
                    ],*/
                    ListView.builder(
                      // controller: controller,
                      controller: scrollController,
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
                          child: (getSnapShopValue[index]['sender_chat_user_id']
                                      .toString() ==
                                  widget.strLoginSenderChatIdForPublic)
                              ? rightSideUIOnlyForPublicChat(
                                  getSnapShopValue, index)
                              : leftSideUIOnlyForPublicChat(
                                  getSnapShopValue, index),
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
        // textWithRegularStyle('str', Colors.black, 12),
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              //
              GestureDetector(
                onTap: () {
                  //
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivateChatScreenTwo(
                        strSenderName:
                            widget.strLoginSenderNameForPublic.toString(),
                        strReceiverName:
                            getSnapshotData[index]['sender_name'].toString(),
                        strReceiverFirebaseId: getSnapshotData[index]
                                ['sender_firebase_id']
                            .toString(),
                        strSenderChatId:
                            widget.strLoginSenderChatIdForPublic.toString(),
                        strReceiverChatId: getSnapshotData[index]
                                ['sender_chat_user_id']
                            .toString(),
                      ),
                    ),
                  );
                  //
                },
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(
                      18.0,
                    ),
                  ),
                  child: (getSnapshotData[index]['sender_gender'].toString() ==
                          '0')
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                          child: Image.asset(
                            'assets/images/man.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                          child: Image.asset(
                            'assets/images/woman.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              //
              const SizedBox(
                width: 4,
              ),
              //
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 80),
                  // width: MediaQuery.of(context).size.width,
                  // color: Colors.amber,
                  child: GestureDetector(
                    onTap: () {
                      //
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivateChatScreenTwo(
                            strSenderName:
                                widget.strLoginSenderNameForPublic.toString(),
                            strReceiverName: getSnapshotData[index]
                                    ['sender_name']
                                .toString(),
                            strReceiverFirebaseId: getSnapshotData[index]
                                    ['sender_firebase_id']
                                .toString(),
                            strSenderChatId:
                                widget.strLoginSenderChatIdForPublic.toString(),
                            strReceiverChatId: getSnapshotData[index]
                                    ['sender_chat_user_id']
                                .toString(),
                          ),
                        ),
                      );
                      //
                    },
                    child: textWithSemiBoldStyle(
                      //
                      getSnapshotData[index]['sender_name'].toString(),
                      //
                      16.0,
                      Colors.black,
                      // 'right',
                    ),
                  ),
                ),
              ),
              //
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
              top: 4.0,
              // left: 10.0,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
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
              // color: Colors.grey.shade200,
              color: Color.fromRGBO(
                172,
                166,
                204,
                1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: textWithRegularStyleLeft(
              //
              getSnapshotData[index]['message'].toString(),
              //
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

  //
  Column rightSideUIOnlyForPublicChat(getSnapshotData, int index) {
    return Column(
      children: [
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
                bottomRight: Radius.circular(
                  0,
                ),
              ),
              // color: Color.fromARGB(255, 103, 167, 236),
              color: navigationColor,
            ),
            padding: const EdgeInsets.all(16),
            child: textWithRegularStyleLeft(
              //
              getSnapshotData[index]['message'].toString(),
              //
              14.0,
              Colors.black,
              'right',
            ),
          ),
        ),
        //
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: textWithRegularStyleLeft(
              //
              funcConvertTimeStampToDateAndTime(
                getSnapshotData[index]['time_stamp'],
              ),
              //
              12.0,
              Colors.black,
              'right',
            ),
          ),
        ),
        //
      ],
    );
  }
  //
}

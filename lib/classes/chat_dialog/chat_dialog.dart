// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:shawl_prod/classes/create_group/create_group.dart';
import 'package:shawl_prod/classes/search_add_member/add_members.dart';
import 'package:shawl_prod/classes/set_profile_for_public/set_profile_for_public.dart';
import 'package:shawl_prod/group_chat/group_chat.dart';
// import 'package:water_ship/classes/add_members/add_members.dart';
// import 'package:water_ship/classes/create_group/create_group.dart';

import '../Utils/utils.dart';

class DialogScreen extends StatefulWidget {
  const DialogScreen({
    super.key,
  });

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  //
  FirebaseAuth firebase_auth = FirebaseAuth.instance;
  //

  @override
  void initState() {
    //
    // funcDummy();
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: textWithRegularStyle(
            'Chats',
            Colors.white,
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
                  // print(FirebaseAuth.instance.currentUser!.photoURL);
                  logoutpopup(context, 'Are you sure you want to logout?');
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                height: 44,
                width: 44,
                child: NeoPopButton(
                  color: navigationColor,
                  // onTapUp: () => HapticFeedback.vibrate(),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  onTapUp: () {
                    //
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddMembersScreen(),
                      ),
                    );
                    //
                  },
                  onTapDown: () => HapticFeedback.vibrate(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // drawer: SizedBox(
        //   width: MediaQuery.of(context).size.width,
        //   child: const NavigationDrawer(),
        // ),
        body: Stack(
          children: [
            //
            addMemberAndCreateGroupUI(context),
            //

            //
            Container(
              margin: const EdgeInsets.only(top: 64.0),
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: 0.4,
              // child: widget
            ),
            //
            const SizedBox(
              height: 120,
            ),
            groupsListingUI(),
            //
          ],
        ), /**/
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> groupsListingUI() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('${strFirebaseMode}groups')
          .doc('India')
          .collection('details')
          .orderBy('time_stamp', descending: true)
          .where('match', arrayContainsAny: [
        //
        FirebaseAuth.instance.currentUser!.uid,
        //
      ]).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (kDebugMode) {
            // print(snapshot.data!.docs[0]['members_details'[0]]);
          }

          var save_snapshot_value = snapshot.data!.docs;
          if (kDebugMode) {
            print(save_snapshot_value);
          }
          return (snapshot.data!.docs.isEmpty)
              ? Center(
                  child: textWithRegularStyle(
                    'No chat found',
                    Colors.black,
                    14.0,
                  ),
                )
              : Container(
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(
                    top: 60,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            //
                            if (kDebugMode) {
                              print(snapshot.data!.docs[index]['chat_type']
                                  .toString());
                            }
                            //
                            if (snapshot.data!.docs[index]['chat_type']
                                    .toString() ==
                                'group') {
                              //
                              func_push_to_group_chat(
                                  snapshot.data!.docs[index].data());
                              //
                            } else {
                              func_push_to_private_chat(
                                  snapshot.data!.docs[index].data());
                            }
                          },
                          child: (snapshot.data!.docs[index]['chat_type']
                                      .toString() ==
                                  'group')
                              ? groupChatUI(snapshot, index)
                              : privateChatUI(snapshot, index),
                        );
                      },
                    ),
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
    );
  }

  Row addMemberAndCreateGroupUI(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //
        AddMemberUI(context),
        //
        CreateGroupUI(context),
        //
      ],
    );
  }

  SizedBox CreateGroupUI(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 160,
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
            //
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateGroupScreen(),
              ),
            );
            //
          },
          onTapDown: () => HapticFeedback.vibrate(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: textWithRegularStyle(
                  'Create Group',
                  Colors.black,
                  14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox AddMemberUI(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 180,
      // color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NeoPopButton(
          color: Colors.blueAccent,
          // onTapUp: () => HapticFeedback.vibrate(),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          onTapUp: () {
            //
            //
            if (kDebugMode) {
              print('=====> ADD MEMBER <======');
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SetProfileForpublicScreen(),
              ),
            );
            //
          },
          onTapDown: () => HapticFeedback.vibrate(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  children: [
                    const Icon(
                      Icons.group,
                      color: Colors.white,
                      size: 18.0,
                    ),
                    //
                    const SizedBox(
                      width: 8,
                    ),
                    //
                    textWithRegularStyle(
                      'Public Room',
                      Colors.white,
                      14.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile groupChatUI(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return ListTile(
      leading: (snapshot.data!.docs[index]['group_display_image'].toString() ==
              '')
          ? Container(
              height: 54,
              width: 54,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  40,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            )
          : SizedBox(
              height: 54,
              width: 54,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  27.0,
                ),
                child: Image.network(
                  snapshot.data!.docs[index]['group_display_image'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      title: textWithBoldStyle(
        //
        snapshot.data!.docs[index]['group_name'].toString(),
        //
        Colors.black,
        18.0,
      ),
      subtitle: (snapshot.data!.docs[index]['last_message'].toString() == '')
          ? Row(
              children: [
                const Icon(
                  Icons.image,
                  size: 20.0,
                ),
                textWithRegularStyle(
                  ' Image',
                  Colors.black,
                  14.0,
                ),
              ],
            )
          : ((snapshot.data!.docs[index]['last_message'].toString()).length >
                  40)
              ? Text(
                  (snapshot.data!.docs[index]['last_message'].toString())
                      .replaceRange(
                          40,
                          (snapshot.data!.docs[index]['last_message']
                                  .toString())
                              .length,
                          '...'),
                  style: const TextStyle(
                    // fontFamily: font_family_name,
                    fontSize: 16.0,
                  ),
                )
              : textWithRegularStyle(
                  (snapshot.data!.docs[index]['last_message'].toString()),
                  Colors.black,
                  14.0,
                ),
    );
  }

  ListTile privateChatUI(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return ListTile(
      leading: (snapshot.data!.docs[index]['sender_firebase_id'].toString() ==
              FirebaseAuth.instance.currentUser!.uid)
          ? Container(
              height: 54,
              width: 54,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: (snapshot.data!.docs[index]['receiver_image'].toString() ==
                      '')
                  ? Container(
                      height: 54,
                      width: 54,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/logo.png',
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                        27.0,
                      ),
                      child: Image.network(
                        snapshot.data!.docs[index]['receiver_image'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
            )
          : Container(
              height: 54,
              width: 54,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: (snapshot.data!.docs[index]['sender_image'].toString() ==
                      '')
                  ? Container(
                      height: 54,
                      width: 54,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/logo.JPG',
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                        27.0,
                      ),
                      child: Image.network(
                        snapshot.data!.docs[index]['sender_image'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      title: (snapshot.data!.docs[index]['sender_firebase_id'].toString() ==
              FirebaseAuth.instance.currentUser!.uid)
          ? textWithBoldStyle(
              //
              snapshot.data!.docs[index]['receiver_name'].toString(),
              //
              Colors.black,
              18.0,
            )
          : textWithRegularStyle(
              //
              snapshot.data!.docs[index]['sender_name'].toString(),
              //
              Colors.black,
              14.0,
            ),
      subtitle: (snapshot.data!.docs[index]['message'].toString() == '')
          ? Row(
              children: [
                const Icon(
                  Icons.image,
                  size: 20.0,
                ),
                textWithRegularStyle(
                  ' Image',
                  Colors.black,
                  14.0,
                ),
              ],
            )
          : ((snapshot.data!.docs[index]['message'].toString()).length > 40)
              ? Text(
                  (snapshot.data!.docs[index]['message'].toString())
                      .replaceRange(
                          40,
                          (snapshot.data!.docs[index]['message'].toString())
                              .length,
                          '...'),
                  style: const TextStyle(
                    // fontFamily: font_family_name,
                    fontSize: 16.0,
                  ),
                )
              : textWithRegularStyle(
                  (snapshot.data!.docs[index]['message'].toString()),
                  Colors.black,
                  14.0,
                ),
    );
  }

  // push
  func_push_to_private_chat(dict_dialog_data) {
    if (kDebugMode) {
      print(dict_dialog_data);
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ChatScreen(
    //       chatDialogData: dict_dialog_data,
    //       strFromDialog: 'yes',
    //     ),
    //   ),
    // );
  }

  //
  func_push_to_group_chat(dict_dialog_data) {
    if (kDebugMode) {
      print(dict_dialog_data);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupChatScreen(
          chatDialogData: dict_dialog_data,
        ),
      ),
    );
  }

  //
  funcDummy() {
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}groups')
        .doc('India')
        .collection('details')
        .where('group_id', isEqualTo: 'qwerty')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print('==========> DISHANT RAJPUT');
        print('==========> DISHANT RAJPUT');
        print(result);
        print(result.exists);
        print(result.id);
        print(result.data());
        print('==========> DISHANT RAJPUT');
        print('==========> DISHANT RAJPUT');
        FirebaseFirestore.instance
            .collection("users")
            .doc(result.id)
            .collection("pets")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            print(result.data());
          });
        });
      });
    });
  }
}

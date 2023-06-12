// ignore_for_file: avoid_print

// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

import '../Utils/utils.dart';

class AddMembersScreen extends StatefulWidget {
  const AddMembersScreen({super.key});

  @override
  State<AddMembersScreen> createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  //
  late final TextEditingController contEmail;
  //
  var strScreenLoader = '0';

  var strGroupName = '';
  var strGroupImage = '';
  var strMemberCapacity = '';
  // var strSeachedUserName = '';
  // var strSearchedUserImage = '';
  // var strSearchedUserEmail = '';
  // var strSearchedUserIdCardId = '';
  // var strSearchFriendFirestoreId = '';
  // var strSearchFriendFirebaseId = '';
  //
  var strSaveFirestoreId = '';
  //
  @override
  void initState() {
    //
    contEmail = TextEditingController();
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Search Group',
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
                    Icons.chevron_left,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          searchViaIdCardUI(context),
          //
          const SizedBox(
            height: 40,
          ),
          //
          (strScreenLoader == '0')
              ? const SizedBox(
                  height: 0,
                )
              : searchedUserShowDataUI()
          //
        ],
      ),
    );
  }

  ListTile searchedUserShowDataUI() {
    return ListTile(
      leading: SizedBox(
        height: 46,
        width: 46,
        child: (strGroupImage == '')
            ? Image.asset(
                'assets/images/logo.png',
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: Image.network(
                  strGroupImage,
                  fit: BoxFit.cover,
                ),
              ),
      ),
      title: textWithBoldStyle(
        //
        strGroupName,
        //
        Colors.black,
        18.0,
      ),
      subtitle: textWithRegularStyle(
        //
        "Member's capacity : " + strMemberCapacity,
        //
        Colors.black,
        14.0,
      ),
      trailing: (strScreenLoader == '2')
          ? SizedBox(
              height: 80,
              width: 120,
              // color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: NeoPopButton(
                  color: Colors.greenAccent,
                  // onTapUp: () => HapticFeedback.vibrate(),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  onTapUp: () {
                    //
                    funcAlreadyAMember();
                    //
                  },
                  onTapDown: () => HapticFeedback.vibrate(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: textWithRegularStyle(
                          'Member',
                          Colors.black,
                          16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox(
              height: 50,
              width: 80,
              // color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: NeoPopButton(
                  color: Colors.greenAccent,
                  // onTapUp: () => HapticFeedback.vibrate(),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  onTapUp: () {
                    //
                    funcAddUserInMyFriendsListXMPP();
                    //
                  },
                  onTapDown: () => HapticFeedback.vibrate(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: textWithRegularStyle(
                          'Add',
                          Colors.black,
                          16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Container searchViaIdCardUI(BuildContext context) {
    return Container(
      // height: 100,
      margin: const EdgeInsets.only(
        top: 20.0,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(
          246,
          248,
          253,
          1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 10.0,
                right: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  30,
                ),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xffDDDDDD),
                    blurRadius: 6.0,
                    spreadRadius: 2.0,
                    offset: Offset(0.0, 0.0),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: TextFormField(
                  controller: contEmail,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: false,
                  // controller: contGrindCategory,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Group id...',
                  ),
                  onTap: () {
                    //

                    //
                  },
                  // validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          //
          SizedBox(
            height: 64,
            width: 64,
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
                  funcCheckIsThisUserAlreadyInThisGroup();
                  //
                },
                onTapDown: () => HapticFeedback.vibrate(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Icon(
                        Icons.search,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ), //
        ],
      ),
    );
  }

  // CHECK IF THIS USER IS IN GROUP ALREADY OR NOT
  funcCheckIsThisUserAlreadyInThisGroup() {
    //
    showCustomDialog(context, 'please wait...');
    //
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}groups')
        .doc('India')
        .collection('details')
        .where('group_id', isEqualTo: contEmail.text)
        .where('match', arrayContainsAny: [
          //
          // '1234'
          FirebaseAuth.instance.currentUser!.uid,
          //
        ])
        .get()
        .then((value) => {
              print(value.docs.length),
              if (value.docs.length == 1)
                {
                  print('YES, YOU ALREADY IN THIS GROUP'),
                  //
                  // setState(() {
                  strScreenLoader = '2',
                  // }),
                  funcSearchUserViaIdGroupId(),
                  //
                }
              else
                {
                  funcSearchUserViaIdGroupId(),
                }
            });
    //
    // funcSearchUserViaIdGroupId();
  }

  //
  funcSearchUserViaIdGroupId() {
    if (kDebugMode) {
      print('dishu');
    }
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}groups')
        .doc('India')
        .collection('details')
        .where('group_id', isEqualTo: contEmail.text)
        .get()
        .then((value) => {
              if (value.docs.isEmpty)
                {
                  Navigator.pop(context),
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: navigationColor,
                      content: textWithBoldStyle(
                        //
                        'No group found. Please check group id and enter again.'
                            .toString(),
                        //
                        Colors.white,
                        14.0,
                      ),
                    ),
                  ),
                  //
                  setState(() {
                    strScreenLoader = '0';
                  }),
                }
              else
                {
                  print('yes some group'),
                  //
                  // print(value.docs[0]['firestore_id']),
                  //
                  strSaveFirestoreId = value.docs[0]['firestore_id'],
                  //
                  setState(() {
                    //
                    strGroupName = value.docs[0]['group_name'];
                    strGroupImage = value.docs[0]['group_display_image'];
                    strMemberCapacity = value.docs[0]['total_members'];
                    //

                    if (strScreenLoader == '2') {
                      strScreenLoader = '2';
                    } else {
                      strScreenLoader = '1';
                    }

                    Navigator.pop(context);
                  }),
                }
            });
  }

  funcAlreadyAMember() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: navigationColor,
        content: textWithBoldStyle(
          //
          'You already a member of this group.'.toString(),
          //
          Colors.white,
          14.0,
        ),
      ),
    );
  }

  // GET LOGIN USER DETAILS
  funcAddUserInMyFriendsListXMPP() {
    //
    FocusScope.of(context).requestFocus(FocusNode());
    showCustomDialog(context, 'please wait...');
    //
    print('USER PRESSED ADD');
    //
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc('India')
        .collection('details')
        .doc(strSaveFirestoreId.toString())
        .update({
      "members_details": FieldValue.arrayUnion([
        {
          'member_active': 'yes',
          'member_type': 'member',
          'member_name': FirebaseAuth.instance.currentUser!.displayName,
          'member_firebase_id': FirebaseAuth.instance.currentUser!.uid,
        }
      ])
    }).then((value) => {
              FirebaseFirestore.instance
                  .collection("${strFirebaseMode}groups")
                  .doc('India')
                  .collection('details')
                  .doc(strSaveFirestoreId.toString())
                  .update({
                "match": FieldValue.arrayUnion(
                    [FirebaseAuth.instance.currentUser!.uid])
              }).then((value) => {
                        print('ALL DONE'),
                        //
                        Navigator.pop(context),
                        Navigator.pop(context),
                        //
                      })

              // Update one field, creating the document if it does not already exist.

// db.collection("cities").doc("BJ").set(data, SetOptions(merge: true));

              // FirebaseFirestore.instance
              //     .collection("${strFirebaseMode}groups")
              //     .doc('India')
              //     .collection('details')
              //     .doc(strSaveFirestoreId.toString())
              //     .update({
              //   "match": FieldValue.arrayUnion([
              //     {
              //       'firebase_id': FirebaseAuth.instance.currentUser!.uid,
              //     }
              //   ])
              // }),
            });
    //
    // funcUpdateMatchAndAddFirebaseUI();

    //
  }

  //
  funcUpdateMatchAndAddFirebaseUI() {}
}

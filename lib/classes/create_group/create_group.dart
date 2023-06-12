// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:uuid/uuid.dart';

import '../Utils/utils.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  //
  var strFriendLoader = '0';
  var strLoginUserName = '';
  var strLoginUserId = '';
  var strLoginUserFirebaseId = '';
  var strloginUserImage = '';
  var arrSearchFriend = [];
  //
  var strFriendsList = '0';
  //
  var arrFriends = [];
  //
  late final TextEditingController contEmail;
  //
  var strCheckmark = '0';
  File? imageFile;
  ImagePicker picker = ImagePicker();
  //
  var strProfilImageLoader = '0';
  var strGetUploadImageURL = '';
  //
  var strUserSelectImage = '0';
  //
  @override
  void initState() {
    //

    contEmail = TextEditingController();
    //
    super.initState();
  }

  funcCreateCustomFriendListWB() {
    for (int i = 0; i < arrSearchFriend.length; i++) {
      var customDict = {
        'userId': arrSearchFriend[i]['userId'].toString(),
        'profileId': arrSearchFriend[i]['profileId'].toString(),
        'FirstUserimage': arrSearchFriend[i]['FirstUserimage'].toString(),
        'SecondUserimage': arrSearchFriend[i]['SecondUserimage'].toString(),
        'FirstfullName': arrSearchFriend[i]['FirstfullName'].toString(),
        'SecondfullName': arrSearchFriend[i]['SecondfullName'].toString(),
        'friendFirebaseId':
            (strLoginUserId == arrSearchFriend[i]['userId'].toString())
                ? arrSearchFriend[i]['FirstFirebaseId'].toString()
                : arrSearchFriend[i]['SecondFirebaseId'].toString(),
        'status': 'no'
      };

      arrFriends.add(customDict);
    }

    if (kDebugMode) {
      print(arrSearchFriend.length);
      print('custom friends list');
      print(arrFriends);
    }

    setState(() {
      strFriendLoader = '1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Create group',
          Colors.white,
          16.0,
        ),
        backgroundColor: navigationColor,
        actions: [
          IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('object');
              }
              //
              funcCreateGroup();
              //
            },
            icon: const Icon(
              Icons.check,
              size: 28.0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //
            headerUI(context),
            //
            const SizedBox(
              height: 10,
            ),
            /*Align(
              alignment: Alignment.centerLeft,
              child: textWithBoldStyle(
                ' Friends',
                Colors.black,
                22.0,
              ),
            ),*/
            //
            (strFriendsList == '0')
                ? const SizedBox(
                    width: 0,
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        for (int i = 0; i < arrFriends.length; i++) ...[
                          //
                          if (arrFriends[i]['status'] == 'yes') ...[
                            Container(
                              height: 40,
                              // width: 80,
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        20.0,
                                      ),
                                      child: (strLoginUserId ==
                                              arrFriends[i]['userId']
                                                  .toString())
                                          ? (arrFriends[i]['FirstUserimage']
                                                      .toString() ==
                                                  '')
                                              ? Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                      246,
                                                      248,
                                                      253,
                                                      1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      30,
                                                    ),
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(
                                                        'assets/images/logo.png',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                      246,
                                                      248,
                                                      253,
                                                      1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      30,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      30,
                                                    ),
                                                    child: Image.network(
                                                      //
                                                      arrFriends[i]
                                                              ['FirstUserimage']
                                                          .toString(),
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.cover,
                                                      //
                                                    ),
                                                  ),
                                                )
                                          : (arrFriends[i]['SecondUserimage']
                                                      .toString() ==
                                                  '')
                                              ? Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                      246,
                                                      248,
                                                      253,
                                                      1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      30,
                                                    ),
                                                    image:
                                                        const DecorationImage(
                                                      image: AssetImage(
                                                        'assets/images/avatar.png',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                      246,
                                                      248,
                                                      253,
                                                      1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      30,
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      30,
                                                    ),
                                                    child: Image.network(
                                                      //
                                                      arrFriends[i][
                                                              'SecondUserimage']
                                                          .toString(),
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.cover,
                                                      //
                                                    ),
                                                  ),
                                                ),
                                    ),
                                  ),
                                  //
                                  (strLoginUserId ==
                                          arrFriends[i]['userId'].toString())
                                      ? textWithBoldStyle(
                                          //
                                          arrFriends[i]['FirstfullName']
                                              .toString(),
                                          // '12',
                                          //
                                          Colors.black,
                                          16.0,
                                        )
                                      : textWithBoldStyle(
                                          //
                                          arrFriends[i]['SecondfullName']
                                              .toString(),
                                          // '12',
                                          //
                                          Colors.black,
                                          16.0,
                                        ),

                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //
                                ],
                              ),
                            ),
                          ],
                          //
                        ]
                      ],
                    ),
                  ),
            //
            const SizedBox(
              height: 6,
            ),
            for (int i = 0; i < arrFriends.length; i++) ...[
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(
                  246,
                  248,
                  253,
                  1,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 10.0,
                        ),
                        width: 40,
                        height: 40,
                        child: (strLoginUserId ==
                                arrFriends[i]['userId'].toString())
                            ? (arrFriends[i]['FirstUserimage'].toString() == '')
                                ? Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                        246,
                                        248,
                                        253,
                                        1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/logo.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                        246,
                                        248,
                                        253,
                                        1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                      child: Image.network(
                                        //
                                        arrFriends[i]['FirstUserimage']
                                            .toString(),
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        //
                                      ),
                                    ),
                                  )
                            : (arrFriends[i]['SecondUserimage'].toString() ==
                                    '')
                                ? Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                        246,
                                        248,
                                        253,
                                        1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/logo.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                        246,
                                        248,
                                        253,
                                        1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                      child: Image.network(
                                        //
                                        arrFriends[i]['SecondUserimage']
                                            .toString(),
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        //
                                      ),
                                    ),
                                  ),
                      ),
                    ),
                    //
                    Expanded(
                      child:
                          (strLoginUserId == arrFriends[i]['userId'].toString())
                              ? textWithBoldStyle(
                                  //
                                  arrFriends[i]['FirstfullName'].toString(),
                                  // '12',
                                  //
                                  Colors.black,
                                  16.0,
                                )
                              : textWithBoldStyle(
                                  //
                                  arrFriends[i]['SecondfullName'].toString(),
                                  // '12',
                                  //
                                  Colors.black,
                                  16.0,
                                ),
                    ),
                    //
                    InkWell(
                      onTap: () {
                        //
                        funcAdOrRemoveFriends(i);
                        //
                      },
                      child: (arrFriends[i]['status'].toString() == 'no')
                          ? Container(
                              margin: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              height: 36,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Center(
                                child: textWithRegularStyle(
                                  'Add',
                                  Colors.black,
                                  14.0,
                                ),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              height: 36,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Center(
                                child: textWithRegularStyle(
                                  'Remove',
                                  Colors.white,
                                  12.0,
                                ),
                              ),
                            ),
                    ),
                    //
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Container headerUI(BuildContext context) {
    return Container(
      // height: 100,
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
          InkWell(
            onTap: () {
              //
              openCameraAndGaleeryPopUP(context);
              //
            },
            child: (imageFile == null)
                ? Container(
                    margin: const EdgeInsets.only(
                      left: 20.0,
                      bottom: 20.0,
                      top: 20.0,
                    ),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        40.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffDDDDDD),
                          blurRadius: 6.0,
                          spreadRadius: 2.0,
                          offset: Offset(0.0, 0.0),
                        )
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  )
                : (strProfilImageLoader == '1')
                    ? Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          bottom: 20.0,
                          top: 20.0,
                        ),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            40.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffDDDDDD),
                              blurRadius: 6.0,
                              spreadRadius: 2.0,
                              offset: Offset(0.0, 0.0),
                            )
                          ],
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              40.0,
                            ),
                            child: const CircularProgressIndicator()),
                      )
                    : Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          bottom: 20.0,
                          top: 20.0,
                        ),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(
                            40.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffDDDDDD),
                              blurRadius: 6.0,
                              spreadRadius: 2.0,
                              offset: Offset(0.0, 0.0),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            40.0,
                          ),
                          child: Image.file(
                            fit: BoxFit.cover,
                            imageFile!,
                          ),
                        ),
                      ),
          ),
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
                    hintText: 'Group name',
                  ),
                  onTap: () {
                    // category_list_POPUP('str_message');
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
        ],
      ),
    );
  }

  //
  funcAdOrRemoveFriends(i) {
    //
    if (kDebugMode) {
      print(i);
      print(arrFriends[i]);
    }

    if (arrFriends[i]['status'] == 'no') {
      var custom = {
        'userId': arrSearchFriend[i]['userId'].toString(),
        'profileId': arrSearchFriend[i]['profileId'].toString(),
        'FirstUserimage': arrSearchFriend[i]['FirstUserimage'].toString(),
        'SecondUserimage': arrSearchFriend[i]['SecondUserimage'].toString(),
        'FirstfullName': arrSearchFriend[i]['FirstfullName'].toString(),
        'SecondfullName': arrSearchFriend[i]['SecondfullName'].toString(),
        'friendFirebaseId':
            (strLoginUserId == arrSearchFriend[i]['userId'].toString())
                ? arrSearchFriend[i]['FirstFirebaseId'].toString()
                : arrSearchFriend[i]['SecondFirebaseId'].toString(),
        'status': 'yes'
      };
      //
      arrFriends.removeAt(i); // remove
      arrFriends.insert(i, custom); // insert
      //
    } else {
      var custom = {
        'userId': arrSearchFriend[i]['userId'].toString(),
        'profileId': arrSearchFriend[i]['profileId'].toString(),
        'FirstUserimage': arrSearchFriend[i]['FirstUserimage'].toString(),
        'SecondUserimage': arrSearchFriend[i]['SecondUserimage'].toString(),
        'FirstfullName': arrSearchFriend[i]['FirstfullName'].toString(),
        'SecondfullName': arrSearchFriend[i]['SecondfullName'].toString(),
        'friendFirebaseId':
            (strLoginUserId == arrSearchFriend[i]['userId'].toString())
                ? arrSearchFriend[i]['FirstFirebaseId'].toString()
                : arrSearchFriend[i]['SecondFirebaseId'].toString(),
        'status': 'no'
      };
      //
      arrFriends.removeAt(i); // remove
      arrFriends.insert(i, custom); // insert
      //
    }

    setState(() {
      for (int i = 0; i < arrFriends.length; i++) {
        if (arrFriends[i]['status'] == 'yes') {
          strFriendsList = '1';
          return;
        } else {
          strFriendsList = '0';
        }

        //
      }
    });
    //
  }

  //
  //
  void openCameraAndGaleeryPopUP(BuildContext context) {
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
                  imageFile = File(pickedFile.path);
                });
              }
            },
            child: textWithRegularStyle(
              'Open Camera',
              Colors.black,
              14.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              //

              //
              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  if (kDebugMode) {
                    print('object');
                  }

                  //
                  imageFile = File(pickedFile.path);
                  //
                  strProfilImageLoader = '1';
                  uploadImageToFirebase(context);
                  //
                });
              }
            },
            child: textWithRegularStyle(
              'Open Gallery',
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
              Colors.red,
              16.0,
            ),
          ),
        ],
      ),
    );
  }

  //
  funcCreateGroup() {
    if (kDebugMode) {
      print('create group');
      // print(strFriendsList);
    }
    //
    showCustomDialog(context, 'please wait...');
    funcCreateGroupChatInXMPP();
    //
  }

  //
  funcCreateGroupChatInXMPP() {
    //
    var groupIdCreate = const Uuid().v4();
    var arrMatch = [];
    //
    if (kDebugMode) {
      // print(arrFriends);
    }
    //
    arrMatch.add(FirebaseAuth.instance.currentUser!.uid);
    //

    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}groups/India/details',
    );

    users
        .add(
          {
            'group_id': groupIdCreate.toString(),
            'group_name': contEmail.text.toString(),
            'group_display_image': strGetUploadImageURL.toString(),
            'chat_type': 'group',
            'last_message': '',
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'total_members': '20',
            'match': arrMatch,
            'admin_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'members_details': [
              {
                'member_active': 'yes',
                'member_type': 'admin',
                'member_name': FirebaseAuth.instance.currentUser!.displayName,
                'member_firebase_id': FirebaseAuth.instance.currentUser!.uid,
              },
            ],
          },
        )
        .then(
          (value) => funcUpdateFirestoreIdInGroup(
            groupIdCreate.toString(),
            value.id,
          ),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  // UPDATE FIRESTORE ID IN GROUP
  funcUpdateFirestoreIdInGroup(get_group_id, firestore_id) {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc('India')
        .collection('details')
        .doc(firestore_id)
        .set(
      {
        'firestore_id': firestore_id,
      },
      SetOptions(merge: true),
    ).then(
      (value1) {
        //
        funcSuccesssfullyCreate(
          get_group_id.toString(),
        );
        //
      },
    );
  }

  // SUCCESSFULLY CREATED A GROUP
  funcSuccesssfullyCreate(get_group_id) {
    //

    Navigator.pop(context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: navigationColor,
        content: textWithBoldStyle(
          //
          'Successfully Created'.toString(),
          //
          Colors.white,
          14.0,
        ),
      ),
    );
    //
  }

  // upload image via firebase
  Future uploadImageToFirebase(BuildContext context) async {
    if (kDebugMode) {
      print('dishu');
    }
    // String fileName = basename(imageFile_for_profile!.path);
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child(
          'group_chat_profile_display_image/${FirebaseAuth.instance.currentUser!.uid}',
        )
        .child(
          generateRandomString(10),
        );
    await storageRef.putFile(imageFile!);
    return await storageRef.getDownloadURL().then((value) => {
          print(
            '======>$value',
          ),
          // sendImageViaFirebase(value)

          setState(() {
            strProfilImageLoader = '2';
            strGetUploadImageURL = value;
            strUserSelectImage = '1';
          }),
        });
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

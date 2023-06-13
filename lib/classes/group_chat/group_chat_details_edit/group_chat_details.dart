// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/utils.dart';

class GroupChatDetailsScreen extends StatefulWidget {
  const GroupChatDetailsScreen({super.key, this.dictGetDataForDetails});

  final dictGetDataForDetails;

  @override
  State<GroupChatDetailsScreen> createState() => _GroupChatDetailsScreenState();
}

class _GroupChatDetailsScreenState extends State<GroupChatDetailsScreen> {
  //
  var strRemovedMemberName = '';
  var strFriendLoader = '1';
  var strLoginUserName = '';
  var strLoginUserId = '';
  var strLoginUserFirebaseId = '';
  var strloginUserImage = '';
  var arrSearchFriend = [];
  // var str
  //
  var strFriendsList = '0';
  //
  //
  late final TextEditingController contGroupName;
  //
  var strCheckmark = '0';
  File? imageFile;
  ImagePicker picker = ImagePicker();
  //
  var strProfilImageLoader = '0';
  // var strGetUploadImageURL = '';
  //
  // var arrGroupDetails = [];
  var strGetImageData = '';
  //
  var strSaveGroupNameAfterUpdate = '';
  // var strSaveGroupImageAfterUpdate = '';
  //
  var arrMembers = [];
  var arrMembersDetails = [];
  //
  var strDeleteGroupButton = '0';
  //
  var arrSaveXMPPmembers = [];
  //
  @override
  void initState() {
    //
    if (kDebugMode) {
      print('================ GROUP DATA =====================');
      print(widget.dictGetDataForDetails);
      /*print(widget.dictGetDataForDetails['members_details']);
      print(widget.dictGetDataForDetails['members_details'].length);
      print(widget.dictGetDataForDetails['members_details'].length.runtimeType);*/
      print('=================================================');
    }
    super.initState();
    //
    funcGroupDetails();
    //
  }

  funcGroupDetails() {
    // set group name
    contGroupName = TextEditingController(
        text: widget.dictGetDataForDetails['group_name'].toString());
    strSaveGroupNameAfterUpdate =
        widget.dictGetDataForDetails['group_name'].toString();
    // set image

    strGetImageData =
        widget.dictGetDataForDetails['group_display_image'].toString();
    //
    print('================ DONE INIT =====================');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Details',
          Colors.white,
          18.0,
        ),
        //
        leading: (strGetImageData == '')
            ? IconButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    //strSaveGroupNameAfterUpdate.toString(),
                    'ok',
                  );
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              )
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
        backgroundColor: navigationColor,
      ),
      //
      backgroundColor: appDesertColor,
      //
      body: (strFriendLoader == '0')
          ? Center(
              child: CircularProgressIndicator(
                color: navigationColor,
              ),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('${strFirebaseMode}groups')
                  .doc('India')
                  .collection('details')
                  .orderBy('time_stamp', descending: true)
                  .where('group_id',
                      isEqualTo:
                          widget.dictGetDataForDetails['group_id'].toString())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (kDebugMode) {
                    print(snapshot.data!.docs[0]['match'][0]);
                  }

                  var saveSnapshotValue = snapshot.data!.docs;
                  if (kDebugMode) {
                    print('============== DIALOGS ==============');
                    print(saveSnapshotValue[0]['match']);
                    print('======================================');
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print(snapshot.data!.docs[0]['members_details'][3]
                        // ['firebase_id']);
                        //
                        arrMembers = snapshot.data!.docs[0]['match'];
                        //

                        arrMembersDetails =
                            snapshot.data!.docs[0]['members_details'];
                        //
                        if (kDebugMode) {
                          print('============== MATCH ==============');
                          print(arrMembersDetails);
                          print('======================================');
                        }
                        (snapshot.data!.docs[0]['members_details'][0]
                                    ['firebase_id'] ==
                                FirebaseAuth.instance.currentUser!.uid)
                            ? strDeleteGroupButton = '1'
                            : strDeleteGroupButton = '0';

                        //
                        funcGetFriendsList(arrMembersDetails);
                        //
                        return Column(
                          children: [
                            //
                            headerUI(context),
                            //
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: textWithBoldStyle(
                                ' Members',
                                Colors.black,
                                22.0,
                              ),
                            ),
                            //

                            //
                            for (int i = 0;
                                i <
                                    snapshot.data!.docs[0]['members_details']
                                        .length;
                                i++) ...[
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                      //
                                      'assets/images/logo.png',
                                      //
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: textWithBoldStyle(
                                  //
                                  snapshot.data!.docs[0]['members_details'][i]
                                      ['member_name'],
                                  //
                                  Colors.black,
                                  14.0,
                                ),
                                trailing: (snapshot.data!.docs[0]
                                            ['admin_firebase_id'] ==
                                        FirebaseAuth.instance.currentUser!.uid)
                                    ? (snapshot.data!.docs[0]['members_details']
                                                [i]['member_type'] ==
                                            'admin')
                                        ? textWithRegularStyle(
                                            'admin',
                                            Colors.black,
                                            14.0,
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              funcGetMemberDetailsxmpp(
                                                  i,
                                                  snapshot
                                                      .data!
                                                      .docs[0]
                                                          ['members_details'][i]
                                                          ['member_firebase_id']
                                                      .toString());
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  14.0,
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
                                              child: Center(
                                                child: textWithRegularStyle(
                                                  'Remove',
                                                  Colors.white,
                                                  14.0,
                                                ),
                                              ),
                                            ),
                                          )
                                    : (snapshot.data!.docs[0]['members_details']
                                                [i]['member_type'] ==
                                            'admin')
                                        ? textWithRegularStyle(
                                            'admin', Colors.black, 14.0)
                                        : SizedBox(
                                            height: 0,
                                          ),
                              ),
                              //
                              Container(
                                height: 0.4,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black,
                              ),
                            ],
                            //
                            const SizedBox(
                              height: 40,
                            ),
                            (snapshot.data!.docs[0]['members_details'][0]
                                        ['firebase_id'] ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? GestureDetector(
                                    onTap: () {
                                      //
                                      print('delete this group');
                                      //
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.add,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                //

                                                //
                                              },
                                              child: textWithBoldStyle(
                                                'Add Participants',
                                                Colors.black,
                                                14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        //

                                        const SizedBox(
                                          height: 20,
                                        ),
                                        textWithRegularStyle(
                                          'Delete Group',
                                          Colors.red,
                                          14.0,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                  )
                          ],
                        );
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
    );
  }

  //
  Container headerUI(BuildContext context) {
    return Container(
      // height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.transparent,
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
                ? (strGetImageData == '')
                    ? Container(
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
                        child: Image.asset(
                          'assets/images/logo.png',
                        ),
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
                            40,
                          ),
                          child: Image.network(
                            strGetImageData,
                            fit: BoxFit.cover,
                          ),
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
                          color: Colors.amber,
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
                          child: const CircularProgressIndicator(),
                        ),
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
                  controller: contGroupName,
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
                  onEditingComplete: () {
                    //do your stuff
                    if (kDebugMode) {
                      print('dismiss keybaord');
                    }

                    // dismiss keyboard
                    // FocusScope.of(context).requestFocus(FocusNode());
                    //

                    funcGetDataXMPP();
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
        ],
      ),
    );
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
                  //
                  /*const snackBar = SnackBar(
                    backgroundColor: Colors.blueAccent,
                    content: Text('updating....'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  //
                  */
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
  funcGetDataXMPP() {
    if (kDebugMode) {
      print('=============== GROUP ID IS ======================');
      // print(widget.dictGetDataForDetails['group_id'].toString());
      print('====================================================');
    }

//
    const snackBar = SnackBar(
      backgroundColor: Colors.blueAccent,
      content: Text('updating....'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc("India")
        .collection("details")
        .where("group_id",
            isEqualTo: widget.dictGetDataForDetails['group_id'].toString())
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs);
      }

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          print('======> NO USER FOUND');
        }

        //
      } else {
        for (var element in value.docs) {
          if (kDebugMode) {
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print(element.id);
            print(element.id.runtimeType);
          }
          //
          funcUpdateNameXMPP(
            element.id,
          );
          //
        }
      }
    });
    //
  }

  //
  funcUpdateNameXMPP(firestoreId) {
    if (kDebugMode) {
      print('=============== FIRESTORE ID ======================');
      print(firestoreId);
      print('====================================================');
    }
    //
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc('India')
        .collection('details')
        .doc(firestoreId)
        .set(
      {
        'group_name': contGroupName.text.toString(),
        'group_display_image': strGetImageData.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value1) {
        //
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //
        const snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text('Updated....'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //
        setState(() {
          strSaveGroupNameAfterUpdate = contGroupName.text.toString();

          strProfilImageLoader = '2';
        });

        //
      },
    );
    //
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
            //
            strGetImageData = value;
            //
            funcGetDataXMPP();
          })

          //

          //
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
  //
  //
  /*funcGetDataFromXMPP() {
    if (kDebugMode) {
      print('=============== GROUP ID IS ======================');
      print(widget.dictGetDataForDetails['group_id'].toString());
      print('====================================================');
    }

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc("India")
        .collection("details")
        .where("group_id",
            isEqualTo: widget.dictGetDataForDetails['group_id'].toString())
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs);
      }

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          print('======> NO USER FOUND');
        }

        //
      } else {
        for (var element in value.docs) {
          if (kDebugMode) {
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print(element.id);
            print(element.id.runtimeType);
          }
          //
          funcUpdateImageXMPP(
            element.id,
          );
          //
        }
      }
    });
    //
  }

  //
  funcUpdateImageXMPP(firestoreId) {
    if (kDebugMode) {
      print('=============== FIRESTORE ID ======================');
      print(firestoreId);
      print('====================================================');
    }
    //
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc('India')
        .collection('details')
        .doc(firestoreId)
        .set(
      {
        'group_display_image': strSaveGroupImageAfterUpdate.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value1) {
        //
        setState(() {
          strProfilImageLoader = '2';
        });

        //
      },
    );
    //
  }*/
  //
  funcGetMemberDetailsxmpp(
    getCellId,
    getUserFirebaseId,
  ) {
//

    if (kDebugMode) {
      print('=============== GROUP ID IS ======================');
      print(widget.dictGetDataForDetails['group_id'].toString());

      print('=============== CLICKED USER FIREBASE ID ======================');
      print(getUserFirebaseId.toString());
      print('====================================================');
    }

//
    const snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('deleting....'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc("India")
        .collection("details")
        .where("group_id",
            isEqualTo: widget.dictGetDataForDetails['group_id'].toString())
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs.length);
        print(value.docs);
      }

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          print('======> NO USER FOUND');
        }

        //
      } else {
        for (var element in value.docs) {
          if (kDebugMode) {
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print('=============== GROUP FIRESTORE ID ======================');
            print(element.id);
            print('====================================================');

            print(element.id.runtimeType);
          }
          //
          funcDeleteFirebaseIdFromMATCHxmpp(
            element.id,
            getUserFirebaseId.toString(),
          );
          //
        }
      }
    });
    //
  }

  //
  funcDeleteFirebaseIdFromMATCHxmpp(
    firestoreId,
    deleteUserFirebaseId,
  ) {
    print(widget.dictGetDataForDetails['match']);
    print(firestoreId);
    print(deleteUserFirebaseId);
    //
    var arrRemoveFriendFromMembers = [];
    //
    for (int i = 0; i < arrMembers.length; i++) {
      if (arrMembers[i].toString() == deleteUserFirebaseId.toString()) {
        print('yes match');
      } else {
        print('no match');
        // strRemovedMemberName = arrMembers[i]['member_name'].toString();
        arrRemoveFriendFromMembers.add(arrMembers[i]);
      }
    }
    //
    print(arrRemoveFriendFromMembers);
    //

    // funcDeleteMemberFullDetailsFromThisGroup(
    //   firestoreId,
    //   deleteUserFirebaseId,
    // );
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc("India")
        .collection("details")
        .doc(firestoreId)
        .update({
      'match': arrRemoveFriendFromMembers,
    }).then((value) => {
              //
              //
              arrRemoveFriendFromMembers.clear(),
              //
              funcDeleteMemberFullDetailsFromThisGroup(
                firestoreId,
                deleteUserFirebaseId,
              ),
              //
            });
  }

  // also delete member full details
  funcDeleteMemberFullDetailsFromThisGroup(
    firestoreId,
    deleteUserFirebaseId,
  ) {
    // print('member details call');
    /*print('=============== MEMBERS IN GROUP ======================');
    print(arrMembersDetails);
    print(arrMembersDetails.length);*/

    //
    var arrRemoveFriendFromMembers = [];
    // //
    for (int i = 0; i < arrMembersDetails.length; i++) {
      //
      if (arrMembersDetails[i]['member_firebase_id'].toString() ==
          deleteUserFirebaseId.toString()) {
        print('yes match details of member');
      } else {
        var custom = {
          'member_active': arrMembersDetails[i]['member_active'].toString(),
          'member_firebase_id':
              arrMembersDetails[i]['member_firebase_id'].toString(),
          'member_name': arrMembersDetails[i]['member_name'].toString(),
          'member_type': arrMembersDetails[i]['member_type'].toString(),
        };
        //
        arrRemoveFriendFromMembers.add(custom);
      }
      //
    }
    //
    print(arrRemoveFriendFromMembers);
    print(arrRemoveFriendFromMembers.length);

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc("India")
        .collection("details")
        .doc(firestoreId)
        .update({
      'members_details': arrRemoveFriendFromMembers,
    }).then((value) => {
              //
              arrRemoveFriendFromMembers.clear(),
              //
            });
    //
    //
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //
    const snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Text('removed....'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //
  }

  //
  funcDeleteWholeGroup() {
    if (kDebugMode) {
      print('=============== GROUP ID IS ======================');
      print(widget.dictGetDataForDetails['group_id'].toString());
      print('====================================================');
    }

//
    const snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text('deleting....'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}groups")
        .doc("India")
        .collection("details")
        .where("group_id",
            isEqualTo: widget.dictGetDataForDetails['group_id'].toString())
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs.length);
        print(value.docs);
      }

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          print('======> NO USER FOUND');
        }

        //
      } else {
        for (var element in value.docs) {
          if (kDebugMode) {
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print('=============== GROUP FIRESTORE ID ======================');
            print(element.id);
            print('=========================================================');

            print(element.id.runtimeType);
          }
          //
          FirebaseFirestore.instance
              .collection("${strFirebaseMode}groups")
              .doc("India")
              .collection("details")
              .doc(element.id)
              .delete()
              .then((value) => {
                    // funcRemoveUserMessage(),
                    Navigator.pop(context),
                    Navigator.pop(context),
                  });
          //
        }
      }
    });
  }

  //
  funcRemoveUserMessage() {
    // print(cont_txt_send_message.text);

    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}message/${widget.dictGetDataForDetails['group_id'].toString()}/details',
    );

    users
        .add(
          {
            'type': 'remove_user',
            'admin_name': FirebaseAuth.instance.currentUser!.displayName,
            'removed_user_name': strRemovedMemberName
          },
        )
        .then((value) =>
                //
                print(value)
            // funcEditMessageAndInsertFirestoreId(value.id),
            //
            )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  //
  funcGetFriendsList(getMembersDetails) {
    print('==========================================================');
    print('=================== XMPP MEMBERS =========================');
    print(getMembersDetails);
    print('==========================================================');
    print('=============== LOCAL SERVER MEMBERS =====================');
    print(arrSearchFriend);
    print('==========================================================');
    print('==========================================================');
  }
}

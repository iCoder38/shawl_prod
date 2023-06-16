import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shawl_prod/classes/public_chat_room/public_chat_room.dart';
import 'package:uuid/uuid.dart';

import '../Utils/utils.dart';

class SetProfileForpublicScreen extends StatefulWidget {
  const SetProfileForpublicScreen({super.key});

  @override
  State<SetProfileForpublicScreen> createState() =>
      _SetProfileForpublicScreenState();
}

class _SetProfileForpublicScreenState extends State<SetProfileForpublicScreen> {
  //
  var strSelectGenderType = '0';
  int segmentedControlValue = 0;
  late final TextEditingController contSetName;
  //
  var arrMaleIcons = [
    'assets/images/public_chat_male_cool.png',
    'assets/images/public_chat_male_rich.png',
  ];
  //
  @override
  void initState() {
    //
    contSetName = TextEditingController();

    // funcTestEncrypt();
    super.initState();
  }

  @override
  void dispose() {
    //
    contSetName.dispose();

    //
    super.dispose();
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
            'Create Public Profile',
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
        ),
        //
        backgroundColor: appDesertColor,
        //
        body: Column(
          children: [
            //
            const SizedBox(
              height: 20,
            ),
            //
            Row(
              children: [
                //
                const SizedBox(
                  width: 10,
                ),
                //
                Align(
                  alignment: Alignment.topLeft,
                  child: textWithRegularStyle(
                    'Set your name',
                    Colors.black,
                    14.0,
                  ),
                ),
              ],
            ),
            //
            Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 5,
              ),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
                color: Colors.white,
                border: Border.all(width: 0.4),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 188, 182, 182),
                    blurRadius: 6.0,
                    spreadRadius: 2.0,
                    offset: Offset(0.0, 0.0),
                  )
                ],
              ),
              child: TextFormField(
                controller: contSetName,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some name';
                  }
                  return null;
                },
              ),
            ),
            //
            const SizedBox(
              height: 20,
            ),
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                child: CupertinoSegmentedControl<int>(
                  selectedColor: navigationColor,
                  borderColor: Colors.white,
                  children: {
                    0: Text('Male'),
                    1: Text('Female'),
                    // 2: Text('Prefer not to say'),
                  },
                  onValueChanged: (int val) {
                    setState(() {
                      print(val);
                      segmentedControlValue = val;
                    });
                  },
                  groupValue: segmentedControlValue,
                ),
              ),
            ),
            //
            const SizedBox(
              height: 10,
            ),
            //
            // selectAvatarUI(),
            //
            const SizedBox(
              height: 10,
            ),
            //
            SizedBox(
              height: 60,
              width: 240,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: NeoPopButton(
                  color: Colors.lightBlueAccent,
                  // onTapUp: () => HapticFeedback.vibrate(),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  onTapUp: () {
                    //
                    if (contSetName.text == '') {
                      FocusScope.of(context).requestFocus(FocusNode());
                      popUpWithOutsideClick(
                          context, 'Please enter some name.', 'Ok');
                    } else {
                      showCustomDialog(context, 'creating...');
                      funcSetProfileForChat();
                    }
                    //
                  },
                  onTapDown: () => HapticFeedback.vibrate(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWithBoldStyle(
                        'Create and Enter',
                        Colors.black,
                        14.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //
            const SizedBox(
              height: 100,
            ),
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: textWithRegularStyle(
                  '',
                  // 'You can set any name and chat Anonymously with anybody. Your all data is safe and secured with us.',
                  Colors.grey,
                  14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView selectAvatarUI() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < arrMaleIcons.length; i++) ...[
            (segmentedControlValue == 0)
                ? Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(
                        22.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      child: Image.asset(
                        //
                        arrMaleIcons[i].toString(),
                        //
                      ),
                    ),
                  )
                : Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(
                        22.0,
                      ),
                    ),
                  ),
            SizedBox(
              width: 8,
            ),
          ]
        ],
      ),
    );
  }

// CHECK PROFILE DATA AFTER CLICK ON SET
  funcSetProfileForChat() {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}user")
        .doc("India")
        .collection("details")
        .where("user_firebase_id",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs);
      }

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          print('======> NO USER FOUND');
        }
        // ADD THIS USER TO FIREBASE SERVER
        // funcRegisterNewUserInDB();
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

          // EDIT USER IF IT ALREADY EXIST
          funcCreatePublicName(element.id);
        }
      }
    });
  }

  // CREATE PUBLIC NAME
  funcCreatePublicName(firestore) async {
    var chatUserId = const Uuid().v4();
    if (kDebugMode) {
      print(chatUserId);
    }
    //
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('login_user_chat_id', chatUserId.toString());
    //

    FirebaseFirestore.instance
        .collection("${strFirebaseMode}user")
        .doc('India')
        .collection('details')
        .doc(firestore)
        .set(
      {
        'chat_user_id': chatUserId,
        'time_stamp': DateTime.now().millisecondsSinceEpoch,
        'gender_status': segmentedControlValue.toString(),
        'public_chat_name': contSetName.text.toString()
      },
      SetOptions(merge: true),
    ).then(
      (value1) {
        //
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PublicChatRoomScreen(
              strSenderName: contSetName.text.toString(),
              strSenderChatId: chatUserId.toString(),
              strSenderGender: segmentedControlValue.toString(),
            ),
          ),
        );
        //
        setState(() {
          // strSetLoader = '1';
        });
        //
        //
      },
    );
  }
}

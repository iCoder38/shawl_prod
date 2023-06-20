import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

import '../../Utils/utils.dart';

class PrivateChatSettingsScreen extends StatefulWidget {
  const PrivateChatSettingsScreen({
    super.key,
    required this.strFirestoreId,
    required this.arrImagePermission,
  });

  final String strFirestoreId;
  final String arrImagePermission;

  @override
  State<PrivateChatSettingsScreen> createState() =>
      _PrivateChatSettingsScreenState();
}

class _PrivateChatSettingsScreenState extends State<PrivateChatSettingsScreen> {
  //
  var strBackUIrefresh = '0';
  var strIsMyFirebaseIdAvailaibleInImagePermission = '0';
  var arrImagePermissionParse = [];
  var strShowAlertText = '0';
  var switchImagePermission = false;
  //
  @override
  void initState() {
    if (kDebugMode) {
      print('FIRESTORE ID =====> ${widget.strFirestoreId}');
      print('IMAGE PERMISSION ARRAY =====> ${widget.arrImagePermission}');
    }

    funcShowImage();

    super.initState();
  }

  funcShowImage() {
    (widget.strFirestoreId == '0')
        ? strShowAlertText = '0'
        : strShowAlertText = '1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithBoldStyle(
          'Settings',
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
                Navigator.pop(context, strBackUIrefresh);
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
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('${strFirebaseMode}dialog')
            .doc('India')
            .collection('details')
            .where(
              'firestoreId',
              isEqualTo: widget.strFirestoreId,
            )
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
          if (snapshot2.hasData) {
            // if (kDebugMode) {

            var saveSnapshotValue2 = snapshot2.data!.docs;

            //
            arrImagePermissionParse = saveSnapshotValue2[0]['image_permission'];
            if (kDebugMode) {
              print('=====> IMAGE PERMISSION DATA <======');
              // print(saveSnapshotValue2[0]['image_permission']);
              print(arrImagePermissionParse);
              // print('=====================================');
            }
            //
            if (arrImagePermissionParse.isEmpty) {
              switchImagePermission = false;
            } else {
              for (int i = 0; i < arrImagePermissionParse.length; i++) {
                if (arrImagePermissionParse[i].toString() ==
                    FirebaseAuth.instance.currentUser!.uid.toString()) {
                  if (kDebugMode) {
                    print('YES I AM AVAILAIBLE');
                    print(switchImagePermission);
                  }
                  //
                  switchImagePermission = true;
                  //
                }
              }
            }

            //
            return privateChatSettingUI(context);
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
      //
      //
    );
  }

  Column privateChatSettingUI(
    BuildContext context,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(
              Icons.image,
            ),
            title: textWithBoldStyle(
              'Image permission',
              Colors.black,
              16.0,
            ),
            subtitle: textWithRegularStyle(
              'Both of you must agree to share images with each other.',
              Colors.black,
              14.0,
            ),
            trailing: Switch(
              // This bool value toggles the switch.
              value: switchImagePermission,
              activeColor: Colors.greenAccent,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  switchImagePermission = value;
                });
                funcImageSwitchPermission();
              },
            ),
          ),
        ),
        //
        Container(
          margin: const EdgeInsets.only(
            left: 20.0,
          ),
          height: 0.4,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
        ),
      ],
    );
  }

  //
  funcAddFirebaseIdInImagePermissionData() {
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}dialog')
        .doc('India')
        .collection('details')
        .doc(widget.strFirestoreId.toString())
        .update(
      {
        'image_permission': FieldValue.arrayUnion(
          [FirebaseAuth.instance.currentUser!.uid.toString()],
        )
      },
    ).then((value) => {
              Navigator.pop(context),
            });
    //
    /*(switchImagePermission == true)
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.greenAccent,
              content: textWithBoldStyle(
                //
                'Image permission : Granted'.toString(),
                //
                Colors.black,
                14.0,
              ),
            ),
          )
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: textWithBoldStyle(
                //
                'Image permission : Denied'.toString(),
                //
                Colors.white,
                14.0,
              ),
            ),
          );*/
  }

  //
  funcRemoveFirebaseIdInImagePermissionData() {
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}dialog')
        .doc('India')
        .collection('details')
        .doc(widget.strFirestoreId.toString())
        .update(
      {
        'image_permission': FieldValue.arrayRemove(
          [FirebaseAuth.instance.currentUser!.uid.toString()],
        )
      },
    ).then((value) => {
              Navigator.pop(context),
            });
    //
    /*(switchImagePermission == true)
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.greenAccent,
              content: textWithBoldStyle(
                //
                'Image permission : Granted'.toString(),
                //
                Colors.black,
                14.0,
              ),
            ),
          )
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: textWithBoldStyle(
                //
                'Image permission : Denied'.toString(),
                //
                Colors.white,
                14.0,
              ),
            ),
          );*/
  }

  // image switch permission
  funcImageSwitchPermission() {
    if (kDebugMode) {
      print(switchImagePermission);
    }
    //
    showCustomDialog(context, 'please wait...');
    // setState(() {});
    //
    strBackUIrefresh = 'pop_from_setting';
    // //
    // ScaffoldMessenger.of(context).removeCurrentSnackBar();
    // //
    (switchImagePermission == true)
        ? funcAddFirebaseIdInImagePermissionData()
        : funcRemoveFirebaseIdInImagePermissionData();
    //
  }
}

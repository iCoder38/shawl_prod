import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

import '../../Utils/utils.dart';

class PrivateChatSettingsScreen extends StatefulWidget {
  const PrivateChatSettingsScreen({super.key, required this.strFirestoreId});

  final String strFirestoreId;

  @override
  State<PrivateChatSettingsScreen> createState() =>
      _PrivateChatSettingsScreenState();
}

class _PrivateChatSettingsScreenState extends State<PrivateChatSettingsScreen> {
  //
  var strShowAlertText = '0';
  var switchImagePermission = false;
  //
  @override
  void initState() {
    if (kDebugMode) {
      print('FIRESTORE ID =====> ${widget.strFirestoreId}');
    }

    func();
    super.initState();
  }

  func() {
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
                Navigator.pop(context, 'pop_from_setting');
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
      body: (strShowAlertText == '0')
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: textWithBoldStyle(
                  'You have to chat first with this user to activate "Image Permission Alert".',
                  Colors.black,
                  14.0,
                ),
              ),
            )
          : Column(
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
                      'Allow other to share image with you.',
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
                          funcImageSwitchPermission();
                        });
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
            ),
    );
  }

  //
  funcUpdateImagepermissionData() {
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
    );
  }

  // image switch permission
  funcImageSwitchPermission() {
    if (kDebugMode) {
      print(switchImagePermission);
    }
    //
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    //
    (switchImagePermission == true)
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
          );
    //
  }
}

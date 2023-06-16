import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shawl_prod/classes/chat_dialog/chat_dialog.dart';
import 'package:shawl_prod/classes/set_profile_for_public/set_profile_for_public.dart';
// import 'package:water_ship/classes/chat_dialog/chat_dialog.dart';

import '../../main.dart';
import '../Utils/utils.dart';
import '../login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //
  Timer? timer;
  //
  @override
  void initState() {
    //
    funcPlayTimer();
    //
    // FirebaseAuth.instance.signOut();
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: textWithRegularStyle(
      //     'Splash',
      //     Colors.white,
      //     16.0,
      //   ),
      //   backgroundColor: navigationColor,
      // ),
      backgroundColor: const Color.fromRGBO(
        230,
        228,
        210,
        1,
      ),
      body: Center(
        child: SizedBox(
          height: 120,
          width: 120,
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
      ),
    );
  }

  funcGetAllNotificationFunctions() {
    funcGetDeviceToken();
    //
    funcGetFullDataOfNotification();
    //
  }

  //
  funcGetDeviceToken() async {
    //
    final token = await firebaseMessaging.getToken();

    //
    if (kDebugMode) {
      print('=============> HERE IS MY DEVICE TOKEN <=============');
      print('======================================================');
      print(token);
      print('======================================================');
      print('======================================================');
    }
    // save token locally
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('deviceToken', token.toString());
    //
  }

  //
  // get notification in foreground
  funcGetFullDataOfNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('=====> GOT NOTIFICATION IN FOREGROUND <=====');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print('Message data: ${message.data}');
          print(
              'Message also contained a notification: ${message.notification}');
        }
        // setState(() {
        //   notifTitle = message.notification!.title;
        //   notifBody = message.notification!.body;
        // });
      }
      //
      if (message.data['type'].toString() == 'audio_call') {
        //
        if (kDebugMode) {
          print(message.data['channel_name'].toString());
        }
        //
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChatAudioCallScreen(
        //       getAllData: message.data,
        //       strGetCallStatus: 'get_call',
        //     ),
        //   ),
        // );
        //
      } else if (message.data['type'].toString() == 'videoCall') {
        //
      }
    });
  }

  //
  funcPlayTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        //
        if (t.tick == 2) {
          t.cancel();
          // func_push_to_next_screen();
          // if (kDebugMode) {
          //   print('object');
          // }
          //
          if (FirebaseAuth.instance.currentUser != null) {
            // signed in
            //
            if (kDebugMode) {
              print('SUCCESSSFULLY SIGNED IN');
            }
            if (FirebaseAuth.instance.currentUser!.emailVerified == false) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
              popUpWithOutsideClick(
                context,
                'Your account is not verified yet. Please verify your account.',
                'Ok',
              );
            } else {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const DialogScreen(),
              //   ),
              // );
              //
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetProfileForpublicScreen(),
                ),
              );
              //
            }

            //
          } else {
            // signed out
            //
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
            //
          }

          //
        }
      },
    );
  }
  //
}

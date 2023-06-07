// ignore_for_file: use_build_context_synchronously

// import 'dart:async';

import 'dart:convert';
// import 'dart:html';

import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:shawl_prod/classes/chat_dialog/chat_dialog.dart';
import 'package:shawl_prod/classes/sign_up/sign_up.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:crypto/crypto.dart';

import '../Utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  final formKey = GlobalKey<FormState>();
  late final TextEditingController contEmail;
  late final TextEditingController contPassword;
  //
  // static Encrypted? encrypted;
  // static var decrypted;
  //
  @override
  void initState() {
    //
    contEmail = TextEditingController();
    contPassword = TextEditingController();
    //
    // funcTestEncrypt();
    super.initState();
  }

  @override
  void dispose() {
    //
    contEmail.dispose();
    contPassword.dispose();
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
          title: textWithBoldStyle(
            'Login',
            Colors.black,
            18.0,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: navigationColor,
        ),
        backgroundColor: const Color.fromRGBO(
          254,
          248,
          224,
          1,
        ),
        body: Form(
          key: formKey,
          child: Column(
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
                      'Email address',
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
                  controller: contEmail,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Email address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email address';
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
                      'Password',
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
                  controller: contPassword,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
              ),
              //
              const SizedBox(
                height: 10,
              ),
              //

              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: NeoPopButton(
                    color: navigationColor,
                    // onTapUp: () => HapticFeedback.vibrate(),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    onTapUp: () {
                      //
                      if (formKey.currentState!.validate()) {
                        //
                        showCustomDialog(context, 'please wait...');
                        signInViaFirebase();

                        //
                      }
                    },
                    onTapDown: () => HapticFeedback.vibrate(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textWithBoldStyle(
                          'Sign In',
                          Colors.black,
                          14.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                      //
                    },
                    onTapDown: () => HapticFeedback.vibrate(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textWithBoldStyle(
                          'Sign Up',
                          Colors.black,
                          14.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //
            ],
          ),
        ),
      ),
    );
  }

  //
  //
  signInViaFirebase() async {
    try {
      UserCredential customUserCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: contEmail.text, password: contPassword.text);
      // return customUserCredential.user!.uid;
      if (kDebugMode) {
        print(customUserCredential);
      }
      //
      Navigator.pop(context);
      //
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DialogScreen(),
        ),
      );
      //
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
        print(e.message);
      }

      customException(e.message);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        // print(e);
      }
    }
  }

  //
  customException(errorMessageIs) {
    //
    Navigator.pop(context);
    //
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: navigationColor,
        content: textWithBoldStyle(
          //
          errorMessageIs.toString(),
          //
          Colors.white,
          14.0,
        ),
      ),
    );
  }
}

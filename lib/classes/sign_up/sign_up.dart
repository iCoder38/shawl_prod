import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

import '../Utils/utils.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

// import 'package:flutter_email_sender/flutter_email_sender.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //
  final formKey = GlobalKey<FormState>();
  late final TextEditingController contName;
  late final TextEditingController contEmail;
  late final TextEditingController contPassword;
  //
  final random = Random();
  //
  @override
  void initState() {
    //
    contName = TextEditingController();
    contEmail = TextEditingController();
    contPassword = TextEditingController();
    //
    sendOTPviaEmailInXMPP();
    //
    super.initState();
  }

  @override
  void dispose() {
    //
    contName.dispose();
    contEmail.dispose();
    contPassword.dispose();
    //

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithBoldStyle(
          'Create an account',
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
                Navigator.pop(context);
              },
              onTapDown: () => HapticFeedback.vibrate(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
      backgroundColor: const Color.fromRGBO(
        254,
        248,
        224,
        1,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                      'Name',
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
                  controller: contName,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
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
                  keyboardType: TextInputType.emailAddress,
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
                height: 10,
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
                    color: Colors.lightBlueAccent,

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
                        funcSignUpAccount();

                        //
                      }
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
              const SizedBox(
                height: 20,
              ),
              //
              SizedBox(
                height: 60,
                width: 200,
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
                      Navigator.pop(context);
                    },
                    onTapDown: () => HapticFeedback.vibrate(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_back,
                              size: 20.0,
                            ),
                            textWithBoldStyle(
                              'Sign In',
                              Colors.black,
                              14.0,
                            ),
                          ],
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
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: textWithRegularStyle(
                    'Please enter your registered E-mail address. We only get your Email for Security purpose only. We will not share any type of your data to anyone. Your all data is all Safe and Secured with us.\n\nCheers :) Feel free and chat anonymously.',
                    Colors.grey,
                    12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  //
  funcSignUpAccount() async {
    try {
      UserCredential customUserCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: contEmail.text, password: contPassword.text);

      successCreateAccount(customUserCredential);

      return customUserCredential.user!.uid;
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

  successCreateAccount(userDetails) async {
    if (kDebugMode) {
      print('============ USER ACCOUNT DETAILS================');
      print(userDetails);
      print('=================================================');
    }
    //
    // var plainText = contName.text;
    // final key = encrypt.Key.fromUtf8('my 32 length key................');
    // final iv = encrypt.IV.fromLength(16);
    // // final encrypted = encrypt.Encrypter(AES(key));
    // final encrypter = Encrypter(AES(key));
    // //
    // final encrypted = encrypter.encrypt(plainText, iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
    // if (kDebugMode) {
    //   // final encrypted = encrypter.encrypt(plainText, iv: iv);
    //   // final decrypted = encrypter.decrypt(encrypted, iv: iv);

    //   print(decrypted);
    //   print(encrypted.base64);
    // }

    FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value) => {
          // AFTER SENT EMAIL VERIFICATIOIN THEN UPDATE NAME
          FirebaseAuth.instance.currentUser!
              // .updateDisplayName(encrypted.base64.toString())
              .updateDisplayName(contName.text)
              .then((value) => {
                    // create user in DB
                    funcCreateUserNowInXMPP(),
                  }),
        });

    //
  }

  funcCreateUserNowInXMPP() {
    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}user/India/details',
    );

    users
        .add(
          {
            'user_firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'user_firebase_name':
                FirebaseAuth.instance.currentUser!.displayName,
            'user_firebase_email': FirebaseAuth.instance.currentUser!.email,
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'id_card_number': get6DigitNumber(),
            'active': 'yes'
          },
        )
        .then((value) => {
              // print(value.id),
              funcEditFirestoreIdInRegistration(value.id),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: navigationColor,
                  content: textWithBoldStyle(
                    //
                    'Failed to add. Please try again after sometime.'
                        .toString(),
                    //
                    Colors.white,
                    14.0,
                  ),
                ),
              ),
            });
  }

  //
  funcEditFirestoreIdInRegistration(elementId) {
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}user')
        .doc('India')
        .collection('details')
        .doc(elementId)
        .set(
      {
        'firestore_id': elementId,
      },
      SetOptions(merge: true),
    ).then(
      (value) {
        if (kDebugMode) {
          print('value 1.0');
        }
        //
        funcSuccessMessageAfterCompleteAllRegistrationInXMPP();
        //
      },
    );
  }

  //
  funcSuccessMessageAfterCompleteAllRegistrationInXMPP() {
    //
    // var emailAuth = 'someemail@domain.com';
    // FirebaseAuth.instance
    //     .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs)
    //     .catchError(
    //         (onError) => print('Error sending email verification $onError'))
    //     .then((value) => print('Successfully sent email verification'));

    Navigator.pop(context);
    Navigator.pop(context);
    //
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.lightBlueAccent,
        content: textWithBoldStyle(
          //
          'Successfully Created.'.toString(),
          //
          Colors.white,
          14.0,
        ),
      ),
    );
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

  //
  sendOTPviaEmailInXMPP() async {
    //

// exports.sendWelcomeEmail = functions.auth.user().onCreate((user) => {
//   // ...
// });

    // FirebaseFirestore.instance.collection('').add({
    //   to:[''],
    //   template: {
    //   name: "subscribe",
    // },
    // });

    //
  }
  //
}

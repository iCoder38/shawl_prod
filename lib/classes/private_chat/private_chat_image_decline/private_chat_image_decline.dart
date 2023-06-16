// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/utils.dart';

class PrivateChatImageDeclineScreen extends StatefulWidget {
  const PrivateChatImageDeclineScreen(
      {super.key, this.getPrivateChatDataDecline});

  final getPrivateChatDataDecline;

  @override
  State<PrivateChatImageDeclineScreen> createState() =>
      _PrivateChatImageDeclineScreenState();
}

class _PrivateChatImageDeclineScreenState
    extends State<PrivateChatImageDeclineScreen> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.only(
          left: 40,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              16,
            ),
            bottomLeft: Radius.circular(
              16,
            ),
            topRight: Radius.circular(
              16,
            ),
          ),
          color: Colors.redAccent,
        ),
        padding: const EdgeInsets.all(
          16,
        ),
        child: textWithRegularStyleLeft(
          //
          widget.getPrivateChatDataDecline['message'].toString(),
          //
          16.0,
          Colors.white,
          'right',
        ),
      ),
    );
  }
}

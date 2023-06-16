// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../../../Utils/utils.dart';

class PrivateChatReceiverImageDeclineScreen extends StatefulWidget {
  const PrivateChatReceiverImageDeclineScreen({
    super.key,
    this.privateChatReceiverImageDecline,
  });

  final privateChatReceiverImageDecline;

  @override
  State<PrivateChatReceiverImageDeclineScreen> createState() =>
      _PrivateChatReceiverImageDeclineScreenState();
}

class _PrivateChatReceiverImageDeclineScreenState
    extends State<PrivateChatReceiverImageDeclineScreen> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.only(
          right: 40,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              16,
            ),
            bottomRight: Radius.circular(
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
          widget.privateChatReceiverImageDecline['message'].toString(),
          //
          16.0,
          Colors.white,
          'left',
        ),
      ),
    );
  }
}

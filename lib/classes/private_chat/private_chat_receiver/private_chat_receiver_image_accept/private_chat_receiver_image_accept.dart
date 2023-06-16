import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utils/utils.dart';

class PrivateChatReceiverImageAcceptScreen extends StatefulWidget {
  const PrivateChatReceiverImageAcceptScreen(
      {super.key, this.privateChatReceiverImageAccept});

  final privateChatReceiverImageAccept;

  @override
  State<PrivateChatReceiverImageAcceptScreen> createState() =>
      _PrivateChatReceiverImageAcceptScreenState();
}

class _PrivateChatReceiverImageAcceptScreenState
    extends State<PrivateChatReceiverImageAcceptScreen> {
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
          color: Colors.greenAccent,
        ),
        padding: const EdgeInsets.all(
          16,
        ),
        child: textWithRegularStyleLeft(
          //
          widget.privateChatReceiverImageAccept['message'].toString(),
          //
          14.0,
          Colors.black,
          'left',
        ),
      ),
    );
  }
}

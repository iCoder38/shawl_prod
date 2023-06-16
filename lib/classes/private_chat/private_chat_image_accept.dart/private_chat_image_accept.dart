// ignore_for_file: prefer_typing_uninitialized_variables

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/utils.dart';

class PrivateChatImageAcceptScreen extends StatefulWidget {
  const PrivateChatImageAcceptScreen(
      {super.key, this.getPrivateChatDataAccept});

  final getPrivateChatDataAccept;

  @override
  State<PrivateChatImageAcceptScreen> createState() =>
      _PrivateChatImageAcceptScreenState();
}

class _PrivateChatImageAcceptScreenState
    extends State<PrivateChatImageAcceptScreen> {
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
          color: Colors.greenAccent,
        ),
        padding: const EdgeInsets.all(
          16,
        ),
        child: textWithRegularStyleLeft(
          //
          widget.getPrivateChatDataAccept['message'].toString(),
          //
          16.0,
          Colors.black,
          'right',
        ),
      ),
    );
  }
}

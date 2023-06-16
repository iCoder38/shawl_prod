import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/utils.dart';

class TimeStampIntoTime extends StatefulWidget {
  const TimeStampIntoTime({super.key, this.getDataForTime});

  final getDataForTime;

  @override
  State<TimeStampIntoTime> createState() => _TimeStampIntoTimeState();
}

class _TimeStampIntoTimeState extends State<TimeStampIntoTime> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: textWithRegularStyleLeft(
        // getSnapshot[index]['time_stamp'].toString(),
        // '123',
        funcConvertTimeStampToDateAndTime(
          //
          widget.getDataForTime['time_stamp'],
          //
        ),
        12.0,
        Colors.black,
        'left',
      ),
    );
  }
}

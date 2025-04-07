import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NeomorphicDatetimePicker extends StatefulWidget {
  final String hintText;
  final Function updateValue;
  final double width;
  final bool isTimePicker;

  NeomorphicDatetimePicker({
    Key key,
    @required this.hintText,
    @required this.updateValue,
    @required this.width,
    this.isTimePicker = false,
  }) : super(key: key);

  @override
  _NeomorphicDatetimePickerState createState() => _NeomorphicDatetimePickerState();
}

class _NeomorphicDatetimePickerState extends State<NeomorphicDatetimePicker> {
  String text = "";
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !widget.isTimePicker
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

              final splittedDate = date.toString().split(" ")[0].split("-");
              //final formattedDate = splittedDate[2] + "/" + splittedDate[1] + "/" + splittedDate[0];
              final formattedDate = DateFormat('dd-MMM-yyyy').format(date);
              setState(() {
                text = formattedDate.toString();
              });
              widget.updateValue(date.toIso8601String());
            }
          : () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              setState(() {
                text = time.format(context);
              });
              widget.updateValue(time.format(context));
            },
      child: Container(
        width: this.widget.width,
        margin: EdgeInsets.symmetric(
          vertical: 5,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black26,
              offset: Offset.fromDirection(Math.pi * .5, 4),
            ),
          ],
        ),
        child: Text(
          (text?.length ?? 0) > 0 ? text : widget.hintText,
          style: (text?.length ?? 0) > 0
              ? TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                )
              : TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
        ),
      ),
    );
  }
}

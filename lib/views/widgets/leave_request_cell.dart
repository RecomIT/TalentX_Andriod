import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class LeaveRequestCell extends StatelessWidget {
  final bool isDark;
  final bool isLeftRounded;
  final bool isRightRounded;
  final String text;

  const LeaveRequestCell({
    Key key,
    @required this.text,
    this.isDark = false,
    this.isLeftRounded = false,
    this.isRightRounded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 31.5,

      decoration: BoxDecoration(
        color: isDark ? kPrimaryColor : Color(0xfff3f3f3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isLeftRounded ? 12 : 0),
          bottomLeft: Radius.circular(isLeftRounded ? 12 : 0),
          topRight: Radius.circular(isRightRounded ? 12 : 0),
          bottomRight: Radius.circular(isRightRounded ? 12 : 0),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5,
      ),
      margin: EdgeInsets.only(
        bottom: 2,
        right: 2,
      ),
      child: Center(
        child: Text(
          text ?? " ",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

AppBar getFlatAppBar(
  BuildContext context,
  String userName,
  String userRole, {
  Widget leadingIcon,
  Function onTapLeadingIcon,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: kPrimaryColor,
    automaticallyImplyLeading: false,
    // leading: Padding(padding: EdgeInsets.only(left:8),
    //   child: InkWell(
    //     onTap: onTapLeadingIcon ?? () => Navigator.of(context).pop(),
    //     child: leadingIcon ?? Icon(Icons.arrow_back_ios),
    //   ),
    // ),
    title: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      //SizedBox(width: 35),
      Image.asset(
        'assets/images/talent-x.png',
        fit: BoxFit.contain,
        height: 24,
        color: Colors.white,
      ),
    ],
  ),

    actions: [
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back !!!\n$userName',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' v 1.4.11',//userRole,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
       Padding(
        padding: EdgeInsets.fromLTRB(10,0 ,5,0),
        child: InkWell(
          onTap: onTapLeadingIcon ?? () => Navigator.of(context).pop(),
          child: leadingIcon ?? Icon(Icons.wrap_text_rounded,), //arrow_back_ios ,home_outlined,arrow_back
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 15,
          top: 5,
          bottom: 5,
        ),
        child: Container(
            // width: 45,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.all(Radius.circular(30)),
            // ),
            ),
      ),
    ],
  );
}

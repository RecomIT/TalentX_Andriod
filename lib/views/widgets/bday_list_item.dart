import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constants.dart';

class BirthdayListItem extends StatelessWidget {
  final String photo;
  final String name;
  final String designation;
  final String department;
  final String phone;

  const BirthdayListItem({
    Key key,
    @required this.photo,
    @required this.name,
    @required this.designation,
    @required this.department,
    @required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            child: this.photo == null || this.photo.length < 256
                ? Container(
                    height: 45,
                    width: 45,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.black54,
                    ),
                  )
                : Container(
                    height: 45,
                    width: 45,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: MemoryImage(base64Decode(this.photo)),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 5),
                Text(
                  department,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  designation,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 2),
                InkWell(
                  onTap: () async {
                    //print('CLICKED $phone');
                    var url = 'tel://$phone';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    'Phone : $phone',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                ),

              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.18,
            child: SvgPicture.asset("assets/icons/bday_cake.svg",width: 45,),

          ),
        ],
      ),
    );
  }
}

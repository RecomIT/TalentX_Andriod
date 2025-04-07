import 'dart:convert';

import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class EventListItem extends StatelessWidget {
  final String photo;
  final String name;
  final String details;
  final String date;
  const EventListItem({
    Key key,
    @required this.photo,
    @required this.name,
    @required this.details,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.23,
            child: Column(
              children: [
                this.photo == null || (this.photo?.length ?? 0) < 256
                    ? Container(
                        height: 45,
                        width: 45,
                        // margin: EdgeInsets.symmetric(horizontal: 10),
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
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                SizedBox(height: 5),
                Text(
                  date.split("T")[0],
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  details,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

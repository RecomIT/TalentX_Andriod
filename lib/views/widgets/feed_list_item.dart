import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class FeedListItem extends StatelessWidget {
  final String title;
  final String description;
  final String start;
  final String end;
  // final Function onTapFunction;
  const FeedListItem({
    Key key,
    @required this.title,
    @required this.description,
    @required this.start,
    @required this.end,
    // @required this.onTapFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.58,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? " ",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 5),
                Text(
                  (start ?? " ") + " - " + (end ?? " "),
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description ?? " ",
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.2,
          //   child: InkWell(
          //     onTap: onTapFunction ?? () {},
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Text(
          //           "See Summary",
          //           style: TextStyle(
          //             fontSize: 9,
          //             fontWeight: FontWeight.bold,
          //             color: kPrimaryColor,
          //           ),
          //         ),
          //         Icon(
          //           Icons.arrow_forward_ios,
          //           color: kPrimaryColor,
          //           size: 9,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class SchedulerRequestItem extends StatelessWidget {
  final String title;
  final String description;
  final Function onApprove;
  final Function onReject;
  const SchedulerRequestItem({
    Key key,
    @required this.title,
    @required this.description,
    @required this.onApprove,
    @required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 5),
                Text(
                  description ?? " ",
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  visualDensity: VisualDensity.compact,
                  onPressed: onApprove ?? () {},
                  color: kPrimaryColor,
                  child: Text(
                    "Approve",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  visualDensity: VisualDensity.compact,
                  onPressed: onReject ?? () {},
                  color: kPrimaryColor,
                  child: Text(
                    "Reject",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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

import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class LeaveRequestItem extends StatelessWidget {
  final String title;
  final String description;
  final String attachment;
  final Function onApprove;
  final Function onReject;
  final Function onTab;
  const LeaveRequestItem({
    Key key,
    @required this.title,
    @required this.description,
    @required this.attachment,
    @required this.onApprove,
    @required this.onReject,
    @required this.onTab,
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
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 5),
                Text(
                  description ?? " ",
                  maxLines: 25,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                  ),
                ),

                SizedBox(height: 3),
                Text(
                  //attachment !='N/A' ? attachment : 'Attachment : Download',
                  'Attachment',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.bold
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  visualDensity: VisualDensity.compact,
                  onPressed: !attachment.contains('N/A') ? onTab : null,
                  color: kPrimaryColor,
                  child: Text(
                    "Download",
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

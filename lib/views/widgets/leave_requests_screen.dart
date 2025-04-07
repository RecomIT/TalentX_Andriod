import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recom_app/data/models/leave_request_list.dart';
import 'package:recom_app/data/models/scheduler_request_data.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/views/widgets/scheduler_request_item.dart';

import '../../data/models/all_leave_report.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import 'custom_table.dart';
import 'leave_request_item.dart';
import 'neomorphic_text_form_field.dart';

class LeaveRequestsScreen extends StatefulWidget {
   LeaveRequestsScreen({
    Key key,
     this.scaffoldKey,
     this.apiService,
     this.currentUser,
   }) : super(key: key);

   final GlobalKey<ScaffoldState> scaffoldKey;
   final ApiService apiService;
   final User currentUser;

   List<LeaveRequest> _leaveReqList;


   @override
  _LeaveRequestsScreenState createState() => _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends State<LeaveRequestsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black12,
            offset: Offset.fromDirection(Math.pi * .5, 10),
          )
        ],
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: FutureBuilder<LeaveRequestList>(
          future: widget.apiService.getWaitingForApprovalLeaveRequestList(),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              widget._leaveReqList = snapshot.data.leaveRequests.where((e) => e.status=='pending').toList();
              //print(widget._leaveReqList.first.leaveId);
              if(widget._leaveReqList.length==0){
                return Text(
                  "No Pending Requests for Approval", //No Pending Requests for Approval
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                );
              }
              else{
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    (widget._leaveReqList?.length ?? 0) + 1,
                        (idx) {
                      if (idx == 0) {
                        return Text(
                          "Pending Requests \n", //No Pending Requests for Approval
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        );
                      } else
                        return Column(
                          children: [
                            LeaveRequestItem(
                              title: widget._leaveReqList[idx - 1].empName,
                              description:
                                  'Type : ' + widget._leaveReqList[idx - 1].leaveType +
                                  '\nFrom : ' + widget._leaveReqList[idx - 1].fromDate +
                                  '\nTo : ' + widget._leaveReqList[idx - 1].toDate +
                                   '\nTotalDay(s) : ' + widget._leaveReqList[idx - 1].totalDays.toString() +
                                  '\nStatus : ' + widget._leaveReqList[idx - 1].status +
                                  '\nDescription : ' + widget._leaveReqList[idx - 1].leaveDescription,
                              attachment: 'Attachment : '+ widget._leaveReqList[idx - 1].leaveDocument,

                              onTab: () async {
                                var status = await Permission.storage.status;
                                if (!status.isGranted) {
                                  status = await Permission.storage.request();
                                  if (!status.isGranted) {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message: "Please allow storage permission!",
                                      fillColor: Colors.red,
                                    );
                                    return;
                                  }
                                }

                                try {
                                  Directory appDocDir;
                                  if(Platform.isAndroid){
                                    appDocDir = Directory("/storage/emulated/0/Download");
                                  }
                                  else if(Platform.isIOS){
                                    appDocDir = await getApplicationDocumentsDirectory();
                                  }
                                  final pdfFile = File("${appDocDir.path}/${widget._leaveReqList[idx - 1].leaveDocument}");

                                  if (!pdfFile.existsSync()) {
                                    bool downloaded = await widget.apiService.getLeaveAttachment(widget._leaveReqList[idx - 1].leaveId.toString(), pdfFile.path);
                                    if (!downloaded) {
                                      showSnackBarMessage(
                                        scaffoldKey: widget.scaffoldKey,
                                        message:
                                        "Sorry, could not downloaded.!",
                                        fillColor: Colors.red,
                                      );
                                      return;
                                    }
                                  }

                                  if (pdfFile.existsSync()) {
                                    await OpenFile.open(pdfFile.path);
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message:
                                      "Sorry, failed to open file  Please check your premissions network and connectivity!file!",
                                      fillColor: Colors.red,
                                    );
                                  }

                                } catch (e) {
                                  showSnackBarMessage(
                                    scaffoldKey: widget.scaffoldKey,
                                    message:
                                    "Sorry, failed to open file  Please check your premissions network and connectivity!file!",
                                    fillColor: Colors.red,
                                  );
                                }
                              },
                              onApprove: () async {
                                try {
                                  final response = await widget.apiService.approvelLeave(widget._leaveReqList[idx - 1].leaveId);
                                  if (response.statusCode == 200) {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message: "Approved Leave Request!",
                                      fillColor: Colors.green,
                                    );
                                    setState(() {
                                      widget._leaveReqList.removeWhere(
                                              (sr) => sr.leaveId == widget._leaveReqList[idx - 1].leaveId);
                                    });
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message: response.data["message"],
                                      fillColor: Colors.red,
                                    );
                                  }
                                } catch (ex) {
                                  showSnackBarMessage(
                                    scaffoldKey: widget.scaffoldKey,
                                    message: "Failed to approve leave request!",
                                    fillColor: Colors.red,
                                  );
                                }
                              },
                              onReject: () async {
                                try {
                                  final response = await widget.apiService.cancelLeave(widget._leaveReqList[idx - 1].leaveId);
                                  if (response.statusCode == 200) {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message: "Rejected Leave Request!",
                                      fillColor: Colors.green,
                                    );
                                    setState(() {
                                      widget._leaveReqList.removeWhere(
                                              (sr) => sr.leaveId == widget._leaveReqList[idx - 1].leaveId);
                                    });
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message: response.data["message"],
                                      fillColor: Colors.red,
                                    );
                                  }
                                } catch (ex) {
                                  showSnackBarMessage(
                                    scaffoldKey: widget.scaffoldKey,
                                    message: "Failed to reject leave request!",
                                    fillColor: Colors.red,
                                  );
                                }
                              },
                            ),
                            idx < widget._leaveReqList?.length ? Divider() : SizedBox(),
                          ],
                        );
                    },
                  ),
                );
              }

            } else if (snapshot.hasError) {
              return SizedBox();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}




// import 'package:flutter/material.dart';
//
// import '../../utils/constants.dart';
//
// class SchedulerRequestItem extends StatelessWidget {
//   final String title;
//   final String description;
//   final Function onApprove;
//   final Function onReject;
//   const SchedulerRequestItem({
//     Key key,
//     @required this.title,
//     @required this.description,
//     @required this.onApprove,
//     @required this.onReject,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             width: MediaQuery.of(context).size.width * 0.58,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title ?? " ",
//                   style: TextStyle(
//                     color: kPrimaryColor,
//                     fontSize: 9,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 2,
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   description ?? " ",
//                   maxLines: 2,
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontSize: 9,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: MediaQuery.of(context).size.width * 0.2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 RaisedButton(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(7)),
//                   ),
//                   visualDensity: VisualDensity.compact,
//                   onPressed: onApprove ?? () {},
//                   color: kPrimaryColor,
//                   child: Text(
//                     "Approve",
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 RaisedButton(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(7)),
//                   ),
//                   visualDensity: VisualDensity.compact,
//                   onPressed: onReject ?? () {},
//                   color: kPrimaryColor,
//                   child: Text(
//                     "Reject",
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

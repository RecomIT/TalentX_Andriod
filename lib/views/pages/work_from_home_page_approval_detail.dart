import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/resignation_awaiting.dart';
import 'package:recom_app/data/models/resignation_details.dart';
import 'package:recom_app/data/models/work_from_home_awaiting.dart';
import 'package:recom_app/data/models/work_from_home_details.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';
import  '../../services/helper/string_extension.dart';

class WorkFromHomePageApprovalDetail extends StatefulWidget {
  final WorkFromHomeAwaiting workFromHomeAwaiting;

  const WorkFromHomePageApprovalDetail({
    Key key,
    this.workFromHomeAwaiting,
  }) : super(key: key);
  @override
  _WorkFromHomePageApprovalDetailState createState() => _WorkFromHomePageApprovalDetailState();
}

class _WorkFromHomePageApprovalDetailState extends State<WorkFromHomePageApprovalDetail> {
  User _currentUser;
  ApiService _apiService;
  bool _isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String note= 'N/A';
  bool isActionCanceled = false;
  DateFormat _dateFormat= DateFormat('E ,MMM dd,yyyy hh:mm:ss a');//('hh:mm:ss, dd-MMM-yyyy');

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.workFromHomeAwaiting == null) {
      print('workFromHomeAwaiting is null');
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final kScreenSize = MediaQuery.of(context).size;
    DateFormat dateFormatter = DateFormat('dd-MMM-yyyy');

    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
        child: (widget.workFromHomeAwaiting == null)
            ? SizedBox()
            : SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black26,
                  offset: Offset.fromDirection(Math.pi * .5, 10),
                ),
              ],
            ),
            child: FutureBuilder<WorkFromHomeDetails>(
                future: _apiService.getWorkFromHomeDetail(widget.workFromHomeAwaiting.wfhId),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    var wfhDetails = snapshot.data;
                    if(wfhDetails == null){
                      return Text('Message : No Off-Site Attendance Details Available');
                    }else{
                      return Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: (kScreenSize.width - 40) * 0.80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Off-Site Attendance Details',
                                          //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Name : ${wfhDetails.name.trim()} (${wfhDetails.code.trim()})', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),

                                        // Text(
                                        //   'Application Date : ${wfhDetails.applicationDate.trim()}', //${myResignationList[idx].applicationDate}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // SizedBox(height: 5,),
                                        Text(
                                          'Start Date : ${wfhDetails.startDate}', //${dateFormatter.format(DateTime.tryParse(wfhDetails.startDate))}', //
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Start Time : ${wfhDetails.startTime}',  //${wfhDetails.startDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'End Date : ${wfhDetails.endDate}', //${dateFormatter.format(DateTime.tryParse( wfhDetails.endDate))}', //
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'End Time : ${wfhDetails.endTime}', //${wfhDetails.endDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'No. of Days/Hours  : ${wfhDetails.numberOfDays}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Description : ${wfhDetails.description.capitalize()}',
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        // Html(data: wfhDetails.description,  //resignationDetails.description  //"<p>Hello <b>Flutter</b><p>"
                                        //     defaultTextStyle: TextStyle(fontSize: 12,color: Colors.black45,)),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Reason : ${wfhDetails.type.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'Status : ${wfhDetails.status.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Supervisor : ${wfhDetails.supervisor}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 10,),
                                        // Text(
                                        //   'Note : ${wfhDetails.note}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        //
                                        // SizedBox(height: 15,),
                                        wfhDetails.attachment != 'N/A'?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                var status = await Permission.storage.status;
                                                if (!status.isGranted) {
                                                  status = await Permission.storage.request();
                                                  if (!status.isGranted) {
                                                    showSnackBarMessage(
                                                      scaffoldKey: _scaffoldKey,
                                                      message: "Please allow storage permission!",
                                                      fillColor: Colors.red,
                                                    );
                                                    return;
                                                  }
                                                }
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                try {
                                                  Directory appDocDir;
                                                  if(Platform.isAndroid){
                                                    appDocDir = Directory("/storage/emulated/0/Download");
                                                  }
                                                  else if(Platform.isIOS){
                                                    appDocDir = await getApplicationDocumentsDirectory();
                                                  }
                                                  final pdfFile = File("${appDocDir.path}/wfh_${wfhDetails.attachment.split('/').last}");//.pdf
                                                  print(pdfFile);

                                                  if (!pdfFile.existsSync()) {
                                                    bool downloaded = await _apiService.getWFHAttachment(wfhDetails.wfhId, pdfFile.path);
                                                    if (!downloaded) {
                                                      showSnackBarMessage(
                                                        scaffoldKey: _scaffoldKey,
                                                        message:
                                                        "Sorry, No Attachment found!",
                                                        fillColor: Colors.red,
                                                      );
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      return;
                                                    }
                                                  }

                                                  if (pdfFile.existsSync()) {
                                                    await OpenFile.open(pdfFile.path);
                                                    print('-------------Attachment Opened------------');
                                                  } else {
                                                    showSnackBarMessage(
                                                      scaffoldKey: _scaffoldKey,
                                                      message:
                                                      "Sorry, failed to open Attachment  Please check your permissions network and connectivity!file!",
                                                      fillColor: Colors.red,
                                                    );
                                                  }

                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                } catch (e) {
                                                  showSnackBarMessage(
                                                    scaffoldKey: _scaffoldKey,
                                                    message:
                                                    "Sorry, failed to open Attachment  Please check your permissions network and connectivity!file!",
                                                    fillColor: Colors.red,
                                                  );
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                }
                                              },
                                              // onTap: () async {
                                              //   // print('Download CLICKED');
                                              //   //var url = 'http://staging.hrmisbd.com/storage/' + wfhDetails.attachment;
                                              //   var url = 'https://talentx.shopf.co/storage/' + wfhDetails.attachment;
                                              //   print(url);
                                              //   if (await canLaunch(
                                              //       url)) {
                                              //     await launch(url);
                                              //   } else {
                                              //     showSnackBarMessage(
                                              //       scaffoldKey: _scaffoldKey,
                                              //       message: "No Attachment Available!",
                                              //       fillColor: Colors.red,
                                              //     );
                                              //   }
                                              // },
                                              child: Container(
                                                margin: EdgeInsets.only(right: 5),
                                                width: 80,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(7),
                                                    ),
                                                    //color: kPrimaryColor,
                                                    border: Border.all(color: kPrimaryColor)
                                                ),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.download_rounded,
                                                      color: kPrimaryColor,//Colors.white,
                                                    ),
                                                    Text(
                                                      "Attachment",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10,
                                                        color: kPrimaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ):
                                        Container(),
                                        SizedBox(height: 20,),
                                        _isLoading ? Center(child: CircularProgressIndicator()):Container(),

                                        SizedBox(height: 10,),
                                        // wfhDetails.status.toLowerCase().contains('pending')  ?
                                        // Row(
                                        //   children: [
                                        //     ElevatedButton(
                                        //       style: ElevatedButton.styleFrom(
                                        //           primary: kPrimaryColor
                                        //       ),
                                        //       onPressed: () async {
                                        //         await showDialog(
                                        //             barrierDismissible: false,
                                        //             context: context,
                                        //             builder: (BuildContext context) {
                                        //               return  addNotesDialogBox(context);
                                        //             });
                                        //
                                        //         if(isActionCanceled){
                                        //           isActionCanceled=false;
                                        //           return;
                                        //         }
                                        //         setState(() {
                                        //           _isLoading = true;
                                        //         });
                                        //         try {
                                        //           final response = await _apiService.approveRejectWFHRequest(widget.workFromHomeAwaiting.wfhId.toString(),note,'approved');
                                        //           if (response.statusCode == 200) {
                                        //             setState(() {
                                        //               _isLoading = false;
                                        //             });
                                        //             showDialog(
                                        //               context: context,
                                        //               builder: (BuildContext context) {
                                        //                 return AlertDialog(
                                        //                   title: Text("Successfully"),
                                        //                   content: Text("Successfully Approved Request!"),
                                        //                   actions: [
                                        //                     FlatButton(
                                        //                       child: new Text("OK"),
                                        //                       onPressed: () {
                                        //                         Navigator.of(context).pop();
                                        //                         Navigator.of(context).pushNamed(WORK_FROM_HOME_PAGE,arguments:WorkFromHomePageScreen.WorkFromHomeAwaitingApproval);
                                        //                       },
                                        //                     ),
                                        //                   ],
                                        //                 );
                                        //               },
                                        //             );
                                        //
                                        //           } else {
                                        //             setState(() {
                                        //               _isLoading = false;
                                        //             });
                                        //             showSnackBarMessage(
                                        //               scaffoldKey: _scaffoldKey,
                                        //               message: response.data["message"],
                                        //               fillColor: Colors.red,
                                        //             );
                                        //           }
                                        //         } catch (ex) {
                                        //           setState(() {
                                        //             _isLoading = false;
                                        //           });
                                        //           showSnackBarMessage(
                                        //             scaffoldKey: _scaffoldKey,
                                        //             message: "Failed to Approve request!",
                                        //             fillColor: Colors.red,
                                        //           );
                                        //         }
                                        //       },
                                        //       child: Text('Approve'),
                                        //     ),
                                        //     SizedBox(width: 10,),
                                        //     OutlinedButton(
                                        //       style: OutlinedButton.styleFrom(
                                        //           primary: kPrimaryColor
                                        //       ),
                                        //       onPressed: () async {
                                        //         await showDialog(
                                        //             barrierDismissible: false,
                                        //             context: context,
                                        //             builder: (BuildContext context) {
                                        //               return  addNotesDialogBox(context);
                                        //             });
                                        //
                                        //         if(isActionCanceled){
                                        //           isActionCanceled=false;
                                        //           return;
                                        //         }
                                        //         setState(() {
                                        //           _isLoading = true;
                                        //         });
                                        //         try {
                                        //           final response = await _apiService.approveRejectWFHRequest(widget.workFromHomeAwaiting.wfhId.toString(),note,'rejected');
                                        //           if (response.statusCode == 200) {
                                        //             setState(() {
                                        //               _isLoading = false;
                                        //             });
                                        //             showDialog(
                                        //               context: context,
                                        //               builder: (BuildContext context) {
                                        //                 return AlertDialog(
                                        //                   title: Text("Successfully"),
                                        //                   content: Text("Successfully Rejected Request!"),
                                        //                   actions: [
                                        //                     FlatButton(
                                        //                       child: new Text("OK"),
                                        //                       onPressed: () {
                                        //                         Navigator.of(context).pop();
                                        //                         Navigator.of(context).pushNamed(WORK_FROM_HOME_PAGE,arguments:WorkFromHomePageScreen.WorkFromHomeAwaitingApproval);
                                        //                       },
                                        //                     ),
                                        //                   ],
                                        //                 );
                                        //               },
                                        //             );
                                        //
                                        //           } else {
                                        //             setState(() {
                                        //               _isLoading = false;
                                        //             });
                                        //             showSnackBarMessage(
                                        //               scaffoldKey: _scaffoldKey,
                                        //               message: response.data["message"],
                                        //               fillColor: Colors.red,
                                        //             );
                                        //           }
                                        //         } catch (ex) {
                                        //           setState(() {
                                        //             _isLoading = false;
                                        //           });
                                        //           showSnackBarMessage(
                                        //             scaffoldKey: _scaffoldKey,
                                        //             message: "Failed to Reject request!",
                                        //             fillColor: Colors.red,
                                        //           );
                                        //         }
                                        //       },
                                        //       child: Text('Reject'),
                                        //     ),
                                        //     SizedBox(width: 10,),
                                        //     // ElevatedButton(
                                        //     //   style: ElevatedButton.styleFrom(
                                        //     //       primary: Colors.red
                                        //     //   ),
                                        //     //   onPressed: () async {
                                        //     //     await showDialog(
                                        //     //         barrierDismissible: false,
                                        //     //         context: context,
                                        //     //         builder: (BuildContext context) {
                                        //     //           return  addNotesDialogBox(context);
                                        //     //         });
                                        //     //
                                        //     //     if(isActionCanceled){
                                        //     //       isActionCanceled=false;
                                        //     //       return;
                                        //     //     }
                                        //     //     setState(() {
                                        //     //       _isLoading = true;
                                        //     //     });
                                        //     //     try {
                                        //     //       final response = await _apiService.rejectResignationRequest(widget.resignationAwaiting.rememberToken,note);
                                        //     //       if (response.statusCode == 200) {
                                        //     //         setState(() {
                                        //     //           _isLoading = false;
                                        //     //         });
                                        //     //         showDialog(
                                        //     //           context: context,
                                        //     //           builder: (BuildContext context) {
                                        //     //             return AlertDialog(
                                        //     //               title: Text("Successfully"),
                                        //     //               content: Text("Successfully Reject Resignation Request!"),
                                        //     //               actions: [
                                        //     //                 FlatButton(
                                        //     //                   child: new Text("OK"),
                                        //     //                   onPressed: () {
                                        //     //                     Navigator.of(context).pop();
                                        //     //                     Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationAwaitingApproval);
                                        //     //                   },
                                        //     //                 ),
                                        //     //               ],
                                        //     //             );
                                        //     //           },
                                        //     //         );
                                        //     //
                                        //     //       } else {
                                        //     //         setState(() {
                                        //     //           _isLoading = false;
                                        //     //         });
                                        //     //         showSnackBarMessage(
                                        //     //           scaffoldKey: _scaffoldKey,
                                        //     //           message: response.data["message"],
                                        //     //           fillColor: Colors.red,
                                        //     //         );
                                        //     //       }
                                        //     //     } catch (ex) {
                                        //     //       setState(() {
                                        //     //         _isLoading = false;
                                        //     //       });
                                        //     //       showSnackBarMessage(
                                        //     //         scaffoldKey: _scaffoldKey,
                                        //     //         message: "Failed to reject Resignation request!",
                                        //     //         fillColor: Colors.red,
                                        //     //       );
                                        //     //     }
                                        //     //   },
                                        //     //   child: Text('Reject'),
                                        //     // ),
                                        //   ],
                                        // ) :
                                        // Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }

                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
      ),
    );
  }

  AlertDialog addNotesDialogBox(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25),
      title: Container(
        decoration: new BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                child: Text(
                  "Add Note",
                  style: TextStyle(color: Colors.white),
                )),
            InkResponse(
              onTap: () {
                note='N/A';
                isActionCanceled = true;
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                radius: 14,
                child: Icon(
                  Icons.close,
                  color: Colors.grey[400],
                ),
                backgroundColor: Colors.grey[100],
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 120,
        width: 600,
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20),
              NeomorphicTextFormField(
                initVal:null,
                inputType: TextInputType.text,
                numOfMaxLines: 3,
                hintText: "Please add note here..",
                fontSize: 12,
                onChangeFunction: (String value) {
                  note = value.trim();
                  //print('note : ' + note);
                },
              ),

            ],
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  note='N/A';
                  isActionCanceled = true;
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 10,),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  "Send",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  isActionCanceled = false;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),

      ],
    );
  }

}

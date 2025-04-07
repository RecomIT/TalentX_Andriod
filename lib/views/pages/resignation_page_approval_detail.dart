import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/resignation_awaiting.dart';
import 'package:recom_app/data/models/resignation_details.dart';
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

class ResignationPageApprovalDetail extends StatefulWidget {
  final ResignationAwaiting resignationAwaiting;

  const ResignationPageApprovalDetail({
    Key key,
    this.resignationAwaiting,
  }) : super(key: key);
  @override
  _ResignationPageApprovalDetailState createState() => _ResignationPageApprovalDetailState();
}

class _ResignationPageApprovalDetailState extends State<ResignationPageApprovalDetail> {
  User _currentUser;
  ApiService _apiService;
  bool _isLoading = false;
  bool _isPolicyVisible=false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String note= 'N/A';
  bool isActionCanceled = false;
  DateFormat _dateFormat= DateFormat('E ,MMM dd,yyyy hh:mm:ss a');//('hh:mm:ss, dd-MMM-yyyy');
  List<KeyValuePair> policyList;
  String policy;


  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.resignationAwaiting == null) {
      print('resignationAwaiting is null');
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
            (route) => false,
      );
    }
    policyList= [];
    _getPolicyList();
    //_getTravelPlanDetail();
    //_travelPlanDetail = _apiService.getTravelPlanDetail(widget.travelPlan.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final kScreenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
        child: (widget.resignationAwaiting == null)
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
            child: FutureBuilder<ResignationDetails>(
                future: _apiService.getResignationDetail(widget.resignationAwaiting.separationId),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    var resignationDetails = snapshot.data;
                    try{
                      DateFormat format = DateFormat('dd-MMM-yyyy');
                      DateTime lastworkingDate = format.parse(resignationDetails.lastWorkingDay.trim());
                      DateTime applicationDate = format.parse(resignationDetails.applicationDate.trim());
                      var noticePeriod = resignationDetails.noticePeriod;
                      var diff = lastworkingDate.difference(applicationDate).inDays + 1;
                      _isPolicyVisible = diff < noticePeriod ? true: false;
                    }catch(e){
                      _isPolicyVisible = false;
                    }

                    if(resignationDetails == null){
                      return Text('Message : No Resignation Details Available');
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
                                          'Name : ${resignationDetails.employeeName}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Date of Joining : ${resignationDetails.joiningDate}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Notice Days : ${resignationDetails.noticePeriod}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'Submission Date : ${resignationDetails.applicationDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Last Working Date : ${resignationDetails.lastWorkingDay}', //resignationEffectiveDate
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),

                                        Text(
                                          'Reason for Leaving : ${resignationDetails.leavingReason}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        // SizedBox(height: 5,),
                                        // Text(
                                        //   'Description : ${resignationDetails.description}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Description :', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Html(data: resignationDetails.description,  //resignationDetails.description  //"<p>Hello <b>Flutter</b><p>"
                                            defaultTextStyle: TextStyle(fontSize: 12,color: Colors.black45,)),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Asking for Notice Period Waive : ${resignationDetails.noticePeriodWaive== 1 ? 'YES':'N0'}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),SizedBox(height: 5,),
                                        Text(
                                          'Notice Period Policy : ${resignationDetails.noticePeriodPolicy}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Supervisor : ${resignationDetails.supervisorName}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          '2nd Line Supervisor : ${resignationDetails.seceondLineSupervisor}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'Concerning (HR) : ${resignationDetails.concerningHr}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'Status : ${resignationDetails.status.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Remarks : ${resignationDetails.separationProcesses.first.remarks.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'Processed By : ${resignationDetails.separationProcesses.first.processedBy}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                        !resignationDetails.separationProcesses.first.statusDate.toLowerCase().contains('n/a')?
                                        Text(
                                          'Processed At : ${_dateFormat.format(DateTime.tryParse(resignationDetails.separationProcesses.first.statusDate))}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ):
                                        Text(
                                          'Processed At : ${resignationDetails.separationProcesses.first.statusDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 15,),
                                        resignationDetails.attachment.length>0?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                // print('Download CLICKED');
                                                // print(resignationDetails.attachment.first.attachment);
                                                var url = resignationDetails.attachment.first.attachment ?? 'N/A';
                                                if (await canLaunch(
                                                    url)) {
                                                  await launch(url);
                                                } else {
                                                  showSnackBarMessage(
                                                    scaffoldKey: _scaffoldKey,
                                                    message: "No Attachment Available!",
                                                    fillColor: Colors.red,
                                                  );
                                                }
                                              },
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
                                            )
                                          ],
                                          // InkWell(
                                          //   onTap: () async {
                                          //     //print('Download CLICKED');
                                          //     var status = await Permission.storage.status;
                                          //     if (!status.isGranted) {
                                          //       status = await Permission.storage.request();
                                          //       if (!status.isGranted) {
                                          //         showSnackBarMessage(
                                          //           scaffoldKey: _scaffoldKey,
                                          //           message: "Please allow storage permission!",
                                          //           fillColor: Colors.red,
                                          //         );
                                          //         return;
                                          //       }
                                          //     }
                                          //
                                          //     try {
                                          //       Directory appDocDir;
                                          //                       if(Platform.isAndroid){
                                          //                         appDocDir = Directory("/storage/emulated/0/Download");
                                          //                       }
                                          //                       else if(Platform.isIOS){
                                          //                         appDocDir = await getApplicationDocumentsDirectory();
                                          //                       }
                                          //
                                          //       final pdfFile = File("${appDocDir.path}/Resignation_application_${resignationDetails.separationId}.pdf");
                                          //
                                          //       if (!pdfFile.existsSync()) {
                                          //         bool downloaded = await _apiService.getTravellPlan("", pdfFile.path); //resignationDetails.separationId.toString()
                                          //         if (!downloaded) {
                                          //           showSnackBarMessage(
                                          //             scaffoldKey: _scaffoldKey,
                                          //             message:
                                          //             "Sorry, No file available!",
                                          //             fillColor: Colors.red,
                                          //           );
                                          //           return;
                                          //         }
                                          //       }
                                          //
                                          //       if (pdfFile.existsSync()) {
                                          //         await OpenFile.open(pdfFile.path);
                                          //       } else {
                                          //         showSnackBarMessage(
                                          //           scaffoldKey: _scaffoldKey,
                                          //           message:
                                          //           "Sorry, failed to open file  Please check your premissions network and connectivity!file!",
                                          //           fillColor: Colors.red,
                                          //         );
                                          //       }
                                          //
                                          //     } catch (e) {
                                          //       showSnackBarMessage(
                                          //         scaffoldKey: _scaffoldKey,
                                          //         message:
                                          //         "Sorry, failed to open file  Please check your premissions network and connectivity!file!",
                                          //         fillColor: Colors.red,
                                          //       );
                                          //     }
                                          //   },
                                          //   child: Container(
                                          //     width: 80,
                                          //     padding: EdgeInsets.symmetric(
                                          //       horizontal: 5,
                                          //       vertical: 2,
                                          //     ),
                                          //     decoration: BoxDecoration(
                                          //         borderRadius: BorderRadius.all(
                                          //           Radius.circular(7),
                                          //         ),
                                          //         //color: kPrimaryColor,
                                          //         border: Border.all(color: kPrimaryColor)
                                          //     ),
                                          //     child: Column(
                                          //       children: [
                                          //         Icon(
                                          //           Icons.download_rounded,
                                          //           color: kPrimaryColor,//Colors.white,
                                          //         ),
                                          //         Text(
                                          //           "Attachment",
                                          //           style: TextStyle(
                                          //             fontWeight: FontWeight.bold,
                                          //             fontSize: 10,
                                          //             color: kPrimaryColor,
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                        ):
                                        Container(),
                                        _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
                                        SizedBox(height: 10,),
                                        resignationDetails.status.toLowerCase().contains('pending')  ?
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: kPrimaryColor
                                              ),
                                              onPressed: () async {
                                                await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter setState){
                                                            return AlertDialog(
                                                              contentPadding: EdgeInsets.only(left: 10, right: 10),
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
                                                                    SizedBox(height: 10,),
                                                                    InkResponse(
                                                                      onTap: () {
                                                                        note='N/A';
                                                                        policy=null;
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
                                                                height: 250,
                                                                width: 600,
                                                                child: Container(
                                                                  child: Column(
                                                                    children: [
                                                                      SizedBox(height: 10,),
                                                                      _isPolicyVisible ?
                                                                      Container(
                                                                        padding: EdgeInsets.only(
                                                                          left: 7,
                                                                          right: 3,
                                                                          top: 10,
                                                                          bottom: 10,
                                                                        ),
                                                                        margin: EdgeInsets.only(top: 10),
                                                                        width: double.infinity,
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              blurRadius: 15,
                                                                              color: Colors.black26,
                                                                              offset: Offset.fromDirection(Math.pi * .5, 10),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child: Container(
                                                                          padding: EdgeInsets.only(
                                                                            left: 7,
                                                                            right: 3,
                                                                            top: 10,
                                                                            bottom: 10,
                                                                          ),
                                                                          margin: EdgeInsets.only(top: 10),
                                                                          width: double.infinity,
                                                                          child: DropdownButton<String>(
                                                                            isDense: false,
                                                                            underline: SizedBox(),
                                                                            value: policy,
                                                                            hint: Text('Select Notice Period Policy',
                                                                              style: TextStyle(fontSize: 12,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.grey[500]),),
                                                                            items: List<DropdownMenuItem<String>>.generate(
                                                                              (policyList?.length ?? 0) + 1,
                                                                                  (idx) =>
                                                                                  DropdownMenuItem<String>(
                                                                                    value: idx == 0 ? null : policyList[idx - 1].id,
                                                                                    child: Container(
                                                                                      width: MediaQuery
                                                                                          .of(context)
                                                                                          .size
                                                                                          .width * 0.6,
                                                                                      padding: EdgeInsets.only(left: 20),
                                                                                      child: Text(
                                                                                        idx == 0 ? "Select Notice Period Policy" : policyList[idx - 1].name,
                                                                                        style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                            ),
                                                                            onChanged: (String value) {
                                                                              setState(() {
                                                                                policy = value ?? policy;
                                                                                if(policy !=null){
                                                                                  policy=policy.trim();
                                                                                  print('Select Notice Period Policy: ' + policy);
                                                                                }
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      )
                                                                      :Container(),
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
                                                                          policy=null;
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
                                                            //return  addNotesDialogBox(context);
                                                          });
                                                    });
                                                if(isActionCanceled){
                                                  isActionCanceled=false;
                                                  return;
                                                }
                                                if (policy == null && _isPolicyVisible) {
                                                  showSnackBarMessage(
                                                    scaffoldKey: _scaffoldKey,
                                                    message: "Please Select Notice Period Policy",
                                                    fillColor: Colors.red,
                                                  );
                                                  return;
                                                }
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                try {
                                                  final response = await _apiService.
                                                  approveResignationRequest(widget.resignationAwaiting.rememberToken,note,policy);
                                                  if (response.statusCode == 200) {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text("Successfully"),
                                                            content: Text("Successfully Approved Resignation Request!"),
                                                            actions: [
                                                              FlatButton(
                                                                child: new Text("OK"),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationAwaitingApproval);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                      },
                                                    );

                                                  } else {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showSnackBarMessage(
                                                      scaffoldKey: _scaffoldKey,
                                                      message: response.data["message"],
                                                      fillColor: Colors.red,
                                                    );
                                                  }
                                                } catch (ex) {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  showSnackBarMessage(
                                                    scaffoldKey: _scaffoldKey,
                                                    message: "Failed to approve Resignation request!",
                                                    fillColor: Colors.red,
                                                  );
                                                }
                                              },
                                              child: Text('Approve'),
                                            ),
                                            SizedBox(width: 10,),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  primary: kPrimaryColor
                                              ),
                                              onPressed: () async {
                                                await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return  addNotesDialogBox(context);
                                                    });

                                                if(isActionCanceled){
                                                  isActionCanceled=false;
                                                  return;
                                                }
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                try {
                                                  final response = await _apiService.revertResignationRequest(widget.resignationAwaiting.rememberToken,note);
                                                  if (response.statusCode == 200) {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Successfully"),
                                                          content: Text("Successfully Reverted Resignation Request!"),
                                                          actions: [
                                                            FlatButton(
                                                              child: new Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationAwaitingApproval);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );

                                                  } else {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showSnackBarMessage(
                                                      scaffoldKey: _scaffoldKey,
                                                      message: response.data["message"],
                                                      fillColor: Colors.red,
                                                    );
                                                  }
                                                } catch (ex) {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  showSnackBarMessage(
                                                    scaffoldKey: _scaffoldKey,
                                                    message: "Failed to revert Resignation request!",
                                                    fillColor: Colors.red,
                                                  );
                                                }
                                              },
                                              child: Text('Revert'),
                                            ),
                                            SizedBox(width: 10,),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red
                                              ),
                                              onPressed: () async {
                                                await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return  addNotesDialogBox(context);
                                                    });

                                                if(isActionCanceled){
                                                  isActionCanceled=false;
                                                  return;
                                                }
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                try {
                                                  final response = await _apiService.rejectResignationRequest(widget.resignationAwaiting.rememberToken,note);
                                                  if (response.statusCode == 200) {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Successfully"),
                                                          content: Text("Successfully Reject Resignation Request!"),
                                                          actions: [
                                                            FlatButton(
                                                              child: new Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationAwaitingApproval);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );

                                                  } else {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showSnackBarMessage(
                                                      scaffoldKey: _scaffoldKey,
                                                      message: response.data["message"],
                                                      fillColor: Colors.red,
                                                    );
                                                  }
                                                } catch (ex) {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  showSnackBarMessage(
                                                    scaffoldKey: _scaffoldKey,
                                                    message: "Failed to reject Resignation request!",
                                                    fillColor: Colors.red,
                                                  );
                                                }
                                              },
                                              child: Text('Reject'),
                                            ),
                                          ],
                                        ) :
                                        Container(),


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
      contentPadding: EdgeInsets.only(left: 20, right: 20),
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
            SizedBox(height: 10,),
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
        height: 200,
        width: 600,
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10,),
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

  void _getPolicyList() async{
    var response = await _apiService.getNoticePeriodPolicyList();
    setState(() {
      policyList= response.policyList;

    });
  }
}

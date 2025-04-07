import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/my_settlement_list.dart';
import 'package:recom_app/data/models/resignation_details.dart';
import 'package:recom_app/data/models/settlement_request_data.dart';
import 'package:recom_app/data/models/settlement_request_detail.dart';
import 'package:recom_app/data/models/travel_plan_detail.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';
import '../widgets/wide_filled_button.dart';
import "../../services/helper/string_extension.dart";
import 'package:flutter_html/flutter_html.dart';

class ResignationPageDetail extends StatefulWidget {
  final MyResignation myResignation;  //My

  const ResignationPageDetail({
    Key key,
    this.myResignation,
  }) : super(key: key);
  @override
  _ResignationPageDetailState createState() => _ResignationPageDetailState();
}

class _ResignationPageDetailState extends State<ResignationPageDetail> {
  User _currentUser;
  ApiService _apiService;
  bool _isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String msg;
  DateFormat _dateFormat= DateFormat('E ,MMM dd,yyyy hh:mm:ss a');//('hh:mm:ss, dd-MMM-yyyy');

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.myResignation == null) {
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
        child: (widget.myResignation == null)
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
                future: _apiService.getResignationDetail(widget.myResignation.separationId),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    var resignationDetails = snapshot.data;
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
                                          'Name : ${resignationDetails.employeeName.trim()}', //${myResignationList[idx].applicationDate}
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
                                          'Submission Date : ${resignationDetails.applicationDate??''}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Last Working Date : ${resignationDetails.lastWorkingDay??''}', //${_colleagues[idx].code}
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
                                        SizedBox(height: 5,),
                                        // Text(
                                        //   'Description : ${resignationDetails.description}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // Html(data:"<p>Hello <b>Flutter</b><p>",
                                        //     defaultTextStyle: TextStyle(fontSize: 12)),
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
                                          'Asking for Notice Period Waive : ${resignationDetails.noticePeriodWaive== 1 ? 'Yes':'No'}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
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
                                                   print(resignationDetails.attachment.first.attachment);
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


// void _getTravelPlanDetail() async{
//   var response = await _apiService.getTravelPlanDetail(widget.travelPlan.id.toString());
//   setState(() {
//     _travelPlanDetail=  response;
//     // print('referenceNo : '+ referenceNo);
//   });
// }
}

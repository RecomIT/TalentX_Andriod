import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/my_settlement_list.dart';
import 'package:recom_app/data/models/resignation_details.dart';
import 'package:recom_app/data/models/settlement_request_data.dart';
import 'package:recom_app/data/models/settlement_request_detail.dart';
import 'package:recom_app/data/models/travel_plan_detail.dart';
import 'package:recom_app/data/models/work_from_home.dart';
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
import '../widgets/wide_filled_button.dart';
import "../../services/helper/string_extension.dart";
import 'package:flutter_html/flutter_html.dart';

class WorkFromHomePageDetail extends StatefulWidget {
  final WorkFromHome workFromHome;

  const WorkFromHomePageDetail({
    Key key,
    this.workFromHome,
  }) : super(key: key);
  @override
  _WorkFromHomePageDetailState createState() => _WorkFromHomePageDetailState();
}

class _WorkFromHomePageDetailState extends State<WorkFromHomePageDetail> {
  User _currentUser;
  ApiService _apiService;
  bool _isLoading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String msg;
  DateFormat dateFormatter = DateFormat('dd-MMM-yyyy');//DateFormat('E ,MMM dd,yyyy hh:mm:ss a');//('hh:mm:ss, dd-MMM-yyyy');

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.workFromHome == null) {
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
        child: (widget.workFromHome == null)
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
                future: _apiService.getWorkFromHomeDetail(widget.workFromHome.wfhId),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    var wfhDetails = snapshot.data;
                    //print(wfhDetails.toJson());
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
                                        //   'Code : ${wfhDetails.code.trim()}', //${myResignationList[idx].applicationDate}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // SizedBox(height: 5,),
                                        // Text(
                                        //   'Application Date : ${wfhDetails.applicationDate.trim()}', //${myResignationList[idx].applicationDate}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        //SizedBox(height: 5,),
                                        Text(
                                          'Start Date : ${wfhDetails.startDate}',//${dateFormatter.format(DateTime.tryParse(wfhDetails.startDate))}',  //
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
                                          'End Date : ${wfhDetails.endDate}', //${dateFormatter.format(DateTime.tryParse(wfhDetails.endDate))}', //
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
                                          'No. of Days/Hours : ${wfhDetails.numberOfDays}', //${_colleagues[idx].code}
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
                                        // SizedBox(height: 5,),
                                        // Html(data: wfhDetails.description,  //resignationDetails.description  //"<p>Hello <b>Flutter</b><p>"
                                        //   defaultTextStyle: TextStyle(fontSize: 12,color: Colors.black45,)),
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

                                        // SizedBox(height: 5,),
                                        // Text(
                                        //   'Note : ${wfhDetails.note}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),

                                        SizedBox(height: 10,),
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

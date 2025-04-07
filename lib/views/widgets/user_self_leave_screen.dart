import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/leave_type.dart';
import 'package:recom_app/data/models/user_profile.dart';

import '../../data/models/employee_id_list.dart';
import '../../data/models/leave_balance_chart_data.dart';
import '../../data/models/leave_request_list.dart';
import '../../data/models/user.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import 'custom_table.dart';
import 'leave_request_cell.dart';
import 'neomorphic_datetime_picker.dart';
import 'neomorphic_text_form_field.dart';
import 'wide_filled_button.dart';

class UserSelfLeaveScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ApiService apiService;
  final User currentUser;

  const UserSelfLeaveScreen({
    Key key,
    this.scaffoldKey,
    this.apiService,
    this.currentUser,
  }) : super(key: key);
  @override
  _UserSelfLeaveScreenState createState() => _UserSelfLeaveScreenState();
}



class _UserSelfLeaveScreenState extends State<UserSelfLeaveScreen> {
  List<LeaveRequest> _leaveReqList;
  final _leaveApplyFormKey = GlobalKey<FormState>();
  final dateFormatter = new DateFormat('dd-MMM-yyyy');
  //final dateFormatter = new DateFormat('y-MM-d');
  String typeOfLeave;
  List<EmployeeListItem> _employeeList;
  bool _isLoading = false;
  // final typeOfLeaveList = [
  //   {'id':1,'name':'Casual Leave'},
  //   {'id':2,'name':'Sick Leave'},
  //   {'id':3,'name':'Annual Leave'},
  //   {'id':4,'name':'Paternity Leave'}
  // ];

  // final durationTypeList = [
  //   "Full day",
  //   "Half day",
  // ];
  // String halfDayType; // (If DurationType = Full Day then Optional Else Required)
  // final halfDayTypeList = [
  //   "1st half",
  //   "2nd half",
  // ];
// full_day / 1st_half / 2nd_half
  List<KeyValuePair> leaveDurations =  [
    KeyValuePair(id: "full_day",name: "Full Day"),
    KeyValuePair(id: "1st_half",name: "1st Half"),
    KeyValuePair(id: "2nd_half",name: "2nd Half"),
  ];
  String durationType;
  String leaveDurationType ="full_day";

  String fromDate;
  String toDate; // if DurationType = Half Day then FromDate = ToDate = Date),
  String leavePurpose='';
  String relieverId;
  String ccId;
  String toId = '';
  String attachmentName;
  String attachmentPath;
  String attachmentContent; // (optional,Size:Max 1MB,Format: pdf,jpeg,jpg,docx,png),
  String attachmentExtention; // (If Attachment submitted then Required)
  DateTime StartDate; // = DateTime.now();
  DateTime EndDate; //=  DateTime.now();
  String noOfDays = '0';
  BasicInfo userBasicInfo;
  String leaveName;
  String empCode;
  Future<LeaveBalanceChartData> _leaveBalanceChartData;
  Future<LeaveTypeList> _leaveTypes;
  Future<UserProfile> _userProfile;
  Future<LeaveRequestList> _leaveRequestList;
  bool _isleaveRequestListChanged = false;
  DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);


  @override
  void initState() {

    _leaveBalanceChartData= widget.apiService.getLeaveBalanceChartData();
    _leaveTypes = widget.apiService.getLeaveTypes();
    _userProfile = widget.apiService.getUserProfile();
    _leaveRequestList = widget.apiService.getLeaveRequestList();

    super.initState();
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Leave Balance",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              FutureBuilder<LeaveBalanceChartData>(
                future: _leaveBalanceChartData,
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    List<List<String>> leaveBalanceList = [];
                    snapshot.data.leaveBalanceList.forEach((leave) {
                      leaveBalanceList.add([
                        leave.leaveName,
                        leave.total.toString(),
                        leave.availed.toString(),
                        leave.encashed.toString(),
                        leave.balance.toString(),
                      ]);
                    });
                    return Column(
                      children: [
                        CustomTableHeader(
                          headerTitles: [
                            "Leave Type",
                            "Allocated",
                            "Availed",
                            "Encashed",
                            "Remaining"
                          ],
                          colSizes: [6, 5, 4, 5, 5],
                        ),
                        SizedBox(height: 5),
                        CustomTableBody(
                          colSizes: [6, 5, 4, 5, 5],
                          bodyData: leaveBalanceList,
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
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
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Apply Leave",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _leaveApplyFormKey.currentState.reset();
                      this.setState(() {
                        typeOfLeave = null;
                        durationType = null;
                        //halfDayType = null;
                        fromDate = null;
                        toDate = null;
                        leavePurpose = null;
                        toId = '';
                        ccId = null;
                        relieverId = null;
                        attachmentName = null;
                        attachmentContent = null;
                        attachmentExtention = null;
                      });
                    },
                    child: Icon(
                      Icons.refresh,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Form(
                key: _leaveApplyFormKey,
                child: Column(
                  children: [
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
                      child: FutureBuilder<LeaveTypeList>(
                        future: _leaveTypes,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && !snapshot.hasError) {
                            //print(snapshot.hasData.toString());
                            var leaveTypes= snapshot.data.leaveTypes.toList();
                            return Container(
                              padding: EdgeInsets.only(
                                left: 7,
                                right: 3,
                                top: 10,
                                bottom: 10,
                              ),
                              margin: EdgeInsets.only(top: 10),
                              width: double.infinity,
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.all(Radius.circular(10)),
                              //   boxShadow: [
                              //     BoxShadow(
                              //       blurRadius: 15,
                              //       color: Colors.black26,
                              //       offset: Offset.fromDirection(Math.pi * .5, 10),
                              //     ),
                              //   ],
                              // ),
                              child: DropdownButton<String>(
                                isDense: true,
                                underline: SizedBox(),
                                value: typeOfLeave,
                                hint: Text('Select Leave Type',
                                  style: TextStyle(fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),),
                                items: List<DropdownMenuItem<String>>.generate(
                                  (leaveTypes?.length ?? 0) + 1,
                                      (idx) =>
                                      DropdownMenuItem<String>(

                                        value: idx == 0 ? null : leaveTypes[idx - 1].id,
                                        child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.6,
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            idx == 0 ? "Leave Types" : leaveTypes[idx - 1].name,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                                onChanged: (String lvType) {
                                  setState(() {
                                    typeOfLeave = lvType;
                                    leaveName =leaveTypes.where((e) => e.id==lvType).first.name;
                                    //print(typeOfLeave + leaveName);
                                    //leaveName =leaveTypes[int.tryParse(lvType) - 1].name;
                                  });
                                },
                              ),
                            );
                          }
                          else if (snapshot.hasError) {
                            return SizedBox(width: double
                                .infinity,); //Text(snapshot.error.toString());
                          }
                          else {
                            return SizedBox(width: double.infinity,);
                          }
                        },
                      ),
                      // child: DropdownButton<String>(
                      //   hint: Text('Select Leave type',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey[500]),),
                      //   isDense: true,
                      //   underline: SizedBox(),
                      //   value: typeOfLeave,
                      //   items: List<DropdownMenuItem<String>>.generate(
                      //     typeOfLeaveList.length + 1,
                      //     (idx) => DropdownMenuItem<String>(
                      //       value: idx == 0 ? null : typeOfLeaveList[idx - 1]['id'],
                      //       child: Container(
                      //         width: MediaQuery.of(context).size.width * 0.6,
                      //         padding: EdgeInsets.only(left: 20),
                      //         child: Text(
                      //           idx == 0 ? "Type of Leave" : typeOfLeaveList[idx - 1]['name'],
                      //           style: TextStyle(
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   onChanged: (String lvType) {
                      //     setState(() {
                      //       typeOfLeave = lvType;
                      //     });
                      //   },
                      // ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(
                    //     left: 7,
                    //     right: 3,
                    //     top: 10,
                    //     bottom: 10,
                    //   ),
                    //   margin: EdgeInsets.only(top: 10),
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         blurRadius: 15,
                    //         color: Colors.black26,
                    //         offset: Offset.fromDirection(Math.pi * .5, 10),
                    //       ),
                    //     ],
                    //   ),
                    //   child: DropdownButton<String>(
                    //     isDense: true,
                    //     underline: SizedBox(),
                    //     value: durationType,
                    //     items: List<DropdownMenuItem<String>>.generate(
                    //       durationTypeList.length + 1,
                    //       (idx) => DropdownMenuItem<String>(
                    //         value: idx == 0 ? null : durationTypeList[idx - 1],
                    //         child: Container(
                    //           width: MediaQuery.of(context).size.width * 0.6,
                    //           padding: EdgeInsets.only(left: 20),
                    //           child: Text(
                    //             idx == 0 ? "Duration Type" : durationTypeList[idx - 1],
                    //             style: TextStyle(
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     onChanged: (String dType) {
                    //       setState(() {
                    //         durationType = dType;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(
                    //     left: 7,
                    //     right: 3,
                    //     top: 10,
                    //     bottom: 10,
                    //   ),
                    //   margin: EdgeInsets.only(top: 10),
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         blurRadius: 15,
                    //         color: Colors.black26,
                    //         offset: Offset.fromDirection(Math.pi * .5, 10),
                    //       ),
                    //     ],
                    //   ),
                    //   child: DropdownButton<String>(
                    //     isDense: true,
                    //     underline: SizedBox(),
                    //     value: halfDayType,
                    //     items: List<DropdownMenuItem<String>>.generate(
                    //       halfDayTypeList.length + 1,
                    //       (idx) => DropdownMenuItem<String>(
                    //         value: idx == 0 ? null : halfDayTypeList[idx - 1],
                    //         child: Container(
                    //           width: MediaQuery.of(context).size.width * 0.6,
                    //           padding: EdgeInsets.only(left: 20),
                    //           child: Text(
                    //             idx == 0 ? "Half Day Type" : halfDayTypeList[idx - 1],
                    //             style: TextStyle(
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     onChanged: (String hdType) {
                    //       setState(() {
                    //         halfDayType = hdType;
                    //       });
                    //     },
                    //   ),
                    // ),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NeomorphicDatetimePicker(
                          hintText: "Start Date",
                          updateValue: (String from) {
                            setState(() {
                              if (from.isNotEmpty) {
                                StartDate = DateTime.parse(from);
                                fromDate = dateFormatter.format(StartDate);
                                //print(fromDate);
                                if (EndDate != null && StartDate != null) {
                                  noOfDays = "${((EndDate)
                                      .difference((StartDate))
                                      .inDays + 1).toString()}";
                                }
                              }
                              else {
                                fromDate = from;
                              }
                            });
                          },
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.365,
                        ),
                        NeomorphicDatetimePicker(
                          hintText: "End Date",
                          updateValue: (String to) {
                            setState(() {
                              if (to.isNotEmpty) {
                                EndDate = DateTime.parse(to);
                                toDate = dateFormatter.format(EndDate);
                                //print(toDate);
                                if (EndDate != null && StartDate != null) {
                                  noOfDays = "${((EndDate)
                                      .difference((StartDate))
                                      .inDays + 1).toString()}";
                                }
                              }
                              else {
                                toDate = to;
                              }
                            });
                          },
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.365,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: noOfDays == '0' || noOfDays.contains('-')
                          ? false
                          : true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          leaveDurationType != "full_day" ?
                          Text(
                            'Number of Days : ' +  "0.5",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ) :
                          Text(
                          'Number of Days : ' +  noOfDays,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            color: Colors.black26,
                            offset: Offset.fromDirection(
                                Math.pi * .25, 5),
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
                          isDense: true,
                          underline: SizedBox(),
                          value: leaveDurationType,
                          hint: Text('Full/Half Day',
                            style: TextStyle(fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),),
                          items: List<DropdownMenuItem<String>>.generate(
                            (leaveDurations?.length ?? 0) + 1,
                                (idx) =>
                                DropdownMenuItem<String>(
                                  value: idx == 0
                                      ? null
                                      : leaveDurations[idx - 1].id,
                                  //domestic
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.6,
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      idx == 0
                                          ? "Select Full/Half Day"
                                          : leaveDurations[idx - 1].name,
                                      //Domestic
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
                              leaveDurationType = value ?? leaveDurationType;
                              if(leaveDurationType !=null){
                                print('leaveDurationType: ' + leaveDurationType);
                                if (leaveDurationType != "full_day" && fromDate != toDate) {
                                  showSnackBarMessage(
                                    scaffoldKey: widget.scaffoldKey,
                                    message: "Please make sure that for Half Day leave Start Date and End Date are the same!",
                                    fillColor: Colors.red,
                                  );
                                  return;
                                }

                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    NeomorphicTextFormField(
                      inputType: TextInputType.text,
                      numOfMaxLines: 5,
                      hintText: "Description",
                      fontSize: 12,
                      onChangeFunction: (String purpose) {
                        leavePurpose = purpose;

                        // setState(() {
                        //   leavePurpose = purpose;
                        // });
                      },
                    ),

                    SizedBox(height: 10),
                    //CC and Relivers Drop Down
                    // FutureBuilder<EmployeeIdList>(
                    //   future: widget.apiService.getReliverIds(),
                    //   builder: (context, snapshot) {
                    //     if ((snapshot.hasData && !snapshot.hasError)) {
                    //       _employeeList = snapshot.data.employeeList;
                    //
                    //       print('EmpCode DD ' + empCode);
                    //       var supervisor=_employeeList.firstWhere((element) => element.name.contains(empCode),orElse: ()=>null);
                    //       if(supervisor!=null){
                    //         toId=supervisor.iD;
                    //       }
                    //       else toId='';
                    //       print('ToId DD ' +toId);
                    //       //var supervisor=_employeeList.firstWhere((element) => element.name.contains(empCode));
                    //     }
                    //     return //Container();
                    //       Column(
                    //       children: [
                    //         Container(
                    //           padding: EdgeInsets.only(
                    //             left: 7,
                    //             right: 3,
                    //             top: 10,
                    //             bottom: 10,
                    //           ),
                    //           margin: EdgeInsets.only(top: 10),
                    //           width: double.infinity,
                    //           decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(10)),
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 blurRadius: 15,
                    //                 color: Colors.black26,
                    //                 offset: Offset.fromDirection(
                    //                     Math.pi * .5, 10),
                    //               ),
                    //             ],
                    //           ),
                    //           child: DropdownButton<String>(
                    //             isDense: true,
                    //             underline: SizedBox(),
                    //             value: ccId,
                    //             hint: Text(
                    //               'CC',
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.bold,
                    //                   color: Colors.grey[500]),
                    //             ),
                    //             items:
                    //                 List<DropdownMenuItem<String>>.generate(
                    //               (_employeeList?.length ?? 0) + 1,
                    //               (idx) => DropdownMenuItem<String>(
                    //                 value: idx == 0
                    //                     ? null
                    //                     : _employeeList[idx - 1].iD,
                    //                 child: Container(
                    //                   width:
                    //                       MediaQuery.of(context).size.width *
                    //                           0.6,
                    //                   padding: EdgeInsets.only(left: 20),
                    //                   child: Text(
                    //                     idx == 0
                    //                         ? "CC :"
                    //                          : _employeeList[idx - 1].name,
                    //                     style: TextStyle(
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             onChanged: (String rlvId) {
                    //               setState(() {
                    //                 ccId = rlvId;
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),

                    FutureBuilder<UserProfile>(
                        future: _userProfile,
                        builder: (context, snapshot)  {
                          if (snapshot.hasData && !snapshot.hasError) {
                            userBasicInfo = snapshot.data.basicInfo;
                            var supervisorName = '';
                            if (userBasicInfo != null) {
                              supervisorName = userBasicInfo.supervisor;
                              toId=widget.currentUser.supervisor_id;
                            }
                            //print('SupervisorName:' + supervisorName + ' || SupervisorID:' + toId.toString());
                            return
                              NeomorphicTextFormField(
                              inputType: TextInputType.text,
                              initVal: 'To : ${supervisorName} ',
                              hintText: "To :",
                              isReadOnly: true,
                              fontSize: 12,
                            );
                          }
                          else if (snapshot.hasError) {
                            return SizedBox(width: double.infinity,); //Text(snapshot.error.toString());
                          }
                          else {
                            return SizedBox(width: double.infinity,);
                          }
                        }),
                    SizedBox(height: 10),

                    //CC and Relivers Drop Down
                    // FutureBuilder<EmployeeIdList>(
                    //     future: _employeeList!= null ? null : widget.apiService.getReliverIds(),
                    //     builder: (context, snapshot) {
                    //       List<EmployeeListItem> dropDownListCC;
                    //       List<EmployeeListItem> dropDownListReliver;
                    //       if (_employeeList != null) {
                    //         dropDownListCC = _employeeList;
                    //         dropDownListReliver = _employeeList;
                    //       } else {
                    //         if ((snapshot.hasData && !snapshot.hasError)) {
                    //           _employeeList= snapshot.data.employeeList;
                    //           dropDownListCC = snapshot.data.employeeList;
                    //           dropDownListReliver = snapshot.data.employeeList;
                    //         } else if(snapshot.hasError){
                    //           return SizedBox(width: double.infinity,);
                    //         }
                    //         else{
                    //           return SizedBox(width: double.infinity,);
                    //         }
                    //       }
                    //       return Column(
                    //         children: [
                    //           Container(
                    //             padding: EdgeInsets.only(
                    //               left: 7,
                    //               right: 3,
                    //               top: 10,
                    //               bottom: 10,
                    //             ),
                    //             margin: EdgeInsets.only(top: 10),
                    //             width: double.infinity,
                    //             decoration: BoxDecoration(
                    //               color: Colors.white,
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(10)),
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   blurRadius: 15,
                    //                   color: Colors.black26,
                    //                   offset: Offset.fromDirection(
                    //                       Math.pi * .5, 10),
                    //                 ),
                    //               ],
                    //             ),
                    //             child: DropdownButton<String>(
                    //               isDense: true,
                    //               underline: SizedBox(),
                    //               value: ccId,
                    //               hint: Text(
                    //                 'CC',
                    //                 style: TextStyle(
                    //                     fontSize: 12,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Colors.grey[500]),
                    //               ),
                    //               items:
                    //                   List<DropdownMenuItem<String>>.generate(
                    //                 (dropDownListCC?.length ?? 0) + 1,
                    //                 (idx) => DropdownMenuItem<String>(
                    //                   value: idx == 0
                    //                       ? null
                    //                       : dropDownListCC[idx - 1].iD,
                    //                   child: Container(
                    //                     width:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.6,
                    //                     padding: EdgeInsets.only(left: 20),
                    //                     child: Text(
                    //                       idx == 0
                    //                           ? "CC :"
                    //                           : dropDownListCC[idx - 1].name,
                    //                       style: TextStyle(
                    //                         fontSize: 12,
                    //                         fontWeight: FontWeight.bold,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               onChanged: (String rlvId) {
                    //                 setState(() {
                    //                   ccId = rlvId;
                    //                 });
                    //               },
                    //             ),
                    //           ),
                    //           // Container(
                    //           //   padding: EdgeInsets.only(
                    //           //     left: 7,
                    //           //     right: 3,
                    //           //     top: 10,
                    //           //     bottom: 10,
                    //           //   ),
                    //           //   margin: EdgeInsets.only(top: 10),
                    //           //   width: double.infinity,
                    //           //   decoration: BoxDecoration(
                    //           //     color: Colors.white,
                    //           //     borderRadius:
                    //           //         BorderRadius.all(Radius.circular(10)),
                    //           //     boxShadow: [
                    //           //       BoxShadow(
                    //           //         blurRadius: 15,
                    //           //         color: Colors.black26,
                    //           //         offset: Offset.fromDirection(
                    //           //             Math.pi * .5, 10),
                    //           //       ),
                    //           //     ],
                    //           //   ),
                    //           //   child: DropdownButton<String>(
                    //           //     isDense: true,
                    //           //     underline: SizedBox(),
                    //           //     value: relieverId,
                    //           //     hint: Text(
                    //           //       'Releiver',
                    //           //       style: TextStyle(
                    //           //           fontSize: 12,
                    //           //           fontWeight: FontWeight.bold,
                    //           //           color: Colors.grey[500]),
                    //           //     ),
                    //           //     items:
                    //           //     List<DropdownMenuItem<String>>.generate(
                    //           //       (dropDownListReliver?.length ?? 0) + 1,
                    //           //           (idx) => DropdownMenuItem<String>(
                    //           //         value: idx == 0
                    //           //             ? null
                    //           //             : dropDownListReliver[idx - 1].iD,
                    //           //         child: Container(
                    //           //           width:
                    //           //           MediaQuery.of(context).size.width *
                    //           //               0.6,
                    //           //           padding: EdgeInsets.only(left: 20),
                    //           //           child: Text(
                    //           //             idx == 0
                    //           //                 ? "Reliver :"
                    //           //                 : dropDownListCC[idx - 1].name,
                    //           //             style: TextStyle(
                    //           //               fontSize: 12,
                    //           //               fontWeight: FontWeight.bold,
                    //           //             ),
                    //           //           ),
                    //           //         ),
                    //           //       ),
                    //           //     ),
                    //           //     onChanged: (String rlvId) {
                    //           //       setState(() {
                    //           //         relieverId = rlvId;
                    //           //       });
                    //           //     },
                    //           //   ),
                    //           // )
                    //         ],
                    //       );
                    //     }
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 80) * 0.7,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                color: Colors.black26,
                                offset: Offset.fromDirection(Math.pi * .5, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            attachmentName ?? "Attachment",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: attachmentName == null
                                  ? Colors.black45
                                  : Colors.black,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
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
                            final pickedFile = await FilePicker.getFile(
                              type: FileType.custom,
                              allowedExtensions: [
                                "pdf",
                                "jpeg",
                                "jpg",
                                "docx",
                                "png"
                              ],
                            );
                            if (pickedFile == null) return;
                            final fileCotent = base64Encode(
                                pickedFile.readAsBytesSync());
                            setState(() {
                              attachmentName = pickedFile.path
                                  .split("/")
                                  .last;
                              attachmentExtention = pickedFile.path
                                  .split("/")
                                  .last
                                  .split(".")
                                  .last;
                              attachmentContent = fileCotent;
                              attachmentPath = pickedFile.path;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width - 80) * 0.28,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.camera_enhance_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Center(child: CircularProgressIndicator(),)
                        : WideFilledButton(
                      buttonText: "Submit",
                      onTapFunction: () async {

                        if (typeOfLeave == null) {
                          showSnackBarMessage(
                            scaffoldKey: widget.scaffoldKey,
                            message: "Please select type of leave!",
                            fillColor: Colors.red,
                          );
                          return;
                        }
                        //
                        String lvName = leaveName.trim().toLowerCase();
                        if (leaveDurationType != "full_day") {
                          if(!lvName.contains("casual") && !lvName.contains("annual")){
                            showSnackBarMessage(
                              scaffoldKey: widget.scaffoldKey,
                              message: "Half day leave is only applicable on Casual and Annual Leaves!",
                              fillColor: Colors.red,
                            );
                            return;
                          }
                        }

                        if (fromDate == null) {
                          showSnackBarMessage(
                            scaffoldKey: widget.scaffoldKey,
                            message: "Please select From Date!",
                            fillColor: Colors.red,
                          );
                          return;
                        }
                        // if (durationType == null) {
                        //   showSnackBarMessage(
                        //     scaffoldKey: widget.scaffoldKey,
                        //     message: "Please select duration type!",
                        //     fillColor: Colors.red,
                        //   );
                        //   return;
                        // }
                        // if (durationType == durationTypeList[1] && halfDayType == null) {
                        //   showSnackBarMessage(
                        //     scaffoldKey: widget.scaffoldKey,
                        //     message: "Please select Halfday type!",
                        //     fillColor: Colors.red,
                        //   );
                        //   return;
                        // }
                        if (toDate == null) {
                          showSnackBarMessage(
                            scaffoldKey: widget.scaffoldKey,
                            message: "Please select To Date!",
                            fillColor: Colors.red,
                          );
                          return;
                        }
                        //noOfDays.contains('-')
                        if (EndDate.isBefore(StartDate)) {
                          showSnackBarMessage(
                            scaffoldKey: widget.scaffoldKey,
                            message: "Invalid Date selection! Start Date can't be greater then End Date",
                            fillColor: Colors.red,
                          );
                          return;
                        }
                        if (StartDate.isBefore(dateToday) || EndDate.isBefore(dateToday)) {
                          if(lvName == "pilgrimage"){
                            showSnackBarMessage(
                              scaffoldKey: widget.scaffoldKey,
                              message: "Back Dated request is not allowed for "+ lvName,
                              fillColor: Colors.red,
                            );
                            return;
                          }
                        }
                        if (leaveDurationType != "full_day" && fromDate != toDate) {
                          showSnackBarMessage(
                            scaffoldKey: widget.scaffoldKey,
                            message: "Please make sure that for Half Day leave Start Date and End Date are the same!",
                            fillColor: Colors.red,
                          );
                          return;
                        }
                        // if (leavePurpose == null) {
                        //   showSnackBarMessage(
                        //     scaffoldKey: widget.scaffoldKey,
                        //     message: "Please enter leave description!",
                        //     fillColor: Colors.red,
                        //   );
                        //   return;
                        // }
                        if (toId == null) {
                          showSnackBarMessage(
                            scaffoldKey: widget.scaffoldKey,
                            message: "To ID is missing",
                            fillColor: Colors.red,
                          );
                          return;
                        }

                        int countDays = int.tryParse(noOfDays);
                        // String lvName = leaveName.trim().toLowerCase();
                        if ((lvName == "sick") && (countDays > 2) &&
                            (attachmentContent == null)) {
                          showSnackBarMessage(
                            scaffoldKey: widget.scaffoldKey,
                            message: "Attachment for sick leave (more than 2days) is mandatory",
                            fillColor: Colors.red,
                          );
                          return;
                        }

                        try {
                          setState(() {
                            _isLoading = true;
                          });

                          var formData = FormData.fromMap({
                            "leavetype_id": typeOfLeave,
                            "start_date": fromDate,
                            "end_date": toDate,
                            "description": leavePurpose,
                            "to": toId,
                            "cc": ccId,
                            "releiver": relieverId,
                            "full_half_day": leaveDurationType,
                          });


                          // if (halfDayType != null) formData["HalfDayType"] = halfDayType;
                          // if (relieverId != null) formData["RelieverId"] = relieverId;
                          if (attachmentContent != null) {
                            // formData["Attachment"] = attachmentContent;
                            // formData["AttachmentExtention"] = attachmentExtention;

                            var file = await MultipartFile.fromFile(
                                attachmentPath,
                                filename: attachmentName);
                            formData.files.add(MapEntry("document", file));
                          }

                          print('--------------From Submit----------------' + formData.fields.toString());
                          final response = await widget.apiService.applyForLeave(formData);

                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            showSnackBarMessage(
                              scaffoldKey: widget.scaffoldKey,
                              message: "Successfully applied for leave!",
                              fillColor: Colors.green,
                            );
                            _leaveApplyFormKey.currentState.reset();
                            this.setState(() {
                              typeOfLeave = null;
                              durationType = null;
                              //halfDayType = null;
                              fromDate = null;
                              toDate = null;
                              leavePurpose = null;
                              relieverId = null;
                              attachmentName = null;
                              attachmentContent = null;
                              attachmentExtention = null;
                              toId = null;
                              ccId = null;
                              _isLoading = false;
                              leaveName = null;
                              _isleaveRequestListChanged=true;
                            });
                          }
                          else {
                            showSnackBarMessage(
                              scaffoldKey: widget.scaffoldKey,
                              message: response.data["message"],
                              fillColor: Colors.red,
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        } catch (ex) {
                          showSnackBarMessage(
                            scaffoldKey: widget.scaffoldKey,
                            message: "Failed to apply for leave!",
                            fillColor: Colors.red,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
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
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Leave Requests",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              FutureBuilder<LeaveRequestList>(
                future: !_isleaveRequestListChanged ? _leaveRequestList : _leaveRequestList = widget.apiService.getLeaveRequestList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    _leaveReqList =
                        snapshot.data.leaveRequests.where((e) => e.status ==
                            'pending').toList();
                    _isleaveRequestListChanged=false;
                    return SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 40,
                      height: 12.0 * 20,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (_leaveReqList?.length ?? 0) + 1,
                        //(snapshot.data.leaveRequests?.length ?? 0) + 1,
                        itemBuilder: (context, idx) {
                          if (idx == 0) {
                            return Column(
                              children: [
                                LeaveRequestCell(
                                  isLeftRounded: true,
                                  isDark: true,
                                  text: "",
                                ),
                                // LeaveRequestCell(
                                //   isLeftRounded: true,
                                //   isDark: true,
                                //   text: "Name",
                                // ),
                                LeaveRequestCell(
                                  isLeftRounded: true,
                                  isDark: true,
                                  text: "Leave Type",
                                ),
                                LeaveRequestCell(
                                  isLeftRounded: true,
                                  isDark: true,
                                  text: "Start Date",
                                ),
                                LeaveRequestCell(
                                  isLeftRounded: true,
                                  isDark: true,
                                  text: "End Date",
                                ),
                                LeaveRequestCell(
                                  isLeftRounded: true,
                                  isDark: true,
                                  text: "Total Days",
                                ),
                                LeaveRequestCell(
                                  isLeftRounded: true,
                                  isDark: true,
                                  text: "Status",
                                ),
                                // LeaveRequestCell(
                                //   isLeftRounded: true,
                                //   isDark: true,
                                //   text: "Description",
                                //
                                // ),
                                LeaveRequestCell(
                                  isLeftRounded: true,
                                  isDark: true,
                                  text: "Attachment",
                                ),

                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    // try {
                                    //   setState(() {
                                    //     _isLoading = true;
                                    //   });
                                    //
                                    //   final response =
                                    //   await widget.apiService.cancelLeave(
                                    //       _leaveReqList[idx - 1].leaveId);
                                    //   if (response.statusCode == 200) {
                                    //     showSnackBarMessage(
                                    //       scaffoldKey: widget.scaffoldKey,
                                    //       message: "Successfully Cancelled Leave!",
                                    //       fillColor: Colors.green,
                                    //     );
                                    //     setState(() {
                                    //       _leaveReqList.removeAt(idx - 1);
                                    //       _isLoading = false;
                                    //       _isleaveRequestListChanged=true;
                                    //     });
                                    //   } else {
                                    //     setState(() {
                                    //       _isLoading = false;
                                    //     });
                                    //     showSnackBarMessage(
                                    //       scaffoldKey: widget.scaffoldKey,
                                    //       message: response.data["message"],
                                    //       fillColor: Colors.red,
                                    //     );
                                    //   }
                                    // } catch (ex) {
                                    //   setState(() {
                                    //     _isLoading = false;
                                    //   });
                                    //   // showSnackBarMessage(
                                    //   //   scaffoldKey: widget.scaffoldKey,
                                    //   //   message: ex.toString(),
                                    //   //   fillColor: Colors.red,
                                    //   // );
                                    // }
                                  },
                                  child: LeaveRequestCell(
                                    isRightRounded: idx ==
                                        (_leaveReqList?.length ?? 0),
                                    isDark: true,
                                    text: "", //Cancel
                                  ),
                                ),
                                // LeaveRequestCell(
                                //   isRightRounded: idx == (_leaveReqList?.length ?? 0),
                                //   text: _leaveReqList[idx - 1].empName,
                                // ),
                                LeaveRequestCell(
                                  isRightRounded: idx ==
                                      (_leaveReqList?.length ?? 0),
                                  text: _leaveReqList[idx - 1].leaveType,
                                ),
                                LeaveRequestCell(
                                  isRightRounded: idx ==
                                      (_leaveReqList?.length ?? 0),
                                  text: _leaveReqList[idx - 1].fromDate,
                                ),
                                LeaveRequestCell(
                                  isRightRounded: idx ==
                                      (_leaveReqList?.length ?? 0),
                                  text: _leaveReqList[idx - 1].toDate,
                                ),
                                LeaveRequestCell(
                                  isRightRounded: idx ==
                                      (_leaveReqList?.length ?? 0),
                                  text: _leaveReqList[idx - 1].totalDays
                                      .toString(),
                                ),
                                LeaveRequestCell(
                                  isRightRounded: idx ==
                                      (_leaveReqList?.length ?? 0),
                                  text: _leaveReqList[idx - 1].status,
                                ),
                                // LeaveRequestCell(
                                //   isRightRounded: idx ==
                                //       (_leaveReqList?.length ?? 0),
                                //   text: _leaveReqList[idx - 1].leaveDescription,
                                // ),
                                InkWell(
                                  onTap: () async {
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
                                      final pdfFile = File("${appDocDir.path}/${_leaveReqList[idx - 1].leaveDocument}");

                                      if (!pdfFile.existsSync()) {
                                        bool downloaded = await widget.apiService.getLeaveAttachment(_leaveReqList[idx - 1].leaveId.toString(), pdfFile.path);
                                        if (!downloaded) {
                                          showSnackBarMessage(
                                            scaffoldKey: widget.scaffoldKey,
                                            message:
                                            "Sorry, No file available.!",
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
                                  child: LeaveRequestCell(
                                    isRightRounded: idx ==
                                        (_leaveReqList?.length ?? 0),
                                    text: _leaveReqList[idx - 1]
                                        .leaveDocument == 'N/A'
                                        ? _leaveReqList[idx - 1].leaveDocument
                                        : 'Download File',
                                  ),
                                ),

                              ],
                            );
                          }
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error
                        .toString()
                        .split("Exception: ")
                        .last);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
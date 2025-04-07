import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/employee_id_list.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/leave_type.dart';
import 'package:recom_app/data/models/resignation_info.dart';
import 'package:recom_app/data/models/travel_purpose.dart';
import 'package:recom_app/data/models/travel_type.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/data/models/user_profile.dart';
import 'package:recom_app/data/models/work_from_home_reason.dart';
import 'package:recom_app/data/providers/UserProvider.dart';
import 'package:recom_app/services/api/api.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';
import 'package:recom_app/views/widgets/flat_app_bar.dart';
import 'package:recom_app/views/widgets/neomorphic_datetime_picker.dart';
import 'package:recom_app/views/widgets/neomorphic_text_form_field.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:recom_app/views/widgets/wide_filled_button.dart';
import 'dart:math' as Math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdownfield/dropdownfield.dart';

class CreateWorkFromHomePage extends StatefulWidget {

  @override
  _CreateWorkFromHomeScreenState createState() => _CreateWorkFromHomeScreenState();
}

class _CreateWorkFromHomeScreenState extends State<CreateWorkFromHomePage> {
  ApiService _apiService;
  User _currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _FormKey= GlobalKey<FormState>();
  DateFormat dateFormatter;
  String currentDateFormat = '';

  String reason;
  List<KeyValuePair> reasonList;
  Future<WorkFromHomeReason> _reasonRequest;

  String startDate;
  String endDate;
  String startTime;
  String endTime;
  DateTime fromDate;
  DateTime toDate;

  String description='';
  String attachmentName;
  String attachmentPath;
  String attachmentContent; // (optional,Size:Max 5MB,Format: pdf,jpeg,jpg,docx,png),
  String attachmentExtention;
  String toId;
  DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ;
  bool _isBackDateSelected= false;
  bool _isOutofOfficeEngagement=false;
  String noOfDays='';


  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _getCurrentDateFormat();
    reasonList= [];
    _getReasonList();
  }
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery
        .of(context)
        .size;
    _currentUser = Provider
        .of<UserProvider>(context, listen: false)
        .user;
    toId = _currentUser.supervisor_id;
    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20,),
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
                            "Apply for Off-Site Attendance",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     _FormKey.currentState.reset();
                          //     this.setState(() {
                          //       reason=null;
                          //       startDate = null;
                          //       endDate = null;
                          //       startTime=null;
                          //       endTime=null;
                          //       _isOutofOfficeEngagement=false;
                          //       description=null;
                          //       attachmentName = null;
                          //       attachmentContent = null;
                          //       attachmentExtention = null;
                          //     });
                          //   },
                          //   child: Icon(
                          //     Icons.refresh,
                          //     color: Colors.black54,
                          //   ),
                          // ),
                        ],
                      ),
                      Form(
                        key: _FormKey,
                        child: Column(
                          children: [
                            SizedBox(height: 5),
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
                                  isDense: true,
                                  underline: SizedBox(),
                                  value: reason,
                                  hint: Text('Select Reason',
                                    style: TextStyle(fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[500]),),
                                  items: List<DropdownMenuItem<String>>.generate(
                                    (reasonList?.length ?? 0) + 1,
                                        (idx) =>
                                        DropdownMenuItem<String>(
                                          value: idx == 0 ? null : reasonList[idx - 1].id,
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.6,
                                            padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              idx == 0 ? "Select Reason" : reasonList[idx - 1].name,
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
                                      reason = value ?? reason;
                                      if(reason !=null){
                                        reason=reason.trim();
                                        print('reason: ' + reason);
                                        _isOutofOfficeEngagement = reason.toLowerCase().contains('out-of-office-engagement') ? true : false;
                                        if(!_isOutofOfficeEngagement){
                                          startTime=null;
                                          endTime=null;
                                        }
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                NeomorphicDatetimePicker(
                                  hintText: startDate ?? "Start Date",
                                  updateValue: (String from) {
                                      setState(() {
                                        startDate = dateFormatter.format(DateTime.parse(from));
                                        print("Start Date : " + startDate);
                                        fromDate = DateTime.tryParse(from);
                                      });
                                      _getNoOfDays();
                                  },
                                  width: MediaQuery.of(context).size.width * 0.365,
                                ),
                                NeomorphicDatetimePicker(
                                  hintText: endDate ?? "End Date",
                                  updateValue: (String to) {
                                      setState(() {
                                        endDate = dateFormatter.format(DateTime.parse(to));
                                        print("End Date : " + endDate);
                                        toDate=DateTime.tryParse(to);
                                      });
                                      _getNoOfDays();
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
                              visible: _isOutofOfficeEngagement,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  NeomorphicDatetimePicker(
                                    hintText: startTime ?? "Start Time",
                                    isTimePicker: true,
                                    updateValue: (String from) {
                                      setState(() {
                                        startTime = from;
                                        print("Start Time : " + startTime.toString());
                                      });
                                    },
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.365,
                                  ),
                                  NeomorphicDatetimePicker(
                                    hintText: endTime ?? "End Time",
                                    isTimePicker: true,
                                    updateValue: (String to) {
                                      setState(() {
                                        endTime = to;
                                        print("End Time : " + endTime);
                                        //toDate=DateTime.tryParse(to);
                                      });
                                    },
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.365,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            NeomorphicTextFormField(
                              key: Key(noOfDays),
                              inputType: TextInputType.text,
                              initVal: 'No. of Days : ${noOfDays} ',
                              hintText: "No. of Days :",
                              isReadOnly: true,
                              fontSize: 12,
                            ),
                            SizedBox(height: 10),
                            NeomorphicTextFormField(
                              inputType: TextInputType.text,
                              initVal: 'To : ${_currentUser.supervisor_name} ',
                              hintText: "To :",
                              isReadOnly: true,
                              fontSize: 12,
                            ),
                            SizedBox(height: 10),
                            NeomorphicTextFormField(
                              inputType: TextInputType.text,
                              numOfMaxLines: 5,
                              hintText: "Description",
                              fontSize: 12,
                              onChangeFunction: (String text) {
                                description = text;
                              },
                            ),
                            SizedBox(height: 10),
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
                                          scaffoldKey: _scaffoldKey,
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
                                        "docx",
                                        "doc"
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

                                if (reason == null) {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Please Select Reason!",
                                    fillColor: Colors.red,
                                  );
                                  return;
                                }
                                if (startDate == null) {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Please Select Start Date!",
                                    fillColor: Colors.red,
                                  );
                                  return;
                                }
                                if (endDate == null) {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Please Select End Date!",
                                    fillColor: Colors.red,
                                  );
                                  return;
                                }
                                if (toDate.isBefore(fromDate)) {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Invalid Date selection! Start Date can't be greater then End Date",
                                    fillColor: Colors.red,
                                  );
                                  return;
                                }
                                if (fromDate.isBefore(dateToday) || toDate.isBefore(dateToday)) {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Back Dated request is not allowed!",
                                    fillColor: Colors.red,
                                  );
                                  return;
                                }
                                if (_isOutofOfficeEngagement && startTime == null) {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Please Select Start Time!",
                                    fillColor: Colors.red,
                                  );
                                  return;
                                }
                                if (_isOutofOfficeEngagement &&  endTime == null) {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Please Select End Time!",
                                    fillColor: Colors.red,
                                  );
                                  return;
                                }
                                if (toId == null) {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "To ID is missing",
                                    fillColor: Colors.red,
                                  );
                                  return;
                                }
                                try {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  var formData = FormData.fromMap({
                                    "type": reason,
                                    "start_date": startDate,
                                    "end_date": endDate,
                                    "start_time": startTime,
                                    "end_time": endTime,
                                    "to": toId,
                                    "description": description,
                                  });

                                  if (attachmentContent != null) {
                                    var file = await MultipartFile.fromFile(
                                        attachmentPath,
                                        filename: attachmentName);
                                    formData.files.add(MapEntry("attachment", file));
                                  }

                                  print('--------------From Submit----------------' + formData.fields.toString());

                                  final response = await _apiService.applyForWFH(formData);

                                  if (response.statusCode == 200 ||
                                      response.statusCode == 201) {
                                    setState(() {
                                      _isLoading=false;
                                      _showDialog(context);
                                    });

                                  }
                                  else {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: response.data["message"],
                                      fillColor: Colors.red,
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                } catch (ex) {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Failed to apply request!",
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
              ],
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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successfully"),
          content: Text("Successfully Applied for Off-Site Attendance!"),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(WORK_FROM_HOME_PAGE,arguments: WorkFromHomePageScreen.WorkFromHomeApplication);
              },
            ),
          ],
        );
      },
    );
  }

  void _getNoOfDays() async{
    var response = await _apiService.getNoOfDaysWFH(startDate,endDate);
    setState(() {
      noOfDays  = response;
      print('noOfDays : '+ noOfDays.toString());
    });
  }
  void _getReasonList() async{
    var response = await _apiService.getWFHReason();
    setState(() {
      reasonList  = response.workFromHomeReasonList;
      //print('reasonList : '+ reasonList.toJson().toString());
    });
  }
  //API Calls
  void _getCurrentDateFormat() async{
    var response = await _apiService.getCurrentDateFormat();
    setState(() {
      currentDateFormat = response.trim().toLowerCase();
      //print('currentDateFormat : '+ currentDateFormat);

      //'dd-MMM-yyyy'  //dd MMM,yyyy  //yyyy-MM-dd
      switch(currentDateFormat) {
        case 'd-m-y': {dateFormatter = new DateFormat('dd-MMM-yyyy');}break;
        case 'd m, y': {dateFormatter = new DateFormat('dd MMM,yyyy');}break;
        case 'y-m-d': {dateFormatter = new DateFormat('yyyy-MM-dd');}break;
        default: {dateFormatter = new DateFormat('dd-MMM-yyyy');}break;
      }
    });
  }
}




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
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/resignation_info.dart';
import 'package:recom_app/data/models/travel_purpose.dart';
import 'package:recom_app/data/models/travel_type.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/data/models/user_profile.dart';
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

class EditResignationPage extends StatefulWidget {
final MyResignation myResignation;
  const EditResignationPage({
    Key key,
    @required this.myResignation,
  }) : super(key: key);


  @override
  _EditResignationScreenState createState() => _EditResignationScreenState();
}

class _EditResignationScreenState extends State<EditResignationPage> {
  ApiService _apiService;
  User _currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _FormKey= GlobalKey<FormState>();
  DateFormat dateFormatter;
  String currentDateFormat = '';
  ResignationInfo resignationInfo;
  List<KeyValuePair> reasonList;
  String attachmentName;
  String attachmentPath;
  String attachmentContent; // (optional,Size:Max 5MB,Format: pdf,jpeg,jpg,docx,png),
  String attachmentExtention;
  String hrGroup;
  BasicInfo userBasicInfo;
  Future<UserProfile> _userProfile;
  String toId = '';
  String ccId;
  List<TravelType> ccList = <TravelType>[];
  List<EmployeeListItem> employeeIdList = <EmployeeListItem>[];

  int separation_id;
  String resignation_effective_date;
  int seceond_level_supervisor_id;
  String leaving_reason;
  String resignation_application="";
  String hr_email;
  String secondSupervisor;
  int supervisor_id_2;
  bool notice_period_waive = false;
  DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ;


  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _setInitialValues();
    resignationInfo = ResignationInfo();
    reasonList= [];
    _getCurrentDateFormat();
    //_getResignationInfo();
    _getReasonList();
    _generateCCList();
    _getEmployeeIdList();
    _userProfile = _apiService.getUserProfile();

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
                          "Update Resignation",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _FormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text(
                            "EMPLOYEE NAME :${resignationInfo.employeeName??''}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            "DATE OF JOINING : ${resignationInfo.joiningDate??''}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            "NOTICE PERIOD : ${resignationInfo.noticePeriod??''}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            "APPLICATION DATE : ${resignationInfo.applicationDate??''}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 5,),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex:2,
                                child: Text(
                                  "LAST WORKING DATE :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex:3,
                                child:NeomorphicDatetimePicker(
                                  hintText: "${resignationInfo.resignationEffectiveDate??''}",
                                  updateValue: (String from) {
                                    setState(() {
                                      if (from.isNotEmpty) {
                                        var lastWorkingDate = DateTime.parse(from);
                                        if(lastWorkingDate.isBefore(dateToday)){
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Back Date Selection not allowed!",
                                            fillColor: Colors.red,
                                          );
                                          print('resignation_effective_date : '+ resignation_effective_date);
                                        }
                                        else{
                                          resignation_effective_date = dateFormatter.format(lastWorkingDate);
                                          print('resignation_effective_date : '+ resignation_effective_date);

                                          var noticeServedDay = lastWorkingDate.difference(dateToday).inDays + 1;

                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Your notice served day is " + noticeServedDay.toString(),
                                            fillColor: Colors.green,
                                          );
                                        }

                                      }
                                    });
                                  },
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.365,
                                ),
                              ),

                            ],
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
                                value: reasonList.isNotEmpty ? leaving_reason : null,
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
                                    leaving_reason = value ?? leaving_reason;
                                    if(leaving_reason !=null){
                                      leaving_reason=leaving_reason.trim();
                                      print('leaving_reason: ' + leaving_reason);
                                    }
                                  });
                                },
                              ),
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
                          SizedBox(height: 10),
                          // NeomorphicTextFormField(
                          //     inputType: TextInputType.text,
                          //     hintText: "Ref Id",
                          //     initVal: userBasicInfo.refId,
                          //     isReadOnly: !editMode,
                          //     onChangeFunction: (String val) {
                          //       userBasicInfo.refId = val;
                          //     }),
                          NeomorphicTextFormField(
                            inputType: TextInputType.text,
                            numOfMaxLines: 8,
                            hintText: "Description",
                            fontSize: 12,
                            initVal: resignation_application,
                            onChangeFunction: (String value) {
                              if(value !=null){
                                resignation_application = value.trim();
                                print('resignation_application : ' + resignation_application);
                              }
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

                          FutureBuilder<UserProfile>(
                              future: _userProfile,
                              builder: (context, snapshot)  {
                                if (snapshot.hasData && !snapshot.hasError) {
                                  userBasicInfo = snapshot.data.basicInfo;
                                  var supervisorName = '';
                                  if (userBasicInfo != null) {
                                    supervisorName = userBasicInfo.supervisor;
                                    toId= _currentUser.supervisor_id;
                                  }
                                  //print('SupervisorName:' + supervisorName + '|| SupervisorID:' + toId.toString());

                                  return
                                    NeomorphicTextFormField(
                                      inputType: TextInputType.text,
                                      initVal: 'Supervisor : ${supervisorName} ',
                                      hintText: "Supervisor :",
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
                                  offset: Offset.fromDirection(Math.pi * .25, 5),
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
                                value:  employeeIdList.isNotEmpty ? secondSupervisor : null,
                                hint: Text('2nd Level Supervisor',
                                  style: TextStyle(fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),),
                                items: List<DropdownMenuItem<String>>.generate(
                                  (employeeIdList?.length ?? 0) + 1,
                                      (idx) =>
                                      DropdownMenuItem<String>(
                                        value: idx == 0
                                            ? null
                                            : employeeIdList[idx - 1].iD,
                                        //domestic
                                        child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.6,
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            idx == 0
                                                ? "2nd Level Supervisor"
                                                : employeeIdList[idx - 1].name,
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
                                    secondSupervisor = value ?? secondSupervisor;
                                    if(secondSupervisor != null){
                                      supervisor_id_2= int.tryParse(secondSupervisor);
                                      print('secondSupervisor : ' + employeeIdList.where((e) => e.iD==secondSupervisor).first.name);
                                    }
                                  });
                                },
                              ),
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
                            //margin: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 15,
                                  color: Colors.black26,
                                  offset: Offset.fromDirection(Math.pi * .25, 5),
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
                                value: ccList.isNotEmpty ? hr_email : null,
                                hint: Text('Select CC (HR)',
                                  style: TextStyle(fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500]),),
                                items: List<DropdownMenuItem<String>>.generate(
                                  (ccList?.length ?? 0) + 1,
                                      (idx) =>
                                      DropdownMenuItem<String>(
                                        value: idx == 0
                                            ? null
                                            : ccList[idx - 1].id,
                                        //domestic
                                        child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.6,
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            idx == 0
                                                ? "Select CC (HR)"
                                                : ccList[idx - 1].name,
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
                                    hr_email = value ?? hr_email;
                                    if(hr_email != null){
                                      hr_email =hr_email.trim();
                                      print('hr_email(cc) : ' + hr_email);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Checkbox(
                                value: notice_period_waive,
                                activeColor: kPrimaryColor,
                                onChanged: (newValue) {
                                  setState(() {
                                    notice_period_waive = newValue;
                                    print('notice_period_waive : ' + notice_period_waive.toString());
                                  });
                                },
                              ),
                              Text('Request for Notice Period Waive'),
                            ],
                          ),



                          SizedBox(height: 20),
                          _isLoading
                              ? Center(child: CircularProgressIndicator(),)
                              : WideFilledButton(
                            buttonText: "Submit",
                            onTapFunction: () async {

                              if (resignation_effective_date == null) {
                                showSnackBarMessage(
                                  scaffoldKey: _scaffoldKey,
                                  message: "Please select last working day!",
                                  fillColor: Colors.red,
                                );
                                return;
                              }
                              if (leaving_reason == null) {
                                showSnackBarMessage(
                                  scaffoldKey: _scaffoldKey,
                                  message: "Please Select Leaving Reason",
                                  fillColor: Colors.red,
                                );
                                return;
                              }
                              if (resignation_application == null) {
                                showSnackBarMessage(
                                  scaffoldKey: _scaffoldKey,
                                  message: "Description field is required!",
                                  fillColor: Colors.red,
                                );
                                return;
                              }
                              if (notice_period_waive == true && attachmentContent == null) {
                                showSnackBarMessage(
                                  scaffoldKey: _scaffoldKey,
                                  message: "Document should be mandatory as you selected yes for notice period waive!",
                                  fillColor: Colors.red,
                                );
                                return;
                              }
                              if (hr_email == null) {
                                showSnackBarMessage(
                                  scaffoldKey: _scaffoldKey,
                                  message: "Please select CC (HR)",
                                  fillColor: Colors.red,
                                );
                                return;
                              }

                              try {
                                setState(() {
                                  _isLoading = true;
                                });

                                var formData = FormData.fromMap({
                                  "separation_id" : separation_id,
                                  "resignation_effective_date": resignation_effective_date,
                                  "leaving_reason": leaving_reason,
                                  "resignation_application": resignation_application,
                                  "hr_email": hr_email,
                                  "supervisor_id_2": supervisor_id_2,
                                  "notice_period_waive": notice_period_waive == true ? 1 : 0,
                                });

                                if (attachmentContent != null) {
                                  var file = await MultipartFile.fromFile(
                                      attachmentPath,
                                      filename: attachmentName);
                                  formData.files.add(MapEntry("attachment", file));
                                }

                                print('--------------From Submit----------------' + formData.fields.toString());

                                final response = await _apiService.applyForResignationUpdate(formData);

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
                                  message: "Failed to Update for resignation!",
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
          content: Text("Successfully Updated for Resignation!!!"),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments: ResignationPageScreen.ResignationApplication);
              },
            ),
          ],
        );
      },
    );
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
  void _getResignationInfo() async {
    var response = await _apiService.getResignationInfo();
    setState(() {
      resignationInfo  = response;
      resignation_effective_date = resignationInfo.resignationEffectiveDate;
      secondSupervisor = resignationInfo.seceondLevelSupervisorId.toString();
      supervisor_id_2 =  resignationInfo.seceondLevelSupervisorId;
    });
  }
  void _getReasonList() async{
    var response = await _apiService.getResignationReason();
    setState(() {
      reasonList  = response.keyValuePair;
      //print('reasonList : '+ reasonList.toJson().toString());
    });
  }
  void _generateCCList() async {
    var response =  await _apiService.getResignationCCs();
    setState(() {
      ccList = response.travelType.toList();
    });

  }
  void _getEmployeeIdList() async{
    var response =  await _apiService.getReliverIds();
    setState(() {
      employeeIdList = response.employeeList.toList();
    });

  }

  void _setInitialValues() async{
    var response = await _apiService.getEditResignation(widget.myResignation.separationId);
    separation_id= response.id;
    resignationInfo.employeeName=response.employeeName;
    resignationInfo.joiningDate =response.joiningDate;
    resignationInfo.noticePeriod = response.noticePeriod;
    resignationInfo.applicationDate = response.applicationDate;
    resignationInfo.resignationEffectiveDate = response.resignationEffectiveDate;
    resignation_effective_date = response.resignationEffectiveDate;
    leaving_reason = response.leavingReason;

    setState(() {
      resignation_application = response.resignationApplication;
    });

    secondSupervisor = response.seceondLevelSupervisorId.toString();
    supervisor_id_2 =  response.seceondLevelSupervisorId;

    hr_email = response.hrEmail;
    notice_period_waive = response.noticePeriodWaive == 1 ? true : false;
    //print("notice_period_waive : "+ notice_period_waive.toString());
  }
}




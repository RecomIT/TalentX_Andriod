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
import 'package:recom_app/data/models/id_card_request.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/leave_type.dart';
import 'package:recom_app/data/models/letter_request.dart';
import 'package:recom_app/data/models/resignation_info.dart';
import 'package:recom_app/data/models/travel_purpose.dart';
import 'package:recom_app/data/models/travel_type.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/data/models/user_profile.dart';
import 'package:recom_app/data/models/id_card_request.dart';
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


class CreateLetterPage extends StatefulWidget {
  const CreateLetterPage({Key key}) : super(key: key);

  @override
  _CreateLetterPageState createState() => _CreateLetterPageState();
}

class _CreateLetterPageState extends State<CreateLetterPage> {
  ApiService _apiService;
  LetterRequest requestInfo;
  Future<LetterRequest> _letterRequest;
  User _currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey= GlobalKey<FormState>();
  //DateFormat _dateFormat= DateFormat('MMM dd,yyyy');//('hh:mm:ss, dd-MMM-yyyy');

  String currentDateFormat = '';
  DateFormat dateFormatter;
  String fromDate;
  String toDate;
  String dob;
  DateTime StartDate;
  DateTime EndDate;
  DateTime DateofBirth;

  String requisition_type;
  bool is_introductory_type = false;
  bool is_invitation_type = false;
  String reason;
  String other_reason;
  bool is_other_reason = false;
  bool salary_display = false;
  String passport_no;
  String embassy_name;
  String embassy_address;
  bool is_other_embassy = false;
  String other_embassy_name;
  String other_embassy_address;
  String remarks;

  List<LetterReason> reasonList=[]; //Letter Types with Key Value Pair
  
  bool _isLoading = false;
  String note= 'N/A';
  bool isActionCanceled = false;

  String attachmentName;
  String attachmentPath;
  String attachmentContent; // (optional,Size:Max 1MB,Format: pdf,jpeg,jpg,docx,png),
  String attachmentExtention;

  String photoName;
  String photoPath;
  String photoContent; // (optional,Size:Max 1MB,Format: pdf,jpeg,jpg,docx,png),
  String photoExtention;

  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _getCurrentDateFormat();
    _letterRequest=_apiService.getLetterRequest();

  }

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
            //mainAxisAlignment: MainAxisAlignment.start,
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
                child:
                FutureBuilder<LetterRequest>(
                    future: _letterRequest,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        requestInfo = snapshot.data;
                        //print(requestInfo);
                        if(requestInfo == null){
                          return Text('Message : No Request Details Available');
                        }else{
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Request For Letter",
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15,),
                                      Text(
                                        "Employee Name : ${_currentUser.name}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Employee Role : ${requestInfo.employeeRole}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Division : ${requestInfo.employeeDivision}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Department : ${requestInfo.employeeDepartment}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Line Manager : ${requestInfo.lineManager}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      // !requestInfo.dateOfJoin.toLowerCase().contains('n/a') ?
                                      // Text('Date of Join :  ${dateFormatter.format(DateTime.tryParse(requestInfo.dateOfJoin))}',style: TextStyle(
                                      //   color: Colors.black45,
                                      //   fontWeight: FontWeight.bold,
                                      //   fontSize: 12,
                                      // ))
                                      //     :
                                      Text('Date of Join :  ${requestInfo.dateOfJoin}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 10,),
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
                                            value: requisition_type,
                                            hint: Text('Select Requisition For',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.requisitionFor?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.requisitionFor[idx - 1].key,
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Requisition For" : requestInfo.requisitionFor[idx - 1].value,
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
                                                requisition_type = value ?? requisition_type;
                                                if(requisition_type !=null){
                                                  requisition_type=requisition_type;
                                                  reason=null;
                                                  other_reason=null;
                                                  is_other_reason= false;
                                                  is_introductory_type=false;
                                                  is_invitation_type=false;
                                                  salary_display =false;
                                                  passport_no=null;
                                                  dob=null;
                                                  toDate=null;
                                                  fromDate=null;
                                                  embassy_name=null;
                                                  embassy_address=null;
                                                  is_other_embassy=false;
                                                  other_embassy_name=null;
                                                  other_embassy_address=null;
                                                  remarks=null;
                                                  attachmentContent=null;
                                                  attachmentName=null;
                                                  attachmentPath=null;
                                                  attachmentExtention=null;


                                                  print('requisition_type: ' + requisition_type);

                                                  switch(requisition_type) {
                                                    case 'Salary Certificate': reasonList = requestInfo.salaryCertificate; break;
                                                    case 'Introductory Letter': {reasonList = requestInfo.introductoryLetter; is_introductory_type=true;print('is_introductory_type: ' + is_introductory_type.toString());} break;
                                                    case 'Invitation Letter': {reasonList = requestInfo.invitationLetter; is_invitation_type=true;print('is_invitation_type: ' + is_invitation_type.toString());} break;
                                                    case 'Experience Letter': reasonList = requestInfo.experienceLetter; break;
                                                    default: reasonList =[];break;
                                                  }

                                                }
                                              });
                                            },
                                          ),
                                        ),

                                      ),
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
                                          margin: EdgeInsets.only(top: 5),
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
                                                    value: idx == 0 ? null : reasonList[idx - 1].key,
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Reason" : reasonList[idx - 1].value,
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
                                                  reason=reason;
                                                  print('reason: ' + reason);
                                                  is_other_reason = reason.toLowerCase().contains('others') ? true : false;
                                                  if(!is_other_reason){
                                                    other_reason=null;
                                                  }
                                                  print('is_other_reason : ' + is_other_reason.toString());
                                                }
                                              });
                                            },
                                          ),
                                        ),

                                      ),
                                      SizedBox(height: 10),
                                      is_other_reason ? NeomorphicTextFormField(
                                        inputType: TextInputType.text,
                                        numOfMaxLines: 3,
                                        hintText: "Other Reason",
                                        fontSize: 12,
                                        onChangeFunction: (String purpose) {
                                          other_reason = purpose;
                                          print('other_reason: ' + other_reason);
                                        },
                                      ): Container(),
                                      SizedBox(height: 10),

                                      Visibility(
                                        visible: is_introductory_type || is_invitation_type,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: salary_display,
                                                    activeColor: kPrimaryColor,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        salary_display = newValue;
                                                        print('salary_display : ' + salary_display.toString());
                                                      });
                                                    },
                                                  ),
                                                  Text('Salary Display'),
                                                ],
                                              ),
                                              NeomorphicTextFormField(
                                                inputType: TextInputType.text,
                                                hintText: "Passport No",
                                                fontSize: 12,
                                                onChangeFunction: (String text) {
                                                  passport_no = text ;
                                                  print('passport_no: ' + passport_no.toString());
                                                },
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  NeomorphicDatetimePicker(
                                                    hintText: dob ?? "Date of Birth",
                                                    updateValue: (String from) {
                                                      setState(() {
                                                        dob = dateFormatter.format(DateTime.tryParse(from));
                                                        print("Date of Birth : " + dob);
                                                        DateofBirth = DateTime.tryParse(from);
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  NeomorphicDatetimePicker(
                                                    hintText: fromDate ?? "Leave Start Date",
                                                    updateValue: (String from) {
                                                      setState(() {
                                                        fromDate = dateFormatter.format(DateTime.tryParse(from));
                                                        print("Leave Start Date : " + fromDate);
                                                        StartDate=DateTime.tryParse(from);
                                                      });
                                                    },
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width * 0.365,
                                                  ),
                                                  NeomorphicDatetimePicker(
                                                    hintText: toDate ?? "Leave End Date",
                                                    updateValue: (String to) {
                                                      setState(() {
                                                        toDate = dateFormatter.format(DateTime.tryParse(to));
                                                        print("Leave End Date : " + toDate);
                                                        EndDate =DateTime.tryParse(to);
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
                                                  margin: EdgeInsets.only(top: 5),
                                                  width: double.infinity,

                                                  child: DropdownButton<String>(
                                                    isDense: true,
                                                    underline: SizedBox(),
                                                    value: embassy_name,
                                                    hint: Text('Select Embassy Name',
                                                      style: TextStyle(fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey[500]),),
                                                    items: List<DropdownMenuItem<String>>.generate(
                                                      (requestInfo.embassy?.length ?? 0) + 1,
                                                          (idx) =>
                                                          DropdownMenuItem<String>(
                                                            value: idx == 0 ? null : requestInfo.embassy[idx - 1].embassyName,
                                                            child: Container(
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width * 0.6,
                                                              padding: EdgeInsets.only(left: 20),
                                                              child: Text(
                                                                idx == 0 ? "Select Embassy Name" : requestInfo.embassy[idx - 1].embassyName,
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
                                                        embassy_name = value ?? embassy_name;
                                                        if(embassy_name !=null){
                                                          embassy_name=embassy_name;
                                                          var embassy = requestInfo.embassy.firstWhere((e) => e.embassyName==embassy_name,orElse: (()=>null));
                                                          embassy_address = embassy != null ? embassy.address : null;
                                                          print('embassy_name: ' + embassy_name);
                                                          print('embassy_address: ' + embassy_address.toString());
                                                          is_other_embassy = embassy_address.toLowerCase().contains('others') ? true : false;
                                                          if(!is_other_embassy){
                                                            other_embassy_name=null;
                                                            other_embassy_address=null;
                                                          }
                                                          print('other_embassy_name: ' + other_embassy_name.toString());
                                                          print('other_embassy_address: ' + other_embassy_address.toString());
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),

                                              ),
                                              SizedBox(height: 10),
                                              !is_other_embassy ? NeomorphicTextFormField(
                                                key: Key(embassy_address),
                                                initVal: "Embassy Address : ${embassy_address??''}",
                                                isReadOnly: true,
                                                inputType: TextInputType.text,
                                                numOfMaxLines: 3,
                                                hintText: "Embassy Address",
                                                fontSize: 12,
                                                onChangeFunction: (String text) {
                                                  embassy_address = text;
                                                  print('embassy_address: ' + embassy_address);
                                                },
                                              ):Container(),
                                              SizedBox(height: 10),

                                              is_other_embassy ? NeomorphicTextFormField(
                                                inputType: TextInputType.text,
                                                numOfMaxLines: 3,
                                                hintText: "Other Embassy Name",
                                                fontSize: 12,
                                                onChangeFunction: (String purpose) {
                                                  other_embassy_name = purpose;
                                                  print('other_embassy_name: ' + other_embassy_name);
                                                },
                                              ): Container(),

                                              SizedBox(height: 10),

                                              is_other_embassy ? NeomorphicTextFormField(
                                                inputType: TextInputType.text,
                                                numOfMaxLines: 3,
                                                hintText: "Other Embassy Address",
                                                fontSize: 12,
                                                onChangeFunction: (String purpose) {
                                                  other_embassy_address = purpose;
                                                  print('other_embassy_address: ' + other_embassy_address);
                                                },
                                              ): Container(),
                                              SizedBox(height: 10),

                                              NeomorphicTextFormField(
                                                inputType: TextInputType.text,
                                                numOfMaxLines: 3,
                                                hintText: "Description",
                                                fontSize: 12,
                                                onChangeFunction: (String text) {
                                                  remarks = text;
                                                  print('Description: ' + remarks);
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
                                                      final fileContent = base64Encode(pickedFile.readAsBytesSync());
                                                      setState(() {
                                                        attachmentName = pickedFile.path
                                                            .split("/")
                                                            .last;
                                                        attachmentExtention = pickedFile.path
                                                            .split("/")
                                                            .last
                                                            .split(".")
                                                            .last;
                                                        attachmentContent = fileContent;
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

                                            ],
                                      )),


                                      SizedBox(height:20),
                                      _isLoading
                                          ? Center(child: CircularProgressIndicator(),)
                                          : WideFilledButton(
                                        buttonText: "Submit",
                                        onTapFunction: () async {

                                          if (requisition_type == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Requisition Letter Type!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (reason == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Reason!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }

                                          if (is_other_reason && other_reason == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Specify Other Reason!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }

                                          if(is_invitation_type || is_introductory_type){

                                            if (passport_no == null || passport_no.trim().isEmpty) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Please Specify a Valid Passport No!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }
                                            if (dob == null) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Date of Birth is Required!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }
                                            if (fromDate == null) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Leave Start Date is Required!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }
                                            if (toDate == null) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Leave End Date is Required!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }

                                            if (EndDate.isBefore(StartDate)) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Wrong Date Selection.Leave End Date can not be before Leave Start Date!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }

                                            if (embassy_name == null) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Please Select Embassy Name!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }

                                            if (is_other_embassy && other_embassy_name == null) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Please Specify Other Embassy Name!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }
                                            if (is_other_embassy && other_embassy_address == null) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Please Specify Other Embassy Address!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }

                                            if (remarks == null || remarks.trim().isEmpty) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Description is Required!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }

                                            if (attachmentContent == null) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Attachment is Required!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }
                                          }



                                          try {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            var formData = FormData.fromMap({
                                              "requisition_type": requisition_type,
                                              "reason":  reason,  // is_other_reason ? null :
                                              "others_reason": other_reason,
                                              "salary_display": salary_display ? 'yes' : 'no',
                                              "passport_no": passport_no,
                                              "start_date": fromDate,
                                              "end_date": toDate,
                                              "date_of_birth": dob,
                                              "embassy_name": is_other_embassy ? null : embassy_name,
                                              "embassy_address": is_other_embassy ? null : embassy_address,
                                              "other_embassy_name": other_embassy_name,
                                              "other_embassy_address": other_embassy_address,
                                              "remarks": remarks,
                                            });


                                            if (attachmentContent != null) {
                                              var file = await MultipartFile.fromFile(
                                                  attachmentPath,
                                                  filename: attachmentName);
                                              formData.files.add(MapEntry("attachment", file));
                                            }


                                            print('--------------From Submit----------------' + formData.fields.toString());

                                            final response = await _apiService.applyForLetter(formData);

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
                                              message: "Failed to apply for for Letter Requisition!",
                                              fillColor: Colors.red,
                                            );
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        },
                                      ),
                                    ]),
                              )],
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
            ],
          ),
        ),

      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
      ),
    );
  }

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
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successfully"),
          content: Text("Successfully Applied for Letter Requisition!!!"),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(LETTER_PAGE,arguments: LetterPageScreen.Letter);
              },
            ),
          ],
        );
      },
    );
  }
}



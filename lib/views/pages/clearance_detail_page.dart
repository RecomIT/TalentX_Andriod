import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/attachment_model.dart';
import 'package:recom_app/data/models/clearance.dart';
import 'package:recom_app/data/models/clearance_details.dart';
import 'package:recom_app/data/models/employee_id_list.dart';
import 'package:recom_app/data/models/id_card_request.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/leave_type.dart';
import 'package:recom_app/data/models/lunch_subscription_request.dart';
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
import 'package:recom_app/views/pages/lunch_subscription_page.dart';
import 'package:recom_app/views/widgets/flat_app_bar.dart';
import 'package:recom_app/views/widgets/neomorphic_datetime_picker.dart';
import 'package:recom_app/views/widgets/neomorphic_text_form_field.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:recom_app/views/widgets/wide_filled_button.dart';
import 'dart:math' as Math;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dropdownfield/dropdownfield.dart';

class ClearanceDetailPage extends StatefulWidget {
  final Clearance clearance;
  const ClearanceDetailPage({Key key, this.clearance}) : super(key: key);

  @override
  _ClearanceDetailPageState createState() => _ClearanceDetailPageState();
}

class _ClearanceDetailPageState extends State<ClearanceDetailPage> {
  ApiService _apiService;

  User _currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _FormKey= GlobalKey<FormState>();

  Future<ClearanceDetails> _clearanceDetails;
  ClearanceDetails requestInfo;
  List<KeyValuePair> selectOptions =[
    new KeyValuePair(id: 'Yes', name: 'Yes'),
    new KeyValuePair(id: 'No', name: 'No')
  ];

  String deduction = 'No';
  String reimburse = 'No';
  double deductionAmount = 0;
  double reimburseAmount = 0;
  String deductionRemarks = '';
  String reimburseRemarks = '';
  String remarks;
  String status;
  //List<AttachmentModel> files = [];
  List<File> files = [];

  bool _isLoading = false;
  String note= 'N/A';
  bool isActionCanceled = false;

  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.clearance == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
            (route) => false,
      );
    }
    _clearanceDetails = _apiService.getClearanceDetails(widget.clearance.id.toString());
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
        child: (widget.clearance == null)
            ?  SizedBox() :
        SingleChildScrollView(
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
                FutureBuilder<ClearanceDetails>(
                    future: _clearanceDetails,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        requestInfo = snapshot.data;
                        //print(requestInfo.subscriptionRequestTimeLine);
                        if(requestInfo == null){
                          return Text('Message : No Clearance Feedback Details Available');
                        }else{
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Clearance Feedback",
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
                                      SizedBox(height: 15,),
                                      Text(
                                        "Employee Name : ${requestInfo.employeeInfo.employeeName}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Date of Joining : ${requestInfo.employeeInfo.joiningDate}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Notice Period : ${requestInfo.employeeInfo.noticePeriod}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text('Notice Period Served :  ${requestInfo.employeeInfo.noticePeriodServed}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Application Date :  ${requestInfo.employeeInfo.applicationDate}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Resignation Effective Date :  ${requestInfo.employeeInfo.resignationEffectiveDate}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Reason for Leaving :  ${requestInfo.employeeInfo.leavingReason}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Personal Phone :  ${requestInfo.employeeInfo.personalPhone}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Personal Email :  ${requestInfo.employeeInfo.personalEmail}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Official Phone :  ${requestInfo.employeeInfo.officialPhone}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Official Email :  ${requestInfo.employeeInfo.officialEmail}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Supervisor Id :  ${requestInfo.employeeInfo.supervisorId}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Supervisor Name :  ${requestInfo.employeeInfo.supervisorName}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Supervisor Phone :  ${requestInfo.employeeInfo.supervisorPhone}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Supervisor Email :  ${requestInfo.employeeInfo.supervisorEmail}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 5,),
                                      Text('Location :  ${requestInfo.employeeInfo.employeeLocation}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 10,),

                                      Visibility(
                                        visible:
                                        requestInfo.clearanceAuthority, child: Column(
                                        children: [
                                          Text('Deduction  '
                                              ,style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              )),
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
                                                value: deduction,
                                                hint: Text('Select Deduction',
                                                  style: TextStyle(fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey[500]),),
                                                items: List<DropdownMenuItem<String>>.generate(
                                                  (selectOptions?.length ?? 0) + 1,
                                                      (idx) =>
                                                      DropdownMenuItem<String>(
                                                        value: idx == 0 ? null : selectOptions[idx - 1].id.toString(),
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width * 0.6,
                                                          padding: EdgeInsets.only(left: 20),
                                                          child: Text(
                                                            idx == 0 ? "Select Deduction" : selectOptions[idx - 1].name,
                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                ),
                                                onChanged: (String value) {
                                                  setState(() {
                                                    deduction = value ?? deduction;
                                                    if(deduction !=null){
                                                      deduction = deduction;
                                                      deductionAmount = 0;
                                                      deductionRemarks = '';
                                                      print('deduction: ' + deduction + '| deductionAmount : ' + deductionAmount.toString() + '| deductionRemarks : ' + deductionRemarks);
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Visibility(
                                            visible: deduction == 'Yes' ,
                                            child: Column(
                                              children: [
                                                NeomorphicTextFormField(
                                                  //initVal: deductionAmount.toString(),
                                                    inputType: TextInputType.number,
                                                    hintText: "Input Deduction Amount",
                                                    onChangeFunction: (String val) {
                                                      deductionAmount = double.tryParse(val);
                                                      if(deductionAmount !=null){
                                                        print('deductionAmount : ' + deductionAmount.toString());
                                                      }else{deductionAmount=0;
                                                      print('deductionAmount : ' + deductionAmount.toString());                                            }
                                                    }),

                                                NeomorphicTextFormField(
                                                  //initVal: 'Office Address : ${deductionRemarks??''} ',
                                                  inputType: TextInputType.text,
                                                  hintText: "Deduction Remarks",
                                                  onChangeFunction: (String value) {
                                                    if (value != null) {
                                                      deductionRemarks = value.trim();
                                                      print('Deduction Remarks : ' + deductionRemarks);
                                                    }
                                                  },
                                                ),
                                              ],),
                                          ),
                                          SizedBox(height: 10),

                                          Text('Reimburse  '
                                              ,style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              )),
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
                                                value: reimburse,
                                                hint: Text('Select Reimburse',
                                                  style: TextStyle(fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey[500]),),
                                                items: List<DropdownMenuItem<String>>.generate(
                                                  (selectOptions?.length ?? 0) + 1,
                                                      (idx) =>
                                                      DropdownMenuItem<String>(
                                                        value: idx == 0 ? null : selectOptions[idx - 1].id.toString(),
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width * 0.6,
                                                          padding: EdgeInsets.only(left: 20),
                                                          child: Text(
                                                            idx == 0 ? "Select Reimburse" : selectOptions[idx - 1].name,
                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                ),
                                                onChanged: (String value) {
                                                  setState(() {
                                                    reimburse = value ?? reimburse;
                                                    if(reimburse !=null){
                                                      reimburse = reimburse;
                                                      reimburseAmount = 0;
                                                      reimburseRemarks = '';
                                                      print('reimburse: ' + reimburse + '| reimburseAmount : ' + reimburseAmount.toString() + '| reimburseRemarks : ' + reimburseRemarks);
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Visibility(
                                            visible: reimburse == 'Yes' ,
                                            child: Column(
                                              children: [
                                                NeomorphicTextFormField(
                                                  //initVal: deductionAmount.toString(),
                                                    inputType: TextInputType.number,
                                                    hintText: "Input Reimburse Amount",
                                                    onChangeFunction: (String val) {
                                                      reimburseAmount = double.tryParse(val);
                                                      if(reimburseAmount !=null){
                                                        print('reimburseAmount : ' + reimburseAmount.toString());
                                                      }else{
                                                        reimburseAmount=0;
                                                        print('reimburseAmount : ' + reimburseAmount.toString());
                                                      }
                                                    }),

                                                NeomorphicTextFormField(
                                                  //initVal: 'Office Address : ${deductionRemarks??''} ',
                                                  inputType: TextInputType.text,
                                                  hintText: "Reimburse Remarks",
                                                  onChangeFunction: (String value) {
                                                    if (value != null) {
                                                      reimburseRemarks = value.trim();
                                                      print('Reimburse Remarks : ' + reimburseRemarks);
                                                    }
                                                  },
                                                ),
                                              ],),
                                          ),
                                        ],)),

                                      SizedBox(height: 5,),
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
                                            value: status,
                                            hint: Text('Select Status',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.statusDropdown.statusDropdownList?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.statusDropdown.statusDropdownList[idx - 1].id.toString(),
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Status" : requestInfo.statusDropdown.statusDropdownList[idx - 1].name,
                                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                            onChanged: (String value) {
                                              setState(() {
                                                status = value ?? status;
                                                if(status !=null){
                                                  status = status;
                                                  print('Status: ' + status );
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      NeomorphicTextFormField(
                                        //initVal: 'Office Address : ${deductionRemarks??''} ',
                                        inputType: TextInputType.text,
                                        hintText: "Remarks",
                                        numOfMaxLines: 3,
                                        onChangeFunction: (String value) {
                                          if (value != null) {
                                            remarks = value.trim();
                                            print('Remarks : ' + remarks);
                                          }
                                        },
                                      ),

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
                                            child: Text("${ files?.length > 0 ?  files?.map((e) => e.path.split("/").last).join('\n')
                                                : "Documents"}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45
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

                                              final pickedFiles = await FilePicker.getMultiFile(type: FileType.custom, allowedExtensions: [
                                                  "pdf",
                                                  "jpeg",
                                                  "jpg",
                                                  "docx",
                                                  "doc",
                                                  "png"
                                                ],);

                                              if (pickedFiles != null) {
                                                List<File> file = pickedFiles.map((paths) => File(paths.path)).toList();
                                                files = file;
                                                //files.forEach((e) {print('===============>>>'+ e.path.split("/").last);});
                                              }
                                              else{
                                                files=[];
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              width: (MediaQuery.of(context).size.width - 80) * 0.28,
                                              decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.all(Radius.circular(15),)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.camera_enhance_outlined, color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height:20),
                                      _isLoading
                                          ? Center(child: CircularProgressIndicator(),)
                                          : WideFilledButton(
                                        buttonText: "Submit",
                                        onTapFunction: () async {

                                          if (status == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Status!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (remarks == null || remarks.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Remarks is Required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }

                                          if(requestInfo.clearanceAuthority){
                                            if (deduction == 'Yes') {
                                              if (deductionAmount < 1) {
                                                showSnackBarMessage(
                                                  scaffoldKey: _scaffoldKey,
                                                  message: "Please Insert a Valid Deduction Amount!",
                                                  fillColor: Colors.red,
                                                );
                                                return;
                                              }
                                              if (deductionRemarks == null || deductionRemarks.isEmpty) {
                                                showSnackBarMessage(
                                                  scaffoldKey: _scaffoldKey,
                                                  message: "Deduction Remarks is Required!",
                                                  fillColor: Colors.red,
                                                );
                                                return;
                                              }
                                            }
                                            if (reimburse == 'Yes') {
                                              if (reimburseAmount < 1) {
                                                showSnackBarMessage(
                                                  scaffoldKey: _scaffoldKey,
                                                  message: "Please Insert a Valid Reimburse Amount!",
                                                  fillColor: Colors.red,
                                                );
                                                return;
                                              }
                                              if (reimburseRemarks == null || reimburseRemarks.isEmpty) {
                                                showSnackBarMessage(
                                                  scaffoldKey: _scaffoldKey,
                                                  message: "Reimburse Remarks is Required!",
                                                  fillColor: Colors.red,
                                                );
                                                return;
                                              }
                                            }
                                          }

                                          try {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            var formData = FormData.fromMap({
                                               "status": status,
                                               "remarks": remarks,
                                            });

                                            files.forEach((e) async {
                                              var file = await MultipartFile.fromFile(
                                                  e.path,
                                                  filename: e.path.split("/").last);
                                              formData.files.add(MapEntry("attachment", file));
                                              print('--------------From File Submit---------------- File Name : ' + file.filename);
                                            });

                                            if(requestInfo.clearanceAuthority){
                                              formData.fields.add(MapEntry("deduction", deduction));
                                              formData.fields.add(MapEntry("deduction_amount", deductionAmount.toString()));
                                              formData.fields.add(MapEntry("deduction_remarks", deductionRemarks));
                                              formData.fields.add(MapEntry("reimburse", reimburse));
                                              formData.fields.add(MapEntry("reimburse_amount", reimburseAmount.toString()));
                                              formData.fields.add(MapEntry("reimburse_remarks", reimburseRemarks));
                                            }

                                            print('-------------- From Submit----------------' + formData.fields.toString());
                                            //return;
                                            final response = await _apiService.applyForClearanceFeedbacks(formData, widget.clearance.id.toString());

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
                                              message: "Failed to apply for Clearance Feedbacks!",
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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successfully"),
          content: Text("Successfully Applied for Clearance Feedbacks"),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(CLEARANCE_PAGE,arguments:ClearancePageScreen.Clearance);
              },
            ),
          ],
        );
      },
    );
  }
}



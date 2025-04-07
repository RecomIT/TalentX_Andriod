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
import 'package:recom_app/data/models/Id_card.dart';
import 'package:recom_app/data/models/edit_id_card_request.dart';
import 'package:recom_app/data/models/edit_visiting_card_request.dart';
import 'package:recom_app/data/models/employee_id_list.dart';
import 'package:recom_app/data/models/id_card_request.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/leave_type.dart';
import 'package:recom_app/data/models/resignation_info.dart';
import 'package:recom_app/data/models/travel_purpose.dart';
import 'package:recom_app/data/models/travel_type.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/data/models/user_profile.dart';
import 'package:recom_app/data/models/visiting_card.dart';
import 'package:recom_app/data/models/visiting_card_request.dart';
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


class EditIdCardPage extends StatefulWidget {
  final IdCard myIdCard;
  const EditIdCardPage({Key key,
  this.myIdCard}) : super(key: key);

  @override
  _EditIdCardPageState createState() => _EditIdCardPageState();
}

class _EditIdCardPageState extends State<EditIdCardPage> {
  ApiService _apiService;
  EditIdCardRequest requestInfo;
  User _currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _FormKey= GlobalKey<FormState>();
  DateFormat _dateFormat= DateFormat('MMM dd,yyyy');//('hh:mm:ss, dd-MMM-yyyy');
  String required_status;
  String short_name;
  //int quantity=0;
  String quantity;
  String official_contact;
  String official_email;
  String official_address;
  String business_unit_head_id;
  String blood_group;
  String reason;
  String remarks;
  bool _isLoading = false;
  String note= 'N/A';
  bool isActionCanceled = false;
  Future<EditIdCardRequest> _editIdCardRequest;
  String attachmentName;
  String attachmentPath;
  String attachmentContent; // (optional,Size:Max 1MB,Format: pdf,jpeg,jpg,docx,png),
  String attachmentExtention;

  String photoName;
  String photoPath;
  String photoContent; // (optional,Size:Max 1MB,Format: pdf,jpeg,jpg,docx,png),
  String photoExtention;

  void initState() {
    if (widget.myIdCard == null)
    {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
            (route) => false,
      );
    }
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _editIdCardRequest=_apiService.getEditIdCardRequest(widget.myIdCard.id);
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
        child: (widget.myIdCard == null)
            ? SizedBox()
            :SingleChildScrollView(
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
                FutureBuilder<EditIdCardRequest>(
                    future: _editIdCardRequest,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        requestInfo = snapshot.data;
                        //print(requestInfo.employeeBusinessUnit);
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
                                    "Request For ID Card",
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
                                        "Employee Name : ${requestInfo.employeeDetails.employeeName}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Employee Code : ${requestInfo.employeeDetails.employeeCode}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Employee Role : ${requestInfo.employeeDetails.employeeRole}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Division : ${requestInfo.employeeDetails.employeeDivision}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Department : ${requestInfo.employeeDetails.employeeDepartment}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Line Manager : ${requestInfo.employeeDetails.lineManager}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      !requestInfo.employeeDetails.requisitionDate.toLowerCase().contains('n/a') ?
                                      Text('Requisition Date :  ${_dateFormat.format(DateTime.tryParse(requestInfo.employeeDetails.requisitionDate))}',style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ))
                                          :
                                      Text('Requisition Date :  ${requestInfo.employeeDetails.requisitionDate}'
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
                                            value: required_status?? requestInfo.idCardDetails.requiredStatus,
                                            hint: Text('Select Required Status',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.employeeDetails.requiredStatus?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.employeeDetails.requiredStatus[idx - 1].key,
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Required Status" : requestInfo.employeeDetails.requiredStatus[idx - 1].value,
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
                                                required_status = value ?? required_status;
                                                if(required_status !=null){
                                                  required_status=required_status;
                                                  print('required_status: ' + required_status);
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
                                          margin: EdgeInsets.only(top: 10),
                                          width: double.infinity,
                                          child: DropdownButton<String>(
                                            isDense: true,
                                            underline: SizedBox(),
                                            value: blood_group ?? requestInfo.idCardDetails.bloodGroup,
                                            hint: Text('Blood Group',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.employeeDetails.bloodGroup?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.employeeDetails.bloodGroup[idx - 1].key.toString(),
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Blood Group" : requestInfo.employeeDetails.bloodGroup[idx - 1].value,
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
                                                blood_group = value ?? blood_group;
                                                if(blood_group !=null){
                                                  blood_group=blood_group;
                                                  print('blood_group: ' + blood_group);
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
                                            value: reason?? requestInfo.idCardDetails.reason,
                                            hint: Text('Select Reason',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.employeeDetails.reason?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.employeeDetails.reason[idx - 1].key,
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Reason" : requestInfo.employeeDetails.reason[idx - 1].value,
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
                                                }
                                              });
                                            },
                                          ),
                                        ),

                                      ),
                                      SizedBox(height: 5),
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
                                              photoName ?? "Photo",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: photoName == null
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
                                                photoName = pickedFile.path
                                                    .split("/")
                                                    .last;
                                                photoExtention = pickedFile.path
                                                    .split("/")
                                                    .last
                                                    .split(".")
                                                    .last;
                                                photoContent = fileCotent;
                                                photoPath = pickedFile.path;
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
                                      SizedBox(height:10),
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

                                      SizedBox(height:20),
                                      _isLoading
                                          ? Center(child: CircularProgressIndicator(),)
                                          : WideFilledButton(
                                        buttonText: "Submit",
                                        onTapFunction: () async {

                                          if (required_status == null) {
                                            required_status= requestInfo.idCardDetails.requiredStatus;
                                          }
                                          if (blood_group == null) {
                                            blood_group= requestInfo.idCardDetails.bloodGroup;
                                          }
                                          if (reason == null) {
                                            reason= requestInfo.idCardDetails.reason;
                                          }

                                          if (photoContent == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Photo is mandatory!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (attachmentContent == null && reason.toLowerCase()=='lost') {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "If Reason is Lost then, GD copy is mandatory!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }

                                          try {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            var formData = FormData.fromMap({
                                              "id_card_id" : requestInfo.idCardDetails.id,
                                              "blood_group": blood_group,
                                              "reason": reason,
                                              "required_status": required_status,
                                            });

                                            if (photoContent != null) {
                                              var file = await MultipartFile.fromFile(
                                                  photoPath,
                                                  filename: photoName);
                                              formData.files.add(MapEntry("photo", file));
                                            }
                                            if (attachmentContent != null) {
                                              var file = await MultipartFile.fromFile(
                                                  attachmentPath,
                                                  filename: attachmentName);
                                              formData.files.add(MapEntry("attachment", file));
                                            }

                                            print('--------------From Submit----------------' + formData.fields.toString());

                                            final response = await _apiService.updateForIdCard(formData);

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
                                              message: "Failed to apply for for ID Card Requisition!",
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
          content: Text("Successfully Applied for ID Card Requisition!!!"),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ID_CARD_PAGE,arguments: IdCardPageScreen.IdCard);
              },
            ),
          ],
        );
      },
    );
  }
}



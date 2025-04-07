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


class CreateVisitingCardPage extends StatefulWidget {
  const CreateVisitingCardPage({Key key}) : super(key: key);

  @override
  _CreateVisitingCardPageState createState() => _CreateVisitingCardPageState();
}

class _CreateVisitingCardPageState extends State<CreateVisitingCardPage> {
  ApiService _apiService;
  VisitingCardRequest requestInfo;
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
  String remarks;
  Future<VisitingCardRequest> _visitingCardRequest;
  bool _isLoading = false;
  String note= 'N/A';
  bool isActionCanceled = false;

  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _visitingCardRequest=_apiService.getVisitingCardRequest();
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
                FutureBuilder<VisitingCardRequest>(
                    future: _visitingCardRequest,
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
                                    "Request For Visiting Card",
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
                                        "Employee Name : ${requestInfo.employeeName}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Employee Code : ${requestInfo.employeeCode}",
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
                                      !requestInfo.requisitionDate.toLowerCase().contains('n/a') ?
                                      Text('Requisition Date :  ${_dateFormat.format(DateTime.tryParse(requestInfo.requisitionDate))}',style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ))
                                          :
                                      Text('Requisition Date :  ${requestInfo.requisitionDate}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 10,),
                                      NeomorphicTextFormField(
                                        initVal:short_name,
                                        inputType: TextInputType.text,
                                        numOfMaxLines: 1,
                                        hintText:  "Short Name", //short_name ?? "Short Name"
                                        fontSize: 12,
                                        onChangeFunction: (String value) {
                                          if(value !=null){
                                            short_name = value;
                                            print('short_name : ' + short_name);
                                          }
                                        },
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
                                            value: required_status,
                                            hint: Text('Select Required Status',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.requiredStatus?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.requiredStatus[idx - 1].key,
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Required Status" : requestInfo.requiredStatus[idx - 1].value,
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
                                            value: business_unit_head_id,
                                            hint: Text('Business Unit Head',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.businessHeads?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.businessHeads[idx - 1].id.toString(),
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Business Unit Head" : requestInfo.businessHeads[idx - 1].name,
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
                                                business_unit_head_id = value ?? business_unit_head_id;
                                                if(business_unit_head_id !=null){
                                                  business_unit_head_id=business_unit_head_id;
                                                  print('business_unit_head_id: ' + business_unit_head_id);
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
                                            isDense: false,
                                            underline: SizedBox(),
                                            value: official_address,
                                            hint: Text('Select Official Address',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.officeAddress?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.officeAddress[idx - 1].key,
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Official Address" : requestInfo.officeAddress[idx - 1].value,
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
                                                official_address = value ?? official_address;
                                                if(official_address !=null){
                                                  official_address=official_address;
                                                  print('official_address: ' + official_address);
                                                }
                                              });
                                            },
                                          ),
                                        ),

                                      ),
                                      SizedBox(height:10),
                                      NeomorphicTextFormField(
                                        initVal: official_contact,
                                        inputType: TextInputType.text,
                                        numOfMaxLines: 2,
                                        hintText:  "Official Contact Number ", //short_name ?? "Required Quantity"
                                        fontSize: 12,
                                        onChangeFunction: (String value) {
                                          if(value !=null){
                                            official_contact =value;
                                            print('official_contact : ' + official_contact.toString());
                                          }
                                        },
                                      ),
                                      SizedBox(height:10),
                                      NeomorphicTextFormField(
                                        initVal: official_email,
                                        inputType: TextInputType.emailAddress,
                                        numOfMaxLines: 2,
                                        hintText:  "Official Email ", //short_name ?? "Required Quantity"
                                        fontSize: 12,
                                        onChangeFunction: (String value) {
                                          if(value !=null){
                                            official_email =value;
                                            print('official_email : ' + official_email.toString());
                                          }
                                        },
                                      ),
                                      SizedBox(height:10),
                                      NeomorphicTextFormField(
                                        initVal: requestInfo.visitingCardQuantity,
                                        inputType: TextInputType.number,
                                        numOfMaxLines: 1,
                                        hintText:  "Required Quantity",
                                        fontSize: 12,
                                        onChangeFunction: (String value) {
                                          if(value !=null){
                                            quantity = value;
                                            print('quantity : ' + quantity);
                                          }
                                        },
                                      ),
                                      SizedBox(height:10),
                                      NeomorphicTextFormField(
                                        initVal: remarks,
                                        inputType: TextInputType.text,
                                        numOfMaxLines: 2,
                                        hintText:  "Remarks", //short_name ?? "Required Quantity"
                                        fontSize: 12,
                                        onChangeFunction: (String value) {
                                          if(value !=null){
                                            remarks =value;
                                            print('remarks : ' + remarks.toString());
                                          }
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      _isLoading
                                          ? Center(child: CircularProgressIndicator(),)
                                          : WideFilledButton(
                                        buttonText: "Submit",
                                        onTapFunction: () async {

                                          if (short_name == null || short_name.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Short Name is Required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (required_status == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Required Status!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (business_unit_head_id == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Business Unit Head!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (official_address == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Official Address!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (official_contact == null || official_contact.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Official Contact is Required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (official_email == null || official_email.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Official Email is Required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }

                                          //print('quantity : ' + quantity.toString());
                                          if (quantity == null) {
                                            quantity=requestInfo.visitingCardQuantity;
                                            //print('quantity : ' + quantity.toString());
                                          }
                                          //print('quantity : ' + quantity.toString());
                                          if (quantity.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Quantity is Required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (remarks == null) {
                                            remarks='N/A';
                                          }

                                          await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return  cardPreview(context);
                                              });

                                          if(isActionCanceled){
                                            isActionCanceled=false;
                                            return;
                                          }

                                          try {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            var formData = FormData.fromMap({
                                               "business_unit_head_id": int.tryParse(business_unit_head_id.trim()),
                                               "short_name": short_name,
                                               "official_contact": official_contact,
                                               "official_email": official_email,
                                               "official_address": official_address,
                                               "quantity": int.tryParse(quantity.trim()),
                                               "required_status": required_status,
                                               "remarks": remarks,
                                            });

                                            print('--------------From Submit----------------' + formData.fields.toString());
                                            final response = await _apiService.applyForVisitingCard(formData);

                                            if (response.statusCode == 200 ||
                                                response.statusCode == 201) {
                                              //_FormKey.currentState.reset();
                                              // this.setState(() {
                                              //   business_unit_head_id=null;
                                              //   short_name=null;
                                              //   official_contact=null;
                                              //   official_email=null;
                                              //   official_address=null;
                                              //   quantity=null;
                                              //   required_status=null;
                                              //   remarks=null;
                                              //   _isLoading = false;
                                              // });
                                              // showSnackBarMessage(
                                              //   scaffoldKey: _scaffoldKey,
                                              //   message: "Successfully applied for Visiting Card Request!",
                                              //   fillColor: Colors.green,
                                              // );
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
                                              message: "Failed to apply for for Visiting Card Requisition!",
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
          content: Text("Successfully Applied for Visiting Card Requisition!!!"),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(VISITING_CARD_PAGE,arguments: VisitingCardPageScreen.VisitingCard);
              },
            ),
          ],
        );
      },
    );
  }
  AlertDialog cardPreview(BuildContext context) {
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
                  "Preview",
                  style: TextStyle(color: Colors.white),
                )),
            InkResponse(
              onTap: () {
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
        margin: EdgeInsets.only(top: 10),
        height: !requestInfo.employeeBusinessUnit.toLowerCase().contains('red') ? 260 :300,  //redx
        width: 600,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26)
        ),
        // color: Colors.red,
        child: !requestInfo.employeeBusinessUnit.toLowerCase().contains('red') ? shopup() : redex() //redx
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
  Widget shopup(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 5),
              color: kPrimaryColor,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  Transform.rotate(angle: 320,
                    child: Text(short_name??'',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.yellow,
                      ),),),
                  Spacer(),
                  Container(
                    //padding: EdgeInsets.only(right: 10),
                    //margin: EdgeInsets.only(left: 30),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(requestInfo.employeeName??'',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: Colors.white,
                          ),),
                        Text(requestInfo.employeeRole??'',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: Colors.white,
                          ),),
                        Text(requestInfo.employeeDepartment??'',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: Colors.white,
                          ),),
                        Text(official_email??'',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: Colors.white,
                          ),),
                        Text(official_contact??'',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            color: Colors.white,
                          ),),
                      ],
                    ),
                  ),
                  SizedBox(height: 25,)


                ],
              ),
            )),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset('assets/images/shopup_logo.png'),
                Text('shopup.com.bd',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 11,
                    color: Colors.black54,
                  ),),
                SizedBox(height: 5,),
                Text(official_address??'',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 11,
                    color: Colors.black54,


                  ),),
                Spacer(),
              ],
            ),
          ),
        )],
    );
  }
  Widget redex(){
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: Container(
              //padding: EdgeInsets.only(right: 10),
              color: Colors.white,
              child:Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset('assets/images/x.png'),height: 40,),
                  Container(
                    padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(requestInfo.employeeName??'',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.redAccent,
                          ),),
                        Text(requestInfo.employeeRole??'',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 8,
                            color: Colors.black54,
                          ),),
                        Text(requestInfo.employeeDepartment??'',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 8,
                            color: Colors.black54,
                          ),),
                        SizedBox(height: 6,),
                        Text(official_contact??'',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 8,
                            color: Colors.redAccent,
                          ),),
                        Text(official_email??'',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 8,
                            color: Colors.black54,
                          ),),
                        SizedBox(height: 6,),
                        Text('Head Office : ${official_address??''}',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 8,
                            color: Colors.black54,

                          ),),
                        SizedBox(height: 3,),
                        Text('www.redx.com.bd'??'',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                            color: Colors.black54,

                          ),),

                      ],
                    ),
                  ),
                ],
              ),


            )),
        Expanded(
          child: Container(
            child: Image.asset('assets/images/redex.png',fit: BoxFit.cover,),
          ),
        )],
    );
  }
}



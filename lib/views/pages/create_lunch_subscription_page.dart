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


class CreateLunchSubscriptionPage extends StatefulWidget {
  const CreateLunchSubscriptionPage({Key key}) : super(key: key);

  @override
  _CreateLunchSubscriptionPageState createState() => _CreateLunchSubscriptionPageState();
}

class _CreateLunchSubscriptionPageState extends State<CreateLunchSubscriptionPage> {
  ApiService _apiService;
  LunchSubscriptionRequest requestInfo;
  User _currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _FormKey= GlobalKey<FormState>();
  DateFormat _dateFormat= DateFormat('MMM dd,yyyy');//('hh:mm:ss, dd-MMM-yyyy');

  DateFormat dateFormatter;
  String currentDateFormat = '';

  String official_location;
  String official_address;
  String official_floor;
  String food;
  String rfid;
  List<Floors> floors =[];
  String from_date;
  DateTime startDate;
  bool agree = false;

  Future<LunchSubscriptionRequest> _lunchSubscriptionRequest;
  bool _isLoading = false;
  String note= 'N/A';
  bool isActionCanceled = false;

  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _lunchSubscriptionRequest=_apiService.getLunchSubscriptionRequest();
    _getCurrentDateFormat();
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
                FutureBuilder<LunchSubscriptionRequest>(
                    future: _lunchSubscriptionRequest,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        requestInfo = snapshot.data;
                        //print(requestInfo.subscriptionRequestTimeLine);
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
                                    "Request For Monthly Lunch",
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

                                      Text('Subscription Date :  ${requestInfo.subscriptionDate}'
                                          ,style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text(
                                            "Lunch Start Date",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: NeomorphicDatetimePicker(
                                              hintText: "Start Date",
                                              updateValue: (String from) {
                                                setState(() {
                                                  if (from.isNotEmpty) {
                                                    startDate = DateTime.parse(from);
                                                    from_date = dateFormatter.format(startDate);
                                                    print('from_date : ' + from_date.toString());
                                                  }
                                                });
                                              },
                                              width: MediaQuery.of(context).size.width * 0.365,
                                            ),
                                          ),
                                        ],
                                      ),
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
                                            value: official_location,
                                            hint: Text('Select Office Location',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.officeLocation?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.officeLocation[idx - 1].id.toString(),
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Office Location" : requestInfo.officeLocation[idx - 1].name,
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
                                                official_location = value ?? official_location;
                                                if(official_location !=null){
                                                  official_floor=null;
                                                  official_location=official_location;
                                                  var officeLocation = requestInfo.officeLocation.firstWhere((e) => e.id.toString() == value, orElse: ()=>null);
                                                  if(officeLocation != null){
                                                    official_address =  officeLocation.address;
                                                    floors = officeLocation.floors;
                                                    print('official_location: ' + official_location);
                                                    print('official_address: ' + official_address.toString());
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
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
                                            value: official_floor,
                                            hint: Text('Select Floor',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (floors?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : floors[idx - 1].id.toString(),
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Floor" : floors[idx - 1].name,
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
                                                official_floor = value ?? official_floor;
                                                if(official_floor !=null){
                                                  official_floor=official_floor;
                                                  print('official_floor: ' + official_floor);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      NeomorphicTextFormField(
                                        key: Key(official_address),
                                        onChangeFunction: null,
                                        inputType: TextInputType.text,
                                        initVal: 'Office Address : ${official_address??''} ',
                                        hintText: "Office Address :",
                                        isReadOnly: true,
                                        fontSize: 12,
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
                                            value: food,
                                            hint: Text('Select Food Preference',
                                              style: TextStyle(fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[500]),),
                                            items: List<DropdownMenuItem<String>>.generate(
                                              (requestInfo.food.foodList?.length ?? 0) + 1,
                                                  (idx) =>
                                                  DropdownMenuItem<String>(
                                                    value: idx == 0 ? null : requestInfo.food.foodList[idx - 1].id.toString(),
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width * 0.6,
                                                      padding: EdgeInsets.only(left: 20),
                                                      child: Text(
                                                        idx == 0 ? "Select Food Preference" : requestInfo.food.foodList[idx - 1].name,
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
                                                food = value ?? food;
                                                if(food !=null){
                                                  food=food;
                                                  print('food: ' + food);
                                                }
                                                });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      NeomorphicTextFormField(
                                        initVal:rfid,
                                        inputType: TextInputType.text,
                                        hintText:"RFID of Your ID Card",// rfid ??
                                        fontSize: 12,
                                        onChangeFunction: (String value) {
                                          if(value !=null){
                                            rfid = value.trim();
                                            print('rfid : ' + rfid);
                                          }
                                        },
                                      ),

                                      SizedBox(height: 20),
                                      Text(
                                        "TERMS & CONDITIONS",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "1. Lunch facility is subsidized and employee will pay BDT ${requestInfo.perMeal} per lunch.",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "2. Subscription before ${requestInfo.subscriptionRequestTimeLine} will be activated from the next working day",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "3. Employees can unsubscribe from lunch before ${requestInfo.subscriptionRequestTimeLine}, with the unsubscription taking effect from the following day",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),

                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: agree,
                                            activeColor: kPrimaryColor,
                                            onChanged: (newValue) {
                                              setState(() {
                                                agree = newValue;
                                                print('agree : ' + agree.toString());
                                              });
                                            },
                                          ),
                                          Expanded(child: Text('I understad & agree above mentioned all the conditions.',style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Colors.black54,
                                          ),),),
                                        ],
                                      ),

                                      SizedBox(height:20),
                                      _isLoading
                                          ? Center(child: CircularProgressIndicator(),)
                                          : WideFilledButton(
                                        buttonText: "Submit",
                                        onTapFunction: () async {

                                          if (from_date == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Lunch Start Date!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (official_location == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Official Location!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (official_floor == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Office Floor!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }

                                          if (food == null) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please Select Food Preference!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }

                                          if (rfid == null || rfid.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "RFID is Required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (agree == false) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Need to Agree with Terms And Conditions",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }

                                          try {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            var formData = FormData.fromMap({
                                               "office_location_id": official_location.toString().trim(),
                                               "floor_id": official_floor.toString().trim(),
                                               "from_date": from_date,
                                               "food":food,
                                               "rfid":rfid,
                                               "agree": agree,
                                            });




                                            print('--------------From Submit----------------' + formData.fields.toString());
                                            final response = await _apiService.applyForLunchSubscription(formData);

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
                                              message: "Failed to apply for for Lunch Subscription!",
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
          content: Text("Successfully Applied for Lunch Subscription"),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(LUNCH_SUBSCRIPTION_PAGE,arguments: LunchSubscriptionPageScreen.LunchSubscription);
              },
            ),
          ],
        );
      },
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
}



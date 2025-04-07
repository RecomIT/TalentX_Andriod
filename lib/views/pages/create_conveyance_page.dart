import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/conveyance_info.dart';
import 'package:recom_app/data/models/employee_id_list.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/resignation_info.dart';
import 'package:recom_app/data/models/travel_purpose.dart';
import 'package:recom_app/data/models/travel_type.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/data/models/user_profile.dart';
import 'package:recom_app/data/providers/UserProvider.dart';
import 'package:recom_app/data/view_models/conveyance_view_model.dart';
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

import 'edit_settlement_page.dart';

class CreateConveyancePage extends StatefulWidget {

  @override
  _CreateConveyanceScreenState createState() => _CreateConveyanceScreenState();
}

class _CreateConveyanceScreenState extends State<CreateConveyancePage> {
  ApiService _apiService;
  User _currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _bottomSheetScaffoldKey = GlobalKey<ScaffoldState>();
  final _FormKey = GlobalKey<FormState>();
  DateFormat dateFormatter;
  String currentDateFormat = '';
  ConveyanceInfo conveyanceInfo =new ConveyanceInfo();
  Future<ConveyanceInfo> _conveyanceInfo;
  ConveyanceViewModel conveyanceVM;
  String _travel_date;
  DateTime travelDate;
  List<String> travel_date=[];

  String _purpose;
  List<String> purpose=[];

  String _mode_of_transport;
  List<String> mode_of_transport=[];

  double _transport=0;
  List<double> transport=[];

  double _food=0;
  List<double> food=[];

  double _other=0;
  List<double> other=[];

  double _total=0;
  List<double> total=[];
  double _grandTotal=0;

  String _location;
  List<String> location=[];

  String _remarks;
  List<String> remarks=[];
  int _conveyanceInfoCount=0;

  String attachmentName;
  String attachmentPath;
  String attachmentContent;
  String attachmentExtention;
  List<AttachmentModel> attachments = [];

  String description;
  String payment_method;
  String business_head_employee_id;
  String final_approver_id;
  bool _isPaymentMethodChanged=false;
  bool _isBankPaymentMethod=false;
  String account_name;
  String account_number;
  String bank_name;
  String bank_account_number;
  String bank_account_name;
  String bank_branch_name;
  String routing_no;

  List<String> costCenters= <String>[];
  List<String> costCenterIds= <String>[];
  String costCenter;
  List<KeyValuePair> costCenterList = <KeyValuePair>[];
  final _tagStateKeyCC = GlobalKey<TagsState>();
  DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool _isBackDateSelected = false;


  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    conveyanceInfo = ConveyanceInfo();
    _getCurrentDateFormat();
    _conveyanceInfo = _apiService.getConveyanceInfo();
    conveyanceVM = ConveyanceViewModel();
    // _getReasonList();
    // _generateCCList();
    //  _getEmployeeIdList();
    //_userProfile = _apiService.getUserProfile();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
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
                child: FutureBuilder<ConveyanceInfo>(
                    future: _conveyanceInfo,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        conveyanceInfo = snapshot.data;
                        //print(requestInfo.employeeBusinessUnit);
                        if(conveyanceInfo == null){
                          return Text('Message : No Request Details Available');
                        }else{
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Apply Conveyance",
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
                                      "Reference No : ${conveyanceInfo.referenceNo}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Ticket Raise Date : ${conveyanceInfo.ticketRaiseDate}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Employee ID : ${conveyanceInfo.employee.code??'N/A'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Employee Name : ${conveyanceInfo.employee.fullName??'N/A'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Division : ${conveyanceInfo.employee.division.name??'N/A'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Department : ${conveyanceInfo.employee.department.name??'N/A'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Cost Center : ${conveyanceInfo.employee.costCenter.name??'N/A'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Contact No : ${conveyanceInfo.employee.phone??'N/A'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Work Place : ${conveyanceInfo.workPlace}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Text(
                                          'Work places other than Base station from where the employees return to the base station without staying night & come back to the base station within Evening and must be more than 6 Hours. The distance should be minimum 15-20 Kilometer from the Base Station',
                                          style: TextStyle(color: Colors.white,fontSize: 11),)
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            width:kScreenSize.width * 0.6,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                            child: Text('Conveyance Details',style: TextStyle(color: Colors.white,fontSize: 11),)
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            // print('------Button Click----------');
                                            showModalBottomSheet(
                                            constraints: BoxConstraints.loose(
                                            Size(kScreenSize.width, kScreenSize.height * 0.75)),
                                            context: context,
                                            isScrollControlled: true,
                                            isDismissible: true,
                                            enableDrag: true,
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            builder: (context) {
                                            return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setState) {
                                            return Scaffold(
                                              extendBody: false,
                                              key: _bottomSheetScaffoldKey,
                                              resizeToAvoidBottomInset: true,
                                              body: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20,),
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
                                                child: ListView(
                                                  children: [
                                                    Container(
                                                        width:kScreenSize.width * 1,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: kPrimaryColor,
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        ),
                                                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                                        child: Text('Conveyance Details',style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),)
                                                    ),
                                                    SizedBox(height: 5,),
                                                    NeomorphicDatetimePicker(
                                                      hintText: _travel_date ?? "Travel Date",
                                                      updateValue: (String from) {
                                                        setState(() {
                                                          _travel_date = dateFormatter.format(DateTime.parse(from));
                                                          print("travel_date : " + _travel_date);
                                                          travelDate = DateTime.tryParse(from);
                                                        });
                                                      },
                                                      width: MediaQuery.of(context).size.width * 0.365,
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
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 15,
                                                            color: Colors.black26,
                                                            offset: Offset.fromDirection(
                                                                Math.pi * .5, 10),
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
                                                          value: _purpose,
                                                          hint: Text('Select Purpose', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500]),),
                                                          items: List<DropdownMenuItem<String>>.generate(
                                                            (conveyanceInfo.purpose.conveyancePurposeList?.length ?? 0) + 1, (idx) => DropdownMenuItem<String>(
                                                            value: idx == 0 ? null : conveyanceInfo.purpose.conveyancePurposeList[idx - 1].id,
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width * 0.6,
                                                              padding: EdgeInsets.only(left: 20),
                                                              child: Text(
                                                                idx == 0 ? "Select Purpose" : conveyanceInfo.purpose.conveyancePurposeList[idx - 1].name,
                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          ),
                                                          onChanged: (String value) {
                                                            setState(() {
                                                              _purpose = value ?? _purpose;
                                                              if (_purpose != null) {
                                                                _purpose = _purpose.trim();
                                                                print('_purpose: ' + _purpose);
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
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 15,
                                                            color: Colors.black26,
                                                            offset: Offset.fromDirection(
                                                                Math.pi * .5, 10),
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
                                                          value: _mode_of_transport,
                                                          hint: Text('Select Mode of Transport', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500]),),
                                                          items: List<DropdownMenuItem<String>>.generate(
                                                            (conveyanceInfo.modeOfTransport.modeOfTransportForConveyanceList?.length ?? 0) + 1, (idx) => DropdownMenuItem<String>(
                                                            value: idx == 0 ? null : conveyanceInfo.modeOfTransport.modeOfTransportForConveyanceList[idx - 1].id,
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width * 0.6,
                                                              padding: EdgeInsets.only(left: 20),
                                                              child: Text(
                                                                idx == 0 ? "Select Mode of Transport" : conveyanceInfo.modeOfTransport.modeOfTransportForConveyanceList[idx - 1].name,
                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          ),
                                                          onChanged: (String value) {
                                                            setState(() {
                                                              _mode_of_transport = value ?? _mode_of_transport;
                                                              if (_mode_of_transport != null) {
                                                                _mode_of_transport = _mode_of_transport.trim();
                                                                print('_mode_of_transport: ' + _mode_of_transport);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    NeomorphicTextFormField(
                                                      initVal:_transport == 0 ? "" : _transport.toString(),
                                                      inputType: TextInputType.number,
                                                      hintText: "Claim transport amount",
                                                      fontSize: 12,
                                                      onChangeFunction: (String value) {
                                                        if (value != null) {
                                                          _transport = double.tryParse(value);
                                                          if(_transport !=null){
                                                            print('_transport : ' + _transport.toString());
                                                          }else{
                                                            _transport=0;
                                                          }
                                                          print('_transport : ' + _transport.toString());
                                                          setState(() {
                                                            _total=0;
                                                            _transport=_transport;
                                                            _total =_transport+_food+ _other;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    NeomorphicTextFormField(
                                                      initVal:_food == 0 ? "" : _food.toString(),
                                                      inputType: TextInputType.number,
                                                      hintText: "Claim food amount",
                                                      fontSize: 12,
                                                      onChangeFunction: (String value) {
                                                        if (value != null) {
                                                          _food = double.tryParse(value);
                                                          if(_food !=null){
                                                            print('_food : ' + _food.toString());
                                                          }else{
                                                            _food=0;
                                                          }
                                                          print('_food : ' + _food.toString());
                                                          setState(() {
                                                            _total=0;
                                                            _food=_food;
                                                            _total =_transport+_food+ _other;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    NeomorphicTextFormField(
                                                      initVal:_other == 0 ? "" : _other.toString(),
                                                      inputType: TextInputType.number,
                                                      hintText: "Claim other amount",
                                                      fontSize: 12,
                                                      onChangeFunction: (String value) {
                                                        if (value != null) {
                                                          _other = double.tryParse(value);
                                                          if(_other !=null){
                                                            print('_other : ' + _other.toString());
                                                          }else{
                                                            _other=0;
                                                          }
                                                          print('_other : ' + _other.toString());
                                                          setState(() {
                                                            _total=0;
                                                            _other=_other;
                                                            _total =_transport+_food+ _other;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Container(
                                                        width:double.infinity,
                                                        decoration: BoxDecoration(
                                                          color: kPrimaryColor,
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        ),
                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                        child: Text('Total : ' + _total.toString(),style: TextStyle(color: Colors.white,fontSize: 11),)
                                                    ),
                                                    SizedBox(height: 5,),
                                                    NeomorphicTextFormField(
                                                      inputType: TextInputType.text,
                                                      hintText: "Location",
                                                      fontSize: 12,
                                                      onChangeFunction: (String value) {
                                                        if (value != null) {
                                                          _location = value.trim();
                                                          print('_location : ' + _location);
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(height: 5,),
                                                    NeomorphicTextFormField(
                                                      inputType: TextInputType.text,
                                                      hintText: "Remarks",
                                                      fontSize: 12,
                                                      onChangeFunction: (String value) {
                                                        if (value != null) {
                                                          _remarks = value.trim();
                                                          print('_remarks : ' + _remarks);
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(top: 10),
                                                          width: (MediaQuery.of(context).size.width - 80) * 0.7,
                                                          padding: EdgeInsets.symmetric(vertical: 15,),
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
                                                              color: attachmentName == null ? Colors.black45 : Colors.black,
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
                                                              allowedExtensions: ["pdf", "docx", "doc", "jpg", "jpeg", "png"],
                                                            );
                                                            if (pickedFile == null) return;
                                                            final fileCotent = base64Encode(pickedFile.readAsBytesSync());
                                                            setState(() {
                                                              attachmentName = pickedFile.path.split("/").last;
                                                              attachmentExtention = pickedFile.path.split("/").last.split(".").last;
                                                              attachmentContent = fileCotent;
                                                              attachmentPath = pickedFile.path;
                                                            });
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.only(top: 10),
                                                            width: (MediaQuery.of(context).size.width - 80) * 0.28,
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

                                                    //Action Button Save/Close
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: kPrimaryColor,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                                                            minimumSize: Size(100, 40), ),
                                                          onPressed: () async {

                                                            //----------------Validation of Bottom Sheet Modal--------------------
                                                            if (_travel_date == null) {
                                                              showSnackBarMessage(
                                                                scaffoldKey: _bottomSheetScaffoldKey,
                                                                message: "Please Select Travel Date!",
                                                                fillColor: Colors.red,
                                                              );
                                                              return;
                                                            }
                                                            if (dateToday.difference(travelDate).inDays > 7) {
                                                              showSnackBarMessage(
                                                                scaffoldKey: _bottomSheetScaffoldKey,
                                                                message: "Back Dated request is not allowed!",
                                                                fillColor: Colors.red,
                                                              );
                                                              return;
                                                            }
                                                            if (travelDate.isAfter(dateToday)) {
                                                              showSnackBarMessage(
                                                                scaffoldKey: _bottomSheetScaffoldKey,
                                                                message: "Future Dated request is not allowed!",
                                                                fillColor: Colors.red,
                                                              );
                                                              return;
                                                            }
                                                            if (_purpose == null) {
                                                              showSnackBarMessage(
                                                                scaffoldKey: _bottomSheetScaffoldKey,
                                                                message: "Please Select Purpose!",
                                                                fillColor: Colors.red,
                                                              );
                                                              return;
                                                            }
                                                            if (_mode_of_transport == null) {
                                                              showSnackBarMessage(
                                                                scaffoldKey: _bottomSheetScaffoldKey,
                                                                message: "Please Select Mode of Transport!",
                                                                fillColor: Colors.red,
                                                              );
                                                              return;
                                                            }
                                                            if (_remarks == null || _remarks.isEmpty) {
                                                              showSnackBarMessage(
                                                                scaffoldKey: _bottomSheetScaffoldKey,
                                                                message: "Remark field is Required!",
                                                                fillColor: Colors.red,
                                                              );
                                                              return;
                                                            }
                                                            // if (attachmentContent == null) {
                                                            //   showSnackBarMessage(
                                                            //     scaffoldKey: _bottomSheetScaffoldKey,
                                                            //     message: "Attachment is Required!",
                                                            //     fillColor: Colors.red,
                                                            //   );
                                                            //   return;
                                                            // }

                                                            ///----------------Populate Arrays from Bottom Sheet Modal--------------------
                                                            //print(_total.toString());
                                                            conveyanceVM.travel_date.add(_travel_date);
                                                            conveyanceVM.id=conveyanceVM.travel_date.length;
                                                            conveyanceVM.purpose.add(_purpose);
                                                            conveyanceVM.mode_of_transport.add(_mode_of_transport);
                                                            conveyanceVM.transport.add(_transport);
                                                            conveyanceVM.food.add(_food);
                                                            conveyanceVM.other.add(_other);
                                                            conveyanceVM.total.add(_total);
                                                            conveyanceVM.location.add(_location);
                                                            conveyanceVM.remarks.add(_remarks);
                                                            if (attachmentContent != null) {
                                                              conveyanceVM.attachments.add(AttachmentModel(
                                                                  attachmentContent: attachmentContent,
                                                                  attachmentExtention: attachmentExtention,
                                                                  attachmentName: attachmentName,
                                                                  attachmentPath: attachmentPath));
                                                            }
                                                            else{
                                                              conveyanceVM.attachments.add(AttachmentModel());
                                                            }

                                                            print(conveyanceVM.toString());

                                                            setState(() {
                                                              _resetBottomSheetfields();
                                                              // _conveyanceInfoCount+=1;
                                                            });
                                                            await Future.delayed(Duration(milliseconds: 1000));
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text('Save'),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        OutlinedButton(
                                                          style: OutlinedButton.styleFrom(primary: kPrimaryColor,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(32.0)),
                                                            minimumSize: Size(100, 40), ),
                                                          onPressed: () async {
                                                            print('------Close Button Click----------');
                                                            setState(() {
                                                              _resetBottomSheetfields();
                                                            });
                                                            await Future.delayed(Duration(milliseconds: 500));
                                                            Navigator.pop(context);},
                                                          child: Text('Close'),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 5),
                                                    conveyanceVM.travel_date.length > 0 ?
                                                    Container(
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: NeverScrollableScrollPhysics(),
                                                          itemCount: conveyanceVM.travel_date.length,
                                                          itemBuilder: (context, index) {
                                                            return Column(
                                                              children: [
                                                                Card(
                                                                  child: Container(
                                                                    width: double.infinity,
                                                                    height: 180,
                                                                    padding: EdgeInsets.only(left: 10),
                                                                    child:Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Travel Date : ${conveyanceVM.travel_date[index]}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Purpose : ${conveyanceVM.purpose[index]}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Mode of Transport : ${conveyanceVM.mode_of_transport[index]}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Transport amount : ${conveyanceVM.transport[index]}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Food amount : ${conveyanceVM.food[index]}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Other amount : ${conveyanceVM.other[index]}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Total amount : ${conveyanceVM.total[index].toString()}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Location : ${conveyanceVM.location[index]??'N/A'}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Remarks : ${conveyanceVM.remarks[index]??'N/A'}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 5,),
                                                                        Flexible(
                                                                          child: Text('Attachment : ${conveyanceVM.attachments[index].attachmentName != null ? conveyanceVM.attachments[index].attachmentName: 'N/A'}'
                                                                              ,style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10,
                                                                                color: Colors.black54,
                                                                              )),
                                                                        ),
                                                                        SizedBox(height: 10,),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    TextButton.icon(onPressed: (){
                                                                      setState((){
                                                                        conveyanceVM.travel_date.removeAt(index);
                                                                        conveyanceVM.purpose.removeAt(index);
                                                                        conveyanceVM.mode_of_transport.removeAt(index);
                                                                        conveyanceVM.transport.removeAt(index);
                                                                        conveyanceVM.food.removeAt(index);
                                                                        conveyanceVM.other.removeAt(index);
                                                                        conveyanceVM.total.removeAt(index);
                                                                        conveyanceVM.location.removeAt(index);
                                                                        conveyanceVM.remarks.removeAt(index);
                                                                        conveyanceVM.attachments.removeAt(index);
                                                                      });
                                                                    }, icon: Icon(Icons.delete,size: 15,color: kPrimaryColor,), label:
                                                                    Text('Remove',style: TextStyle(fontSize: 10,fontWeight: FontWeight.normal,color: kPrimaryColor),)),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                    ) : Container(),

                                                    SizedBox(height: 10,),
                                                    Container(
                                                        width:double.infinity,
                                                        decoration: BoxDecoration(
                                                          color: kPrimaryColor,
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        ),
                                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                        child: Text('Total Conveyance Bill : ${conveyanceVM.total.fold(0, (p, c) => p + c)}',style: TextStyle(color: Colors.white,fontSize: 11),)
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                              ),
                                            );});});
                                          },
                                          child: Container(
                                            width: 70,
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2,),
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
                                                  Icons.add,
                                                  color: kPrimaryColor,//Colors.white,
                                                ),
                                                Text(
                                                  "Add",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: kPrimaryColor,//Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]
                                    ),
                                    SizedBox(height: 10,),


                                    // Main Content
                                    SizedBox(height: 10,),
                                    NeomorphicTextFormField(
                                      inputType: TextInputType.text,
                                      numOfMaxLines: 3,
                                      hintText: "Description",
                                      fontSize: 12,
                                      onChangeFunction: (String value) {
                                        if (value != null) {
                                          description = value.trim();
                                          print('description : ' + description);
                                        }
                                      },
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 15,
                                            color: Colors.black26,
                                            offset: Offset.fromDirection(
                                                Math.pi * .5, 10),
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
                                          value: payment_method,
                                          hint: Text('Select Payment Method', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500]),),
                                          items: List<DropdownMenuItem<String>>.generate(
                                            (conveyanceInfo.paymentMethod.paymentMethodList?.length ?? 0) + 1, (idx) => DropdownMenuItem<String>(
                                                  value: idx == 0 ? null : conveyanceInfo.paymentMethod.paymentMethodList[idx - 1].id,
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                    padding: EdgeInsets.only(left: 20),
                                                    child: Text(
                                                      idx == 0 ? "Select Payment Method" : conveyanceInfo.paymentMethod.paymentMethodList[idx - 1].name,
                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          ),
                                          onChanged: (String value) {
                                            setState(() {
                                              payment_method = value ?? payment_method;
                                              if (payment_method != null) {
                                                _isPaymentMethodChanged=true;
                                                payment_method = payment_method.trim();
                                                print('payment_method: ' + payment_method);
                                                switch(payment_method.toLowerCase()) {
                                                  case 'bank': {
                                                    _isBankPaymentMethod=true;
                                                    account_name=null;
                                                    account_number=null;

                                                  }break;
                                                   case 'nagad': {
                                                     _isBankPaymentMethod=false;
                                                     bank_name=null;
                                                     bank_account_name=null;
                                                     bank_account_number=null;
                                                     bank_branch_name=null;
                                                     routing_no=null;

                                                   } break;
                                                  default:{
                                                    _isBankPaymentMethod = false;
                                                    bank_name=null;
                                                    bank_account_name=null;
                                                    bank_account_number=null;
                                                    bank_branch_name=null;
                                                    routing_no=null;
                                                  } break;
                                                }

                                              }

                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _isPaymentMethodChanged,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 5,),
                                            Visibility(
                                              visible: !_isBankPaymentMethod,
                                              child: Column(
                                                children: [
                                                  NeomorphicTextFormField(
                                                    inputType: TextInputType.text,
                                                    hintText: "Account Name",
                                                    fontSize: 12,
                                                    onChangeFunction: (String value) {
                                                      if (value != null) {
                                                        account_name = value.trim();
                                                        print('account_name : ' + account_name.toString());
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(height: 5,),
                                                  NeomorphicTextFormField(
                                                    inputType: TextInputType.phone,
                                                    hintText: 'Mobile No',
                                                    fontSize: 12,
                                                    onChangeFunction: (String value) {
                                                      if (value != null) {
                                                        account_number = value.trim();
                                                        print('account_number : ' + account_number.toString());
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: _isBankPaymentMethod,
                                              child: Column(
                                                children: [
                                                  NeomorphicTextFormField(
                                                    initVal: conveyanceInfo.bankDetail.bankName !=null ?
                                                    conveyanceInfo.bankDetail.bankName : null,
                                                    inputType: TextInputType.text,
                                                    hintText: "Bank Name",
                                                    fontSize: 12,
                                                    onChangeFunction: (String value) {
                                                      if (value != null) {
                                                        bank_name = value.trim();
                                                        print('bank_name : ' + bank_name);
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(height: 5,),
                                                  NeomorphicTextFormField(
                                                    initVal: conveyanceInfo.bankDetail.accountName !='N/A' ?
                                                    conveyanceInfo.bankDetail.accountName : null,
                                                    inputType: TextInputType.text,
                                                    hintText: "Account Name",
                                                    fontSize: 12,
                                                    onChangeFunction: (String value) {
                                                      if (value != null) {
                                                        bank_account_name = value.trim();
                                                        print('bank_account_name : ' + bank_account_name);
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(height: 5,),
                                                  NeomorphicTextFormField(
                                                    initVal: conveyanceInfo.bankDetail.bankAccountNumber !='N/A' ?
                                                    conveyanceInfo.bankDetail.bankAccountNumber : null,
                                                    inputType: TextInputType.text,
                                                    hintText: "Account Number",
                                                    fontSize: 12,
                                                    onChangeFunction: (String value) {
                                                      if (value != null) {
                                                        bank_account_number = value.trim();
                                                        print('bank_account_number : ' + bank_account_number.toString());
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(height: 5,),
                                                  NeomorphicTextFormField(
                                                    initVal: conveyanceInfo.bankDetail.bankBranchName !='N/A' ?
                                                    conveyanceInfo.bankDetail.bankBranchName : null,
                                                    inputType: TextInputType.text,
                                                    hintText: "Branch Name",
                                                    fontSize: 12,
                                                    onChangeFunction: (String value) {
                                                      if (value != null) {
                                                        bank_branch_name = value.trim();
                                                        print('bank_branch_name : ' + bank_branch_name.toString());
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(height: 5,),
                                                  NeomorphicTextFormField(
                                                    initVal: conveyanceInfo.bankDetail.bankRoutingNo !='N/A' ?
                                                    conveyanceInfo.bankDetail.bankRoutingNo : null,
                                                    inputType: TextInputType.number,
                                                    hintText: "Routing No",
                                                    fontSize: 12,
                                                    onChangeFunction: (String value) {
                                                      if (value != null) {
                                                        routing_no = value.trim();
                                                        print('routing_no : ' + routing_no.toString());
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
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
                                      child: Column(
                                        children: [
                                          DropDownField(
                                            onValueChanged: (dynamic value) {
                                              setState(() {
                                                costCenter = value;
                                                print('costCenter : ' + costCenter);
                                                bool isCCAlreadyExist = costCenters.contains(costCenter);
                                                if (!isCCAlreadyExist) {
                                                  var ccId = conveyanceInfo.costCenters.businessUnitWiseCostCenter.firstWhere((e) => e.name==costCenter.trim()).id;
                                                  costCenters.add(costCenter);
                                                  costCenterIds.add(ccId);
                                                }
                                                print('costCenters : ' + costCenters.toList().toString());
                                              });
                                            },
                                            //enabled: true,
                                            strict: false,
                                            itemsVisibleInDropdown: 5,
                                            value: costCenter,
                                            //required: false,
                                            labelText: 'Select Cost Center(s)',
                                            labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),
                                            items: conveyanceInfo.costCenters.businessUnitWiseCostCenter.map((e) => e.name).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    costCenters.length > 0 ?
                                    Tags(
                                      key: _tagStateKeyCC,
                                      horizontalScroll: true,
                                      heightHorizontalScroll:40,
                                      itemCount: costCenters.length,
                                      itemBuilder: (int index){
                                        final item = costCenters[index];
                                        return Container(
                                          width: 150,
                                          child: ItemTags(
                                            key: Key(index.toString()),
                                            index: index,
                                            title: item,
                                            activeColor:kPrimaryColor,
                                            //combine: ItemTagsCombine.withTextBefore,
                                            removeButton: ItemTagsRemoveButton(
                                              backgroundColor: Colors.white,
                                              color: Colors.black,
                                              onRemoved: (){
                                                // Remove the item from the data source.
                                                setState(() {
                                                  costCenters.removeAt(index);
                                                  costCenterIds.removeAt(index);
                                                  print('costCenters : ' + costCenters.toList().toString());
                                                });
                                                //required
                                                return true;
                                              },
                                            ), // OR null,
                                            onPressed: (item) => print(item),
                                            onLongPressed: (item) => print(item),
                                          ),
                                        );

                                      },
                                    ) : Container(),
                                    SizedBox(height: 10),
                                    NeomorphicTextFormField(
                                    inputType: TextInputType.text,
                                    initVal: 'CC : ${conveyanceInfo.cc} ',
                                    hintText: "CC :",
                                    isReadOnly: true,
                                    fontSize: 12,
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
                                          value: business_head_employee_id,
                                          hint: Text('Business Head', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500]),),
                                          items: List<DropdownMenuItem<String>>.generate(
                                            (conveyanceInfo.businessHead.businessHeadList?.length ?? 0) + 1, (idx) =>
                                                DropdownMenuItem<String>(
                                                  value: idx == 0 ? null : conveyanceInfo.businessHead.businessHeadList[idx - 1].id,
                                                  //domestic
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                    padding: EdgeInsets.only(left: 20),
                                                    child: Text(idx == 0 ? "Business Head" : conveyanceInfo.businessHead.businessHeadList[idx - 1].name,
                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          ),
                                          onChanged: (String value) {
                                            setState(() {
                                              business_head_employee_id = value ?? business_head_employee_id;
                                              if (business_head_employee_id != null) {
                                                business_head_employee_id = business_head_employee_id;
                                                print('business_head_employee_id : ' + business_head_employee_id);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    NeomorphicTextFormField(
                                      inputType: TextInputType.text,
                                      initVal: 'First Approver : ${conveyanceInfo.firstApprover} ',
                                      hintText: "First Approver :",
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
                                      //margin: EdgeInsets.only(top: 10),
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
                                          value: final_approver_id,
                                          hint: Text('Select Final Approver',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500]),),
                                          items: List<DropdownMenuItem<String>>.generate(
                                            (conveyanceInfo.finalApprover.finalApproverList?.length ?? 0) + 1,
                                                (idx) =>
                                                DropdownMenuItem<String>(
                                                  value: idx == 0 ? null : conveyanceInfo.finalApprover.finalApproverList[idx - 1].id,
                                                  //domestic
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                    padding: EdgeInsets.only(left: 20),
                                                    child: Text(
                                                      idx == 0
                                                          ? "Select Final Approver"
                                                          : conveyanceInfo.finalApprover.finalApproverList[idx - 1].name,
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
                                              final_approver_id = value ?? final_approver_id;
                                              if (final_approver_id != null) {
                                                final_approver_id = final_approver_id;
                                                print('final_approver_id : ' + final_approver_id);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),

                                    _isLoading
                                        ? Center(child: CircularProgressIndicator(),)
                                        : WideFilledButton(
                                      buttonText: "Submit",
                                      onTapFunction: () async {
                                        if (conveyanceVM.travel_date.length < 1) {
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Please Add at least one Conveyance Details",
                                            fillColor: Colors.red,
                                          );
                                          return;
                                        }
                                        if (description==null || description.isEmpty) {
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Description field is required!",
                                            fillColor: Colors.red,
                                          );
                                          return;
                                        }
                                        if (payment_method==null) {
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Please select Payment Method!",
                                            fillColor: Colors.red,
                                          );
                                          return;
                                        }

                                        if (!_isBankPaymentMethod) {
                                          if (account_name==null || account_name.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Account Name field is required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (account_number==null || account_number.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Mobile Number field is required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (account_number.length != 11) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Please enter 11 digit Mobile number!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                        }

                                        if (_isBankPaymentMethod) {
                                          if (bank_name==null || bank_name.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Bank Name field is required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (bank_account_name ==null || bank_account_name.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Bank Account Name field is required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (bank_account_number==null || bank_account_number.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Bank Account Number field is required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (bank_branch_name ==null || bank_branch_name.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Bank Branch Name field is required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }
                                          if (routing_no ==null || routing_no.isEmpty) {
                                            showSnackBarMessage(
                                              scaffoldKey: _scaffoldKey,
                                              message: "Bank Routing Number field is required!",
                                              fillColor: Colors.red,
                                            );
                                            return;
                                          }

                                          if(routing_no !=null){
                                            int isValidRoutingNo=0;
                                            try{
                                              isValidRoutingNo = int.parse(routing_no);
                                            }
                                            catch(e) {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Bank Routing Number field is invalid!",
                                                fillColor: Colors.red,
                                              );
                                              return;
                                            }

                                          }
                                        }

                                        if (costCenterIds.length < 1) {
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Please select Cost Center!",
                                            fillColor: Colors.red,
                                          );
                                          return;
                                        }

                                        if (business_head_employee_id==null) {
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Please select Business Head!",
                                            fillColor: Colors.red,
                                          );
                                          return;
                                        }
                                        if (final_approver_id==null) {
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Please select Final Approver!",
                                            fillColor: Colors.red,
                                          );
                                          return;
                                        }

                                        try {
                                          setState(() {
                                            _isLoading = true;
                                          });

                                          var formData = FormData.fromMap({
                                            "payment_method": payment_method,
                                            "description": description,
                                            "account_name": account_name,
                                            "account_number": account_number,
                                            "bank_name": bank_name,
                                            "bank_account_number": bank_account_number, //int.tryParse(bank_account_number) ,
                                            "bank_account_name": bank_account_name,
                                            "branch_name": bank_branch_name,
                                            "routing_no": routing_no,  //int.tryParse(routing_no) ,

                                            "business_head_employee_id": business_head_employee_id,
                                            "final_approver_id": final_approver_id,

                                            "travel_date": conveyanceVM.travel_date,
                                            "purpose": conveyanceVM.purpose,
                                            "mode_of_transport": conveyanceVM.mode_of_transport,
                                            "transport": conveyanceVM.transport,
                                            "food": conveyanceVM.food,
                                            "other": conveyanceVM.other,
                                            "location": conveyanceVM.location,
                                            "remarks": conveyanceVM.remarks,
                                            "cost_center": costCenterIds,
                                          });

                                          if (conveyanceVM.attachments.length > 0) {
                                              for (var attachment in conveyanceVM.attachments) {
                                                if (attachment.attachmentContent != null){
                                                  var file = await MultipartFile.fromFile(attachment.attachmentPath, filename: attachment.attachmentName);
                                                  formData.files.add(MapEntry("attachment[]", file));
                                                }
                                                // else{
                                                //   formData.files.add(MapEntry("attachment[]",null));
                                                // }

                                              }
                                          }

                                          print('--------------From Submit----------------' + formData.fields.toString());
                                          // _isLoading = false;
                                          // return;

                                          final response = await _apiService.applyForConveyance(formData);
                                          if (response.statusCode == 200 || response.statusCode == 201) {
                                            setState(() {
                                              _isLoading = false;
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
                                            message: "Failed to apply for Conveyance!",
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
          content: Text("Successfully Applied for Conveyance!!!"),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(CONVEYANCE_PAGE, arguments: ConveyancePageScreen.ConveyanceApplication);
              },
            ),
          ],
        );
      },
    );
  }

  //API Calls
  void _getCurrentDateFormat() async {
    var response = await _apiService.getCurrentDateFormat();
    setState(() {
      currentDateFormat = response.trim().toLowerCase();
      //print('currentDateFormat : '+ currentDateFormat);

      //'dd-MMM-yyyy'  //dd MMM,yyyy  //yyyy-MM-dd
      switch (currentDateFormat) {
        case 'd-m-y':
          {
            dateFormatter = new DateFormat('dd-MMM-yyyy');
          }
          break;
        case 'd m, y':
          {
            dateFormatter = new DateFormat('dd MMM,yyyy');
          }
          break;
        case 'y-m-d':
          {
            dateFormatter = new DateFormat('yyyy-MM-dd');
          }
          break;
        default:
          {
            dateFormatter = new DateFormat('dd-MMM-yyyy');
          }
          break;
      }
    });
  }
  void _resetBottomSheetfields () async {
    _travel_date=null;
    _purpose=null;
    _mode_of_transport=null;
    _transport=0;
    _food=0;
    _other=0;
    _total=0;
    _location=null;
    _remarks=null;
    attachmentContent=null;
    attachmentExtention=null;
    attachmentName=null;
    attachmentPath=null;
  }



}

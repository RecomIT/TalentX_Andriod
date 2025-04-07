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
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/travel_purpose.dart';
import 'package:recom_app/data/models/travel_type.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/data/models/user_profile.dart';
import 'package:recom_app/data/providers/UserProvider.dart';
import 'package:recom_app/services/api/api.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';
import 'package:recom_app/views/widgets/custom_table.dart';
import 'package:recom_app/views/widgets/flat_app_bar.dart';
import 'package:recom_app/views/widgets/neomorphic_datetime_picker.dart';
import 'package:recom_app/views/widgets/neomorphic_text_form_field.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'dart:math' as Math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdownfield/dropdownfield.dart';

class NewTravelPlanPage extends StatefulWidget {

  @override
  _NewTravelPlanScreenState createState() => _NewTravelPlanScreenState();
}

class _NewTravelPlanScreenState extends State<NewTravelPlanPage> {
  ApiService _apiService;
  User _currentUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _travelApplyFormKeyOne = GlobalKey<FormState>();
  final _travelApplyFormKeyTwo = GlobalKey<FormState>();
  final _travelApplyFormKeyThree = GlobalKey<FormState>();
  final _tagStateKeyTV = GlobalKey<TagsState>();
  final _tagStateKeyCC = GlobalKey<TagsState>();
  DateFormat dateFormatter;
  //var dateFormatter = new DateFormat('dd-MMM-yyyy');  //'dd-MMM-yyyy'  //dd MMM,yyyy  //yyyy-MM-dd
  //Future<TravelTypeList> _travelTypeList;
  //Future<TravelPurposeList> _travelPurposeList;


  final workPlaceList = <TravelType>[
    // new TravelType(id: 'Ex-Head Quarter',value:'ex_head_quater', name: 'Work places other than Base station from where the employees return to the base station without staying night & come back to the base station within Evening and must be more than 6 Hours. The distance should be minimum 15-20 Kilometer from the Base Station'),
    new TravelType(id: 'Outstation',value:'outstation',
        name: 'Work places other than base station where the employees need to stay at night. Applicable for the stations out of Dhaka City')
  ];

  final tripTypeList= <TravelType>[
    new TravelType(id: 'one-way',name: 'One Way'),
    new TravelType(id: 'round-trip',name: 'Round Trip'),
    new TravelType(id: 'multi-city',name: 'Multicity'),
  ];

  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _getCurrentDateFormat();
    _generateTravelTypeList();
    _generateCurrencyList();
    _generateTravellerList();

    //_generateCCList();
    _generateDefaultHRGroup();
    _generateBusinessHeadList();
    _generateFinanceBp();
    _generateCEOList();
    _generateCostCenterList();
    //workPlace = workPlaceList.first.id;
    //_travelTypeList = _apiService.getTravelTypes();
    //_travelPurposeList = _apiService.getTravelPurposes();
  }

  int _activeStepIndex = 0;
  int _multiFormCounter= 1;
  bool _isCompleted = false;
  bool _isLoading = false;
  bool _isWorkPlaceVisible = false;
  bool _isCurrencyVisible = false;
  bool _isMulticity =false;
  int _radioValue = 1;
  String typeOfTravel;
  String workPlace;
  String workPlaceDescription;
  String referenceNo = '';
  String currentDateFormat = '';
  String travelPurpose;
  String transportMode;
  bool _isAirTransportMode = false;
  String currency;
  String startDate;
  String endDate;
  DateTime fromDate;
  DateTime toDate;
  List<String> travellers= <String>[];
  List<String> travellerIds= <String>[];

  List<String> costCenters= <String>[];
  List<String> costCenterIds= <String>[];

  String traveller;
  String costCenter;
  String tripType;
  String description;
  String attachmentName;
  String attachmentPath;
  String attachmentContent; // (optional,Size:Max 1MB,Format: pdf,jpeg,jpg,docx,png),
  String attachmentExtention; // (If Attachment submitted then Required)
  bool hotelAccommodation= false;
  bool hotelAccommodationByAdminDpt= false;
  int hotelAccommodationAmount=0;
  bool transport= false;
  bool transportByAdminDpt= false;
  int transportAmount=0;
  bool dailyAllowance= false;
  int dailyAllowanceAmount =0;
  bool transferAllowance= false;
  bool mealAllowance= false;
  int mealAllowanceAmount =0;
  bool airTicket= false;
  bool airTicketByAdminDpt= false;
  int airTicketAmount=0;
  bool guestHouseAccommodation= false;
  bool advanceRequired= false;
  int advancePayment=0;
  String fromDestination;
  String toDestination;
  int fromDestinationId=null;
  int toDestinationId=null;

  List<String> multiFromDestination =[];
  List<String> multiToDestination=[];
  List<int> multiFromDestinationId= [];
  List<int> multiToDestinationId=[];
  List<String> multiFromDestinationDate =[];
  List<String> multiToDestinationDate=[];

  List<MultiCityForm> multiCityFormList = <MultiCityForm> [];
  MultiCityForm multiCityForm = MultiCityForm();

  String hrGroup;
  int authorityOne;
  String firstApprover ;
  int authorityTwo;
  String secondApprover;
  int authorityThree;
  String finalApprover;

  String payment_method;
  List<KeyValuePair> paymentMethodList = <KeyValuePair>[new KeyValuePair(id: 'Bank',name: 'Bank',),new KeyValuePair(id: 'Nagad',name: 'Nagad',)];
  bool _isPaymentMethodChanged=false;
  bool _isBankPaymentMethod=false;
  String account_name;
  String account_number;
  String bank_name;
  String bank_account_number;
  String bank_account_name;
  String bank_branch_name;
  String routing_no;

  List<TravelType> travelTypeList = <TravelType>[];
  List<TravelPurpose> travelPurposesList = <TravelPurpose>[];
  List<TravelType> travelTransportModesList = <TravelType>[];
  List<TravelType> currencyList = <TravelType>[];
  List<TravelType> travellerList = <TravelType>[];
  List<TravelType> destinationList = <TravelType>[];

  List<TravelType> ccList = <TravelType>[];
  List<TravelType> businessHeadList = <TravelType>[];
  List<TravelType> financeBpList = <TravelType>[];
  List<TravelType> ceoList = <TravelType>[];
  List<KeyValuePair> costCenterList = <KeyValuePair>[];

  FormData formData;
  DateTime tpStartDate;
  DateTime tpEndDate;
  DateTime mcStartDate;
  DateTime mcEndDate;
  DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ;
  bool isCloudWell = false;

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
    isCloudWell = _currentUser.business_unit_id=="4";
    //print("isCloudWell : " + isCloudWell.toString());
    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
          child: Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: kPrimaryColor
                )),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _activeStepIndex,
              steps: stepList(),
              onStepContinue: () {
                if (_activeStepIndex < (stepList().length - 1)) {
                  // Validate Steps forms
                  validateSteps(_activeStepIndex);
                } else {
                  validateSteps(_activeStepIndex);
                }
              },
              onStepCancel: () {
                if (_activeStepIndex == 0) {
                  return;
                }

                setState(() {
                  _activeStepIndex -= 1;
                });
              },
              onStepTapped: (int index) {
                setState(() {
                  //_activeStepIndex = index;
                });
              },
              controlsBuilder: (BuildContext context, ControlsDetails controls) { //(context, {onStepContinue, onStepCancel}) {
                final isLastStep = _activeStepIndex == stepList().length - 1;
                return Container(
                  child: Row(
                    children: [
                      if (_activeStepIndex > 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controls.onStepCancel,
                            child: const Text('Back'),
                          ),
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controls.onStepContinue,
                          child: (isLastStep)
                              ? const Text('Submit')
                              : const Text('Next'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
      ),
    );
  }

  List<Step> stepList() =>
      [
        //Step One
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Step One'),
          content: Container(
            margin: EdgeInsets.only(bottom: 15),
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
                Form(
                  key: _travelApplyFormKeyOne,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Create Travel Plan',
                            style: TextStyle(color: Colors.black38,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: Text('Ref No : $referenceNo',
                              style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold,),
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
                            value: typeOfTravel,
                            hint: Text('Select Travel Type',
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),),
                            items: List<
                                DropdownMenuItem<String>>.generate(
                              (travelTypeList?.length ?? 0) + 1,
                                  (idx) =>
                                  DropdownMenuItem<String>(
                                    value: idx == 0
                                        ? null
                                        : travelTypeList[idx - 1].id,
                                    //domestic
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.6,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        idx == 0
                                            ? "Select Travel Types"
                                            : travelTypeList[idx - 1].name,
                                        //Domestic
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                            onChanged: (String tvType) {
                              setState(() {
                                typeOfTravel = tvType ?? typeOfTravel;
                                workPlace=null;
                                travelPurpose = null;
                                referenceNo='';
                                transportMode=null;
                                currency=null;

                                if(typeOfTravel != null){
                                  print('typeOfTravel: ' + typeOfTravel);
                                  _radioValue=1;

                                  if(typeOfTravel.contains('domestic')){
                                    workPlace = workPlaceList.first.value;
                                    print('workPlace : ' + workPlace);

                                    currency = currencyList.firstWhere((e) => e.id.toLowerCase().contains('bdt')).id;
                                    print('currency : ' + currency);
                                    _isWorkPlaceVisible=true;
                                    _isCurrencyVisible=false;
                                  }
                                  else{
                                    _isCurrencyVisible= true;
                                    _isWorkPlaceVisible=false;
                                  }
                                  _generateTravelPurposeList();
                                  _generateTransportModeList();
                                  _generateDestinationList();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(),
                      _isWorkPlaceVisible ? Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                workPlaceList.length,
                                    (index) {
                                  return
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio(
                                          value: index + 1,
                                          groupValue: _radioValue,
                                          activeColor: Color(0xff2891a6),
                                          onChanged: (int value) {
                                            setState(() {
                                              _radioValue = value;
                                              workPlace =
                                                  workPlaceList[index].value;
                                              workPlaceDescription =
                                                  workPlaceList[index].name;
                                              print('workPlace : ' + workPlace);
                                            });
                                          },
                                        ),
                                        Text(workPlaceList[index].id.toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                      ],
                                    );
                                },
                              ),
                            ),
                            Visibility(
                              visible: !isCloudWell,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Text(workPlaceDescription ?? workPlaceList.first.name, style: TextStyle(color: Colors.white),)
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      )
                          : SizedBox(height: 10),
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
                            value: travelPurpose,
                            hint: Text(
                              'Select Travel Purpose',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),
                            ),
                            items: List<DropdownMenuItem<String>>.generate(
                              (travelPurposesList?.length ?? 0) + 1,
                                  (idx) => DropdownMenuItem<String>(
                                value: idx == 0
                                    ? null
                                    : travelPurposesList[idx - 1].purpose,
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.6,
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    idx == 0
                                        ? "Select Travel Purpose"
                                        : travelPurposesList[idx - 1].purpose,
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
                                travelPurpose = value ?? travelPurpose;
                                if (travelPurpose != null) {
                                  travelPurpose = travelPurpose.trim();
                                  _generateReference();
                                  print('travelPurpose: ' + travelPurpose);
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
                            value: transportMode,
                            hint: Text(
                              'Select Transport Mode',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),
                            ),
                            items: List<
                                DropdownMenuItem<String>>.generate(
                              (travelTransportModesList?.length ?? 0) + 1,
                                  (idx) =>
                                  DropdownMenuItem<String>(
                                    value: idx == 0
                                        ? null
                                        : travelTransportModesList[idx - 1].id,
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.6,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(idx == 0
                                          ? "Select Transport Mode"
                                          : travelTransportModesList[idx - 1]
                                          .name,
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
                                transportMode = value ?? transportMode;
                                if(transportMode !=null){
                                  print('transportMode: ' + transportMode);
                                  _isAirTransportMode = transportMode.toLowerCase().contains('air') ? true : false;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      _isCurrencyVisible ? Container(
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
                            value: currency,
                            hint: Text(
                              'Select Currency',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),
                            ),
                            items: List<DropdownMenuItem<String>>.generate(
                              (currencyList?.length ?? 0) + 1,
                                  (idx) =>
                                  DropdownMenuItem<String>(
                                    value: idx == 0
                                        ? null
                                        : currencyList[idx - 1].id,
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.6,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(idx == 0
                                          ? "Currency"
                                          : currencyList[idx - 1]
                                          .name,
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
                                currency = value ?? currency;
                                if(currency !=null){
                                  print('currency: ' + currency);
                                }
                              });
                            },
                          ),
                        ),
                      )
                          : SizedBox(height: 10),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NeomorphicDatetimePicker(
                            hintText: startDate ?? "Start Date",
                            updateValue: (String from) {
                              setState(() {
                                startDate = dateFormatter.format(DateTime.parse(from));
                                print("Start Date : " + startDate);
                                tpStartDate=DateTime.tryParse(from);
                              });
                            },
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.365,
                          ),
                          NeomorphicDatetimePicker(
                            hintText: endDate ?? "End Date",
                            updateValue: (String to) {
                              setState(() {
                                endDate = dateFormatter.format(DateTime.parse(to));
                                print("End Date : " + endDate);
                                tpEndDate=DateTime.tryParse(to);
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
                    ],
                  ),
                ),
              ],
            ),
          ),

        ),

        //Step Two
        Step(
          state:
          _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text('Step Two'),
          content: Container(
            margin: EdgeInsets.only(bottom: 15),
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
                Form(
                  key: _travelApplyFormKeyTwo,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Create Travel Plan',
                            style: TextStyle(color: Colors.black38,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      //Additional Travelers
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
                                  traveller = value;
                                  print('traveller : ' + traveller);
                                  bool isAlreadyExist = travellers.contains(traveller);
                                  if (!isAlreadyExist) {
                                    var travellerId = travellerList.firstWhere((e) => e.name==traveller.trim()).id;
                                    travellers.add(traveller);
                                    travellerIds.add(travellerId);
                                  }
                                  print('travellers : ' + travellers.toList().toString());
                                });
                              },
                              //enabled: true,
                              strict: false,
                              itemsVisibleInDropdown: 5,
                              value: traveller,
                              //required: false,
                              labelText: 'Add Additional Traveller(s)',
                              labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),
                              items: travellerList.map((e) => e.name).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      travellers.length > 0 ?
                      Tags(
                        key: _tagStateKeyTV,
                        horizontalScroll: true,
                        heightHorizontalScroll:40,
                        itemCount: travellers.length,
                        itemBuilder: (int index){
                          final item = travellers[index];
                          return Container(
                            width: 250,
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
                                    travellers.removeAt(index);
                                    travellerIds.removeAt(index);
                                    print('travellers : ' + travellers.toList().toString());
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
                            value: tripType,
                            hint: Text('Select Trip Type',
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),),
                            items: List<
                                DropdownMenuItem<String>>.generate(
                              (tripTypeList?.length ?? 0) + 1,
                                  (idx) =>
                                  DropdownMenuItem<String>(
                                    value: idx == 0
                                        ? null
                                        : tripTypeList[idx - 1].id,
                                    //domestic
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.6,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        idx == 0
                                            ? "Select Trip Types"
                                            : tripTypeList[idx - 1].name,
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
                                tripType = value ?? tripType;
                                if(tripType !=null){
                                  print('tripType: ' + tripType);
                                  multiCityFormList= <MultiCityForm>[];
                                  multiCityForm= MultiCityForm();
                                  multiFromDestinationId= <int>[];
                                  multiToDestinationId= <int>[];
                                  multiFromDestinationDate= <String>[];
                                  multiToDestinationDate= <String>[];

                                  if(tripType.contains('multi-city')){
                                    _isMulticity= true;
                                    fromDestination=null;
                                    toDestination=null;
                                    fromDestinationId=null;
                                    toDestinationId=null;
                                    _multiFormCounter=1;
                                  }
                                  else{
                                    _isMulticity= false;
                                  }

                                }
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      //From-To
                      !_isMulticity ?
                      //From-To
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
                                  fromDestination = value ?? fromDestination;
                                  if(fromDestination !=null){
                                    var from = destinationList.firstWhere((e) => e.name.contains(fromDestination), orElse: null);
                                    fromDestinationId= int.tryParse(from.id);
                                    print('fromDestination: ' + fromDestination.toString() + ' || fromDestinationId: ' + fromDestinationId.toString());
                                  }
                                });
                              },
                              //enabled: true,
                              strict: false,
                              itemsVisibleInDropdown: 5,
                              value: fromDestination,
                              //required: false,
                              labelText: 'Select From',
                              labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),
                              items: destinationList.map((e) => e.name).toList(),
                            ),
                            SizedBox(height: 20),
                            DropDownField(
                              onValueChanged: (dynamic value) {
                                setState(() {
                                  toDestination = value ?? toDestination;
                                  if(toDestination !=null){
                                    var to = destinationList.firstWhere((e) => e.name.contains(toDestination), orElse: null);
                                    toDestinationId= int.tryParse(to.id);
                                    print('toDestination: ' + toDestination.toString() + ' || toDestinationId: ' + toDestinationId.toString());
                                  }
                                });
                              },
                              //enabled: true,
                              strict: false,
                              itemsVisibleInDropdown: 5,
                              value: toDestination,
                              //required: false,
                              labelText: 'Select To',
                              labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),
                              items: destinationList.map((e) => e.name).toList(),
                            ),
                          ],
                        ),
                      )
                      //Multi-From-To
                          : Container(
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
                        child:_generateMultiCityContainer(),
                        // Column(
                        //   children: [
                        //     ListView.builder(
                        //       shrinkWrap: true,
                        //       physics: NeverScrollableScrollPhysics(),
                        //       itemCount: _multiFormCounter,//_multiFormCounter,
                        //       itemBuilder: (context, index) {
                        //         int idx=0;
                        //         idx= multiCityFormList.length > 0 ? multiCityFormList.length : idx;
                        //         return _generateMultiCityContainer(index);
                        //       },
                        //     ),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         Container(
                        //           margin: EdgeInsets.only(right: 5),
                        //           child: Row(
                        //             children: [
                        //               ElevatedButton(
                        //                 onPressed: () => {
                        //                   validateMultiCityForm(),
                        //                 },
                        //                 child: Text('Add'),
                        //               ),
                        //               SizedBox(width: 10,),
                        //               _multiFormCounter > 1  ?
                        //               ElevatedButton(
                        //                 onPressed: () => {
                        //                   setState(() => {_multiFormCounter--,}),},
                        //                 style: ElevatedButton.styleFrom(
                        //                   primary: Colors.red[400],),
                        //                 child: Text('Remove'),
                        //               ) : Container(),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),

                        //_generateMultiCityContainer(_multiFormCounter),
                      ),


                      SizedBox(height: 10),
                      NeomorphicTextFormField(
                        initVal:description,
                        inputType: TextInputType.text,
                        numOfMaxLines: 3,
                        hintText: description ?? "Description",
                        fontSize: 12,
                        onChangeFunction: (String value) {
                          if(value !=null){
                            description = value.trim();
                            print('description : ' + description);
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
                                .width - 80) * 0.6,
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
                                    scaffoldKey:_scaffoldKey,
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
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        //Step Three
        Step(
          //state: StepState.complete,
          state: _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 2 ,
          title: const Text('Step Three'),
          content: Container(
            margin: EdgeInsets.only(bottom: 15),
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
                Form(
                  key: _travelApplyFormKeyThree,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Create Travel Plan',
                            style: TextStyle(color: Colors.black38,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Visibility(
                            visible:_isWorkPlaceVisible ? true : false,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                ///Domestic
                                Visibility(
                                  visible:_isAirTransportMode  ? true : false,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: airTicket,
                                            activeColor: kPrimaryColor,
                                            onChanged: (newValue) {
                                              setState(() {
                                                airTicket = newValue;
                                                airTicketAmount = 0;
                                                if(airTicket){
                                                  airTicketByAdminDpt=false;
                                                }
                                                print('airTicket : ' + airTicket.toString() + '\nairTicketAmount : ' + airTicket.toString()+ '\nadvancePayment : ' + advancePayment.toString());

                                              });
                                            },
                                          ),
                                          Text('Air Ticket'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: airTicketByAdminDpt,
                                            activeColor: kPrimaryColor,
                                            onChanged: (newValue) {
                                              setState(() {
                                                airTicketByAdminDpt = newValue;
                                                if(airTicketByAdminDpt){
                                                  airTicket=false;
                                                  airTicketAmount = 0;
                                                }
                                                print('airTicketByAdminDpt : ' + airTicketByAdminDpt.toString() + '\nairTicketAmount : ' + airTicketAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());

                                              });
                                            },
                                          ),
                                          Expanded(child: Text('Air Ticket Managed by Admin Dept.')),
                                        ],
                                      ),
                                      airTicket ?
                                      NeomorphicTextFormField(
                                          initVal: airTicketAmount.toString(),
                                          inputType: TextInputType.number,
                                          hintText: "Air Ticket Amount",
                                          onChangeFunction: (String val) {
                                            airTicketAmount = int.tryParse(val);
                                            if(airTicketAmount !=null){
                                              print('airTicketAmount : ' + airTicketAmount.toString());}
                                            else{airTicketAmount=0;}
                                          }
                                      ) : Container(),
                                    ],
                                  ),
                                ),

                                Row(
                                  children: [
                                    Checkbox(
                                      value: hotelAccommodation,
                                      activeColor: kPrimaryColor,
                                      onChanged: (newValue) {
                                        setState(() {
                                          hotelAccommodation = newValue;
                                          hotelAccommodationAmount = 0;
                                          if(hotelAccommodation){
                                            hotelAccommodationByAdminDpt=false;
                                          }
                                          print('hotelAccommodation : ' + hotelAccommodation.toString() + '\nhotelAccommodationAmount : ' + hotelAccommodationAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());

                                        });
                                      },
                                    ),
                                    Text('Hotel Accommodation'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: hotelAccommodationByAdminDpt,
                                      activeColor: kPrimaryColor,
                                      onChanged: (newValue) {
                                        setState(() {
                                          hotelAccommodationByAdminDpt = newValue;
                                          if(hotelAccommodationByAdminDpt){
                                            hotelAccommodation=false;
                                            hotelAccommodationAmount = 0;
                                          }
                                          print('hotelAccommodationByAdminDpt : ' + hotelAccommodationByAdminDpt.toString() + '\nhotelAccommodationAmount : ' + hotelAccommodationAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());

                                        });
                                      },
                                    ),
                                    Expanded(child: Text('Hotel Accommodation Managed by Admin Dept.')),
                                  ],
                                ),
                                hotelAccommodation ?
                                NeomorphicTextFormField(
                                    initVal: hotelAccommodationAmount.toString(),
                                    inputType: TextInputType.number,
                                    hintText: "Hotel Accommodation Amount",
                                    onChangeFunction: (String val) {
                                      hotelAccommodationAmount = int.tryParse(val);
                                      if(hotelAccommodationAmount !=null){
                                        print('hotelAccommodation : ' + hotelAccommodation.toString() + '\nhotelAccommodationAmount : ' + hotelAccommodationAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());                                    }
                                      else{
                                        hotelAccommodationAmount=0;
                                        print('hotelAccommodation : ' + hotelAccommodation.toString() + '\nhotelAccommodationAmount : ' + hotelAccommodationAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());                                    }
                                    }
                                ) : Container(),
                                SizedBox(height: 10,),
                                Visibility(
                                  visible: !isCloudWell,
                                  child: Container(
                                    height: 320,
                                    child: ListView.builder(
                                        itemCount: 1,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context,index){
                                          return Container(
                                              width: 290,
                                              margin: EdgeInsets.only(left: 12),
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     blurRadius: 15,
                                                //     color: Colors.black26,
                                                //     offset: Offset.fromDirection(Math.pi * .25, 5),
                                                //   ),
                                                // ],
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              child:
                                              Column(
                                                children: [
                                                  Text('Ceiling For Accommodation (Those who will have night stay during office assignments)',
                                                    style: TextStyle(color: Colors.white,fontSize: 12)),
                                                  SizedBox(height: 10),
                                                  Text('ACCOMMODATION', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                                                  SizedBox(height: 5),
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: DataTable(
                                                    headingTextStyle: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
                                                    dataTextStyle: TextStyle(color: Colors.white,fontSize: 12 ),
                                                    dataRowHeight: 40,
                                                    headingRowHeight: 40,
                                                    horizontalMargin: 5,
                                                    columns: [
                                                      DataColumn(label: Text('ELIGIBILITY')),
                                                      DataColumn(label: Text('DHAKA/CTG/COX/BARISAL')),
                                                      DataColumn(label: Text('SYLHET/BOGRA')),
                                                      DataColumn(label: Text('RAJSHAHI')),
                                                      DataColumn(label: Text('OTHER DISTRICT')),
                                                    ],
                                                    rows: [
                                                      DataRow(cells: [
                                                        DataCell(Text('Grade 5 & above')),
                                                        DataCell(Text('Tk. 6000')),
                                                        DataCell(Text('Tk. 5500')),
                                                        DataCell(Text('Tk. 5000')),
                                                        DataCell(Text('Tk. 4000')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(Text('Grade 4 & below')),
                                                        DataCell(Text('Tk. 4500')),
                                                        DataCell(Text('Tk. 4500')),
                                                        DataCell(Text('Tk. 4000')),
                                                        DataCell(Text('Tk. 3500')),
                                                      ]),
                                                      DataRow(cells: [
                                                        DataCell(Text('Non-Management\nEmployees')),
                                                        DataCell(Text('Tk. 1500')),
                                                        DataCell(Text('Tk. 1500')),
                                                        DataCell(Text('Tk. 1500')),
                                                        DataCell(Text('Tk. 1000')),
                                                      ]),
                                                    ],),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text('*The above amounts are ceilings an employee can claim up to for accommodation by submitting relevant bill copies.',
                                                    style: TextStyle(color: Colors.white,fontSize: 12))
                                                ],
                                              )
                                              // Column(
                                              //   crossAxisAlignment: CrossAxisAlignment.start,
                                              //   children: [
                                              //     Text('Ceiling For Accommodation (Those who will have night stay during office assignments)', style: TextStyle(color: Colors.white),),
                                              //     SizedBox(height: 5),
                                              //     Text('Band Group : Management Employees\n'
                                              //         'Dhaka : Tk. 4,000\n'
                                              //         'CTG : Tk. 4,000\n'
                                              //         'Sylhet : Tk. 4,000\n'
                                              //         'Cox\'s Bazar : Tk. 4,000\n'
                                              //         'Bogra : Tk. 3,500\n'
                                              //         'Other District : Tk. 3,500\n\n'
                                              //         '*The above amounts are ceilings an employee can claim up to. Employees are required to submit relevant bill copies for claim and verification.',
                                              //         style: TextStyle(color: Colors.white)),
                                              //   ],
                                              // )
                                          );
                                        }),
                                  ),
                                ),

                                Row(
                                  children: [
                                    Checkbox(
                                      value: transport,
                                      activeColor: kPrimaryColor,
                                      onChanged: (newValue) {
                                        setState(() {
                                          transport = newValue;
                                          if(transport){
                                            transportByAdminDpt=false;
                                          }
                                          transportAmount =0;
                                          print('transport : ' + transport.toString() + '\ntransportAmount : ' + transportAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());
                                        });
                                      },
                                    ),
                                    Text('Transport'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: transportByAdminDpt,
                                      activeColor: kPrimaryColor,
                                      onChanged: (newValue) {
                                        setState(() {
                                          transportByAdminDpt = newValue;
                                          if(transportByAdminDpt){
                                            transport=false;
                                            transportAmount =0;
                                          }

                                          print('transportByAdminDpt : ' + transportByAdminDpt.toString() + '\ntransportAmount : ' + transportAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());
                                        });
                                      },
                                    ),
                                    Text('Transport Managed by Admin Dept.'),
                                  ],
                                ),
                                transport ?
                                NeomorphicTextFormField(
                                    initVal: transportAmount.toString(),
                                    inputType: TextInputType.number,
                                    hintText: "Transport Amount",
                                    onChangeFunction: (String val) {
                                      transportAmount = int.tryParse(val);
                                      if(transportAmount !=null){
                                        print('transport : ' + transport.toString() + '\ntransportAmount : ' + transportAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());
                                      }
                                      else{transportAmount=0;
                                      print('transport : ' + transport.toString() + '\ntransportAmount : ' + transportAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());
                                      }
                                    }
                                ) : Container(),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: dailyAllowance,
                                      activeColor: kPrimaryColor,
                                      onChanged: (newValue) {
                                        setState(() {
                                          dailyAllowance = newValue;
                                          dailyAllowanceAmount =0;
                                          print('dailyAllowance : ' + dailyAllowance.toString() + '\ndailyAllowanceAmount : ' + dailyAllowanceAmount.toString() +'\nadvancePayment : ' + advancePayment.toString());
                                        });
                                      },
                                    ),
                                    Text('Daily Allowance'),
                                  ],
                                ),
                                dailyAllowance ?
                                NeomorphicTextFormField(
                                    initVal: dailyAllowanceAmount.toString(),
                                    inputType: TextInputType.number,
                                    hintText: "Daily Allowance Amount",
                                    onChangeFunction: (String val) {
                                      dailyAllowanceAmount = int.tryParse(val);
                                      if(dailyAllowanceAmount !=null){
                                        print('dailyAllowance : ' + dailyAllowance.toString() + '\ndailyAllowanceAmount : ' + dailyAllowanceAmount.toString() +'\nadvancePayment : ' + advancePayment.toString());
                                      }else{dailyAllowanceAmount=0;
                                      print('dailyAllowance : ' + dailyAllowance.toString() + '\ndailyAllowanceAmount : ' + dailyAllowanceAmount.toString() +'\nadvancePayment : ' + advancePayment.toString());
                                      }
                                    }
                                ) : Container(),
                                SizedBox(height: 10,),
                                Visibility(
                                  visible: !isCloudWell,
                                  child: Container(
                                      margin: EdgeInsets.only(left: 12),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     blurRadius: 15,
                                        //     color: Colors.black26,
                                        //     offset: Offset.fromDirection(Math.pi * .25, 5),
                                        //   ),
                                        // ],
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      child: Text('Upto BDT 1000 for Outstation for meal and incidental expenses', style: TextStyle(color: Colors.white),)
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: transferAllowance,
                                      activeColor: kPrimaryColor,
                                      onChanged: (newValue) {
                                        setState(() {
                                          transferAllowance = newValue;
                                          print('transferAllowance : ' + transferAllowance.toString());
                                        });
                                      },
                                    ),
                                    Text('Transfer/Relocation Allowance'),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Visibility(
                                  visible: !isCloudWell,
                                  child: Container(
                                      margin: EdgeInsets.only(left: 12),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     blurRadius: 15,
                                        //     color: Colors.black26,
                                        //     offset: Offset.fromDirection(Math.pi * .25, 5),
                                        //   ),
                                        // ],
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      child: Text('Upto BDT. 15,000', style: TextStyle(color: Colors.white),)
                                  ),
                                ),
                              ],),),
                          Visibility(
                            visible: !_isWorkPlaceVisible ? true : false,
                            child: Column(children: [
                              ///International
                              Row(
                                children: [
                                  Checkbox(
                                    value: airTicket,
                                    activeColor: kPrimaryColor,
                                    onChanged: (newValue) {
                                      setState(() {
                                        airTicket = newValue;
                                        airTicketAmount = 0;
                                        if(airTicket){
                                          airTicketByAdminDpt=false;
                                        }
                                        print('airTicket : ' + airTicket.toString() + '\nairTicketAmount : ' + airTicket.toString()+ '\nadvancePayment : ' + advancePayment.toString());

                                      });
                                    },
                                  ),
                                  Text('Air Ticket'),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: airTicketByAdminDpt,
                                    activeColor: kPrimaryColor,
                                    onChanged: (newValue) {
                                      setState(() {
                                        airTicketByAdminDpt = newValue;
                                        if(airTicketByAdminDpt){
                                          airTicket=false;
                                          airTicketAmount = 0;
                                        }
                                        print('airTicketByAdminDpt : ' + airTicketByAdminDpt.toString() + '\nairTicketAmount : ' + airTicketAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());

                                      });
                                    },
                                  ),
                                  Expanded(child: Text('Air Ticket Managed by Admin Dept.')),
                                ],
                              ),
                              airTicket ?
                              NeomorphicTextFormField(
                                  initVal: airTicketAmount.toString(),
                                  inputType: TextInputType.number,
                                  hintText: "Air Ticket Amount",
                                  onChangeFunction: (String val) {
                                    airTicketAmount = int.tryParse(val);
                                    if(airTicketAmount !=null){
                                      print('airTicketAmount : ' + airTicketAmount.toString());}
                                    else{airTicketAmount=0;}
                                  }
                              ) : Container(),

                              Row(
                                children: [
                                  Checkbox(
                                    value: hotelAccommodation,
                                    activeColor: kPrimaryColor,
                                    onChanged: (newValue) {
                                      setState(() {
                                        hotelAccommodation = newValue;
                                        hotelAccommodationAmount = 0;
                                        if(hotelAccommodation){
                                          hotelAccommodationByAdminDpt=false;
                                        }
                                        print('hotelAccommodation : ' + hotelAccommodation.toString() + '\nhotelAccommodationAmount : ' + hotelAccommodationAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());

                                      });
                                    },
                                  ),
                                  Text('Hotel Accommodation'),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: hotelAccommodationByAdminDpt,
                                    activeColor: kPrimaryColor,
                                    onChanged: (newValue) {
                                      setState(() {
                                        hotelAccommodationByAdminDpt = newValue;
                                        if(hotelAccommodationByAdminDpt){
                                          hotelAccommodation=false;
                                          hotelAccommodationAmount = 0;
                                        }
                                        print('hotelAccommodationByAdminDpt : ' + hotelAccommodationByAdminDpt.toString() + '\nhotelAccommodationAmount : ' + hotelAccommodationAmount.toString()+ '\nadvancePayment : ' + advancePayment.toString());

                                      });
                                    },
                                  ),
                                  Expanded(child: Text('Hotel Accommodation Managed by Admin Dept.')),
                                ],
                              ),
                              hotelAccommodation ?
                              NeomorphicTextFormField(
                                  initVal: hotelAccommodationAmount.toString(),
                                  inputType: TextInputType.number,
                                  hintText: "Hotel Accommodation Amount",
                                  onChangeFunction: (String val) {
                                    hotelAccommodationAmount = int.tryParse(val);
                                    if(hotelAccommodationAmount !=null){
                                      print('hotelAccommodationAmount : ' + hotelAccommodationAmount.toString());}
                                    else{hotelAccommodationAmount=0;}
                                  }
                              ) : Container(),
                              SizedBox(height: 10,),
                              Visibility(
                                visible: !isCloudWell,
                                child: Container(
                                    margin: EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Text('Upto US \$120/day (including breakfast and all taxes)',
                                      style: TextStyle(color: Colors.white),)
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: guestHouseAccommodation,
                                    activeColor: kPrimaryColor,
                                    onChanged: (newValue) {
                                      setState(() {
                                        guestHouseAccommodation = newValue;
                                        print('guestHouseAccommodation : ' + guestHouseAccommodation.toString());
                                      });
                                    },
                                  ),
                                  Text('Guest House Accommodation'),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: mealAllowance,
                                    activeColor: kPrimaryColor,
                                    onChanged: (newValue) {
                                      setState(() {
                                        // mealAllowance = newValue;
                                        // print('mealAllowance : ' + mealAllowance.toString());
                                        mealAllowance = newValue;
                                        mealAllowanceAmount =0;
                                        print('mealAllowance : ' + mealAllowance.toString() + '\nmealAllowanceAmount : ' + mealAllowanceAmount.toString() +'\nadvancePayment : ' + advancePayment.toString());

                                      });
                                    },
                                  ),
                                  Text('Meal Allowance'),
                                ],
                              ),
                              mealAllowance ?
                              NeomorphicTextFormField(
                                  initVal: mealAllowanceAmount.toString(),
                                  inputType: TextInputType.number,
                                  hintText: "Meal Allowance Amount",
                                  onChangeFunction: (String val) {
                                    mealAllowanceAmount = int.tryParse(val);
                                    if(mealAllowanceAmount !=null){
                                      print('mealAllowance : ' + mealAllowance.toString() + '\nmealAllowanceAmount : ' + mealAllowanceAmount.toString() +'\nadvancePayment : ' + advancePayment.toString());
                                    }else{mealAllowanceAmount=0;
                                    print('mealAllowance : ' + mealAllowance.toString() + '\nmealAllowanceAmount : ' + mealAllowanceAmount.toString() +'\nadvancePayment : ' + advancePayment.toString());
                                    }
                                  }
                              ) : Container(),
                              SizedBox(height: 10,),
                              Visibility(
                                visible: !isCloudWell,
                                child: Container(
                                    margin: EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     blurRadius: 15,
                                      //     color: Colors.black26,
                                      //     offset: Offset.fromDirection(Math.pi * .25, 5),
                                      //   ),
                                      // ],
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: Text('Upto US \$75/day (for lunch and dinner including all VAT/SC)',
                                      style: TextStyle(color: Colors.white),)
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(height: 10),

                          //Advance Required??
                          Row(
                            children: [
                              Checkbox(
                                value: advanceRequired,
                                activeColor: kPrimaryColor,
                                onChanged: (newValue) {
                                  setState(() {
                                    advanceRequired = newValue;
                                    if(!advanceRequired){
                                      advancePayment=0;
                                    }
                                    print('advanceRequired : ' + advanceRequired.toString() + ' || advancePayment : ' + advancePayment.toString());
                                  });
                                },
                              ),
                              Text('Advance Required'),
                            ],
                          ),
                          // advanceRequired == true ?
                          // NeomorphicTextFormField(
                          //     initVal: advancePayment.toString(),
                          //     inputType: TextInputType.number,
                          //     hintText: "Advance Amount",
                          //     onChangeFunction: (String val) {
                          //       advancePayment = int.tryParse(val);
                          //       if(advancePayment !=null){
                          //         print('advancePayment : ' + advancePayment.toString());
                          //       }
                          //     })
                          // : Container(),
                          NeomorphicTextFormField(
                            key: Key((hotelAccommodationAmount + transportAmount+ dailyAllowanceAmount + airTicketAmount +mealAllowanceAmount).toString()),
                            initVal: "Advance Amount "+ (hotelAccommodationAmount + transportAmount+ dailyAllowanceAmount+ airTicketAmount + mealAllowanceAmount).toString(), //"Advance Amount : " + advancePayment.toString(),
                            inputType: TextInputType.number,
                            hintText: "Advance Amount",
                            isReadOnly: true,
                            fontSize: 12,
                            // onChangeFunction: (String val) {
                            //   advancePayment = int.tryParse(val);
                            //   if(advancePayment !=null){
                            //     print('advancePayment : ' + advancePayment.toString());
                            //   }
                            // }
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
                              (paymentMethodList?.length ?? 0) + 1, (idx) => DropdownMenuItem<String>(
                              value: idx == 0 ? null : paymentMethodList[idx - 1].id,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  idx == 0 ? "Select Payment Method" : paymentMethodList[idx - 1].name,
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
                              SizedBox(height: 10,),
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
                                      //initVal: conveyanceInfo.bankDetail.bankName !=null ? conveyanceInfo.bankDetail.bankName : null,
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
                                      //initVal: conveyanceInfo.bankDetail.accountName !='N/A' ? conveyanceInfo.bankDetail.accountName : null,
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
                                      //initVal: conveyanceInfo.bankDetail.bankAccountNumber !='N/A' ? conveyanceInfo.bankDetail.bankAccountNumber : null,
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
                                      //initVal: conveyanceInfo.bankDetail.bankBranchName !='N/A' ? conveyanceInfo.bankDetail.bankBranchName : null,
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
                                      //initVal: conveyanceInfo.bankDetail.bankRoutingNo !='N/A' ? conveyanceInfo.bankDetail.bankRoutingNo : null,
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
                      //SizedBox(height: 5),
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
                      //         offset: Offset.fromDirection(Math.pi * .25, 5),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Container(
                      //     padding: EdgeInsets.only(
                      //       left: 7,
                      //       right: 3,
                      //       top: 10,
                      //       bottom: 10,
                      //     ),
                      //     margin: EdgeInsets.only(top: 10),
                      //     width: double.infinity,
                      //     child: DropdownButton<String>(
                      //       isDense: true,
                      //       underline: SizedBox(),
                      //       value: hrGroup,
                      //       hint: Text('Select CC',
                      //         style: TextStyle(fontSize: 12,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.grey[500]),),
                      //       items: List<DropdownMenuItem<String>>.generate(
                      //         (ccList?.length ?? 0) + 1,
                      //             (idx) =>
                      //             DropdownMenuItem<String>(
                      //               value: idx == 0
                      //                   ? null
                      //                   : ccList[idx - 1].id,
                      //               //domestic
                      //               child: Container(
                      //                 width: MediaQuery
                      //                     .of(context)
                      //                     .size
                      //                     .width * 0.6,
                      //                 padding: EdgeInsets.only(left: 20),
                      //                 child: Text(
                      //                   idx == 0
                      //                       ? "Select CC"
                      //                       : ccList[idx - 1].name,
                      //                   //Domestic
                      //                   style: TextStyle(
                      //                     fontSize: 12,
                      //                     fontWeight: FontWeight.bold,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //       ),
                      //       onChanged: (String value) {
                      //         setState(() {
                      //           hrGroup = value ?? hrGroup;
                      //           if(hrGroup != null){
                      //             print('hrGroup(cc) : ' + hrGroup);
                      //           }
                      //         });
                      //       },
                      //     ),
                      //   ),
                      // ),

                      //Add Cost-Center
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
                                    var ccId = costCenterList.firstWhere((e) => e.name==costCenter.trim()).id;
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
                              items: costCenterList.map((e) => e.name).toList(),
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
                        key: Key(hrGroup.toString()),
                        initVal: "CC : ${hrGroup.toString().toUpperCase()}",
                        inputType: TextInputType.text,
                        hintText: "CC",
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
                            value: firstApprover,
                            hint: Text('1ST APPROVER (BUSINESS HEAD)',
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),),
                            items: List<DropdownMenuItem<String>>.generate(
                              (businessHeadList?.length ?? 0) + 1,
                                  (idx) =>
                                  DropdownMenuItem<String>(
                                    value: idx == 0
                                        ? null
                                        : businessHeadList[idx - 1].id,
                                    //domestic
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.6,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        idx == 0
                                            ? "Select 1st Approver (Business Head)"
                                            : businessHeadList[idx - 1].name,
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
                                firstApprover = value ?? firstApprover;
                                if(firstApprover != null){
                                  authorityOne=int.tryParse(firstApprover);
                                  print('firstApprover BSHead: ' + firstApprover);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      !_isWorkPlaceVisible ? SizedBox(height: 10) : SizedBox(),
                      !_isWorkPlaceVisible ?
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
                            value: secondApprover,
                            hint: Text('Select 2nd Approver',
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),),
                            items: List<DropdownMenuItem<String>>.generate(
                              (ceoList?.length ?? 0) + 1,
                                  (idx) =>
                                  DropdownMenuItem<String>(
                                    value: idx == 0
                                        ? null
                                        : ceoList[idx - 1].id,
                                    //domestic
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.6,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        idx == 0
                                            ? "Select 2nd Approver (CEO)"
                                            : ceoList[idx - 1].name,
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
                                secondApprover = value ?? secondApprover;
                                if(secondApprover != null){
                                  authorityTwo =int.tryParse(secondApprover);
                                  print('secondApprover CEO: ' + secondApprover);
                                }
                              });
                            },
                          ),
                        ),
                      ):Container(),
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
                            value: finalApprover,
                            hint: Text('Select Final Approver (Finance BP)',
                              style: TextStyle(fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),),
                            items: List<DropdownMenuItem<String>>.generate(
                              (financeBpList?.length ?? 0) + 1,
                                  (idx) =>
                                  DropdownMenuItem<String>(
                                    value: idx == 0
                                        ? null
                                        : financeBpList[idx - 1].id,
                                    //domestic
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.6,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        idx == 0
                                            ? 'Select Final Approver (Finance BP)'
                                            : financeBpList[idx - 1].name,
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
                                finalApprover = value ?? finalApprover;
                                if(finalApprover != null){
                                  authorityThree =int.tryParse(finalApprover);
                                  print('finalApprover FBP: ' + finalApprover);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      NeomorphicTextFormField(
                        initVal: "Supervisor : ${_currentUser.supervisor_name.toString()}",
                        inputType: TextInputType.text,
                        hintText: "Supervisor",
                        isReadOnly: true,
                        fontSize: 12,
                      ),
                      SizedBox(height: 10),
                      _isLoading
                          ? Center(child: CircularProgressIndicator(),) : Container()

                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ];

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successfully"),
          content: Text("Successfully Applied for Travel Plan!!!"),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(TRAVEL_PLAN_PAGE,arguments: TravelPlanPageScreen.TravelPlans);
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   NEW_TRAVEL_PLAN_PAGE,
                //       (_) => false,
                // );
              },
            ),
          ],
        );
      },
    );
  }
  Widget _generateMultiCityContainer()
  {
    return
      Row(
        children: [
          Container(
            child: Expanded(
              child: Column(
                children: [
                  DropDownField(
                    onValueChanged: (dynamic value) {
                      setState(() {
                        if (value != null) {
                          var destination = destinationList.firstWhere((e) => e.name.contains(value), orElse: ()=>null);
                          var destinationId = int.tryParse(destination.id);
                          print('multiFromDestination: ' + destination.name + ' || multiFromDestinationId: ' + destinationId.toString());
                          multiCityForm.FromId = destinationId;
                          multiCityForm.FromName = destination.name;
                        }
                      });
                    },
                    //enabled: true,
                    strict: false,
                    itemsVisibleInDropdown: 5,
                    value: multiCityForm.FromName ?? null,
                    //required: false,
                    labelText: 'Select From',
                    labelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    items: destinationList.map((e) => e.name).toList(),
                  ),
                  SizedBox(height: 20),
                  DropDownField(
                    onValueChanged: (dynamic value) {
                      setState(() {
                        if (value != null) {
                          var destination = destinationList.firstWhere((e) => e.name.contains(value), orElse: ()=>null);
                          var destinationId = int.tryParse(destination.id);
                          print('multiToDestination: ' + destination.name + ' || multiToDestinationId: ' + destinationId.toString());
                          multiCityForm.ToId = destinationId;
                          multiCityForm.ToName = destination.name;
                        }
                      });
                    },
                    //enabled: true,
                    strict: false,
                    itemsVisibleInDropdown: 5,
                    value: multiCityForm.ToName ?? null,
                    //required: false,
                    labelText: 'Select To',
                    labelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    items: destinationList.map((e) => e.name).toList(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NeomorphicDatetimePicker(
                        hintText:  multiCityForm.FromDate ?? 'From Date',
                        updateValue: (String from) {
                          setState(() {
                            multiCityForm.FromDate =
                                dateFormatter.format(DateTime.parse(from));
                            print("From Date : " + multiCityForm.FromDate);
                            mcStartDate = DateTime.tryParse(from);
                          });
                        },
                        width: MediaQuery.of(context).size.width * 0.350,
                      ),
                      NeomorphicDatetimePicker(
                        hintText: multiCityForm.ToDate ?? 'To Date',
                        updateValue: (String to) {
                          setState(() {
                            multiCityForm.ToDate = dateFormatter.format(DateTime.parse(to));
                            print("To Date : " + multiCityForm.ToDate);
                            mcEndDate = DateTime.tryParse(to);
                          });
                        },
                        width: MediaQuery.of(context).size.width * 0.350,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: ElevatedButton(
                          onPressed: () => {
                            validateMultiCityForm(),
                          },
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: multiCityFormList.length,
                    itemBuilder: (context, index) {
                      return
                        Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(child: Text('From : ' + multiCityFormList[index].FromName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.black54),)),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text('From Date : ' + multiCityFormList[index].FromDate,style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.black54),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Flexible(child: Text('To : ' + multiCityFormList[index].ToName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.black54),)),
                                  ],),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text('To Date : ' + multiCityFormList[index].ToDate,style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.black54),),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Text('Remove'),
                                          Icon(Icons.delete_rounded,color: Colors.black38,),
                                        ],
                                      ),
                                      onTap: (){
                                        print('Remove Clicked');
                                        var item = multiCityFormList[index];
                                        setState(() {
                                          multiCityFormList.removeAt(index);
                                          _multiFormCounter--;
                                          print('multiCityForm Removed : '+ item.FromName + 'multiCityTo : '+ item.ToName);
                                          print('multiCityFormList length : ' + multiCityFormList.length.toString());
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
  void _generateReference() async {
    var response = await _apiService.getReferenceCode(typeOfTravel, travelPurpose);
    setState(() {
      referenceNo = response;
      print('referenceNo : '+ referenceNo);
    });
  }
  void _generateTravelTypeList() async {
    var response =  await _apiService.getTravelTypes();
    setState(() {
      travelTypeList =  response.travelType.toList();
    });

  }
  void _generateTransportModeList() async {
    var response =  await _apiService.getTransportModes(typeOfTravel);
    setState(() {
      travelTransportModesList = response.travelType.toList();
      try{
        var othersMode = travelTransportModesList.singleWhere((e) => e.id =='others',orElse: null);
        if(othersMode != null){
          othersMode.name='Other Modes of Transport (Ride Sharing, CNG, Rickshaw etc.)';
        }
      } catch(e){}

      //print('_travelTransportModesList Length : '+ travelTransportModesList.length.toString());
    });

  }
  void _generateTravelPurposeList() async {
    var response =  await _apiService.getTravelPurposes(typeOfTravel);
    setState(() {
      travelPurposesList = response.travelPurpose.toList();
      //print('travelPurposesList Length : '+ travelPurposesList.length.toString());
    });

  }
  void _generateCurrencyList() async {
    var response =  await _apiService.getCurrencies();
    setState(() {
      currencyList = response.travelType.toList();
      //print('travelPurposesList Length : '+ travelPurposesList.length.toString());
    });

  }
  void _generateTravellerList() async {
    var response =  await _apiService.getTravellers();
    setState(() {
      travellerList = response.travelType.toList();
      //print('travelPurposesList Length : '+ travelPurposesList.length.toString());
    });

  }
  void _generateDestinationList() async {
    var response = await _apiService.getDestinations(typeOfTravel);
    setState(() {
      destinationList = response.travelType.toList();
    });
  }
  void _generateCCList() async {
    var response =  await _apiService.getCCs();
    setState(() {
      ccList = response.travelType.toList();
      //print('travelPurposesList Length : '+ travelPurposesList.length.toString());
    });

  }
  void _generateDefaultHRGroup() async {
    var response =  await _apiService.getDefaultHRGroup();
    setState(() {
      hrGroup = response;
      print('hrGroup  : '+ hrGroup.toString());
    });

  }
  void _generateBusinessHeadList() async {
    var response =  await _apiService.getBusinessHead();
    setState(() {
      businessHeadList = response.travelType.toList();
      //print('travelPurposesList Length : '+ travelPurposesList.length.toString());
    });

  }
  void _generateFinanceBp() async {
    var response =  await _apiService.getFinanceBp();
    setState(() {
      financeBpList = response.travelType.toList();
      //print('travelPurposesList Length : '+ travelPurposesList.length.toString());
    });

  }
  void _generateCEOList() async {
    var response =  await _apiService.getCEO();
    setState(() {
      ceoList = response.travelType.toList();
      //print('travelPurposesList Length : '+ travelPurposesList.length.toString());
    });

  }
  void _generateCostCenterList() async {
    var response =  await _apiService.getCostCenter();
    setState(() {
      costCenterList = response.businessUnitWiseCostCenter.toList();
      //print('travelPurposesList Length : '+ travelPurposesList.length.toString());
    });

  }

  void validateSteps(int activeStepIndex) {

    //First Step
    if(activeStepIndex==0){
      validateFirstStep();
    }
    else if(activeStepIndex==1){
      validateSecondStep();
    }
    else if(activeStepIndex==2){
      validateThirdStep();
    }

  }

  void validateFirstStep() {

    if (checkNullorEmpty(typeOfTravel)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Travel Type!",
        fillColor: Colors.red,
      );
      return;
    }

    if (typeOfTravel.toLowerCase().contains('domestic') && checkNullorEmpty(workPlace)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Work Place!",
        fillColor: Colors.red,
      );
      return;
    }

    if (checkNullorEmpty(travelPurpose)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Travel Purpose!",
        fillColor: Colors.red,
      );
      return;
    }

    if (checkNullorEmpty(transportMode)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Transport Mode!",
        fillColor: Colors.red,
      );
      return;
    }

    if (typeOfTravel.toLowerCase().contains('international') && checkNullorEmpty(currency)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Currency!",
        fillColor: Colors.red,
      );
      return;
    }

    if (checkNullorEmpty(startDate)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Start Date!",
        fillColor: Colors.red,
      );
      return;
    }

    if (checkNullorEmpty(endDate)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select End Date!",
        fillColor: Colors.red,
      );
      return;
    }

    if (tpEndDate.isBefore(tpStartDate)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Invalid Date selection! Start Date can't be greater then End Date",
        fillColor: Colors.red,
      );
      return;
    }
    if (tpStartDate.isBefore(dateToday) || tpEndDate.isBefore(dateToday)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Back Dated request is not allowed!",
        fillColor: Colors.red,
      );
      return;
    }

    setState(() {
      _activeStepIndex += 1;
    });
  }
  void validateSecondStep() {
    if (checkNullorEmpty(tripType)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Trip Type!",
        fillColor: Colors.red,
      );
      return;
    }
    if (!_isMulticity && fromDestinationId==null) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Travel From!",
        fillColor: Colors.red,
      );
      return;
    }
    if (!_isMulticity && toDestinationId==null) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Travel To!",
        fillColor: Colors.red,
      );
      return;
    }
    if (_isMulticity && multiCityFormList.length < 1 ){
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Destination Fields Need to Fill Up and Save!!!",
        fillColor: Colors.red,
      );
      return;
    }
    if (checkNullorEmpty(description)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Description Field is Required!",
        fillColor: Colors.red,
      );
      return;
    }
    setState(() {
      _activeStepIndex += 1;
    });
  }
  void validateThirdStep() {
    if(advanceRequired){
      advancePayment = hotelAccommodationAmount + transportAmount + dailyAllowanceAmount+ airTicketAmount + mealAllowanceAmount;
    } else{advancePayment=0;}
    print('advanceRequired : ' + advanceRequired.toString() + ' || advancePayment : ' + advancePayment.toString());

    // if (advanceRequired && advancePayment < 1) {
    //       showSnackBarMessage(
    //         scaffoldKey: _scaffoldKey,
    //         message: "Please insert Advance Payment Amount!",
    //         fillColor: Colors.red,
    //       );
    //       return;
    //     }

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

    if (checkNullorEmpty(hrGroup)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select CC!",
        fillColor: Colors.red,
      );
      return;
    }
    if (checkNullorEmpty(firstApprover)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select First Approver (Business Head)",
        fillColor: Colors.red,
      );
      return;
    }
    if (!_isWorkPlaceVisible && checkNullorEmpty(secondApprover)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Second Approver (CEO)",
        fillColor: Colors.red,
      );
      return;
    }
    if (checkNullorEmpty(finalApprover)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Final Approver (Finance BP)",
        fillColor: Colors.red,
      );
      return;
    }
    try{

      setState(() {
        _isLoading = true;
      });

      //Generate all fields and submit the form
      generateFormAndSubmit();

    }
    catch(e){
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Failed to Apply for Travel Plan!",
        fillColor: Colors.red,
      );
      setState(() {
        _isLoading = false;
      });
    };
  }

  void validateMultiCityForm() {

    if (multiCityForm.FromId==null) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Travel From!",
        fillColor: Colors.red,
      );
      return;
    }
    if (multiCityForm.ToId==null) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select Tarvel To!",
        fillColor: Colors.red,
      );
      return;
    }
    if (multiCityForm.FromDate==null) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select From Date!",
        fillColor: Colors.red,
      );
      return;
    }
    if (multiCityForm.ToDate==null) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Please select To Date!",
        fillColor: Colors.red,
      );
      return;
    }

    if (mcEndDate.isBefore(mcStartDate)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Invalid Date selection! Start Date can't be greater then End Date",
        fillColor: Colors.red,
      );
      return;
    }
    if (mcStartDate.isBefore(dateToday) || mcEndDate.isBefore(dateToday)) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Back Dated request is not allowed!",
        fillColor: Colors.red,
      );
      return;
    }

    setState(() {
      int id =_multiFormCounter;
      multiCityForm.Id=id;
      var item = multiCityFormList.firstWhere((e) => e.Id == id, orElse: () => null);
      if (item == null) {
        multiCityFormList.add(multiCityForm);
        _multiFormCounter++;
        print('multiCityForm : '+ multiCityForm.FromName + 'multiCityTo : '+ multiCityForm.ToName);
        print('multiCityFormList length : ' + multiCityFormList.length.toString());
        multiCityForm = MultiCityForm();
        mcStartDate = null;
        mcEndDate = null;
      }
    });

  }


  bool checkNullorEmpty(String value){
    if(value==null || value.isEmpty) return true;
    else return false;
  }

  void generateFormAndSubmit() async {
    //For MultiCity
    if (_isMulticity && multiCityFormList.length > 0) {
      multiFromDestinationId = multiCityFormList.map((e) => e.FromId).toList();
      multiToDestinationId = multiCityFormList.map((e) => e.ToId).toList();
      multiFromDestinationDate =
          multiCityFormList.map((e) => e.FromDate).toList();
      multiToDestinationDate = multiCityFormList.map((e) => e.ToDate).toList();
    }

    formData = FormData();
    formData = FormData.fromMap({
      "travel_type": typeOfTravel,
      "reference_no": referenceNo,
      "transport_mode": transportMode,
      "work_place": workPlace,
      "purpose": travelPurpose,
      "trip_type": tripType,
      "currency": currency,
      "description": description,
      "start_date": startDate,
      "end_date": endDate,

      "hotel_accommodation": hotelAccommodation == true ? 1: 0,
      "hotel_accommodation_amount" :  hotelAccommodationAmount,
      "hotel_accommodation_by_admin_dept" : hotelAccommodationByAdminDpt == true ? 1: 0,

      "transport": transport == true ? 1: 0,
      "transport_amount" :  transportAmount,
      "transport_by_admin_dept" : transportByAdminDpt == true ? 1: 0,

      "daily_allowance": dailyAllowance == true ? 1: 0,
      "daily_allowance_amount" :  dailyAllowanceAmount,
      "transfer_allowance": transferAllowance == true ? 1: 0,
      "meal_allowance": mealAllowance == true ? 1: 0,
      "meal_allowance_amount" :  mealAllowanceAmount,

      "air_ticket": airTicket == true ? 1: 0,
      "air_ticket_amount" :  airTicketAmount,
      "air_ticket_by_admin_dept" : airTicketByAdminDpt == true ? 1: 0,

      "guest_house_accommodation": guestHouseAccommodation == true ? 1: 0,
      "advance_payment": advancePayment,
      "traveller": travellerIds,
      "hr_group": hrGroup,
      "authority[0]": firstApprover,
      "authority[1]": secondApprover,
      "authority[2]": finalApprover,
      "from": fromDestinationId ?? 0,
      "to": toDestinationId ?? 0,
      "multi_from": multiFromDestinationId,
      "multi_from_date": multiFromDestinationDate,
      "multi_to": multiToDestinationId,
      "multi_to_date": multiToDestinationDate,

      "payment_method": payment_method,
      "account_name": account_name,
      "account_number": account_number,
      "bank_name": bank_name,
      "bank_account_number": bank_account_number, //int.tryParse(bank_account_number) ,
      "bank_account_name": bank_account_name,
      "routing_no": routing_no,  //int.tryParse(routing_no) ,
      "branch_name": bank_branch_name,
      "cost_center": costCenterIds,

    });
    if (attachmentContent != null) {
      var file = await MultipartFile.fromFile(
          attachmentPath, filename: attachmentName);
      formData.files.add(MapEntry("document", file));
    }
    //return formData;

    print('--------------From Submit----------------' + formData.fields.toString());

    try {
      final response = await _apiService.applyForTravelPlan(formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // showSnackBarMessage(
        //   scaffoldKey: _scaffoldKey,
        //   message: "Successfully Applied for Travel Plan!",
        //   fillColor: Colors.green,
        // );
        // print('Submited');
        setState(() {
          _isCompleted = true;
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
    }
    catch (e) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: "Failed to Apply for Travel Plan!",
        fillColor: Colors.red,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class MultiCityForm
{
  int Id;
  String FromName;
  String ToName;
  int FromId;
  int ToId;
  String FromDate;
  String ToDate;

  MultiCityForm({this.Id,this.FromName, this.ToName,this.FromId,this.ToId,this.FromDate,this.ToDate});

}



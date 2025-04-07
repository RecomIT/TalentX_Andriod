import 'dart:convert';
import 'dart:math' as Math;

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/travel_settlement.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';
import '../widgets/wide_filled_button.dart';

class TravelPlanSettlementPage extends StatefulWidget {
  //final TravelPlan travelPlan;
  final TravelSettlement settlementPlan;

  const TravelPlanSettlementPage({
    Key key,
    //@required this.travelPlan,
    @required this.settlementPlan,
  }) : super(key: key);
  @override
  _TravelPlanSettlementPageState createState() => _TravelPlanSettlementPageState();
}

class _TravelPlanSettlementPageState extends State<TravelPlanSettlementPage> {
  User _currentUser;
  ApiService _apiService;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String msg;
  DateFormat _dateFormat = DateFormat('E ,MMM dd,yyyy hh:mm:ss a'); //('hh:mm:ss, dd-MMM-yyyy');
  int advance_amount=0;
  int air_ticket_amount=0;
  int hotel_accomodation_amount=0;
  int transport_amount=0;
  int daily_allowance_amount=0;
  int meal_allowance_amount=0;
  int transfer_allowance_amount=0;
  int guest_house_accommodation=0;
  String commnets='';
  bool _isLoading = false;

  AttachmentModel air_ticket_amount_file = AttachmentModel();
  AttachmentModel hotel_accomodation_amount_file = AttachmentModel();
  AttachmentModel transport_amount_file = AttachmentModel();
  AttachmentModel daily_allowance_amount_file = AttachmentModel();
  AttachmentModel meal_allowance_amount_file = AttachmentModel();
  AttachmentModel transfer_allowance_amount_file = AttachmentModel();
  AttachmentModel guest_house_accommodation_file = AttachmentModel();

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.settlementPlan == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
            (route) => false,
      );
    }
    _getTravelPlanDetail();
  }

  @override
  Widget build(BuildContext context) {
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
        child: widget.settlementPlan == null
            ? SizedBox()
            : SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            child: Container(
             child: Column(
               children: [
                 Text('TRAVEL PLAN SETTLEMENT',style:TextStyle(
                   fontSize: 12,
                   fontWeight: FontWeight.bold,
                   color:  Colors.black45,
                 ),),
                 SizedBox(height: 10,),

                 //Advance Amount
                 Container(
                   child: Column(
                     children: [
                       NeomorphicTextFormField(
                           key:Key(advance_amount.toString()),
                           initVal: 'Advance Received : ${advance_amount.toString()}',
                           inputType: TextInputType.number,
                           isReadOnly: true,
                           hintText: "Advance Received",
                           onChangeFunction: null),
                       SizedBox(height: 20,),
                     ],
                   ),
                 ),

                 //Air Ticket Container
                 widget.settlementPlan.airTicket == 1 ?
                 Container(
                   child: Column(
                     children: [
                       NeomorphicTextFormField(
                           initVal: null,// air_ticket_amount.toString(),
                           inputType: TextInputType.number,
                           hintText: "Air Ticket Amount",
                           onChangeFunction: (String val) {
                             air_ticket_amount = int.tryParse(val);
                             if(air_ticket_amount !=null){
                               print('air_ticket_amount : ' + air_ticket_amount.toString());
                             }
                           }),
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
                               air_ticket_amount_file.attachmentName ?? "Attachment",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                                 color: air_ticket_amount_file.attachmentName == null
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
                                 air_ticket_amount_file.attachmentName = pickedFile.path.split("/").last;
                                 air_ticket_amount_file.attachmentExtention = pickedFile.path.split("/").last.split(".").last;
                                 air_ticket_amount_file.attachmentContent = fileCotent;
                                 air_ticket_amount_file.attachmentPath = pickedFile.path;
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
                       SizedBox(height: 20,),
                     ],
                   ),
                 ) : Container(),

                 //Hotel Accommodation
                 widget.settlementPlan.hotelAccommodation == 1 ?
                 Container(
                   child: Column(
                     children: [
                       NeomorphicTextFormField(
                           key:Key(hotel_accomodation_amount.toString()),
                           initVal:hotel_accomodation_amount == 0 ? "Hotel Accommodation Amount" : hotel_accomodation_amount.toString(),
                           inputType: TextInputType.number,
                           hintText: "Hotel Accommodation Amount",
                           onChangeFunction: (String val) {
                             hotel_accomodation_amount = int.tryParse(val);
                             if(hotel_accomodation_amount !=null){
                               print('hotel_accomodation_amount : ' + hotel_accomodation_amount.toString());
                             }else{hotel_accomodation_amount=0;}
                           }),
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
                               hotel_accomodation_amount_file.attachmentName ?? "Attachment",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                                 color: hotel_accomodation_amount_file.attachmentName == null
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
                                 hotel_accomodation_amount_file.attachmentName = pickedFile.path.split("/").last;
                                 hotel_accomodation_amount_file.attachmentExtention = pickedFile.path.split("/").last.split(".").last;
                                 hotel_accomodation_amount_file.attachmentContent = fileCotent;
                                 hotel_accomodation_amount_file.attachmentPath = pickedFile.path;
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
                       SizedBox(height: 20,),
                     ],
                   ),
                 ) : Container(),

                 //Transport
                 widget.settlementPlan.transport == 1 ?
                 Container(
                   child: Column(
                     children: [
                       NeomorphicTextFormField(
                           key:Key(transport_amount.toString()),
                           initVal:transport_amount == 0 ? "Transport Amount" : transport_amount.toString(),
                           inputType: TextInputType.number,
                           hintText: "Transport Amount",
                           onChangeFunction: (String val) {
                             transport_amount = int.tryParse(val);
                             if(transport_amount !=null){
                               print('transport_amount : ' + transport_amount.toString());
                             }else{transport_amount=0;}
                           }),
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
                               transport_amount_file.attachmentName ?? "Attachment",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                                 color: transport_amount_file.attachmentName == null
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
                                 transport_amount_file.attachmentName = pickedFile.path.split("/").last;
                                 transport_amount_file.attachmentExtention = pickedFile.path.split("/").last.split(".").last;
                                 transport_amount_file.attachmentContent = fileCotent;
                                 transport_amount_file.attachmentPath = pickedFile.path;
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
                       SizedBox(height: 20,),
                     ],
                   ),
                 ) : Container(),

                 //Daily Allowance
                 widget.settlementPlan.dailyAllowance == 1 ?
                 Container(
                   child: Column(
                     children: [
                       NeomorphicTextFormField(
                           key:Key(daily_allowance_amount.toString()),
                           initVal:daily_allowance_amount == 0 ? "Daily Allowance Amount" : daily_allowance_amount.toString(),
                           inputType: TextInputType.number,
                           hintText: "Daily Allowance Amount",
                           onChangeFunction: (String val) {
                             daily_allowance_amount = int.tryParse(val);
                             if(daily_allowance_amount !=null){
                               print('daily_allowance_amount : ' + daily_allowance_amount.toString());
                             }else{daily_allowance_amount=0;}
                           }),
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
                               daily_allowance_amount_file.attachmentName ?? "Attachment",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                                 color: daily_allowance_amount_file.attachmentName == null
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
                                 daily_allowance_amount_file.attachmentName = pickedFile.path.split("/").last;
                                 daily_allowance_amount_file.attachmentExtention = pickedFile.path.split("/").last.split(".").last;
                                 daily_allowance_amount_file.attachmentContent = fileCotent;
                                 daily_allowance_amount_file.attachmentPath = pickedFile.path;
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
                       SizedBox(height: 20,),
                     ],
                   ),
                 ) : Container(),

                 //Meal Allowance
                 widget.settlementPlan.mealAllowance == 1 ?
                 Container(
                   child: Column(
                     children: [
                       NeomorphicTextFormField(
                           initVal: null,// air_ticket_amount.toString(),
                           inputType: TextInputType.number,
                           hintText: "Meal Allowance Amount",
                           onChangeFunction: (String val) {
                             meal_allowance_amount = int.tryParse(val);
                             if(meal_allowance_amount !=null){
                               print('meal_allowance_amount : ' + meal_allowance_amount.toString());
                             }
                           }),
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
                               meal_allowance_amount_file.attachmentName ?? "Attachment",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                                 color: meal_allowance_amount_file.attachmentName == null
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
                                 meal_allowance_amount_file.attachmentName = pickedFile.path.split("/").last;
                                 meal_allowance_amount_file.attachmentExtention = pickedFile.path.split("/").last.split(".").last;
                                 meal_allowance_amount_file.attachmentContent = fileCotent;
                                 meal_allowance_amount_file.attachmentPath = pickedFile.path;
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
                       SizedBox(height: 20,),
                     ],
                   ),
                 ) : Container(),

                 //Transfer
                 widget.settlementPlan.transferAllowance == 1 ?
                 Container(
                   child: Column(
                     children: [
                       NeomorphicTextFormField(
                           initVal: null,// air_ticket_amount.toString(),
                           inputType: TextInputType.number,
                           hintText: "Transfer Allowance Amount",
                           onChangeFunction: (String val) {
                             transfer_allowance_amount = int.tryParse(val);
                             if(transfer_allowance_amount !=null){
                               print('transfer_allowance_amount : ' + transfer_allowance_amount.toString());
                             }
                           }),
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
                               transfer_allowance_amount_file.attachmentName ?? "Attachment",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                                 color: transfer_allowance_amount_file.attachmentName == null
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
                                 transfer_allowance_amount_file.attachmentName = pickedFile.path.split("/").last;
                                 transfer_allowance_amount_file.attachmentExtention = pickedFile.path.split("/").last.split(".").last;
                                 transfer_allowance_amount_file.attachmentContent = fileCotent;
                                 transfer_allowance_amount_file.attachmentPath = pickedFile.path;
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
                       SizedBox(height: 20,),
                     ],
                   ),
                 ) : Container(),

                 widget.settlementPlan.guestHouseAccommodation == 1 ?
                 Container(
                   child: Column(
                     children: [
                       NeomorphicTextFormField(
                           initVal: null,// air_ticket_amount.toString(),
                           inputType: TextInputType.number,
                           hintText: "Guest House Accommodation Amount",
                           onChangeFunction: (String val) {
                             guest_house_accommodation = int.tryParse(val);
                             if(guest_house_accommodation !=null){
                               print('guest_house_accommodation : ' + guest_house_accommodation.toString());
                             }
                           }),
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
                               guest_house_accommodation_file.attachmentName ?? "Attachment",
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                                 color: guest_house_accommodation_file.attachmentName == null
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
                                 guest_house_accommodation_file.attachmentName = pickedFile.path.split("/").last;
                                 guest_house_accommodation_file.attachmentExtention = pickedFile.path.split("/").last.split(".").last;
                                 guest_house_accommodation_file.attachmentContent = fileCotent;
                                 guest_house_accommodation_file.attachmentPath = pickedFile.path;
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
                       SizedBox(height: 20,),
                     ],
                   ),
                 ) : Container(),

                 NeomorphicTextFormField(
                     initVal: null,// air_ticket_amount.toString(),
                     inputType: TextInputType.text,
                     hintText: "Comments",
                     numOfMaxLines: 2,
                     onChangeFunction: (String val) {
                       commnets = val;
                       if(commnets !=null){
                         print('commnets : ' + commnets.toString());
                       }
                     }),
                 SizedBox(height: 20,),
                 _isLoading ?
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(bottom: 15),
                       child: CircularProgressIndicator(),
                     ),
                   ],
                 ) :  Container(),

                 WideFilledButton(buttonText: 'Submit', onTapFunction: () async {
                   if (widget.settlementPlan.airTicket ==1 && (air_ticket_amount < 1 || air_ticket_amount_file.attachmentContent == null)) {
                     showSnackBarMessage(
                       scaffoldKey: _scaffoldKey,
                       message: "Air ticket amount and attachment are required!",
                       fillColor: Colors.red,
                     );
                     return;
                   }

                   if (widget.settlementPlan.hotelAccommodation ==1 && (hotel_accomodation_amount < 1 || hotel_accomodation_amount_file.attachmentContent == null)) {
                     showSnackBarMessage(
                       scaffoldKey: _scaffoldKey,
                       message: "Hotel Accommodation amount and attachment are required!",
                       fillColor: Colors.red,
                     );
                     return;
                   }

                   if (widget.settlementPlan.transport ==1 && (transport_amount < 1 || transport_amount_file.attachmentContent == null)) {
                     showSnackBarMessage(
                       scaffoldKey: _scaffoldKey,
                       message: "Transport amount and attachment are required!",
                       fillColor: Colors.red,
                     );
                     return;
                   }

                   if (widget.settlementPlan.dailyAllowance ==1 && (daily_allowance_amount < 1 || daily_allowance_amount_file.attachmentContent == null)) {
                     showSnackBarMessage(
                       scaffoldKey: _scaffoldKey,
                       message: "Daily Allowance amount and attachment are required!",
                       fillColor: Colors.red,
                     );
                     return;
                   }

                   if (widget.settlementPlan.mealAllowance ==1 && (meal_allowance_amount < 1 || meal_allowance_amount_file.attachmentContent == null)) {
                     showSnackBarMessage(
                       scaffoldKey: _scaffoldKey,
                       message: "Meal Allowance amount and attachment are required!",
                       fillColor: Colors.red,
                     );
                     return;
                   }

                   if (widget.settlementPlan.transferAllowance ==1 && (transfer_allowance_amount < 1 || transfer_allowance_amount_file.attachmentContent == null)) {
                     showSnackBarMessage(
                       scaffoldKey: _scaffoldKey,
                       message: "Transfer Allowance amount and attachment are required!",
                       fillColor: Colors.red,
                     );
                     return;
                   }

                   if (widget.settlementPlan.guestHouseAccommodation ==1 && (guest_house_accommodation < 1 || guest_house_accommodation_file.attachmentContent == null)) {
                     showSnackBarMessage(
                       scaffoldKey: _scaffoldKey,
                       message: "Guest House Accommodation amount and attachment are required!",
                       fillColor: Colors.red,
                     );
                     return;
                   }

                   _isLoading= true;
                   var formData = FormData.fromMap({
                      "travel_plan_id" :widget.settlementPlan.id,
                      "air_ticket_amount": air_ticket_amount,  //widget.settlementPlan.transferAllowance ==1 air_ticket_amount ? : null
                      "hotel_accomodation_amount":hotel_accomodation_amount,
                      "transport_amount": transport_amount,
                      "daily_allowance_amount":daily_allowance_amount,
                      "meal_allowance_amount": meal_allowance_amount,
                      "transfer_allowance_amount": transfer_allowance_amount,
                      "guest_house_accommodation" : guest_house_accommodation,
                      "comments" : commnets
                   });

                   if (air_ticket_amount_file.attachmentContent != null) {
                     var file = await MultipartFile.fromFile(
                         air_ticket_amount_file.attachmentPath, filename: air_ticket_amount_file.attachmentName);
                     formData.files.add(MapEntry("air_ticket_attachment", file));
                   }
                   if (hotel_accomodation_amount_file.attachmentContent != null) {
                     var file = await MultipartFile.fromFile(
                         hotel_accomodation_amount_file.attachmentPath, filename: hotel_accomodation_amount_file.attachmentName);
                     formData.files.add(MapEntry("hotel_accomodation_attachment", file));
                   }
                   if (transport_amount_file.attachmentContent != null) {
                     var file = await MultipartFile.fromFile(
                         transport_amount_file.attachmentPath, filename: transport_amount_file.attachmentName);
                     formData.files.add(MapEntry("transport_attachment", file));
                   }
                   if (daily_allowance_amount_file.attachmentContent != null) {
                     var file = await MultipartFile.fromFile(
                         daily_allowance_amount_file.attachmentPath, filename: daily_allowance_amount_file.attachmentName);
                     formData.files.add(MapEntry("daily_allowance_attachment", file));
                   }
                   if (meal_allowance_amount_file.attachmentContent != null) {
                     var file = await MultipartFile.fromFile(
                         meal_allowance_amount_file.attachmentPath, filename: meal_allowance_amount_file.attachmentName);
                     formData.files.add(MapEntry("meal_allowance_attachment", file));
                   }
                   if (transfer_allowance_amount_file.attachmentContent != null) {
                     var file = await MultipartFile.fromFile(
                         transfer_allowance_amount_file.attachmentPath, filename: transfer_allowance_amount_file.attachmentName);
                     formData.files.add(MapEntry("transfer_allowance_attachment", file));
                   }

                   if (guest_house_accommodation_file.attachmentContent != null) {
                     var file = await MultipartFile.fromFile(
                         guest_house_accommodation_file.attachmentPath, filename: guest_house_accommodation_file.attachmentName);
                     formData.files.add(MapEntry("guest_house_accommodation_attachment", file));
                   }

                   print('--------------From Submit----------------' + formData.fields.toString());
                   // return;
                   try {
                     final response = await _apiService.applyForTravelPlanSettlement(formData);
                     if (response.statusCode == 200 || response.statusCode == 201) {
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
                   }
                   catch (e) {
                     showSnackBarMessage(
                       scaffoldKey: _scaffoldKey,
                       message: "Failed to Apply for Travel Plan Settlement!",
                       fillColor: Colors.red,
                     );
                     setState(() {
                       _isLoading = false;
                     });
                   }
                 })
               ],
             ),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: kPrimaryColor,
      //   child: Icon(Icons.arrow_back),
      //   onPressed: (){
      //     Navigator.of(context).pop();
      //   },
      // ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
      ),
    );
  }

  void _getTravelPlanDetail() async {
    var response = await _apiService.getTravelPlanDetail(widget.settlementPlan.id.toString());
    setState(() {
      advance_amount=response.advancePayment??0;
      hotel_accomodation_amount=response.hotelAccommodationAmount??0;
      print(response.hotelAccommodationAmount.toString());
      transport_amount=response.transportAmount??0;
      daily_allowance_amount=response.dailyAllowanceAmount??0;

    });
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Successfully"),
        content: Text("Successfully Applied for Travel Plan Settlement!!!"),
        actions: [
          FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(TRAVEL_PLAN_PAGE,arguments: TravelPlanPageScreen.TravelPlans);
            },
          ),
        ],
      );
    },
  );
}

class AttachmentModel{
  String attachmentName;
  String attachmentPath;
  String attachmentContent; // (optional,Size:Max 1MB,Format: pdf,jpeg,jpg,docx,png),
  String attachmentExtention;
  AttachmentModel({this.attachmentName,this.attachmentPath,this.attachmentContent,this.attachmentExtention});
}
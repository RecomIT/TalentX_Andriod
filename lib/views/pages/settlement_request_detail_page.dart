import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/my_settlement_list.dart';
import 'package:recom_app/data/models/settlement_request_data.dart';
import 'package:recom_app/data/models/settlement_request_detail.dart';
import 'package:recom_app/data/models/travel_plan_detail.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';
import '../widgets/wide_filled_button.dart';

class SettlementRequestDetailPage extends StatefulWidget {
  final MySettlement settlementRequest;  //My
  final SettlementRequest settlementReq; // Approval

  const SettlementRequestDetailPage({
    Key key,
    //@required this.settlementRequest,
    this.settlementRequest,
    this.settlementReq,
  }) : super(key: key);
  @override
  _SettlementRequestDetailPageState createState() => _SettlementRequestDetailPageState();
}

class _SettlementRequestDetailPageState extends State<SettlementRequestDetailPage> {
  User _currentUser;
  ApiService _apiService;
  bool _isLoading = false;
  //TravelPlanDetail _travelPlanDetail;
  Future<TravelPlanDetail> _travelPlanDetail;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String msg;
  DateFormat _dateFormat= DateFormat('E ,MMM dd,yyyy hh:mm:ss a');//('hh:mm:ss, dd-MMM-yyyy');
  //String prefix= "http://staging.hrmisbd.com/storage/";
  String prefix= "https://talentx.shopf.co/storage/";

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.settlementRequest == null && widget.settlementReq == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
            (route) => false,
      );
    }
    //_getTravelPlanDetail();
    //_travelPlanDetail = _apiService.getTravelPlanDetail(widget.travelPlan.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
        child: (widget.settlementRequest == null && widget.settlementReq == null)
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
            child: FutureBuilder<SettlementRequestDetail>(
                future: widget.settlementRequest != null ?
                _apiService.getSettlementRequestDetail(widget.settlementRequest.travelSettlementId.toString())
                :_apiService.getSettlementRequestDetail(widget.settlementReq.travelSettlementId.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    //print(snapshot.hasData.toString());
                    var tpDetails = snapshot.data;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'TRAVEL PLAN : ${tpDetails.referenceNo}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          'INITIATED BY : ${tpDetails.fullName.toUpperCase()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'DIVISION : ${tpDetails.department.toUpperCase()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'COST CENTER : ${tpDetails.costCenter.toUpperCase()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 20,),

                        Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'TRAVEL TYPE : ${tpDetails.travelType.toUpperCase()??''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),//Flexible
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'PURPOSE : ${tpDetails.purpose.toUpperCase()??''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 5,),

                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'TRAVEL MODE : ${tpDetails.transportMode.toUpperCase()??''}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 5,),
                        tpDetails.workPlace.toLowerCase().contains('domestic')?
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'WORK PLACE : ${tpDetails.workPlace.toUpperCase()??''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ): Container(),
                        SizedBox(height: 5,),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'STATUS : ${tpDetails.travelPlanStatus.toUpperCase()??''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),

                        Row(
                          children: [
                            Text(
                              'TRAVEL PERIOD',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                ' \u2022 START DATE : ${tpDetails.travelStartDate.toUpperCase()}  \n \u2022 END DATE : ${tpDetails.travelEndDate.toUpperCase()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),

                        Row(
                          children: [
                            Text(
                              'ADDITIONAL TRAVELLER',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: tpDetails.traveller == null ?  0 : tpDetails.traveller.length,
                              itemBuilder: (context,index)
                              {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text('\u2022 ${tpDetails.traveller[index].firstName} ${tpDetails.traveller[index].middleName} ${tpDetails.traveller[index].lastName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(height: 20,),

                        Row(
                          children: [
                            Text('TRAVEL DESTINATION : ${widget.settlementRequest != null ? widget.settlementRequest.tripType.toUpperCase()
                                : widget.settlementReq.tripType.toUpperCase()}',
                              //Text('TRAVEL DESTINATION : ${widget.settlementRequest.tripType.toUpperCase()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),

                        tpDetails.travelDestinations.length > 0 ?
                        ListView.builder(
                          itemCount: tpDetails.travelDestinations.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text('${index+1}. FROM : ${tpDetails.travelDestinations[index].travelStart} \n    TO : ${tpDetails.travelDestinations[index].travelEnd}\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  // Flexible(
                                  //   child: Text('\u2022 TO : ${tpDetails.travelDestinations[index].travelEnd}\n',
                                  //     style: TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 12,
                                  //       color: Colors.black54,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              );
                          },
                        ) : Container(),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text('DESCRIPTION',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Flexible(
                              child: Text('  \u2022 ${tpDetails.description.toUpperCase()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'CURRENCY : ${tpDetails.currency.toUpperCase()??''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('HOTEL ACCOMMODATION : ${tpDetails.hotelAccommodation}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('MEAL ALLOWANCE : ${tpDetails.mealAllowance}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('GUEST HOUSE ACCOMODATION : ${tpDetails.guestHouseAccommodation}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('TRANSPORT : ${tpDetails.transport}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('DAILY ALLOWANCE : ${tpDetails.dailyAllowance}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('TRANSFER ALLOWANCE : ${tpDetails.transferAllowance}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('AIR TICKET : ${tpDetails.airTicket}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('ADVANCE PAYMENT : ${tpDetails.advancePayment??0}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),

                        Row(
                          children: [
                            Text(
                              'APPROVAL AUTHORITY',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                              tpDetails.travelPlanAuthorities.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    width: double.infinity,
                                    height: 160,
                                    padding: EdgeInsets.only(left: 10),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text('NAME : ${tpDetails.travelPlanAuthorities[index].authorityName}'
                                              ,style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              )),
                                        ),
                                        SizedBox(height: 5,),
                                        Text('LAYER :  ${tpDetails.travelPlanAuthorities[index].authorityOrder}'
                                            ,style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black54,
                                            )),
                                        SizedBox(height: 5,),
                                        Text('STATUS :  ${tpDetails.travelPlanAuthorities[index].authorityStatus.toUpperCase()}'
                                            ,style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black54,
                                            )),
                                        SizedBox(height: 5,),
                                        Flexible(
                                          child: Text('PROCESSED BY :  ${tpDetails.travelPlanAuthorities[index].processedEmployee}'
                                              ,style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              )),
                                        ),
                                        SizedBox(height: 5,),
                                        Text('ARRIVAL TIME :  ${_dateFormat.format(DateTime.tryParse(tpDetails.travelPlanAuthorities[index].createdAt)) }'
                                            ,style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black54,
                                            )),
                                        SizedBox(height: 5,),
                                        Flexible(
                                          child: Text('REMARKS :  ${tpDetails.travelPlanAuthorities[index].remarks}',style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.black54,
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),

                        SizedBox(height: 20,),

                        Row(
                          children: [
                            Text(
                              'SETTLEMENT APPROVAL AUTHORITY',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                              tpDetails.travelSettlementAuthority.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    width: double.infinity,
                                    height: 100,
                                    padding: EdgeInsets.only(left: 10),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text('NAME : ${tpDetails.travelSettlementAuthority[index].authorityName}'
                                              ,style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              )),
                                        ),

                                        SizedBox(height: 5,),
                                        Text('STATUS :  ${tpDetails.travelSettlementAuthority[index].status.toUpperCase()}'
                                            ,style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.black54,
                                            )),
                                        SizedBox(height: 5,),
                                        // Flexible(
                                        //   child: Text('PROCESSED BY :  ${tpDetails.travelPlanAuthorities[index].processedEmployee}'
                                        //       ,style: TextStyle(
                                        //         fontWeight: FontWeight.bold,
                                        //         fontSize: 12,
                                        //         color: Colors.black54,
                                        //       )),
                                        // ),
                                        // SizedBox(height: 5,),
                                        Flexible(
                                          child: Text('REMARKS :  ${tpDetails.travelPlanAuthorities[index].remarks}',style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.black54,
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text(
                              'TRAVEL SETTLEMENT DETAIL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text('HOTEL ACCOMMODATION AMOUNT: ${tpDetails.travelSettlement.hotelAccomodationAmount}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.download),
                              onPressed: tpDetails.travelSettlement.hotelAccomodationAttachment != null ? () async {
                                            var url = prefix + tpDetails.travelSettlement.hotelAccomodationAttachment;
                                            print(url);
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              showSnackBarMessage(
                                                scaffoldKey: _scaffoldKey,
                                                message: "No Attachment Available!",
                                                fillColor: Colors.red,
                                              );
                                            }
                                          }
                                        : null,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('MEAL ALLOWANCE : ${tpDetails.travelSettlement.mealAllowanceAmount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.download),
                                onPressed: tpDetails.travelSettlement.mealAllowanceAttachment != null ? ()async {
                                  var url = prefix + tpDetails.travelSettlement.mealAllowanceAttachment;
                                  print(url);
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: "No Attachment Available!",
                                      fillColor: Colors.red,
                                    );
                                  }
                                } : null
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text('GUEST HOUSE ACCOMODATION AMOUNT : ${tpDetails.travelSettlement.guestHouseAccommodationAmount}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.download),
                                onPressed: tpDetails.travelSettlement.guestHouseAccommodationAttachment != null ? ()async {
                                  var url = prefix +  tpDetails.travelSettlement.guestHouseAccommodationAttachment;
                                  print(url);
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: "No Attachment Available!",
                                      fillColor: Colors.red,
                                    );
                                  }
                                } : null
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TRANSPORT AMOUNT : ${tpDetails.travelSettlement.transportAmount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.download),
                                onPressed: tpDetails.travelSettlement.transportAttachment != null ? ()async {
                                  var url = prefix +  tpDetails.travelSettlement.transportAttachment;
                                  print(url);
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: "No Attachment Available!",
                                      fillColor: Colors.red,
                                    );
                                  }
                                }: null
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('DAILY ALLOWANCE AMOUNT : ${tpDetails.travelSettlement.dailyAllowanceAmount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.download),
                                onPressed: tpDetails.travelSettlement.dailyAllowanceAttachment != null ? ()async {
                                  var url = prefix +  tpDetails.travelSettlement.dailyAllowanceAttachment;
                                  print(url);
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: "No Attachment Available!",
                                      fillColor: Colors.red,
                                    );
                                  }
                                } : null
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TRANSFER ALLOWANCE AMOUNT : ${tpDetails.travelSettlement.transferAllowanceAmount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.download),
                                onPressed: tpDetails.travelSettlement.transferAllowanceAttachment != null ? ()async {
                                  var url = prefix +  tpDetails.travelSettlement.transferAllowanceAttachment;
                                  print(url);
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: "No Attachment Available!",
                                      fillColor: Colors.red,
                                    );
                                  }
                                } : null
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('AIR TICKET AMOUNT : ${tpDetails.travelSettlement.airTicketAmount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.download),
                                onPressed: tpDetails.travelSettlement.airTicketAttachment != null ? ()async {
                                  var url = prefix +  tpDetails.travelSettlement.airTicketAttachment;
                                  print(url);
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: "No Attachment Available!",
                                      fillColor: Colors.red,
                                    );
                                  }
                                } : null
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _isLoading ? CircularProgressIndicator() : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        tpDetails.travelSettlement.status.toLowerCase().contains('pending') &&
                            _currentUser.employee_id != tpDetails.travelSettlement.employeeId.toString() ?
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  final response = await _apiService.approveSettlementRequest(widget.settlementReq.travelSettlementId.toString());
                                  if (response.statusCode == 200) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    // showSnackBarMessage(
                                    //   scaffoldKey: _scaffoldKey,
                                    //   message: "Approved Settlement Request!",
                                    //   fillColor: Colors.green,
                                    // );
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Successfully"),
                                          content: Text("Successfully Approved Settlement Request!"),
                                          actions: [
                                            FlatButton(
                                              child: new Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pushNamed(TRAVEL_PLAN_PAGE,arguments: TravelPlanPageScreen.SettlementApprovalList);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: response.data["message"],
                                      fillColor: Colors.red,
                                    );
                                  }
                                } catch (ex) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Failed to approve Settlement request!",
                                    fillColor: Colors.red,
                                  );
                                }
                              },
                              child: Text('Approve'),
                            ),
                            SizedBox(width: 10,),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  primary: kPrimaryColor
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  final response = await _apiService.revertSettlementRequest(widget.settlementReq.travelSettlementId.toString());
                                  if (response.statusCode == 200) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Successfully"),
                                          content: Text("Successfully Reverted Settlement Request!"),
                                          actions: [
                                            FlatButton(
                                              child: new Text("OK"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pushNamed(TRAVEL_PLAN_PAGE,arguments: TravelPlanPageScreen.SettlementApprovalList);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    // showSnackBarMessage(
                                    //   scaffoldKey: _scaffoldKey,
                                    //   message: "Reverted Settlement Request!",
                                    //   fillColor: Colors.green,
                                    // );

                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: response.data["message"],
                                      fillColor: Colors.red,
                                    );
                                  }
                                } catch (ex) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Failed to revert Settlement request!",
                                    fillColor: Colors.red,
                                  );
                                }
                              },
                              child: Text('Revert'),
                            ),
                            // SizedBox(width: 10,),
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     primary: Colors.red[400],),
                            //   onPressed: () async {
                            //     setState(() {
                            //       _isLoading = true;
                            //     });
                            //     try {
                            //       final response = await _apiService.rejectTravelPlan(widget.settlementRequest.travelSettlementId.toString());
                            //       if (response.statusCode == 200) {
                            //         setState(() {
                            //           _isLoading = false;
                            //         });
                            //         showSnackBarMessage(
                            //           scaffoldKey: _scaffoldKey,
                            //           message: "Rejected Travel Request!",
                            //           fillColor: Colors.green,
                            //         );
                            //
                            //       } else {
                            //         setState(() {
                            //           _isLoading = false;
                            //         });
                            //         showSnackBarMessage(
                            //           scaffoldKey: _scaffoldKey,
                            //           message: response.data["message"],
                            //           fillColor: Colors.red,
                            //         );
                            //       }
                            //     } catch (ex) {
                            //       setState(() {
                            //         _isLoading = false;
                            //       });
                            //       showSnackBarMessage(
                            //         scaffoldKey: _scaffoldKey,
                            //         message: "Failed to reject travel request!",
                            //         fillColor: Colors.red,
                            //       );
                            //     }
                            //   },
                            //   child: Text('Reject'),
                            // ),
                          ],
                        ):
                        Container(),
                      ],
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  else {
                    return Center(child: Container(child: CircularProgressIndicator(),));
                  }
                }
            ),
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


// void _getTravelPlanDetail() async{
//   var response = await _apiService.getTravelPlanDetail(widget.travelPlan.id.toString());
//   setState(() {
//     _travelPlanDetail=  response;
//     // print('referenceNo : '+ referenceNo);
//   });
// }
}

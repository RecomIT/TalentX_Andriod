import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/travel_plan.dart';
import 'package:recom_app/data/models/travel_plan_detail.dart';
import 'package:recom_app/data/models/travel_settlement.dart';
import 'package:recom_app/services/helper/string_extension.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';

import '../../data/models/search_colleague_data.dart';
import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';
import '../widgets/wide_filled_button.dart';

class TravelPlanDetailPage extends StatefulWidget {
  final TravelPlan travelPlan;

  const TravelPlanDetailPage({
    Key key,
    @required this.travelPlan,
  }) : super(key: key);
  @override
  _TravelPlanDetailPageState createState() => _TravelPlanDetailPageState();
}

class _TravelPlanDetailPageState extends State<TravelPlanDetailPage> {
  User _currentUser;
  ApiService _apiService;
  bool _isLoading = false;
  //TravelPlanDetail _travelPlanDetail;
  Future<TravelPlanDetail> _travelPlanDetail;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String msg;
  DateFormat _dateFormat= DateFormat('E ,MMM dd,yyyy hh:mm:ss a');//('hh:mm:ss, dd-MMM-yyyy');

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.travelPlan == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
            (route) => false,
      );
    }
    _travelPlanDetail = _apiService.getTravelPlanDetail(widget.travelPlan.id.toString());
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
        child: widget.travelPlan == null
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
                  child: FutureBuilder<TravelPlanDetail>(
                    future: _travelPlanDetail, //_apiService.getTravelPlanDetail(widget.travelPlan.id.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        //print(snapshot.hasData.toString());
                        var tpDetails = snapshot.data;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'TP Reference : ${tpDetails.referenceNo}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              'Initiated By : ${tpDetails.fullName}', // INITIATED BY
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              'Department : ${tpDetails.department}', //DEPARTMENT
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              'Cost Center : ${tpDetails.costCenter}', //COST CENTER
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
                                  'Travel Type : ${tpDetails.travelType.capitalize()??''}', //TRAVEL TYPE
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
                                    'Purpose : ${tpDetails.purpose.capitalize()??''}', //PURPOSE
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
                                    'Travel Mode: ${tpDetails.transportMode.capitalize()??''}', //TRAVEL MODE
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
                            tpDetails.travelType.toLowerCase().contains('domestic') ?
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Work Place : ${tpDetails.workPlace.capitalize()??''}', //WORK PLACE
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
                                  'Status : ${tpDetails.travelPlanStatus.capitalize()??''}', //STATUS
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
                                  'Travel Period', style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ), //TRAVEL PERIOD
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    ' \u2022 Start Date : ${tpDetails.travelStartDate.capitalize()}  \n \u2022 End Date : ${tpDetails.travelEndDate.capitalize()}',
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
                                  'Additional Traveller', //ADDITIONAL TRAVELLER
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
                                Text('Travel Destination : ${widget.travelPlan.tripType.capitalize()}', //TRAVEL DESTINATION
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
                                      child: Text('${index+1}. From : ${tpDetails.travelDestinations[index].travelStart} \n    To : ${tpDetails.travelDestinations[index].travelEnd}\n',
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
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text('Description', //DESCRIPTION
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
                                  child: Text('  \u2022 ${tpDetails.description.capitalize()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text('Cost Center(s)',
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
                                  child: Text('  \u2022 ${tpDetails.applicableCostCenter.capitalize()}',
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
                                  'Currency : ${tpDetails.currency.toUpperCase()??''}', //CURRENCY
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
                                Text('Hotel Accommodation : ${tpDetails.hotelAccommodation}',//HOTEL ACCOMMODATION
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
                                Text('Hotel Accommodation Amount : ${tpDetails.hotelAccommodationAmount}', //HOTEL ACCOMMODATION AMOUNT
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
                                Text('Meal Allowance : ${tpDetails.mealAllowance}', //MEAL ALLOWANCE
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
                                Text('Meal Allowance Amount : ${tpDetails.mealAllowanceAmount}', //HOTEL ACCOMMODATION AMOUNT
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
                                Text('Guest House Accommodation: ${tpDetails.guestHouseAccommodation}', //GUEST HOUSE ACCOMODATION
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
                                Text('Transport : ${tpDetails.transport}', //TRANSPORT
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
                                Text('Transport Amount : ${tpDetails.transportAmount}',//TRANSPORT AMOUNT
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
                                Text('Daily Allowance : ${tpDetails.dailyAllowance}', //DAILY ALLOWANCE
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
                                Text('Daily Allowance Amount : ${tpDetails.dailyAllowanceAmount}', //DAILY ALLOWANCE AMOUNT
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
                                Text('Transfer Allowance : ${tpDetails.transferAllowance}', //TRANSFER ALLOWANCE
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
                                Text('Air Ticket : ${tpDetails.airTicket}', //AIR TICKET
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
                                Text('Air Ticket Amount : ${tpDetails.airTicketAmount}',//TRANSPORT AMOUNT
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
                                Text('Total Advance Payment : ${tpDetails.advancePayment??0}', //ADVANCE PAYMENT
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),

                            Row(children: [Text(
                                  'Approval Authority', //APPROVAL AUTHORITY
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),],),
                            SizedBox(height: 5,),
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
                                                child: Text('Name : ${tpDetails.travelPlanAuthorities[index].authorityName}'
                                                    ,style: TextStyle(
                                                  fontWeight: FontWeight.bold, 
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                )),
                                              ),
                                              SizedBox(height: 5,),
                                              Text('Layer :  ${tpDetails.travelPlanAuthorities[index].authorityOrder}'
                                                  ,style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              )),
                                              SizedBox(height: 5,),
                                              Text('Status :  ${tpDetails.travelPlanAuthorities[index].authorityStatus.capitalize()}'
                                                  ,style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              )),
                                              SizedBox(height: 5,),
                                              Flexible(
                                                child: Text('Processed By :  ${tpDetails.travelPlanAuthorities[index].processedEmployee}'
                                                    ,style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                )),
                                              ),
                                              SizedBox(height: 5,),
                                              !tpDetails.travelPlanAuthorities[index].createdAt.toLowerCase().contains('n/a') ?
                                              Text('Arrival Time :  ${_dateFormat.format(DateTime.tryParse(tpDetails.travelPlanAuthorities[index].createdAt))}',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                              ))
                                                  :
                                              Text('Arrival Time :  ${tpDetails.travelPlanAuthorities[index].createdAt}'
                                              ,style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              )),
                                              SizedBox(height: 5,),
                                              Flexible(
                                                child: Text('Remarks :  ${tpDetails.travelPlanAuthorities[index].remarks}',style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );}),),

                            SizedBox(height: 10,),
                            Row(children: [Text(
                              'Payment Method : ${tpDetails.paymentMethod}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),],),

                            Visibility(
                              visible: tpDetails.paymentMethod.toLowerCase() == 'nagad',
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Row(children: [Text(
                                    'Account Name : ${tpDetails.accountName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),],),
                                  SizedBox(height: 5,),
                                  Row(children: [Text(
                                    'Mobile No : ${tpDetails.accountNumber}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),],),
                                ],
                              ),
                            ),

                            Visibility(
                              visible: tpDetails.paymentMethod.toLowerCase() == 'bank',
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Row(children: [Text(
                                    'Bank Name : ${tpDetails.bankName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),],),
                                  SizedBox(height: 10,),
                                  Row(children: [Text(
                                    'Bank Account Name : ${tpDetails.bankAccountName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),],),
                                  SizedBox(height: 10,),
                                  Row(children: [Text(
                                    'Bank Account Number : ${tpDetails.bankAccountNumber}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),],),
                                  SizedBox(height: 10,),
                                  Row(children: [Text(
                                    'Branch Name : ${tpDetails.branchName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),],),
                                  SizedBox(height: 10,),
                                  Row(children: [Text(
                                    'Routing No : ${tpDetails.routingNo}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),],),
                                ],
                              ),
                            ),

                            SizedBox(height: 10,),



                              SizedBox(height: 20,),
                              _isLoading ? CircularProgressIndicator() : Container(),
                              SizedBox(
                              height: 10,
                            ),

                              tpDetails.inProgressAuthority ?
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
                                        final response = await _apiService.approveTravelPlan(widget.travelPlan.id.toString());
                                        if (response.statusCode == 200) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          // showSnackBarMessage(
                                          //   scaffoldKey: _scaffoldKey,
                                          //   message: "Approved Travel Request!",
                                          //   fillColor: Colors.green,
                                          // );
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Successfully"),
                                                content: Text("Successfully Approved Travel Request!!!!"),
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
                                          message: "Failed to approve travel request!",
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
                                        final response = await _apiService.revertTravelPlan(widget.travelPlan.id.toString());
                                        if (response.statusCode == 200) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          // showSnackBarMessage(
                                          //   scaffoldKey: _scaffoldKey,
                                          //   message: "Reverted Travel Request!",
                                          //   fillColor: Colors.green,
                                          // );
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Successfully"),
                                                content: Text("Successfully Reverted Travel Request!!!!"),
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
                                          message: "Failed to revert travel request!",
                                          fillColor: Colors.red,
                                        );
                                      }
                                    },
                                    child: Text('Revert'),
                                  ),
                                  SizedBox(width: 10,),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red[400],),
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      try {
                                        final response = await _apiService.rejectTravelPlan(widget.travelPlan.id.toString());
                                        if (response.statusCode == 200) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          // showSnackBarMessage(
                                          //   scaffoldKey: _scaffoldKey,
                                          //   message: "Rejected Travel Request!",
                                          //   fillColor: Colors.green,
                                          // );
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Successfully"),
                                                content: Text("Successfully Rejected Travel Request!!!!"),
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
                                          message: "Failed to reject travel request!",
                                          fillColor: Colors.red,
                                        );
                                      }
                                    },
                                    child: Text('Reject'),
                                  ),
                                ],
                              ) : Container(),

                            if (tpDetails.travelPlanStatus.toLowerCase().contains('approved') && tpDetails.employeeId == _currentUser.employee_id)
                                InkWell(
                              onTap: () async {
                                try {
                                  // var data = TravelSettlement(id: 1,airTicket: 0,hotelAccommodation: 1,transport: 0,dailyAllowance: 1, mealAllowance: 0,transferAllowance: 1);
                                  // Navigator.of(context).pushNamed(
                                  //   TRAVEL_PLAN_SETTLEMENT_PAGE,
                                  //   arguments: data,
                                  // );
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  final response = await _apiService.getTravelPlanSettlement(tpDetails.id.toString());
                                  if (response != null) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pushNamed(
                                      TRAVEL_PLAN_SETTLEMENT_PAGE,
                                      arguments: response,
                                    );
                                  }
                                  else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: "Exception : Something went wrong in Travel Settlement Request",
                                      fillColor: Colors.red,
                                    );
                                  }
                                }
                                catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                  });

                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: e.message.toString(),
                                    fillColor: Colors.red,
                                  );
                                }
                              },
                              child: Container(
                                width: 80,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
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
                                      Icons.account_balance_outlined,
                                      color: kPrimaryColor,//Colors.white,
                                      size: 30,
                                    ),
                                    Text(
                                      "Settlement",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: kPrimaryColor,//Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            else Container(),
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
  //   });
  // }
}

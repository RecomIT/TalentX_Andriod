import 'dart:math' as Math;

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/lunch_subscription_details.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/Id_card.dart';
import 'package:recom_app/services/helper/string_extension.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';
import 'package:recom_app/views/widgets/neomorphic_datetime_picker.dart';
import 'package:recom_app/views/widgets/neomorphic_text_form_field.dart';

import '../../data/models/holiday_data.dart';
import '../../services/api/api.dart';
import 'custom_table.dart';

class IfterSubscriptionDashboardScreen extends StatefulWidget {
  final ApiService apiService;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User currentUser;
  const IfterSubscriptionDashboardScreen({
    Key key,
    @required this.apiService,
    this.scaffoldKey,
    this.currentUser}) : super(key: key);

  @override
  State<IfterSubscriptionDashboardScreen> createState() => _IfterSubscriptionDashboardScreenState();
}

class _IfterSubscriptionDashboardScreenState extends State<IfterSubscriptionDashboardScreen> {
  Future<LunchSubscriptionDetailsList> _LunchSubscriptionList;

  DateFormat dateFormatter;
  String currentDateFormat = '';
  bool _isLoading = false;

  @override
  void initState() {
    _LunchSubscriptionList= widget.apiService.getLunchSubscriptionDetails();
    _getCurrentDateFormat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;


    return
      Column(
        children: [
          //SizedBox(height: 20),
          FutureBuilder<LunchSubscriptionDetailsList>(
              future: _LunchSubscriptionList, //_requestId
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  var IfterSubscriptionDetailList = snapshot.data.lunchSubscriptionDetailList.toList();
                  if (IfterSubscriptionDetailList == null || IfterSubscriptionDetailList.length==0) {
                    return Text(
                        'Message : No Subscription Request Detail Available');
                  } else {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 20,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
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
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (kScreenSize.width - 40) * 0.80,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Iftar Subscription Details',
                                            //${myResignationList[idx].applicationDate}
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            itemCount: IfterSubscriptionDetailList.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                width: double.infinity,
                                                height: 130,
                                                padding:
                                                EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          'Month :  ${IfterSubscriptionDetailList[index].month}',
                                                          style:
                                                          TextStyle(
                                                            color: kPrimaryColor,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            12,
                                                          )),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Flexible(
                                                      child: Text(
                                                          'Total Iftar Bill : ${IfterSubscriptionDetailList[index].totalLunchBill}',
                                                          style:
                                                          TextStyle(
                                                            color: Colors
                                                                .black45,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            12,
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        'Total Iftar Taken :  ${IfterSubscriptionDetailList[index].totalLunchTaken}',
                                                        style:
                                                        TextStyle(
                                                          color: Colors
                                                              .black45,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize: 12,
                                                        )),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        'Subscription Date :  ${IfterSubscriptionDetailList[index].subscriptionDate}',
                                                        style:
                                                        TextStyle(
                                                          color: Colors
                                                              .black45,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize:
                                                          12,
                                                        )),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                          'UnSubscription Date :  ${IfterSubscriptionDetailList[index].unSubscriptionDate}',
                                                          style:
                                                          TextStyle(
                                                            color: Colors
                                                                .black45,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            12,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      _isLoading ? Center(
                                          child:
                                          CircularProgressIndicator()) : Container(),
                                      SizedBox(height: 10,),
                                      // IfterSubscriptionDetailList.applicationApproval
                                      //     ? Row(
                                      //   children: [
                                      //     ElevatedButton(
                                      //       style: ElevatedButton
                                      //           .styleFrom(
                                      //           primary:
                                      //           kPrimaryColor),
                                      //       onPressed: () async {
                                      //         await showDialog(
                                      //             barrierDismissible:
                                      //             false,
                                      //             context:
                                      //             context,
                                      //             builder:
                                      //                 (BuildContext
                                      //             context) {
                                      //               return addNotesDialogBox(
                                      //                   context);
                                      //             });
                                      //
                                      //         if (isActionCanceled) {
                                      //           isActionCanceled =
                                      //           false;
                                      //           return;
                                      //         }
                                      //         setState(() {
                                      //           _isLoading = true;
                                      //         });
                                      //         try {
                                      //           final response =
                                      //           await _apiService
                                      //               .approvalIfterSubscriptionRequest(
                                      //               _requestId,
                                      //               note,
                                      //               'Approved');
                                      //           if (response
                                      //               .statusCode ==
                                      //               200) {
                                      //             setState(() {
                                      //               _isLoading =
                                      //               false;
                                      //             });
                                      //             showDialog(
                                      //               context:
                                      //               context,
                                      //               builder:
                                      //                   (BuildContext
                                      //               context) {
                                      //                 return AlertDialog(
                                      //                   title: Text(
                                      //                       "Successfully"),
                                      //                   content: Text(
                                      //                       "Successfully Approved Request!"),
                                      //                   actions: [
                                      //                     FlatButton(
                                      //                       child:
                                      //                       new Text("OK"),
                                      //                       onPressed:
                                      //                           () {
                                      //                         Navigator.of(context).pop();
                                      //                         Navigator.of(context).pushNamed(ID_CARD_PAGE,
                                      //                             arguments: IfterSubscriptionPageScreen.IfterSubscription);
                                      //                       },
                                      //                     ),
                                      //                   ],
                                      //                 );
                                      //               },
                                      //             );
                                      //           } else {
                                      //             setState(() {
                                      //               _isLoading =
                                      //               false;
                                      //             });
                                      //             showSnackBarMessage(
                                      //               scaffoldKey:
                                      //               _scaffoldKey,
                                      //               message: response
                                      //                   .data[
                                      //               "message"],
                                      //               fillColor:
                                      //               Colors
                                      //                   .red,
                                      //             );
                                      //           }
                                      //         } catch (ex) {
                                      //           setState(() {
                                      //             _isLoading =
                                      //             false;
                                      //           });
                                      //           showSnackBarMessage(
                                      //             scaffoldKey:
                                      //             _scaffoldKey,
                                      //             message:
                                      //             "Failed to Approve Request!",
                                      //             fillColor:
                                      //             Colors.red,
                                      //           );
                                      //         }
                                      //       },
                                      //       child:
                                      //       Text('Approve'),
                                      //     ),
                                      //     SizedBox(
                                      //       width: 10,
                                      //     ),
                                      //     OutlinedButton(
                                      //       style: OutlinedButton
                                      //           .styleFrom(
                                      //           primary:
                                      //           kPrimaryColor),
                                      //       onPressed: () async {
                                      //         await showDialog(
                                      //             barrierDismissible:
                                      //             false,
                                      //             context:
                                      //             context,
                                      //             builder:
                                      //                 (BuildContext
                                      //             context) {
                                      //               return addNotesDialogBox(
                                      //                   context);
                                      //             });
                                      //
                                      //         if (isActionCanceled) {
                                      //           isActionCanceled =
                                      //           false;
                                      //           return;
                                      //         }
                                      //         setState(() {
                                      //           _isLoading = true;
                                      //         });
                                      //         try {
                                      //           final response =
                                      //           await _apiService
                                      //               .approvalIfterSubscriptionRequest(
                                      //               _requestId,
                                      //               note,
                                      //               'Reverted');
                                      //           if (response
                                      //               .statusCode ==
                                      //               200) {
                                      //             setState(() {
                                      //               _isLoading =
                                      //               false;
                                      //             });
                                      //             showDialog(
                                      //               context:
                                      //               context,
                                      //               builder:
                                      //                   (BuildContext
                                      //               context) {
                                      //                 return AlertDialog(
                                      //                   title: Text(
                                      //                       "Successfully"),
                                      //                   content: Text(
                                      //                       "Successfully Reverted Request!"),
                                      //                   actions: [
                                      //                     FlatButton(
                                      //                       child:
                                      //                       new Text("OK"),
                                      //                       onPressed:
                                      //                           () {
                                      //                         Navigator.of(context).pop();
                                      //                         Navigator.of(context).pushNamed(ID_CARD_PAGE,
                                      //                             arguments: IfterSubscriptionPageScreen.IfterSubscription);
                                      //                       },
                                      //                     ),
                                      //                   ],
                                      //                 );
                                      //               },
                                      //             );
                                      //           } else {
                                      //             setState(() {
                                      //               _isLoading =
                                      //               false;
                                      //             });
                                      //             showSnackBarMessage(
                                      //               scaffoldKey:
                                      //               _scaffoldKey,
                                      //               message: response
                                      //                   .data[
                                      //               "message"],
                                      //               fillColor:
                                      //               Colors
                                      //                   .red,
                                      //             );
                                      //           }
                                      //         } catch (ex) {
                                      //           setState(() {
                                      //             _isLoading =
                                      //             false;
                                      //           });
                                      //           showSnackBarMessage(
                                      //             scaffoldKey:
                                      //             _scaffoldKey,
                                      //             message:
                                      //             "Failed to Revert Request!",
                                      //             fillColor:
                                      //             Colors.red,
                                      //           );
                                      //         }
                                      //       },
                                      //       child: Text('Revert'),
                                      //     ),
                                      //     SizedBox(
                                      //       width: 10,
                                      //     ),
                                      //     ElevatedButton(
                                      //       style: ElevatedButton
                                      //           .styleFrom(
                                      //           primary:
                                      //           Colors
                                      //               .red),
                                      //       onPressed: () async {
                                      //         await showDialog(
                                      //             barrierDismissible:
                                      //             false,
                                      //             context:
                                      //             context,
                                      //             builder:
                                      //                 (BuildContext
                                      //             context) {
                                      //               return addNotesDialogBox(
                                      //                   context);
                                      //             });
                                      //
                                      //         if (isActionCanceled) {
                                      //           isActionCanceled =
                                      //           false;
                                      //           return;
                                      //         }
                                      //         setState(() {
                                      //           _isLoading = true;
                                      //         });
                                      //         try {
                                      //           final response =
                                      //           await _apiService
                                      //               .approvalIfterSubscriptionRequest(
                                      //               _requestId,
                                      //               note,
                                      //               'Rejected');
                                      //           if (response
                                      //               .statusCode ==
                                      //               200) {
                                      //             setState(() {
                                      //               _isLoading =
                                      //               false;
                                      //             });
                                      //             showDialog(
                                      //               context:
                                      //               context,
                                      //               builder:
                                      //                   (BuildContext
                                      //               context) {
                                      //                 return AlertDialog(
                                      //                   title: Text(
                                      //                       "Successfully"),
                                      //                   content: Text(
                                      //                       "Successfully Rejected Request!"),
                                      //                   actions: [
                                      //                     FlatButton(
                                      //                       child:
                                      //                       new Text("OK"),
                                      //                       onPressed:
                                      //                           () {
                                      //                         Navigator.of(context).pop();
                                      //                         Navigator.of(context).pushNamed(ID_CARD_PAGE,
                                      //                             arguments: IfterSubscriptionPageScreen.IfterSubscription);
                                      //                       },
                                      //                     ),
                                      //                   ],
                                      //                 );
                                      //               },
                                      //             );
                                      //           } else {
                                      //             setState(() {
                                      //               _isLoading =
                                      //               false;
                                      //             });
                                      //             showSnackBarMessage(
                                      //               scaffoldKey:
                                      //               _scaffoldKey,
                                      //               message: response
                                      //                   .data[
                                      //               "message"],
                                      //               fillColor:
                                      //               Colors
                                      //                   .red,
                                      //             );
                                      //           }
                                      //         } catch (ex) {
                                      //           setState(() {
                                      //             _isLoading =
                                      //             false;
                                      //           });
                                      //           showSnackBarMessage(
                                      //             scaffoldKey:
                                      //             _scaffoldKey,
                                      //             message:
                                      //             "Failed to Reject Request!",
                                      //             fillColor:
                                      //             Colors.red,
                                      //           );
                                      //         }
                                      //       },
                                      //       child: Text('Reject'),
                                      //     ),
                                      //   ],
                                      // )
                                      //     : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
        ],
      );
}

  void _getCurrentDateFormat() async{
    var response = await widget.apiService.getCurrentDateFormat();
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

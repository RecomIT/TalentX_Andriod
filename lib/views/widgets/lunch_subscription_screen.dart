import 'dart:math' as Math;

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/lunch_subscription.dart';
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

class LunchSubscriptionScreen extends StatefulWidget {
  final ApiService apiService;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User currentUser;
  const LunchSubscriptionScreen({
    Key key,
    @required this.apiService,
    this.scaffoldKey,
    this.currentUser}) : super(key: key);

  @override
  State<LunchSubscriptionScreen> createState() => _LunchSubscriptionScreenState();
}

class _LunchSubscriptionScreenState extends State<LunchSubscriptionScreen> {
  Future<LunchSubscriptionList> _LunchSubscriptionList;
  String note;
  bool isActionCanceled = false;
  final unsubscribeTypeList = <KeyValuePair>[
    new KeyValuePair(id: 'regular', name: 'Regular'),
    new KeyValuePair(id: 'instant',name: 'Instant')
  ];
  int _radioValue = 0;
  String unsubscribeType;
  DateFormat dateFormatter;
  String currentDateFormat = '';
  String to_date;
  DateTime endDate;
  String unsubscriptionDecision='';
  String availableDate='';

  @override
  void initState() {
    _LunchSubscriptionList= widget.apiService.getMyLunchSubscriptionList();
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
          FutureBuilder<LunchSubscriptionList>(
              future: _LunchSubscriptionList,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  var myLunchSubscriptionList = snapshot.data.lunchSubscriptionList.toList();
                  if(myLunchSubscriptionList == null || myLunchSubscriptionList.length ==0){
                    return Text('Message : No Lunch Subscription Request Available');
                  }else{
                    return Column(
                      children: List.generate(
                        myLunchSubscriptionList?.length,
                            (idx) {
                          return myLunchSubscriptionList?.length > 0
                              ? Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: (kScreenSize.width - 40) * 0.80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Subscription Date : ${myLunchSubscriptionList[idx].subscriptionDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'RFID : ${myLunchSubscriptionList[idx].rfid}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Food : ${myLunchSubscriptionList[idx].food}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'From Date : ${myLunchSubscriptionList[idx].fromDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'To Date : ${myLunchSubscriptionList[idx].toDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Deduction Amount : ${myLunchSubscriptionList[idx].deductionAmount}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        // SizedBox(height: 5,),
                                        // Text(
                                        //   'Lunch Policy : ${myLunchSubscriptionList[idx].lunchPolicy}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        //
                                        // SizedBox(height: 5,),
                                        // Text(
                                        //   'Subsidy Amount : ${myLunchSubscriptionList[idx].subsidyAmount}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'Status : ${myLunchSubscriptionList[idx].status}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 15,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // InkWell(
                                            //   onTap: () {
                                            //     Navigator.of(context).pushNamed(
                                            //       LUNCH_SUBSCRIPTION_PAGE_DETAIL,
                                            //       arguments: myLunchSubscriptionList[idx],
                                            //     );
                                            //   },
                                            //   child: Container(
                                            //     width: 80,
                                            //     padding: EdgeInsets.symmetric(
                                            //       horizontal: 5,
                                            //       vertical: 2,
                                            //     ),
                                            //     decoration: BoxDecoration(
                                            //         borderRadius: BorderRadius.all(
                                            //           Radius.circular(7),
                                            //         ),
                                            //         //color: kPrimaryColor,
                                            //         border: Border.all(color: kPrimaryColor)
                                            //     ),
                                            //     child: Column(
                                            //       children: [
                                            //         Icon(
                                            //           Icons.remove_red_eye,
                                            //           color: kPrimaryColor,//Colors.white,
                                            //         ),
                                            //         Text(
                                            //           "View",
                                            //           style: TextStyle(
                                            //             fontWeight: FontWeight.bold,
                                            //             fontSize: 10,
                                            //             color: kPrimaryColor,//Colors.white,
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                            // SizedBox(width: 8),
                                            !myLunchSubscriptionList[idx].toDate.toLowerCase().contains('n/a') ?
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    await showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return unsubscrbeDialogBox(context);
                                                        });

                                                    if (isActionCanceled) {
                                                      isActionCanceled = false;
                                                      return;
                                                    }
                                                    else{
                                                      try {

                                                        if (unsubscribeType==null) {
                                                          showSnackBarMessage(
                                                            scaffoldKey: widget.scaffoldKey,
                                                            message: "Please select Un-subscription type!",
                                                            fillColor: Colors.red,
                                                          );
                                                          return;
                                                        }
                                                        if (unsubscribeType=='regular' && to_date==null) {
                                                          showSnackBarMessage(
                                                            scaffoldKey: widget.scaffoldKey,
                                                            message: "Please select Un-subscription Date!",
                                                            fillColor: Colors.red,
                                                          );
                                                          return;
                                                        }
                                                        if (note==null) {
                                                          showSnackBarMessage(
                                                            scaffoldKey: widget.scaffoldKey,
                                                            message: "Remarks is required!",
                                                            fillColor: Colors.red,
                                                          );
                                                          return;
                                                        }

                                                        //un_subscription_type
                                                        var formData = FormData.fromMap({
                                                          "un_subscription_type": unsubscribeType.trim(),
                                                          "to_date": to_date,
                                                          "remarks": note,
                                                        });

                                                        print('--------------From Submit----------------' + formData.fields.toString());
                                                        final response = await widget.apiService.applyForUnSubscription(formData);

                                                        if (response.statusCode == 200 ||
                                                            response.statusCode == 201) {

                                                          setState(() {
                                                            _showDialog(context);
                                                          });
                                                        }
                                                        else {
                                                          showSnackBarMessage(
                                                            scaffoldKey: widget.scaffoldKey,
                                                            message: response.data["message"],
                                                            fillColor: Colors.red,
                                                          );
                                                        }
                                                      } catch (ex) {
                                                        setState(() {
                                                          showSnackBarMessage(
                                                            scaffoldKey: widget.scaffoldKey,
                                                            message: "Failed to apply for for Lunch Un-subscription!",
                                                            fillColor: Colors.red,
                                                          );
                                                        });
                                                      }
                                                    }

                                                  },
                                                  child: Container(
                                                    width: 80,
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                          Radius.circular(7),
                                                        ),
                                                        //color: kPrimaryColor,
                                                        border: Border.all(
                                                            color: kPrimaryColor)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.alarm_off_sharp,
                                                          color: kPrimaryColor, //Colors.white,
                                                        ),
                                                        Text("Unsubscribe", style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            fontSize: 10,
                                                            color: kPrimaryColor, //Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ) :
                                            Text(
                                              "# Unsubscribe Request Sent",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: kPrimaryColor,//Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : SizedBox();
                        },
                      ),
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

  StatefulBuilder unsubscrbeDialogBox(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          // contentPadding: EdgeInsets.only(left: 15, right: 15),
          title: Container(
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                    child: Text(
                      "Unsubscription Request Form",
                      style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
                    )),
                InkResponse(
                  onTap: () {
                    note='N/A';
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            height: 320,
            width: 600,
            child: Container(
              child: Column(
                children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          unsubscribeTypeList.length,
                              (index) {
                            return
                              Row(
                                children: [
                                  Radio(
                                    value: index + 1,
                                    groupValue:_radioValue,
                                    activeColor: Color(0xff2891a6),
                                    onChanged: (int value) async {
                                      setState(() {
                                        _radioValue = value;
                                        unsubscribeType = unsubscribeTypeList[index].id;
                                        print('unsubscribeType : ' + unsubscribeType);
                                        //unsubscriptionDecision='';
                                      });

                                        try {
                                          //un_subscription_type
                                          var formData = FormData.fromMap({
                                          "un_subscription_type": unsubscribeType.trim(),
                                          });

                                          //print('--------------From Submit----------------' + formData.fields.toString());
                                          final response = await widget.apiService.applyForUnSubscriptionDecision(formData);

                                          if (response.statusCode == 200 || response.statusCode == 201) {
                                            print(response.data['data'].toString());
                                            print(response.data['data']['available_date']??'N/A');
                                          setState(() {
                                            unsubscriptionDecision=response.data['message'].toString();
                                            if(response.data['data']['available_date']!=null){
                                              availableDate= response.data['data']['available_date'];
                                              to_date= availableDate;
                                            }
                                          });
                                          }
                                          else {
                                          setState(() {
                                            unsubscriptionDecision=response.data['message'].toString();
                                          });
                                          }
                                        } catch (ex) {
                                          setState(() {
                                            unsubscriptionDecision='Failed to get Unsubscription Decision';
                                          });
                                        }

                                      }
                                  ),
                                  Text(unsubscribeTypeList[index].name.toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                ],
                              );
                          },
                        ),
                      ),
                  SizedBox(height: 5),
                  unsubscribeType != 'instant' ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last Date of Daily Lunch', style: TextStyle(color: Colors.black54,fontSize: 10,fontWeight: FontWeight.bold),),
                      NeomorphicDatetimePicker(
                        hintText: to_date ?? "Last Date",  //
                        updateValue: (String from) {
                          setState(() {
                            if (from.isNotEmpty) {
                              endDate = DateTime.parse(from);
                              to_date = dateFormatter.format(endDate);
                              print('to_date : ' + to_date.toString());
                            }
                          });
                        },
                        width: MediaQuery.of(context).size.width * 0.33,
                      ),
                    ],
                  ):
                  Flexible(child: Text('Note : '+unsubscriptionDecision,style: TextStyle(color: Colors.black54,fontSize: 10,fontWeight: FontWeight.bold),)
                  ),


                  SizedBox(height: 5),
                  Text('Add Remarks: Why You Want to unsubscribe:(Describe Shortly)',
                    style: TextStyle(color: Colors.black54,fontSize: 10,fontWeight: FontWeight.bold),),
                  SizedBox(height: 5),
                  NeomorphicTextFormField(
                    initVal:null,
                    inputType: TextInputType.text,
                    numOfMaxLines: 2,
                    hintText: "Please add note here..",
                    fontSize: 12,
                    onChangeFunction: (String value) {
                      note = value.trim();
                      print('note : ' + note);
                    },
                  ),

                ],
              ),
            ),
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
                      note='N/A';
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
                      "Unsubscribed",
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
    );
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successfully"),
          content: Text("Lunch UnSubscribe Successfully Done."),
          actions: [
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
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

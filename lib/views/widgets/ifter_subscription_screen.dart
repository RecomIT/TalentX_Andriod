import 'dart:math' as Math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recom_app/data/models/ifter_subscription.dart';
import '../../services/api/api.dart';

class IfterSubscriptionScreen extends StatefulWidget {
  final ApiService apiService;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User currentUser;

  const IfterSubscriptionScreen(
      {Key key, @required this.apiService, this.scaffoldKey, this.currentUser})
      : super(key: key);

  @override
  State<IfterSubscriptionScreen> createState() =>
      _IfterSubscriptionScreenState();
}

class _IfterSubscriptionScreenState extends State<IfterSubscriptionScreen> {
  Future<IfterSubscriptionList> _IfterSubscriptionList;
  DateFormat dateFormatter;
  String currentDateFormat = '';

  @override
  void initState() {
    _IfterSubscriptionList = widget.apiService.getMyIfterSubscriptionList();
    _getCurrentDateFormat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        //SizedBox(height: 20),
        FutureBuilder<IfterSubscriptionList>(
            future: _IfterSubscriptionList,
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                var myIfterSubscriptionList =
                    snapshot.data.ifterSubscriptionList.toList();
                if (myIfterSubscriptionList == null ||
                    myIfterSubscriptionList.length == 0) {
                  return Text(
                      'Message : No Iftar Subscription Request Available');
                } else {
                  return Column(
                    children: [
                      Column(
                        children: List.generate(
                          myIfterSubscriptionList?.length,
                              (idx) {
                            return myIfterSubscriptionList?.length > 0
                                ? Column(
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
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 6,
                                        color: Colors.black26,
                                        offset: Offset.fromDirection(
                                            Math.pi * .5, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                        (kScreenSize.width - 40) * 0.80,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Request Raise Date : ${myIfterSubscriptionList[idx].requestRaiseDate}',
                                                //${_colleagues[idx].code}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Availing Date : ${myIfterSubscriptionList[idx].availingDate}',
                                                //${_colleagues[idx].code}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Quantity : ${myIfterSubscriptionList[idx].quantity}',
                                                //${_colleagues[idx].code}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            )
                            : SizedBox();
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Total : ${myIfterSubscriptionList.map((e) => e.quantity).toList().fold(0, (p, c) => p + c)}',
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
      ],
    );
  }

  void _getCurrentDateFormat() async {
    var response = await widget.apiService.getCurrentDateFormat();
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
}

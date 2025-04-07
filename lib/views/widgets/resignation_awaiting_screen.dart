import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recom_app/data/models/holiday_data.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/resignation_awaiting.dart';
import 'package:recom_app/data/models/travel_plan.dart';
import 'package:recom_app/data/models/travel_settlement.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/services/api/api.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_table.dart';
import "../../services/helper/string_extension.dart";

class ResignationAwaitingScreen extends StatefulWidget {
  final ApiService apiService;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User currentUser;
  const ResignationAwaitingScreen({
    Key key,
    @required this.apiService,
    this.scaffoldKey,
    this.currentUser}) : super(key: key);

  @override
  _ResignationAwaitingScreenState createState() => _ResignationAwaitingScreenState();
}

class _ResignationAwaitingScreenState extends State<ResignationAwaitingScreen> {
  Future<ResignationAwaitingList> _resignationAwaitingList;
  @override
  void initState() {
    super.initState();
    _resignationAwaitingList = widget.apiService.getResignationAwaitingList();
  }

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;
    List<ResignationAwaiting> awaitingList = <ResignationAwaiting>[];

    return
      Column(
        children: [
          //SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor
                    ),
                    onPressed: (){
                  setState(() {
                    _resignationAwaitingList = widget.apiService.getResignationPendingList();
                    //awaitingList= awaitingList.where((e) => e.status.toLowerCase().contains('pending')).toList();
                  });
                }, child: Text('Pending List')),
                SizedBox(width: 20,),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        primary: kPrimaryColor
                    ),
                    onPressed:(){
                  setState(() {
                    _resignationAwaitingList = widget.apiService.getResignationApprovedList();
                    //awaitingList = awaitingList.where((e) => e.status.toLowerCase().contains('approved')).toList();
                  });

                }, child: Text('Approved List')),
              ],
            ),
          ),
          SizedBox(height: 15,),
          FutureBuilder<ResignationAwaitingList>(
              future: _resignationAwaitingList,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  awaitingList = snapshot.data.resignationAwaitingList.toList();
                  if(awaitingList == null || awaitingList.length ==0){
                    return Text('Message : No Applications Available');
                  }else{
                    return Column(
                      children:
                      List.generate(
                        awaitingList?.length,
                            (idx) {
                          return awaitingList?.length > 0
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
                                          'Name : ${awaitingList[idx].employeeName}', //${awaitingList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),

                                        Text(
                                          'Designation Name : ${awaitingList[idx].designationName}', //${awaitingList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),

                                        Text(
                                          'Submission Date : ${awaitingList[idx].submissionDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Last Working Date : ${awaitingList[idx].lastWorkingDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'Status : ${awaitingList[idx].status.capitalize()}', //${_colleagues[idx].code}
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
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                  RESIGNATION_PAGE_APPROVAL_DETAIL,
                                                  arguments: awaitingList[idx],
                                                );
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
                                                      Icons.remove_red_eye,
                                                      color: kPrimaryColor,//Colors.white,
                                                    ),
                                                    Text(
                                                      "View",
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
                                            SizedBox(width: 8),
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
}
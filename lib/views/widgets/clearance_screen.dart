import 'dart:math' as Math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recom_app/data/models/clearance.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/visiting_card.dart';
import 'package:recom_app/data/models/visiting_card_bh_details.dart';
import 'package:recom_app/services/helper/string_extension.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';

import '../../data/models/holiday_data.dart';
import '../../services/api/api.dart';
import 'custom_table.dart';

class ClearanceScreen extends StatefulWidget {
  final ApiService apiService;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User currentUser;
  const ClearanceScreen({
    Key key,
    @required this.apiService,
    this.scaffoldKey,
    this.currentUser}) : super(key: key);

  @override
  State<ClearanceScreen> createState() => _ClearanceScreenState();
}

class _ClearanceScreenState extends State<ClearanceScreen> {
  Future<ClearanceList> _clearanceListAll;
  List<Clearance> clearanceList =  <Clearance>[];


  @override
  void initState() {
    super.initState();
    _clearanceListAll = widget.apiService.getClearancelList();
  }

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;
    DateFormat _dateFormat= DateFormat('E ,MMM dd,yyyy hh:mm:ss a');//('hh:mm:ss, dd-MMM-yyyy');
    return
       Column(
        children: [
          //SizedBox(height: 20),
          FutureBuilder<ClearanceList>(
              future: _clearanceListAll, //widget.apiService.getClearancelList(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  clearanceList = snapshot.data.clearanceList.toList();
                  if(clearanceList == null || clearanceList.length == 0){
                    return Text('Message : No Clearance Feedback Request Available');
                  }else{
                    return Column(
                      children: List.generate(
                        clearanceList?.length,
                            (idx) {
                          return clearanceList?.length > 0
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
                                          'Code : ${clearanceList[idx].employeeCode}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Name : ${clearanceList[idx].employeeName}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),

                                        Text(
                                          'Role : ${clearanceList[idx].employeeRole}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Business Unit : ${clearanceList[idx].businessUnit}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Cost Center : ${clearanceList[idx].costCenter}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Last Working Day : ${clearanceList[idx].lastWorkingDay}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Clearance Group : ${clearanceList[idx].clearanceGroup}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Clearance Authority : ${clearanceList[idx].clearanceAuthority}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Status : ${clearanceList[idx].status}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(

                                          'Created At : ${clearanceList[idx].createdAt != '-' ?
                                          DateFormat('dd-MMM-yyyy hh:mm:ss a').format(DateTime.tryParse(clearanceList[idx].createdAt).toLocal()) : '-'}'
                                          ,
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                            'Approval Date : ${clearanceList[idx].checkedAt != '-' ?
                                            DateFormat('dd-MMM-yyyy').format(DateTime.tryParse(clearanceList[idx].checkedAt)) : '-'}',
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 15,),
                                        clearanceList[idx].status.toLowerCase() != 'approved' ?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                  CLEARANCE_PAGE_DETAIL,
                                                  arguments: clearanceList[idx],
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
                                            // clearanceList[idx].applicationStatus.toLowerCase().contains('reverted') ?
                                            // Row(
                                            //   children: [
                                            //     InkWell(
                                            //       onTap: () {
                                            //         //Call Edit api then navigate
                                            //         Navigator.of(context).pushNamed(
                                            //           EDIT_RESIGNATION_PAGE,
                                            //           arguments: clearanceList[idx],
                                            //         );
                                            //       },
                                            //       child: Container(
                                            //         width: 80,
                                            //         padding: EdgeInsets.symmetric(
                                            //           horizontal: 5,
                                            //           vertical: 2,
                                            //         ),
                                            //         decoration: BoxDecoration(
                                            //             borderRadius: BorderRadius.all(
                                            //               Radius.circular(7),
                                            //             ),
                                            //             //color: kPrimaryColor,
                                            //             border: Border.all(color: kPrimaryColor)
                                            //         ),
                                            //         child: Column(
                                            //           children: [
                                            //             Icon(
                                            //               Icons.edit,
                                            //               color: kPrimaryColor,//Colors.white,
                                            //             ),
                                            //             Text(
                                            //               "Edit",
                                            //               style: TextStyle(
                                            //                 fontWeight: FontWeight.bold,
                                            //                 fontSize: 10,
                                            //                 color: kPrimaryColor,//Colors.white,
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     SizedBox(width: 8),
                                            //     InkWell(
                                            //       onTap: () async{
                                            //         try {
                                            //           final response = await apiService.deleteResignationRequest(clearanceList[idx].id);
                                            //           if (response.statusCode == 200) {
                                            //             showDialog(
                                            //               context: context,
                                            //               builder: (BuildContext context) {
                                            //                 return AlertDialog(
                                            //                   title: Text("Successfully"),
                                            //                   content: Text("Successfully Delete Resignation Request!"),
                                            //                   actions: [
                                            //                     FlatButton(
                                            //                       child: new Text("OK"),
                                            //                       onPressed: () {
                                            //                         Navigator.of(context).pop();
                                            //                         Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationApplication);
                                            //                       },
                                            //                     ),
                                            //                   ],
                                            //                 );
                                            //               },
                                            //             );
                                            //
                                            //           } else {
                                            //             showSnackBarMessage(
                                            //               scaffoldKey: scaffoldKey,
                                            //               message: response.data["message"],
                                            //               fillColor: Colors.red,
                                            //             );
                                            //           }
                                            //         } catch (ex) {
                                            //           showSnackBarMessage(
                                            //             scaffoldKey: scaffoldKey,
                                            //             message: "Failed to Delete Resignation request!",
                                            //             fillColor: Colors.red,
                                            //           );
                                            //         }
                                            //       },
                                            //       child: Container(
                                            //         width: 80,
                                            //         padding: EdgeInsets.symmetric(
                                            //           horizontal: 5,
                                            //           vertical: 2,
                                            //         ),
                                            //         decoration: BoxDecoration(
                                            //             borderRadius: BorderRadius.all(
                                            //               Radius.circular(7),
                                            //             ),
                                            //             //color: kPrimaryColor,
                                            //             border: Border.all(color: kPrimaryColor)
                                            //         ),
                                            //         child: Column(
                                            //           children: [
                                            //             Icon(
                                            //               Icons.delete,
                                            //               color: kPrimaryColor,//Colors.white,
                                            //             ),
                                            //             Text(
                                            //               "Delete",
                                            //               style: TextStyle(
                                            //                 fontWeight: FontWeight.bold,
                                            //                 fontSize: 10,
                                            //                 color: kPrimaryColor,//Colors.white,
                                            //               ),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // )
                                            //     : Container(),

                                          ],
                                        ) : SizedBox.shrink(),
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

import 'dart:math' as Math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recom_app/data/models/id_card_bh_details.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/visiting_card.dart';
import 'package:recom_app/data/models/visiting_card_bh_details.dart';
import 'package:recom_app/services/helper/string_extension.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';

import '../../data/models/holiday_data.dart';
import '../../services/api/api.dart';
import 'custom_table.dart';

class IdCardLMScreen extends StatelessWidget {
  final ApiService apiService;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User currentUser;
  const IdCardLMScreen({
    Key key,
    @required this.apiService,
    this.scaffoldKey,
    this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;
    return
      Column(
        children: [
          //SizedBox(height: 20),
          FutureBuilder<IdCardBHDetailsList>(
              future: apiService.getIdCardLMDetailList(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  var idCardList = snapshot.data.idCardBHDetailsList.toList();
                  if(idCardList == null || idCardList.length ==0){
                    return Text('Message : No Id Card Request Available');
                  }else{
                    return Column(
                      children: List.generate(
                        idCardList?.length,
                            (idx) {
                          return idCardList?.length > 0
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
                                          'Employee Name : ${idCardList[idx].employeeName}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Employee Code : ${idCardList[idx].employeeCode}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Employee Role : ${idCardList[idx].employeeRole}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Employee Division : ${idCardList[idx].employeeDivision}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Employee Department : ${idCardList[idx].employeeDepartment}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                        Text(
                                          'Requisition Date : ${idCardList[idx].requisitionDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Required Status : ${idCardList[idx].requiredStatus}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Application Status : ${idCardList[idx].applicationStatus}', //${_colleagues[idx].code}
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
                                                  ID_CARD_PAGE_DETAIL,
                                                  arguments: idCardList[idx],
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
                                            // idCardList[idx].applicationStatus.toLowerCase().contains('reverted') ?
                                            // Row(
                                            //   children: [
                                            //     InkWell(
                                            //       onTap: () {
                                            //         //Call Edit api then navigate
                                            //         Navigator.of(context).pushNamed(
                                            //           EDIT_RESIGNATION_PAGE,
                                            //           arguments: idCardList[idx],
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
                                            //           final response = await apiService.deleteResignationRequest(idCardList[idx].id);
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

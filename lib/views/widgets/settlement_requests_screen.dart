import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recom_app/data/models/edit_settlement.dart';
import 'package:recom_app/data/models/my_settlement_list.dart';
import 'package:recom_app/data/models/settlement_request_data.dart';
import 'package:recom_app/data/models/travel_plan.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/services/api/api.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';
import 'dart:math' as Math;
import "../../services/helper/string_extension.dart";

class SettlementRequestsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ApiService apiService;
  final User currentUser;

  const SettlementRequestsScreen({Key key,
    this.scaffoldKey,
    this.apiService,
    this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;
    return
      Column(
        children: [
          //SizedBox(height: 20),
          FutureBuilder<MySettlementList>(
              future: apiService.getSettlementRequestList(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  var settlementRequestList = snapshot.data.mySettlements.toList();
                  //travelPlanDataList=null;
                  if(settlementRequestList == null || settlementRequestList.length == 0){
                    return Text('Message : No Settlement Requests Available');
                  }else{
                     settlementRequestList.sort((a, b) => b.travelSettlementId.compareTo(a.travelSettlementId));
                    return Column(
                      children: List.generate(
                        settlementRequestList?.length,
                            (idx) {
                          return settlementRequestList?.length > 0
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
                                          'REQUESTER ID : ${settlementRequestList[idx].referenceNo}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Travel Type : ${settlementRequestList[idx].travelType.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Reason : ${settlementRequestList[idx].purpose}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Trip Plan : ${settlementRequestList[idx].tripType.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Mode Of Transport : ${settlementRequestList[idx].transportMode.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Year : ${settlementRequestList[idx].year} & Month : ${settlementRequestList[idx].moth}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),

                                        Text(
                                          'Settlement Status : ${settlementRequestList[idx].status.capitalize()}',
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
                                                  SETTLEMENT_REQUEST_DETAIL_PAGE,
                                                  arguments: settlementRequestList[idx],
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
                                            settlementRequestList[idx].status.toLowerCase().contains('reverted') ?
                                            InkWell(
                                              onTap: () async {
                                                try {
                                                  // Navigator.of(context).pushNamed(
                                                  //   EDIT_SETTLEMENT_PAGE,
                                                  //   arguments: EditSettlement(id:12,travelPlanId:68,airTicketAmount: 0,hotelAccomodationAmount: 1000,
                                                  //       transferAllowanceAmount: 1000,transportAmount: 1000,guestHouseAccommodationAmount: 0,mealAllowanceAmount: 0,
                                                  //       dailyAllowanceAmount: 1000),
                                                  // );
                                                  final response = await apiService.getEditSettlement(settlementRequestList[idx].travelSettlementId.toString());
                                                  if (response != null) {
                                                    Navigator.of(context).pushNamed(
                                                      EDIT_SETTLEMENT_PAGE,
                                                      arguments: response,
                                                    );
                                                  }
                                                  else {
                                                    showSnackBarMessage(
                                                      scaffoldKey: scaffoldKey,
                                                      message: "Exception : Something went wrong in Travel Settlement Request",
                                                      fillColor: Colors.red,
                                                    );
                                                  }
                                                }
                                                catch (e) {
                                                  showSnackBarMessage(
                                                    scaffoldKey: scaffoldKey,
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
                                                      Icons.edit,
                                                      color: kPrimaryColor,//Colors.white,
                                                    ),
                                                    Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10,
                                                        color: kPrimaryColor,//Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ) : Container(),
                                            // InkWell(
                                            //   onTap: () async {
                                            //     //print('Download CLICKED');
                                            //     var status = await Permission.storage.status;
                                            //     if (!status.isGranted) {
                                            //       status = await Permission.storage.request();
                                            //       if (!status.isGranted) {
                                            //         showSnackBarMessage(
                                            //           scaffoldKey: scaffoldKey,
                                            //           message: "Please allow storage permission!",
                                            //           fillColor: Colors.red,
                                            //         );
                                            //         return;
                                            //       }
                                            //     }
                                            //
                                            //     try {
                                            //       Directory appDocDir;
                                            //                       if(Platform.isAndroid){
                                            //                         appDocDir = Directory("/storage/emulated/0/Download");
                                            //                       }
                                            //                       else if(Platform.isIOS){
                                            //                         appDocDir = await getApplicationDocumentsDirectory();
                                            //                       }
                                            //
                                            //       final pdfFile = File("${appDocDir.path}/Travel_Plan_${settlementRequestList[idx]
                                            //           .referenceNo.replaceAll('/', '_').replaceAll('-', '_')}.pdf");
                                            //
                                            //       if (!pdfFile.existsSync()) {
                                            //         bool downloaded = await apiService.getTravellPlan(settlementRequestList[idx].id.toString(), pdfFile.path);
                                            //         if (!downloaded) {
                                            //           showSnackBarMessage(
                                            //             scaffoldKey: scaffoldKey,
                                            //             message:
                                            //             "Sorry, No file available.!",
                                            //             fillColor: Colors.red,
                                            //           );
                                            //           return;
                                            //         }
                                            //       }
                                            //
                                            //       if (pdfFile.existsSync()) {
                                            //         await OpenFile.open(pdfFile.path);
                                            //       } else {
                                            //         showSnackBarMessage(
                                            //           scaffoldKey: scaffoldKey,
                                            //           message:
                                            //           "Sorry, failed to open file  Please check your premissions network and connectivity!file!",
                                            //           fillColor: Colors.red,
                                            //         );
                                            //       }
                                            //
                                            //     } catch (e) {
                                            //       showSnackBarMessage(
                                            //         scaffoldKey: scaffoldKey,
                                            //         message:
                                            //         "Sorry, failed to open file  Please check your premissions network and connectivity!file!",
                                            //         fillColor: Colors.red,
                                            //       );
                                            //     }
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
                                            //           Icons.download_rounded,
                                            //           color: kPrimaryColor,//Colors.white,
                                            //         ),
                                            //         Text(
                                            //           "Download",
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
                                            // travelPlanDataList[idx].status.toLowerCase().contains('approved') ?
                                            // InkWell(
                                            //   onTap: () async {
                                            //     //print('CLICKED');
                                            //     try {
                                            //       var data = TravelSettlement(id: 1,airTicket: 0,hotelAccommodation: 1,transport: 0,dailyAllowance: 1, mealAllowance: 0,transferAllowance: 1);
                                            //       Navigator.of(context).pushNamed(
                                            //         TRAVEL_PLAN_SETTLEMENT_PAGE,
                                            //         arguments: data,
                                            //       );
                                            //       // final response = await apiService.getTravelPlanSettlement(travelPlanDataList[idx].id.toString());
                                            //       // if (response != null) {
                                            //       //   Navigator.of(context).pushNamed(
                                            //       //     TRAVEL_PLAN_SETTLEMENT_PAGE,
                                            //       //     arguments: response,
                                            //       //   );
                                            //       // }
                                            //       // else {
                                            //       //   showSnackBarMessage(
                                            //       //     scaffoldKey: scaffoldKey,
                                            //       //     message: "Exception : Something went wrong in Travel Settlement Request",
                                            //       //     fillColor: Colors.red,
                                            //       //   );
                                            //       // }
                                            //     }
                                            //     catch (e) {
                                            //       showSnackBarMessage(
                                            //         scaffoldKey: scaffoldKey,
                                            //         message: e.message.toString(),
                                            //         fillColor: Colors.red,
                                            //       );
                                            //     }
                                            //   },
                                            //   child: Container(
                                            //     width: 80,
                                            //     padding: EdgeInsets.symmetric(
                                            //       horizontal: 5,
                                            //       vertical: 2,
                                            //     ),
                                            //     decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.all(
                                            //         Radius.circular(7),
                                            //       ),
                                            //       //color: kPrimaryColor,
                                            //         border: Border.all(color: kPrimaryColor)
                                            //     ),
                                            //     child: Column(
                                            //       children: [
                                            //         Icon(
                                            //           Icons.account_balance_outlined,
                                            //           color: kPrimaryColor,//Colors.white,
                                            //         ),
                                            //         Text(
                                            //           "Settlement",
                                            //           style: TextStyle(
                                            //             fontWeight: FontWeight.bold,
                                            //             fontSize: 10,
                                            //             color: kPrimaryColor,//Colors.white,
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ) : Container(),

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




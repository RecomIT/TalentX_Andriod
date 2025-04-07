import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recom_app/data/models/holiday_data.dart';
import 'package:recom_app/data/models/travel_plan.dart';
import 'package:recom_app/data/models/travel_settlement.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/services/api/api.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_table.dart';
import "../../services/helper/string_extension.dart";

class TravelPlansScreen extends StatelessWidget {
  final ApiService apiService;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User currentUser;
  const TravelPlansScreen({
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
          FutureBuilder<TravelPlanData>(
              future: apiService.getTravelPlanList(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  var travelPlanDataList = snapshot.data.travelPlan.toList();
                  //travelPlanDataList=null;
                  if(travelPlanDataList == null || travelPlanDataList.length ==0){
                    return Text('Message : No Travel Plan Requests Available');
                  }else{
                    return Column(
                      children: List.generate(
                        travelPlanDataList?.length,
                            (idx) {
                          return travelPlanDataList?.length > 0
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
                                          'REQUESTER ID : ${travelPlanDataList[idx].referenceNo}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        // Text(
                                        //   'NAME : ${travelPlanDataList[idx].employeeName}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // SizedBox(height: 5,),
                                        // Text(
                                        //   'DIVISION : ${travelPlanDataList[idx].divisionName}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // SizedBox(height: 5,),
                                        // Text(
                                        //   'COST CENTER : ${travelPlanDataList[idx].costCenterName}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // SizedBox(height: 5,),
                                        Text(
                                          'Name : ${travelPlanDataList[idx].employeeName.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Division : ${travelPlanDataList[idx].divisionName.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Cost Center : ${travelPlanDataList[idx].costCenterName.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Travel Type : ${travelPlanDataList[idx].travelType.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Applicable Cost Center : ${travelPlanDataList[idx].applicableCostCenter.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Reason : ${travelPlanDataList[idx].purpose}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Trip Plan : ${travelPlanDataList[idx].tripType.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Mode Of Transport : ${travelPlanDataList[idx].transportMode.capitalize()}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Year : ${travelPlanDataList[idx].year} & Month : ${travelPlanDataList[idx].moth}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        // Text(
                                        //   'MONTH : ${travelPlanDataList[idx].moth}', //${_colleagues[idx].code}
                                        //   style: TextStyle(
                                        //     color: Colors.black45,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        // SizedBox(height: 5,),
                                        Text(
                                          'Status : ${travelPlanDataList[idx].status.capitalize()}',
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
                                                  TRAVEL_PLAN_DETAIL_PAGE,
                                                  arguments: travelPlanDataList[idx],
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
                                            travelPlanDataList[idx].status.toLowerCase().contains('reverted') ?
                                            InkWell(
                                              onTap: () {
                                                //Call Edit api then navigate
                                                Navigator.of(context).pushNamed(
                                                  EDIT_TRAVEL_PLAN_PAGE,
                                                  arguments: travelPlanDataList[idx],
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
                                            SizedBox(width: 8),
                                            InkWell(
                                              onTap: () async {
                                                print('Download CLICKED');
                                                var status = await Permission.storage.status;
                                                if (!status.isGranted) {
                                                  status = await Permission.storage.request();
                                                  if (!status.isGranted) {
                                                    showSnackBarMessage(
                                                      scaffoldKey: scaffoldKey,
                                                      message: "Please allow storage permission!",
                                                      fillColor: Colors.red,
                                                    );
                                                    return;
                                                  }
                                                }

                                                try {
                                                  Directory appDocDir;
                                                  if(Platform.isAndroid){
                                                    appDocDir = Directory("/storage/emulated/0/Download");
                                                  }
                                                  else if(Platform.isIOS){
                                                    appDocDir = await getApplicationDocumentsDirectory();
                                                  }

                                                  final pdfFile = File("${appDocDir.path}/Travel_Plan_${travelPlanDataList[idx]
                                                      .referenceNo.replaceAll('/', '_').replaceAll('-', '_')}.pdf");

                                                  if (!pdfFile.existsSync()) {
                                                    bool downloaded = await apiService.getTravellPlan(travelPlanDataList[idx].id.toString(), pdfFile.path);
                                                    if (!downloaded) {
                                                      showSnackBarMessage(
                                                        scaffoldKey: scaffoldKey,
                                                        message:
                                                        "Sorry, No file available.!",
                                                        fillColor: Colors.red,
                                                      );
                                                      return;
                                                    }
                                                  }

                                                  if (pdfFile.existsSync()) {
                                                    await OpenFile.open(pdfFile.path);
                                                  } else {
                                                    showSnackBarMessage(
                                                      scaffoldKey: scaffoldKey,
                                                      message:
                                                      "Sorry, failed to open file  Please check your premissions network and connectivity!file!",
                                                      fillColor: Colors.red,
                                                    );
                                                  }

                                                } catch (e) {
                                                  showSnackBarMessage(
                                                    scaffoldKey: scaffoldKey,
                                                    message:
                                                    "Sorry, failed to open file  Please check your premissions network and connectivity!file!",
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
                                                      Icons.download_rounded,
                                                      color: kPrimaryColor,//Colors.white,
                                                    ),
                                                    Text(
                                                      "Download",
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
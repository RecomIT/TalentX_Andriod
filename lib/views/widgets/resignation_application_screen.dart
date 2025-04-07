import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recom_app/data/models/holiday_data.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/travel_plan.dart';
import 'package:recom_app/data/models/travel_settlement.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/services/api/api.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_table.dart';
import "../../services/helper/string_extension.dart";

class ResignationApplicationScreen extends StatelessWidget {
  final ApiService apiService;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User currentUser;
  const ResignationApplicationScreen({
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
          FutureBuilder<MyResignationList>(
              future: apiService.getMyResignationList(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  var myResignationList = snapshot.data.myResignationList.toList();
                  if(myResignationList == null || myResignationList.length ==0){
                    return Text('Message : No Resignation Applications Available');
                  }else{
                    myResignationList.sort((a,b)=>b.separationId.compareTo(a.separationId));
                    return Column(
                      children: List.generate(
                        myResignationList?.length,
                            (idx) {
                          return myResignationList?.length > 0
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
                                          'Submission Date : ${myResignationList[idx].applicationDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Last Working Date : ${myResignationList[idx].lastWorkingDate}', //${_colleagues[idx].code}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Status : ${myResignationList[idx].status.capitalize()}', //${_colleagues[idx].code}
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
                                                  RESIGNATION_PAGE_DETAIL,
                                                  arguments: myResignationList[idx],
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
                                            myResignationList[idx].status.toLowerCase().contains('reverted') ?
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    //Call Edit api then navigate
                                                    Navigator.of(context).pushNamed(
                                                      EDIT_RESIGNATION_PAGE,
                                                      arguments: myResignationList[idx],
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
                                                ),
                                                SizedBox(width: 8),
                                                InkWell(
                                                  onTap: () async{
                                                      try {
                                                        final response = await apiService.deleteResignationRequest(myResignationList[idx].separationId);
                                                        if (response.statusCode == 200) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: Text("Successfully"),
                                                                content: Text("Successfully Delete Resignation Request!"),
                                                                actions: [
                                                                  FlatButton(
                                                                    child: new Text("OK"),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                      Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationApplication);
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );

                                                        } else {
                                                          showSnackBarMessage(
                                                            scaffoldKey: scaffoldKey,
                                                            message: response.data["message"],
                                                            fillColor: Colors.red,
                                                          );
                                                        }
                                                      } catch (ex) {
                                                        showSnackBarMessage(
                                                          scaffoldKey: scaffoldKey,
                                                          message: "Failed to Delete Resignation request!",
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
                                                          Icons.delete,
                                                          color: kPrimaryColor,//Colors.white,
                                                        ),
                                                        Text(
                                                          "Delete",
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
                                            )
                                                : Container(),

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
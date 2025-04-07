import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/my_settlement_list.dart';
import 'package:recom_app/data/models/resignation_details.dart';
import 'package:recom_app/data/models/settlement_request_data.dart';
import 'package:recom_app/data/models/settlement_request_detail.dart';
import 'package:recom_app/data/models/travel_plan_detail.dart';
import 'package:recom_app/data/models/visiting_card.dart';
import 'package:recom_app/data/models/visiting_card_bh_details.dart';
import 'package:recom_app/data/models/visiting_card_details.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';
import '../widgets/wide_filled_button.dart';
import "../../services/helper/string_extension.dart";
import 'package:flutter_html/flutter_html.dart';

class VisitingCardPageDetail extends StatefulWidget {
  final VisitingCard myVisitingCard;
  final VisitingCardBHDetails visitingCardBH;//My

  const VisitingCardPageDetail({
    Key key,
    this.myVisitingCard,
    this.visitingCardBH,
  }) : super(key: key);
  @override
  _VisitingCardPageDetailState createState() => _VisitingCardPageDetailState();
}

class _VisitingCardPageDetailState extends State<VisitingCardPageDetail> {
  User _currentUser;
  ApiService _apiService;
  bool _isLoading = false;
  String note= 'N/A';
  bool isActionCanceled = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String msg;
  DateFormat _dateFormat= DateFormat('MMM dd,yyyy');//('hh:mm:ss, dd-MMM-yyyy');
  int _requestId;

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.myVisitingCard == null && widget.visitingCardBH==null)
    {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
            (route) => false,
      );
    }
    _requestId = widget.myVisitingCard != null ? widget.myVisitingCard.id :widget.visitingCardBH.id;
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final kScreenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
        child: (widget.myVisitingCard == null && widget.visitingCardBH==null)
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
            child: FutureBuilder<VisitingCardDetails>(
                future: _apiService.getVisitingCardDetails(_requestId),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    var visitingCardDetails = snapshot.data;
                    if(visitingCardDetails == null){
                      return Text('Message : No Visiting Card Details Available');
                    }else{
                      return Column(
                        children: [
                          Container(
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
                                          'Visiting Card Information Details', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Name : ${visitingCardDetails.employeeName.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Short Name : ${visitingCardDetails.shortName.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Employee Code : ${visitingCardDetails.employeeCode.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Employee Role : ${visitingCardDetails.employeeRole.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Employee Division : ${visitingCardDetails.employeeDivision.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Employee Department : ${visitingCardDetails.employeeDepartment.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Official Email : ${visitingCardDetails.officialEmail.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Official Contact : ${visitingCardDetails.officialContact.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Official Address : ${visitingCardDetails.officialAddress.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Business Head : ${visitingCardDetails.businessHead.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Requisition Date : ${visitingCardDetails.requisitionDate.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          'Required Status : ${visitingCardDetails.requiredStatus.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5,),

                                        Text(
                                          'Application Status : ${visitingCardDetails.applicationStatus.trim()}', //${myResignationList[idx].applicationDate}
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text(
                                              'Approval Authorities',
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
                                          itemCount:
                                          visitingCardDetails.approvalAuthorities == null ?  0 : visitingCardDetails.approvalAuthorities.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: double.infinity,
                                              height: 160,
                                              padding: EdgeInsets.only(left: 10),
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Text('Name : ${visitingCardDetails.approvalAuthorities[index].authorityName}'
                                                        ,style: TextStyle(
                                                          color: Colors.black45,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        )),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Text('Layer :  ${visitingCardDetails.approvalAuthorities[index].authorityOrder}'
                                                      ,style: TextStyle(
                                                        color: Colors.black45,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                  SizedBox(height: 5,),
                                                  Text('Status :  ${visitingCardDetails.approvalAuthorities[index].authorityStatus}'
                                                      ,style: TextStyle(
                                                        color: Colors.black45,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                  SizedBox(height: 5,),
                                                  Flexible(
                                                    child: Text('Processed By :  ${visitingCardDetails.approvalAuthorities[index].processedEmployee}'
                                                        ,style: TextStyle(
                                                          color: Colors.black45,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        )),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  !visitingCardDetails.approvalAuthorities[index].createdAt.toLowerCase().contains('n/a') ?
                                                  Text('Arrival Time :  ${_dateFormat.format(DateTime.tryParse(visitingCardDetails.approvalAuthorities[index].createdAt))}',style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ))
                                                      :
                                                  Text('Arrival Time :  ${visitingCardDetails.approvalAuthorities[index].createdAt}'
                                                      ,style: TextStyle(
                                                        color: Colors.black45,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      )),
                                                  SizedBox(height: 5,),
                                                  Flexible(
                                                    child: Text('Remarks :  ${visitingCardDetails.approvalAuthorities[index].remarks}',style: TextStyle(
                                                      color: Colors.black45,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                        _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
                                        SizedBox(height: 10,),
                                        visitingCardDetails.applicationApproval ?
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: kPrimaryColor
                                              ),
                                              onPressed: () async {
                                                await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return  addNotesDialogBox(context);
                                                    });

                                                if(isActionCanceled){
                                                  isActionCanceled=false;
                                                  return;
                                                }
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                try {
                                                  final response = await _apiService.approvalVisitingCardRequest(_requestId,note,'Approved');
                                                  if (response.statusCode == 200) {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Successfully"),
                                                          content: Text("Successfully Approved Request!"),
                                                          actions: [
                                                            FlatButton(
                                                              child: new Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pushNamed(VISITING_CARD_PAGE,arguments:VisitingCardPageScreen.VisitingCard);
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
                                                    message: "Failed to Approve Request!",
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
                                                await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return  addNotesDialogBox(context);
                                                    });

                                                if(isActionCanceled){
                                                  isActionCanceled=false;
                                                  return;
                                                }
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                try {
                                                  final response = await _apiService.approvalVisitingCardRequest(_requestId,note,'Reverted');
                                                  if (response.statusCode == 200) {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Successfully"),
                                                          content: Text("Successfully Reverted Request!"),
                                                          actions: [
                                                            FlatButton(
                                                              child: new Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pushNamed(VISITING_CARD_PAGE,arguments:VisitingCardPageScreen.VisitingCard);
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
                                                    message: "Failed to Revert Request!",
                                                    fillColor: Colors.red,
                                                  );
                                                }
                                              },
                                              child: Text('Revert'),
                                            ),
                                            SizedBox(width: 10,),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.red
                                              ),
                                              onPressed: () async {
                                                await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return  addNotesDialogBox(context);
                                                    });

                                                if(isActionCanceled){
                                                  isActionCanceled=false;
                                                  return;
                                                }
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                try {
                                                  final response = await _apiService.approvalVisitingCardRequest(_requestId,note,'Rejected');
                                                  if (response.statusCode == 200) {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Successfully"),
                                                          content: Text("Successfully Rejected Request!"),
                                                          actions: [
                                                            FlatButton(
                                                              child: new Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                Navigator.of(context).pushNamed(VISITING_CARD_PAGE,arguments:VisitingCardPageScreen.VisitingCard);
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
                                                    message: "Failed to Reject Request!",
                                                    fillColor: Colors.red,
                                                  );
                                                }
                                              },
                                              child: Text('Reject'),
                                            ),
                                          ],
                                        ) :
                                        Container(),
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


  AlertDialog addNotesDialogBox(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25),
      title: Container(
        decoration: new BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                child: Text(
                  "Add Note",
                  style: TextStyle(color: Colors.white),
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 120,
        width: 600,
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20),
              NeomorphicTextFormField(
                initVal:null,
                inputType: TextInputType.text,
                numOfMaxLines: 3,
                hintText: "Please add note here..",
                fontSize: 12,
                onChangeFunction: (String value) {
                  note = value.trim();
                  //print('note : ' + note);
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
                  "Send",
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

}

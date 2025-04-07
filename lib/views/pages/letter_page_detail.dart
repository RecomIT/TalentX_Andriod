import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:recom_app/data/models/id_card_bh_details.dart';

import 'package:recom_app/data/models/Id_card.dart';
import 'package:recom_app/data/models/id_card_details.dart';
import 'package:recom_app/data/models/letter.dart';
import 'package:recom_app/data/models/letter_details.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';

class LetterPageDetail extends StatefulWidget {
  final Letter myLetter;
  //final LetterBHDetails idCardBH; //My

  const LetterPageDetail({
    Key key,
    this.myLetter,
    //this.idCardBH,
  }) : super(key: key);

  @override
  _LetterPageDetailState createState() => _LetterPageDetailState();
}

class _LetterPageDetailState extends State<LetterPageDetail> {
  User _currentUser;
  ApiService _apiService;
  bool _isLoading = false;
  String note = 'N/A';
  bool isActionCanceled = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String msg;
  DateFormat _dateFormat =
      DateFormat('MMM dd,yyyy'); //('hh:mm:ss, dd-MMM-yyyy');
  int _requestId;

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    //&& widget.idCardBH == null
    if (widget.myLetter == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
        (route) => false,
      );
    }
    _requestId = widget.myLetter != null ? widget.myLetter.id : widget.myLetter.id; //widget.idCardBH.id
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
        child: (widget.myLetter == null) //&& widget.idCardBH == null
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
                  child: FutureBuilder<LetterDetails>(
                      future: _apiService.getLetterDetails(_requestId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && !snapshot.hasError) {
                          var letterDetails = snapshot.data;
                          if (letterDetails == null) {
                            return Text(
                                'Message : No Letter Details Available');
                          } else {
                            return Column(
                              children: [
                                Container(
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
                                              Text(
                                                'Requisition Letter Details',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Name : ${letterDetails.employeeName.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Employee Code : ${letterDetails.employeeCode.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Employee Role : ${letterDetails.employeeRole.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Division : ${letterDetails.employeeDivision.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Department : ${letterDetails.employeeDepartment.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Line Manager : ${letterDetails.lineManager.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Reference No : ${letterDetails.referenceNo.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Requisition Type : ${letterDetails.requisitionType.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Requisition Date : ${letterDetails.requisitionDate.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Reason : ${letterDetails.reason.trim()}',
                                                //${myResignationList[idx].applicationDate}
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
                                                'Application Status : ${letterDetails.applicationStatus.trim()}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),

                                              if (letterDetails.requisitionType.trim() =='Introductory Letter'  || letterDetails.requisitionType.trim() =='Invitation Letter')
                                                Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      'Passport No. : ${letterDetails.passportNo.trim()}',
                                                      //${myResignationList[idx].applicationDate}
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
                                                      'Date of Birth : ${letterDetails.dateOfBirth.trim()}',
                                                      //${myResignationList[idx].applicationDate}
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
                                                      'Leave Start Date : ${letterDetails.startDate.trim()}',
                                                      //${myResignationList[idx].applicationDate}
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
                                                      'Leave End Date : ${letterDetails.endDate.trim()}',
                                                      //${myResignationList[idx].applicationDate}
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
                                                      'Embassy Name : ${letterDetails.embassyName.trim()}',
                                                      //${myResignationList[idx].applicationDate}
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
                                                      'Embassy Address : ${letterDetails.embassyAddress.trim()}',
                                                      //${myResignationList[idx].applicationDate}
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        letterDetails.attachment != null ?
                                                        InkWell(
                                                          onTap:  () async {
                                                            var url = letterDetails.attachment;
                                                            print(url);
                                                            if (await canLaunch(url)) {await launch(url);
                                                            } else {
                                                              showSnackBarMessage(
                                                                scaffoldKey: _scaffoldKey,
                                                                message: "No Attachment Available!",
                                                                fillColor: Colors.red,
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            width: 80,
                                                            padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 2,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.all(
                                                                  Radius.circular(7),
                                                                ),
                                                                //color: kPrimaryColor,
                                                                border: Border.all(
                                                                    color:
                                                                    kPrimaryColor)),
                                                            child: Column(
                                                              children: [
                                                                Icon(
                                                                  Icons.download,
                                                                  color:
                                                                  kPrimaryColor, //Colors.white,
                                                                ),
                                                                Text(
                                                                  "Attachment",
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                    fontSize: 10,
                                                                    color:
                                                                    kPrimaryColor, //Colors.white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ): Container(),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ) else Container(),

                                              SizedBox(height: 20,),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Approval Authorities',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: letterDetails
                                                                .approvalAuthorities ==
                                                            null
                                                        ? 0
                                                        : letterDetails
                                                            .approvalAuthorities
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        width: double.infinity,
                                                        height: 160,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                  'Name : ${letterDetails.approvalAuthorities[index].authorityName}',
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
                                                                'Layer :  ${letterDetails.approvalAuthorities[index].authorityOrder}',
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
                                                                'Status :  ${letterDetails.approvalAuthorities[index].authorityStatus}',
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
                                                            Flexible(
                                                              child: Text(
                                                                  'Processed By :  ${letterDetails.approvalAuthorities[index].processedEmployee}',
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
                                                            !letterDetails
                                                                    .approvalAuthorities[
                                                                        index]
                                                                    .createdAt
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        'n/a')
                                                                ? Text(
                                                                    'Arrival Time :  ${_dateFormat.format(DateTime.tryParse(letterDetails.approvalAuthorities[index].createdAt))}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black45,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12,
                                                                    ))
                                                                : Text(
                                                                    'Arrival Time :  ${letterDetails.approvalAuthorities[index].createdAt}',
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
                                                                  'Remarks :  ${letterDetails.approvalAuthorities[index].remarks}',
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
                                              _isLoading
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : Container(),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              letterDetails.applicationApproval
                                                  ? Row(
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                                                          onPressed: () async {
                                                            await showDialog(
                                                                barrierDismissible: false,
                                                                context: context,
                                                                builder:(BuildContext context) {
                                                                  return addNotesDialogBox(context);
                                                                });

                                                            if (isActionCanceled) {
                                                              isActionCanceled = false;
                                                              return;
                                                            }
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            try {
                                                              final response = await _apiService.approvalLetterRequest(_requestId, note, 'Approved');
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
                                                                            Navigator.of(context).pushNamed(LETTER_PAGE,arguments: LetterPageScreen.LetterLM);
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
                                                                showSnackBarMessage(scaffoldKey: _scaffoldKey, message: response.data["message"], fillColor: Colors.red,);
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
                                                          style: OutlinedButton.styleFrom(primary: kPrimaryColor),
                                                          onPressed: () async {
                                                            await showDialog(barrierDismissible: false,
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return addNotesDialogBox(context);});

                                                            if (isActionCanceled) {isActionCanceled = false;return;}
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            try {
                                                              final response =
                                                                  await _apiService.approvalLetterRequest(_requestId, note, 'Reverted');
                                                              if (response.statusCode == 200) {
                                                                setState(() {_isLoading = false;});
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(title: Text("Successfully"),
                                                                      content: Text("Successfully Reverted Request!"),
                                                                      actions: [
                                                                        FlatButton(
                                                                          child: new Text("OK"),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(LETTER_PAGE, arguments: LetterPageScreen.LetterLM);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              } else {
                                                                setState(() {
                                                                  _isLoading =
                                                                      false;
                                                                });
                                                                showSnackBarMessage(
                                                                  scaffoldKey: _scaffoldKey,
                                                                  message: response.data["message"],
                                                                  fillColor: Colors.red,
                                                                );
                                                              }
                                                            } catch (ex) {
                                                              setState(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                              showSnackBarMessage(scaffoldKey: _scaffoldKey,
                                                                message: "Failed to Revert Request!",
                                                                fillColor: Colors.red,
                                                              );
                                                            }
                                                          },
                                                          child: Text('Revert'),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: Colors.red),
                                                          onPressed: () async {
                                                            await showDialog(barrierDismissible: false,
                                                                context: context,
                                                                builder: (BuildContext context) {return addNotesDialogBox(context);});

                                                            if (isActionCanceled) {isActionCanceled = false;return;}
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            try {
                                                              final response =
                                                                  await _apiService.approvalLetterRequest(_requestId, note, 'Rejected');
                                                              if (response.statusCode == 200) {
                                                                setState(() {_isLoading = false;});
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text("Successfully"),
                                                                      content: Text("Successfully Rejected Request!"),
                                                                      actions: [
                                                                        FlatButton(
                                                                          child:  Text("OK"),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(LETTER_PAGE, arguments: LetterPageScreen.LetterLM);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              } else {
                                                                setState(() {_isLoading = false;});
                                                                showSnackBarMessage(
                                                                  scaffoldKey: _scaffoldKey,
                                                                  message: response.data["message"],
                                                                  fillColor: Colors.red,
                                                                );
                                                              }
                                                            } catch (ex) {
                                                              setState(() {_isLoading = false;
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
                                                    )
                                                  : Container(),
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
        onPressed: () {
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
                note = 'N/A';
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
                initVal: null,
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
                  note = 'N/A';
                  isActionCanceled = true;
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 10,
              ),
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

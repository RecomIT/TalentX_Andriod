import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:recom_app/data/models/id_card_bh_details.dart';

import 'package:recom_app/data/models/Id_card.dart';
import 'package:recom_app/data/models/id_card_details.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';

class IdCardPageDetail extends StatefulWidget {
  final IdCard myIdCard;
  final IdCardBHDetails idCardBH; //My

  const IdCardPageDetail({
    Key key,
    this.myIdCard,
    this.idCardBH,
  }) : super(key: key);

  @override
  _IdCardPageDetailState createState() => _IdCardPageDetailState();
}

class _IdCardPageDetailState extends State<IdCardPageDetail> {
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
    if (widget.myIdCard == null && widget.idCardBH == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
        (route) => false,
      );
    }
    _requestId =
        widget.myIdCard != null ? widget.myIdCard.id : widget.idCardBH.id;
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
        child: (widget.myIdCard == null && widget.idCardBH == null)
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
                  child: FutureBuilder<IdCardDetails>(
                      future: _apiService.getIdCardDetails(_requestId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && !snapshot.hasError) {
                          var idCardDetails = snapshot.data;
                          if (idCardDetails == null) {
                            return Text(
                                'Message : No ID Card Details Available');
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
                                                'ID Card Information Details',
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
                                                'Name : ${idCardDetails.employeeName.trim()}',
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
                                                'Employee Code : ${idCardDetails.employeeCode.trim()}',
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
                                                'Employee Role : ${idCardDetails.employeeRole.trim()}',
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
                                                'Employee Division : ${idCardDetails.employeeDivision.trim()}',
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
                                                'Employee Department : ${idCardDetails.employeeDepartment.trim()}',
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
                                                'Line Manager : ${idCardDetails.lineManager.trim()}',
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
                                                'Requisition Date : ${idCardDetails.requisitionDate.trim()}',
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
                                                'Required Status : ${idCardDetails.requiredStatus.trim()}',
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
                                                'Application Status : ${idCardDetails.applicationStatus.trim()}',
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
                                                  idCardDetails.photo != null ?
                                                  InkWell(
                                                    onTap:  () async {
                                                            var url = idCardDetails.photo;
                                                            print(url);
                                                            if (await canLaunch(url)) {await launch(url);
                                                            } else {
                                                              showSnackBarMessage(
                                                                scaffoldKey: _scaffoldKey,
                                                                message: "No Photo Available!",
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
                                                            "Photo",
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
                                                  SizedBox(width: 10,),
                                                  idCardDetails.attachment != null ?
                                                  InkWell(
                                                    onTap:  () async {
                                                      var url = idCardDetails.attachment;
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
                                                    itemCount: idCardDetails
                                                                .approvalAuthorities ==
                                                            null
                                                        ? 0
                                                        : idCardDetails
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
                                                                  'Name : ${idCardDetails.approvalAuthorities[index].authorityName}',
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
                                                                'Layer :  ${idCardDetails.approvalAuthorities[index].authorityOrder}',
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
                                                                'Status :  ${idCardDetails.approvalAuthorities[index].authorityStatus}',
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
                                                                  'Processed By :  ${idCardDetails.approvalAuthorities[index].processedEmployee}',
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
                                                            !idCardDetails
                                                                    .approvalAuthorities[
                                                                        index]
                                                                    .createdAt
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        'n/a')
                                                                ? Text(
                                                                    'Arrival Time :  ${_dateFormat.format(DateTime.tryParse(idCardDetails.approvalAuthorities[index].createdAt))}',
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
                                                                    'Arrival Time :  ${idCardDetails.approvalAuthorities[index].createdAt}',
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
                                                                  'Remarks :  ${idCardDetails.approvalAuthorities[index].remarks}',
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
                                              idCardDetails.applicationApproval
                                                  ? Row(
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      kPrimaryColor),
                                                          onPressed: () async {
                                                            await showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return addNotesDialogBox(
                                                                      context);
                                                                });

                                                            if (isActionCanceled) {
                                                              isActionCanceled =
                                                                  false;
                                                              return;
                                                            }
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            try {
                                                              final response =
                                                                  await _apiService
                                                                      .approvalIdCardRequest(
                                                                          _requestId,
                                                                          note,
                                                                          'Approved');
                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                setState(() {
                                                                  _isLoading =
                                                                      false;
                                                                });
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          "Successfully"),
                                                                      content: Text(
                                                                          "Successfully Approved Request!"),
                                                                      actions: [
                                                                        FlatButton(
                                                                          child:
                                                                              new Text("OK"),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(ID_CARD_PAGE,
                                                                                arguments: IdCardPageScreen.IdCard);
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
                                                                  scaffoldKey:
                                                                      _scaffoldKey,
                                                                  message: response
                                                                          .data[
                                                                      "message"],
                                                                  fillColor:
                                                                      Colors
                                                                          .red,
                                                                );
                                                              }
                                                            } catch (ex) {
                                                              setState(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                              showSnackBarMessage(
                                                                scaffoldKey:
                                                                    _scaffoldKey,
                                                                message:
                                                                    "Failed to Approve Request!",
                                                                fillColor:
                                                                    Colors.red,
                                                              );
                                                            }
                                                          },
                                                          child:
                                                              Text('Approve'),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        OutlinedButton(
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      kPrimaryColor),
                                                          onPressed: () async {
                                                            await showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return addNotesDialogBox(
                                                                      context);
                                                                });

                                                            if (isActionCanceled) {
                                                              isActionCanceled =
                                                                  false;
                                                              return;
                                                            }
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            try {
                                                              final response =
                                                                  await _apiService
                                                                      .approvalIdCardRequest(
                                                                          _requestId,
                                                                          note,
                                                                          'Reverted');
                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                setState(() {
                                                                  _isLoading =
                                                                      false;
                                                                });
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          "Successfully"),
                                                                      content: Text(
                                                                          "Successfully Reverted Request!"),
                                                                      actions: [
                                                                        FlatButton(
                                                                          child:
                                                                              new Text("OK"),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(ID_CARD_PAGE,
                                                                                arguments: IdCardPageScreen.IdCard);
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
                                                                  scaffoldKey:
                                                                      _scaffoldKey,
                                                                  message: response
                                                                          .data[
                                                                      "message"],
                                                                  fillColor:
                                                                      Colors
                                                                          .red,
                                                                );
                                                              }
                                                            } catch (ex) {
                                                              setState(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                              showSnackBarMessage(
                                                                scaffoldKey:
                                                                    _scaffoldKey,
                                                                message:
                                                                    "Failed to Revert Request!",
                                                                fillColor:
                                                                    Colors.red,
                                                              );
                                                            }
                                                          },
                                                          child: Text('Revert'),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      Colors
                                                                          .red),
                                                          onPressed: () async {
                                                            await showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return addNotesDialogBox(
                                                                      context);
                                                                });

                                                            if (isActionCanceled) {
                                                              isActionCanceled =
                                                                  false;
                                                              return;
                                                            }
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            try {
                                                              final response =
                                                                  await _apiService
                                                                      .approvalIdCardRequest(
                                                                          _requestId,
                                                                          note,
                                                                          'Rejected');
                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                setState(() {
                                                                  _isLoading =
                                                                      false;
                                                                });
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          "Successfully"),
                                                                      content: Text(
                                                                          "Successfully Rejected Request!"),
                                                                      actions: [
                                                                        FlatButton(
                                                                          child:
                                                                              new Text("OK"),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(ID_CARD_PAGE,
                                                                                arguments: IdCardPageScreen.IdCard);
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
                                                                  scaffoldKey:
                                                                      _scaffoldKey,
                                                                  message: response
                                                                          .data[
                                                                      "message"],
                                                                  fillColor:
                                                                      Colors
                                                                          .red,
                                                                );
                                                              }
                                                            } catch (ex) {
                                                              setState(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                              showSnackBarMessage(
                                                                scaffoldKey:
                                                                    _scaffoldKey,
                                                                message:
                                                                    "Failed to Reject Request!",
                                                                fillColor:
                                                                    Colors.red,
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

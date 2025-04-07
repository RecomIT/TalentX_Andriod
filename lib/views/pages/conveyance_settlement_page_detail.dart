import 'dart:math' as Math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/conveyance.dart';
import 'package:recom_app/data/models/conveyance_info_details.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';

class ConveyanceSettlementPageDetail extends StatefulWidget {
  final Conveyance myConveyance;

  const ConveyanceSettlementPageDetail({
    Key key,
    this.myConveyance,
  }) : super(key: key);

  @override
  _ConveyanceSettlementPageDetailState createState() => _ConveyanceSettlementPageDetailState();
}

class _ConveyanceSettlementPageDetailState extends State<ConveyanceSettlementPageDetail> {
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
    if (widget.myConveyance == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
        (route) => false,
      );
    }
    _requestId = widget.myConveyance.conveyanceId;
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
        child: (widget.myConveyance == null)
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
                  child: FutureBuilder<ConveyanceInfoDetails>(
                      future: _apiService.getConveyanceDetails(_requestId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && !snapshot.hasError) {
                          var conveyanceDetails = snapshot.data;
                          if (conveyanceDetails == null) { 
                            return Text(
                                'Message : No Conveyance Settlement Details Available');
                          } else {
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Conveyance Information Details',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Application Status : ${conveyanceDetails.status.toUpperCase()}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Reference No : ${conveyanceDetails.referenceNo}',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                'Ticket Raise Date : ${conveyanceDetails.applicationDate}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Employee Code : ${conveyanceDetails.employeeCode}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Employee Name : ${conveyanceDetails.employeeName.trim()}',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                'Employee Division : ${conveyanceDetails.division}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                'Employee Department : ${conveyanceDetails.department}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                'Cost Center : ${conveyanceDetails.costCenter}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                'Contact No : ${conveyanceDetails.contactNo}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                'Work Place : ${conveyanceDetails.workPlace}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(height: 10,),

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
                                              Text(
                                                'Line Manager : ${conveyanceDetails.lineManager}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Conveyance Approver (Finance) : ${conveyanceDetails.finalApprover}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(height: 20,),

                                              Row(
                                                children: [
                                                  Text(
                                                    'Conveyance Details',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                    itemCount: conveyanceDetails.conveyanceDetails == null ? 0 : conveyanceDetails.conveyanceDetails.length,
                                                    itemBuilder: (context, index) {
                                                      return Card(
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: 180,
                                                          padding: EdgeInsets.all( 10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Flexible(child: Text('Travel Date : ${conveyanceDetails.conveyanceDetails[index].travelDate}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,)),),
                                                              SizedBox(height: 5,),
                                                              Flexible(child: Text('Purpose :  ${conveyanceDetails.conveyanceDetails[index].purpose}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,))),
                                                              SizedBox(height: 5,),
                                                              Flexible(child: Text('Mode of Transport :  ${conveyanceDetails.conveyanceDetails[index].modeOfTransport}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,))),
                                                              SizedBox(height: 5,),
                                                              Flexible(child: Text('Transport : ${conveyanceDetails.conveyanceDetails[index].transport}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,)),),
                                                              SizedBox(height: 5,),
                                                              Flexible(child: Text('Food :  ${conveyanceDetails.conveyanceDetails[index].food}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,))),
                                                              SizedBox(height: 5,),
                                                              Flexible(child: Text('Other :  ${conveyanceDetails.conveyanceDetails[index].other}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,))),
                                                              SizedBox(height: 5,),
                                                              Flexible(child: Text('Total : ${conveyanceDetails.conveyanceDetails[index].total}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,)),),
                                                              SizedBox(height: 5,),
                                                              // !conveyanceDetails.conveyance.conveyanceDetails[index].createdAt.toLowerCase().contains('n/a')
                                                              //     ? Text('Arrival Time :  ${_dateFormat.format(DateTime.tryParse(conveyanceDetails.conveyance.conveyanceDetails[index].createdAt))}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 12,))
                                                              //     : Text('Arrival Time :  ${conveyanceDetails.conveyance.conveyanceDetails[index].createdAt}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 12,)),
                                                              // SizedBox(height: 5,),
                                                              Flexible(child: Text('Remarks :  ${conveyanceDetails.conveyanceDetails[index].remarks}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,)),),
                                                              SizedBox(height: 5,),
                                                              conveyanceDetails.conveyanceDetails[index].attachment != 'N/A' ?
                                                              InkWell(
                                                                onTap:  () async {
                                                                  var url = conveyanceDetails.conveyanceDetails[index].attachment;
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
                                                                child: Row(
                                                                  children: [
                                                                Text('Attachment : ', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,)),
                                                                    Container(
                                                                      width: 30,
                                                                      //height: 30,
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
                                                                            color: kPrimaryColor,
                                                                            size: 16,//Colors.white,
                                                                          ),
                                                                          // Text(
                                                                          //   "Attachment",
                                                                          //   style: TextStyle(
                                                                          //     fontWeight:
                                                                          //     FontWeight
                                                                          //         .bold,
                                                                          //     fontSize: 10,
                                                                          //     color:
                                                                          //     kPrimaryColor, //Colors.white,
                                                                          //   ),
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ): Container(),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              SizedBox(height: 5,),
                                              Container(
                                                  width:double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  ),
                                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                  child: Text('Total Bill : ${conveyanceDetails.totalBill}',style: TextStyle(color: Colors.white,fontSize: 11),)
                                              ),
                                              SizedBox(height: 20,),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Others',
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
                                              Text(
                                                'CC : ${conveyanceDetails.cc}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Business Head : ${conveyanceDetails.businessHead}',
                                                //${myResignationList[idx].applicationDate}
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

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
                                              SizedBox(height: 5,),
                                              Container(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: conveyanceDetails.approvalAuthorities == null ? 0 : conveyanceDetails.approvalAuthorities.length,
                                                    itemBuilder: (context, index) {
                                                      return Card(
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: 100,
                                                          padding: EdgeInsets.all( 10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Flexible(child: Text('Authority Name : ${conveyanceDetails.approvalAuthorities[index].authorityName}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,)),),
                                                              SizedBox(height: 5,),
                                                              Flexible(child: Text('Layer :  ${conveyanceDetails.approvalAuthorities[index].authorityOrder}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,))),
                                                              SizedBox(height: 5,),
                                                              Flexible(child: Text('Status :  ${conveyanceDetails.approvalAuthorities[index].authorityStatus}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,))),
                                                              SizedBox(height: 5,),
                                                              // Flexible(child: Text('Processed By : ${conveyanceDetails.conveyance.approvalProcesses[index].processedBy}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,)),),
                                                              // SizedBox(height: 5,),
                                                              // Flexible(child: Text('Arrival Time :  ${conveyanceDetails.conveyance.approvalProcesses[index].processedBy}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,))),
                                                              // SizedBox(height: 5,),
                                                              // Flexible(child: Text('Release Time :  ${conveyanceDetails.conveyance.approvalProcesses[index].processedBy}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,))),
                                                              // SizedBox(height: 5,),
                                                              Flexible(child: Text('Remarks : ${conveyanceDetails.approvalAuthorities[index].remarks}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 10,)),),
                                                              //SizedBox(height: 5,),
                                                              // !conveyanceDetails.conveyance.conveyanceDetails[index].createdAt.toLowerCase().contains('n/a')
                                                              //     ? Text('Arrival Time :  ${_dateFormat.format(DateTime.tryParse(conveyanceDetails.conveyance.conveyanceDetails[index].createdAt))}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 12,))
                                                              //     : Text('Arrival Time :  ${conveyanceDetails.conveyance.conveyanceDetails[index].createdAt}', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 12,)),
                                                              // SizedBox(height: 5,),

                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),

                                              // Text(
                                              //   'Application Status : ${conveyanceDetails.applicationStatus.trim()}',
                                              //   //${myResignationList[idx].applicationDate}
                                              //   style: TextStyle(
                                              //     color: Colors.black45,
                                              //     fontWeight: FontWeight.bold,
                                              //     fontSize: 12,
                                              //   ),
                                              // ),
                                              // SizedBox(
                                              //   height: 20,
                                              // ),
                                              // Row(
                                              //   mainAxisAlignment: MainAxisAlignment.start,
                                              //   children: [
                                              //     conveyanceDetails.photo != null ?
                                              //     InkWell(
                                              //       onTap:  () async {
                                              //               var url = conveyanceDetails.photo;
                                              //               print(url);
                                              //               if (await canLaunch(url)) {await launch(url);
                                              //               } else {
                                              //                 showSnackBarMessage(
                                              //                   scaffoldKey: _scaffoldKey,
                                              //                   message: "No Photo Available!",
                                              //                   fillColor: Colors.red,
                                              //                 );
                                              //               }
                                              //             },
                                              //       child: Container(
                                              //         width: 80,
                                              //         padding:
                                              //             EdgeInsets.symmetric(
                                              //           horizontal: 5,
                                              //           vertical: 2,
                                              //         ),
                                              //         decoration: BoxDecoration(
                                              //             borderRadius:
                                              //                 BorderRadius.all(
                                              //               Radius.circular(7),
                                              //             ),
                                              //             //color: kPrimaryColor,
                                              //             border: Border.all(
                                              //                 color:
                                              //                     kPrimaryColor)),
                                              //         child: Column(
                                              //           children: [
                                              //             Icon(
                                              //               Icons.download,
                                              //               color:
                                              //                   kPrimaryColor, //Colors.white,
                                              //             ),
                                              //             Text(
                                              //               "Photo",
                                              //               style: TextStyle(
                                              //                 fontWeight:
                                              //                     FontWeight
                                              //                         .bold,
                                              //                 fontSize: 10,
                                              //                 color:
                                              //                     kPrimaryColor, //Colors.white,
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //     ): Container(),
                                              //     SizedBox(width: 10,),
                                              //     conveyanceDetails.attachment != null ?
                                              //     InkWell(
                                              //       onTap:  () async {
                                              //         var url = conveyanceDetails.attachment;
                                              //         print(url);
                                              //         if (await canLaunch(url)) {await launch(url);
                                              //         } else {
                                              //           showSnackBarMessage(
                                              //             scaffoldKey: _scaffoldKey,
                                              //             message: "No Attachment Available!",
                                              //             fillColor: Colors.red,
                                              //           );
                                              //         }
                                              //       },
                                              //       child: Container(
                                              //         width: 80,
                                              //         padding:
                                              //         EdgeInsets.symmetric(
                                              //           horizontal: 5,
                                              //           vertical: 2,
                                              //         ),
                                              //         decoration: BoxDecoration(
                                              //             borderRadius:
                                              //             BorderRadius.all(
                                              //               Radius.circular(7),
                                              //             ),
                                              //             //color: kPrimaryColor,
                                              //             border: Border.all(
                                              //                 color:
                                              //                 kPrimaryColor)),
                                              //         child: Column(
                                              //           children: [
                                              //             Icon(
                                              //               Icons.download,
                                              //               color:
                                              //               kPrimaryColor, //Colors.white,
                                              //             ),
                                              //             Text(
                                              //               "Attachment",
                                              //               style: TextStyle(
                                              //                 fontWeight:
                                              //                 FontWeight
                                              //                     .bold,
                                              //                 fontSize: 10,
                                              //                 color:
                                              //                 kPrimaryColor, //Colors.white,
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //     ): Container(),
                                              //   ],
                                              // ),
                                              // SizedBox(height: 20,),

                                              // _isLoading
                                              //     ? Center(
                                              //         child:
                                              //             CircularProgressIndicator())
                                              //     : Container(),
                                              // SizedBox(
                                              //   height: 10,
                                              // ), application_approval
                                              SizedBox(height: 5,),
                                              widget.myConveyance.settlementApproval
                                                  ? Row(
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                                                          onPressed: () async {
                                                            await showDialog(barrierDismissible: false,
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return addNotesDialogBox(context);
                                                                });

                                                            if (isActionCanceled) {isActionCanceled = false;return;}
                                                            setState(() {_isLoading = true;});
                                                            try {
                                                              final response =
                                                                  await _apiService.approvalConveyanceSettlementRequest(widget.myConveyance.settlementId, note, 'Approved');
                                                              if (response.statusCode == 200) {setState(() {_isLoading = false;});
                                                                showDialog(context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text("Successfully"),
                                                                      content: Text("Successfully Approved Request!"),
                                                                      actions: [
                                                                        FlatButton(
                                                                          child: new Text("OK"),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(CONVEYANCE_PAGE, arguments: ConveyancePageScreen.ConveyanceSettlement);
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
                                                              setState(() {_isLoading = false;});
                                                              showSnackBarMessage(scaffoldKey: _scaffoldKey,
                                                                message: "Failed to Approve Request!",
                                                                fillColor: Colors.red,
                                                              );
                                                            }
                                                          },
                                                          child: Text('Approve'),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        OutlinedButton(style: OutlinedButton.styleFrom(primary: kPrimaryColor),
                                                          onPressed: () async {
                                                            await showDialog(barrierDismissible: false,
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return addNotesDialogBox(context);});

                                                            if (isActionCanceled) {isActionCanceled = false;return;
                                                            }
                                                            setState(() {_isLoading = true;});
                                                            try {
                                                              final response = await _apiService.approvalConveyanceSettlementRequest(widget.myConveyance.settlementId, note, 'Reverted');
                                                              if (response.statusCode == 200) {
                                                                setState(() {_isLoading = false;});
                                                                showDialog(context: context,
                                                                  builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text("Successfully"),
                                                                      content: Text("Successfully Reverted Request!"),
                                                                      actions: [
                                                                        FlatButton(
                                                                          child: new Text("OK"),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(CONVEYANCE_PAGE, arguments: ConveyancePageScreen.ConveyanceSettlement);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              } else {
                                                                setState(() {_isLoading = false;});
                                                                showSnackBarMessage(scaffoldKey: _scaffoldKey,
                                                                  message: response.data["message"],
                                                                  fillColor: Colors.red,
                                                                );
                                                              }
                                                            } catch (ex) {
                                                              setState(() {_isLoading = false;});
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
                                                          style: ElevatedButton.styleFrom(primary: Colors.red),
                                                          onPressed: () async {
                                                            await showDialog(barrierDismissible: false,
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return addNotesDialogBox(context);});

                                                            if (isActionCanceled) {isActionCanceled = false;return;}
                                                            setState(() {_isLoading = true;});
                                                            try {
                                                              final response = await _apiService.approvalConveyanceSettlementRequest(widget.myConveyance.settlementId, note, 'Rejected');
                                                              if (response.statusCode == 200) {
                                                                setState(() {_isLoading = false;});
                                                                showDialog(context: context, builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                      title: Text("Successfully"),
                                                                      content: Text("Successfully Rejected Request!"),
                                                                      actions: [
                                                                        FlatButton(
                                                                          child: new Text("OK"),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pushNamed(CONVEYANCE_PAGE, arguments: ConveyancePageScreen.ConveyanceSettlement);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              } else {
                                                                setState(() {_isLoading = false;});
                                                                showSnackBarMessage(scaffoldKey: _scaffoldKey,
                                                                  message: response.data["message"],
                                                                  fillColor: Colors.red,
                                                                );
                                                              }
                                                            } catch (ex) {
                                                              setState(() {_isLoading = false;});
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

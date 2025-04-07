import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/policy.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/search_colleague_data.dart';
import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/rounded_bottom_navbar.dart';
import '../widgets/selectable_svg_icon_button.dart';



class PolicesPage extends StatefulWidget {
  @override
  _PolicesPageState createState() => _PolicesPageState();
}

class _PolicesPageState extends State<PolicesPage> {
  User _currentUser;
  ApiService _apiService;
  var dateFormatter = new DateFormat('dd MMM yyyy'); //MMM dd
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;

    final kScreenSize = MediaQuery.of(context).size;
    List<Policy> policies;
    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    height: 90,
                    color: kPrimaryColor,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: kScreenSize.width * 0.05,
                    ),
                    width: kScreenSize.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Policies",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectabelSvgIconButton(
                                text: "Policies",
                                svgFile: "assets/icons/leave_report.svg",
                                onTapFunction: () {
                                  Navigator.of(context).pop();
                                },
                                isSelected: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(
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
                  ),
                  SizedBox(height: 20),
                  FutureBuilder<PolicyData>(
                    future: _apiService.getPolicieList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        policies = snapshot.data.policy.toList();
                        policies.sort((a, b)=>a.displayOrder.compareTo(b.displayOrder));
                        return Column(
                          children: List.generate(
                            policies?.length,
                                (idx) {
                              return  Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
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
                                      width: (kScreenSize.width - 40) * 0.60,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            policies[idx].name,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap: () async {
                                          //     //print('CLICKED');
                                          //     var url = 'tel://${colleagues[idx].phoneNo}';
                                          //     //await launch('tel://$url');
                                          //     if (await canLaunch(url)) {
                                          //       await launch(url);
                                          //     } else {
                                          //       throw 'Could not launch $url';
                                          //     }
                                          //   },
                                          //   child: Row(
                                          //     children: [
                                          //       Icon(Icons.call,size: 16,),
                                          //       Text(' ' + colleagues[idx].phoneNo)
                                          //     ],
                                          //   ),
                                          // ),
                                          // Text(
                                          //   'Created At : ${dateFormatter.format(DateTime.parse(policies[idx].createdAt))
                                          //       } \nUpdated At : ${dateFormatter.format(DateTime.parse(policies[idx].updatedAt))
                                          //   }',
                                          //   style: TextStyle(
                                          //     color: Colors.black45,
                                          //     fontWeight: FontWeight.bold,
                                          //     fontSize: 10,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap:() async {
                                              //print('View PDF Clicked');
                                              //String path = "assets/documents/policy_1.pdf";
                                                var status = await Permission.storage.status;
                                                if (!status.isGranted) {
                                                  status = await Permission.storage.request();
                                                  if (!status.isGranted) {
                                                    showSnackBarMessage(
                                                      scaffoldKey: _scaffoldKey,
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
                                                  final pdfFile = File("${appDocDir.path}/payslip_01_2021.pdf");

                                                if (!pdfFile.existsSync()) {
                                                  bool downloaded = await _apiService.getSalaryPaySlip(01,2021, pdfFile.path);
                                                  if (!downloaded) {
                                                    showSnackBarMessage(
                                                      scaffoldKey: _scaffoldKey,
                                                      message:
                                                      "Sorry, No file found!",
                                                      fillColor: Colors.red,
                                                    );
                                                    return;
                                                  }
                                                }

                                                if (pdfFile.existsSync()) {
                                                  await OpenFile.open(pdfFile.path);
                                                } else {
                                                  showSnackBarMessage(
                                                    scaffoldKey: _scaffoldKey,
                                                    message:
                                                    "Sorry, failed to open policy file,please check your premissions network and connectivity!file!",
                                                    fillColor: Colors.red,
                                                  );
                                                }
                                                } catch (e) {
                                                  showSnackBarMessage(
                                                    scaffoldKey: _scaffoldKey,
                                                    message:
                                                    "Sorry, failed to open policy file, please check your premissions network and connectivity!file!",
                                                    fillColor: Colors.red,
                                                  );
                                                }
                                            },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
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
                                      ],
                                    ),

                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                    },
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
        isActive: true,
      ),
    );
  }
}

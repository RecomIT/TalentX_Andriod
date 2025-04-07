import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/rounded_bottom_navbar.dart';
import '../widgets/selectable_svg_icon_button.dart';
import '../widgets/small_selectable_svg_button.dart';

class PayrollPage extends StatefulWidget {
  @override
  _PayrollPageState createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  User _currentUser;
  ApiService _apiService;
  int month;
  int year;
  bool isLoading = false;

  SelfPayrollScreen pageScreen = SelfPayrollScreen.SelfPayroll;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _apiService = Provider.of<ApiService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
        onTapLeadingIcon: () {
          if (pageScreen == null || pageScreen == SelfPayrollScreen.SelfPayroll) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              pageScreen = SelfPayrollScreen.SelfPayroll;
            });
          }
        },
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
                            "Payroll",
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
                                text: "Payroll",
                                //size: kScreenSize.width * 0.18,//55,
                                svgFile: "assets/icons/payroll_big.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = SelfPayrollScreen.SelfPayroll;
                                  });
                                },
                                isSelected: pageScreen == SelfPayrollScreen.SelfPayroll,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              getPayrollScreen(context),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
        isActive: false,
      ),
    );
  }

  Widget getPayrollScreen(BuildContext context) {
    if (pageScreen == SelfPayrollScreen.SelfPayroll) {
      return Column(

        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.250,
                  child: SmallSelectabelSvgIconButton(
                    isSelected: false,
                    onTapFunction: () {
                      setState(() {
                        pageScreen = SelfPayrollScreen.SalaryPaySlip;
                      });
                    },
                    text: "Payslip",
                    svgFile: "assets/icons/salary_pay_slip.svg",


                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.250,
                  child: SmallSelectabelSvgIconButton(
                    isSelected: false,
                    onTapFunction: () {
                      setState(() {
                        pageScreen = SelfPayrollScreen.TaxCard;
                      });
                    },
                    text: "Tax Card",
                    svgFile: "assets/icons/tax_card.svg",
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.175,
                //   child: SmallSelectabelSvgIconButton(
                //     isSelected: false,
                //     onTapFunction: () {
                //       setState(() {
                //         pageScreen = SelfPayrollScreen.EditYearlyInvestment;
                //       });
                //     },
                //     text: "Edit Yearly Investment",
                //     svgFile: "assets/icons/yearly_investment.svg",
                //   ),
                // ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.175,
                //   child: SmallSelectabelSvgIconButton(
                //     isSelected: false,
                //     onTapFunction: () {
                //       setState(() {
                //         pageScreen = SelfPayrollScreen.GratuityFundInfo;
                //       });
                //     },
                //     text: "Gratuity Fund Info",
                //     svgFile: "assets/icons/gratuity_fund_info.svg",
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.175,
          //         child: SmallSelectabelSvgIconButton(
          //           isSelected: false,
          //           onTapFunction: () {
          //             setState(() {
          //               pageScreen = SelfPayrollScreen.PFSummary;
          //             });
          //           },
          //           text: "PF Summary",
          //           svgFile: "assets/icons/pf_summary.svg",
          //         ),
          //       ),
          //       SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.175,
          //         child: SmallSelectabelSvgIconButton(
          //           isSelected: false,
          //           onTapFunction: () {
          //             setState(() {
          //               pageScreen = SelfPayrollScreen.LoanSummary;
          //             });
          //           },
          //           text: "Loan Summary",
          //           svgFile: "assets/icons/loan_summary.svg",
          //         ),
          //       ),
          //       SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.175,
          //         child: SmallSelectabelSvgIconButton(
          //           isSelected: false,
          //           onTapFunction: () {
          //             setState(() {
          //               pageScreen = SelfPayrollScreen.WPPFSummary;
          //             });
          //           },
          //           text: "WPPF Summary",
          //           svgFile: "assets/icons/wppf_summary.svg",
          //         ),
          //       ),
          //       SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.175,
          //         child: SmallSelectabelSvgIconButton(
          //           isSelected: false,
          //           onTapFunction: () {
          //             setState(() {
          //               pageScreen = SelfPayrollScreen.TaxReturnSubmission;
          //             });
          //           },
          //           text: "Tax Return Submission",
          //           svgFile: "assets/icons/tax_return_submission.svg",
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      );
    } else if (pageScreen == SelfPayrollScreen.SalaryPaySlip) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        width: double.infinity,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Salary Payslip",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(5),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(20)),
                //     color: kPrimaryColor,
                //   ),
                //   child: Transform.rotate(
                //     angle: Math.pi * 0.25,
                //     child: Icon(
                //       Icons.attach_file,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Salary Month  ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(
                left: 7,
                right: 3,
                top: 10,
                bottom: 10,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black26,
                    offset: Offset.fromDirection(Math.pi * .5, 10),
                  ),
                ],
              ),
              child: DropdownButton<int>(
                isDense: false,
                underline: SizedBox(),
                value: month,
                items: List<DropdownMenuItem<int>>.generate(
                  months.length + 1,
                  (idx) => DropdownMenuItem<int>(
                    value: idx == 0 ? null : idx,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        idx == 0 ? "Select Month" : months[idx - 1],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                onChanged: (int mn) {
                  setState(() {
                    month = mn;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Salary Year  ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(
                left: 7,
                right: 3,
                top: 10,
                bottom: 10,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black26,
                    offset: Offset.fromDirection(Math.pi * .5, 10),
                  ),
                ],
              ),
              child: DropdownButton<int>(
                isDense: false,
                underline: SizedBox(),
                value: year,
                items: List<DropdownMenuItem<int>>.generate(
                  years.length + 1,
                  (idx) => DropdownMenuItem<int>(
                    value: idx == 0 ? null : years[idx - 1],
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        idx == 0 ? "Select Year" : years[idx - 1].toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                onChanged: (int yr) {
                  setState(() {
                    year = yr;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // RaisedButton(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(10),
                //     ),
                //   ),
                //   child: isLoading
                //       ? SizedBox(
                //           height: 15,
                //           width: 15,
                //           child: CircularProgressIndicator(
                //             backgroundColor: Colors.white,
                //           ),
                //         )
                //       : Text(
                //           "Download",
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white,
                //           ),
                //         ),
                //   onPressed: () async {
                //     if (month == null || year == null) {
                //       showSnackBarMessage(
                //         scaffoldKey: _scaffoldKey,
                //         message: "Please select Month & Year",
                //         fillColor: Colors.red,
                //       );
                //       return;
                //     }
                //     var status = await Permission.storage.status;
                //     if (!status.isGranted) {
                //       status = await Permission.storage.request();
                //       if (!status.isGranted) {
                //         showSnackBarMessage(
                //           scaffoldKey: _scaffoldKey,
                //           message: "Please allow storage permission!",
                //           fillColor: Colors.red,
                //         );
                //         return;
                //       }
                //     }
                //     setState(() {
                //       isLoading = true;
                //     });
                //     try {
                //       Directory appDocDir;
                //                       if(Platform.isAndroid){
                //                         appDocDir = Directory("/storage/emulated/0/Download");
                //                       }
                //                       else if(Platform.isIOS){
                //                         appDocDir = await getApplicationDocumentsDirectory();
                //                       }
                //       final pdfFile = File("${appDocDir.path}/payslip_${month}_$year.pdf");
                //       if (pdfFile.existsSync()) {
                //         print("Already Exists - " + pdfFile.path);
                //         showSnackBarMessage(
                //           scaffoldKey: _scaffoldKey,
                //           message: "Successfully downloaded payslip!",
                //           fillColor: Colors.green,
                //         );
                //         setState(() {
                //           isLoading = false;
                //         });
                //         return;
                //       }
                //       bool downloaded = await _apiService.getSalaryPaySlip(month, year, pdfFile.path);
                //       if (!downloaded) {
                //         showSnackBarMessage(
                //           scaffoldKey: _scaffoldKey,
                //           message:
                //               "Sorry, failed to download payslip! Please check your premissions and network connectivity!",
                //           fillColor: Colors.red,
                //         );
                //       } else {
                //         showSnackBarMessage(
                //           scaffoldKey: _scaffoldKey,
                //           message: "Successfully downloaded payslip!",
                //           fillColor: Colors.green,
                //         );
                //       }
                //       setState(() {
                //         isLoading = false;
                //       });
                //     } catch (e) {
                //       showSnackBarMessage(
                //         scaffoldKey: _scaffoldKey,
                //         message:
                //             "Sorry, failed to download payslip! Please check your premissions and network connectivity!",
                //         fillColor: Colors.red,
                //       );
                //       setState(() {
                //         isLoading = false;
                //       });
                //     }
                //   },
                // ),
              ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.75,
              buttonColor: kPrimaryColor,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),

                child: isLoading
                    ? SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
                    : Text(
                  "View",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (month == null || year == null) {
                    showSnackBarMessage(
                      scaffoldKey: _scaffoldKey,
                      message: "Please select Month & Year",
                      fillColor: Colors.red,
                    );
                    return;
                  }
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
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    Directory appDocDir;
                    if(Platform.isAndroid){
                      appDocDir = Directory("/storage/emulated/0/Download");
                    }
                    else if(Platform.isIOS){
                      appDocDir = await getApplicationDocumentsDirectory();
                    }

                    final pdfFile = File("${appDocDir.path}/payslip_${month}_$year.pdf");

                    if (!pdfFile.existsSync()) {
                      bool downloaded = await _apiService.getSalaryPaySlip(month,year, pdfFile.path);
                      if (!downloaded) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                          "Sorry, No Payslip found for the respective salary month and year!",
                          fillColor: Colors.red,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        return;
                      }
                    }

                    if (pdfFile.existsSync()) {
                      await OpenFile.open(pdfFile.path);
                    } else {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                        "Sorry, failed to open payslip  Please check your premissions network and connectivity!file!",
                        fillColor: Colors.red,
                      );
                    }

                    setState(() {
                      isLoading = false;
                    });
                  } catch (e) {
                    showSnackBarMessage(
                      scaffoldKey: _scaffoldKey,
                      message:
                      "Sorry, failed to open payslip  Please check your premissions network and connectivity!file!",
                      fillColor: Colors.red,
                    );
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
            ),

              ],
            ),
          ],
        ),
      );
    } else if (pageScreen == SelfPayrollScreen.TaxCard) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        width: double.infinity,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tax Card",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(5),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(20)),
                //     color: kPrimaryColor,
                //   ),
                //   child: Transform.rotate(
                //     angle: Math.pi * 0.25,
                //     child: Icon(
                //       Icons.attach_file,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Salary Month  ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(
                left: 7,
                right: 3,
                top: 10,
                bottom: 10,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black26,
                    offset: Offset.fromDirection(Math.pi * .5, 10),
                  ),
                ],
              ),
              child: DropdownButton<int>(
                isDense: true,
                underline: SizedBox(),
                value: month,
                items: List<DropdownMenuItem<int>>.generate(
                  months.length + 1,
                  (idx) => DropdownMenuItem<int>(
                    value: idx == 0 ? null : idx,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        idx == 0 ? "Select Month" : months[idx - 1],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                onChanged: (int mn) {
                  setState(() {
                    month = mn;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Salary Year  ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(
                left: 7,
                right: 3,
                top: 10,
                bottom: 10,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black26,
                    offset: Offset.fromDirection(Math.pi * .5, 10),
                  ),
                ],
              ),
              child: DropdownButton<int>(
                isDense: true,
                underline: SizedBox(),
                value: year,
                items: List<DropdownMenuItem<int>>.generate(
                  years.length + 1,
                  (idx) => DropdownMenuItem<int>(
                    value: idx == 0 ? null : years[idx - 1],
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        idx == 0 ? "Select Year" : years[idx - 1].toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                onChanged: (int yr) {
                  setState(() {
                    year = yr;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // RaisedButton(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(10),
                //     ),
                //   ),
                //   child: isLoading
                //       ? SizedBox(
                //           height: 15,
                //           width: 15,
                //           child: CircularProgressIndicator(
                //             backgroundColor: Colors.white,
                //           ),
                //         )
                //       : Text(
                //           "Download",
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white,
                //           ),
                //         ),
                //   onPressed: () async {
                //     if (month == null || year == null) {
                //       showSnackBarMessage(
                //         scaffoldKey: _scaffoldKey,
                //         message: "Please select Month & Year",
                //         fillColor: Colors.red,
                //       );
                //       return;
                //     }
                //     var status = await Permission.storage.status;
                //     if (!status.isGranted) {
                //       status = await Permission.storage.request();
                //       if (!status.isGranted) {
                //         showSnackBarMessage(
                //           scaffoldKey: _scaffoldKey,
                //           message: "Please allow storage permission!",
                //           fillColor: Colors.red,
                //         );
                //         return;
                //       }
                //     }
                //     setState(() {
                //       isLoading = true;
                //     });
                //     try {
                //       Directory appDocDir;
                //                       if(Platform.isAndroid){
                //                         appDocDir = Directory("/storage/emulated/0/Download");
                //                       }
                //                       else if(Platform.isIOS){
                //                         appDocDir = await getApplicationDocumentsDirectory();
                //                       }
                //       final pdfFile = File("${appDocDir.path}/txc_${month}_$year.pdf");
                //       if (pdfFile.existsSync()) {
                //         print("Already Exists - " + pdfFile.path);
                //         showSnackBarMessage(
                //           scaffoldKey: _scaffoldKey,
                //           message: "Successfully downloaded taxcard!",
                //           fillColor: Colors.green,
                //         );
                //         setState(() {
                //           isLoading = false;
                //         });
                //         return;
                //       }
                //       bool downloaded = await _apiService.getTaxCard(month, year, pdfFile.path);
                //       if (!downloaded) {
                //         showSnackBarMessage(
                //           scaffoldKey: _scaffoldKey,
                //           message:
                //               "Sorry, failed to download taxcard! Please check your premissions and network connectivity!",
                //           fillColor: Colors.red,
                //         );
                //       } else {
                //         showSnackBarMessage(
                //           scaffoldKey: _scaffoldKey,
                //           message: "Successfully downloaded taxcard!",
                //           fillColor: Colors.green,
                //         );
                //       }
                //       setState(() {
                //         isLoading = false;
                //       });
                //     } catch (e) {
                //       showSnackBarMessage(
                //         scaffoldKey: _scaffoldKey,
                //         message:
                //             "Sorry, failed to download taxcard! Please check your premissions and network connectivity!",
                //         fillColor: Colors.red,
                //       );
                //       setState(() {
                //         isLoading = false;
                //       });
                //     }
                //   },
                // ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.75,
                  buttonColor: kPrimaryColor,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                      : Text(
                    "View",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (month == null || year == null) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message: "Please select Month & Year",
                        fillColor: Colors.red,
                      );
                      return;
                    }
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
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Directory appDocDir;
                      if(Platform.isAndroid){
                        appDocDir = Directory("/storage/emulated/0/Download");
                      }
                      else if(Platform.isIOS){
                        appDocDir = await getApplicationDocumentsDirectory();
                      }
                      final pdfFile = File("${appDocDir.path}/txc_${month}_$year.pdf");

                      if (!pdfFile.existsSync()) {
                        bool downloaded = await _apiService.getTaxCard(month, year, pdfFile.path);
                        if (!downloaded) {
                          showSnackBarMessage(
                            scaffoldKey: _scaffoldKey,
                            message:
                            "Sorry, No Tax Card found for the respective salary month and year!",
                            fillColor: Colors.red,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                      }

                      if (pdfFile.existsSync()) {
                        await OpenFile.open(pdfFile.path);
                      } else {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                          "Sorry, failed to open taxcard  Please check your premissions network and connectivity!file!",
                          fillColor: Colors.red,
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                        "Sorry, failed to open taxcard  Please check your premissions network and connectivity!file!",
                        fillColor: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),),

              ],
            ),
          ],
        ),
      );
    }
    else if (pageScreen == SelfPayrollScreen.PFSummary) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        width: double.infinity,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "PF Summary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: kPrimaryColor,
                  ),
                  child: Transform.rotate(
                    angle: Math.pi * 0.25,
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(
                left: 7,
                right: 3,
                top: 10,
                bottom: 10,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black26,
                    offset: Offset.fromDirection(Math.pi * .5, 10),
                  ),
                ],
              ),
              child: DropdownButton<int>(
                isDense: true,
                underline: SizedBox(),
                value: year,
                items: List<DropdownMenuItem<int>>.generate(
                  years.length + 1,
                  (idx) => DropdownMenuItem<int>(
                    value: idx == 0 ? null : years[idx - 1],
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        idx == 0 ? "Select Year" : years[idx - 1].toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                onChanged: (int yr) {
                  setState(() {
                    year = yr;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          "Download",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () async {
                    if (year == null) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message: "Please select Year",
                        fillColor: Colors.red,
                      );
                      return;
                    }
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
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Directory appDocDir;
                      if(Platform.isAndroid){
                        appDocDir = Directory("/storage/emulated/0/Download");
                      }
                      else if(Platform.isIOS){
                        appDocDir = await getApplicationDocumentsDirectory();
                      }
                      final pdfFile = File("${appDocDir.path}/pf_summary_$year.pdf");
                      if (pdfFile.existsSync()) {
                        print("Already Exists - " + pdfFile.path);
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Successfully downloaded PF Summary!",
                          fillColor: Colors.green,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        return;
                      }
                      bool downloaded = await _apiService.getPFSummary(year, pdfFile.path);
                      if (!downloaded) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                              "Sorry, failed to download PF Summary! Please check your premissions and network connectivity!",
                          fillColor: Colors.red,
                        );
                      } else {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Successfully downloaded PF Summary!",
                          fillColor: Colors.green,
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                            "Sorry, failed to download PF Summary! Please check your premissions and network connectivity!",
                        fillColor: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          "View",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () async {
                    if (year == null) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message: "Please select Year",
                        fillColor: Colors.red,
                      );
                      return;
                    }
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
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Directory appDocDir;
                      if(Platform.isAndroid){
                        appDocDir = Directory("/storage/emulated/0/Download");
                      }
                      else if(Platform.isIOS){
                        appDocDir = await getApplicationDocumentsDirectory();
                      }
                      final pdfFile = File("${appDocDir.path}/pf_summary_$year.pdf");

                      if (!pdfFile.existsSync()) {
                        bool downloaded = await _apiService.getPFSummary(year, pdfFile.path);
                        if (!downloaded) {
                          showSnackBarMessage(
                            scaffoldKey: _scaffoldKey,
                            message:
                                "Sorry, failed to download PF Summary! Please check your premissions and network connectivity!",
                            fillColor: Colors.red,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                      }

                      if (pdfFile.existsSync()) {
                        await OpenFile.open(pdfFile.path);
                      } else {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                              "Sorry, failed to open PF Summary! Please check your premissions network and connectivity!file!",
                          fillColor: Colors.red,
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                            "Sorry, failed to open PF Summary! Please check your premissions network and connectivity!file!",
                        fillColor: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else if (pageScreen == SelfPayrollScreen.WPPFSummary) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        width: double.infinity,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "WPPF Summary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: kPrimaryColor,
                  ),
                  child: Transform.rotate(
                    angle: Math.pi * 0.25,
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          "Download",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () async {
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
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Directory appDocDir;
                      if(Platform.isAndroid){
                        appDocDir = Directory("/storage/emulated/0/Download");
                      }
                      else if(Platform.isIOS){
                        appDocDir = await getApplicationDocumentsDirectory();
                      }
                      final pdfFile = File("${appDocDir.path}/wppf_summary.pdf");
                      if (pdfFile.existsSync()) {
                        print("Already Exists - " + pdfFile.path);
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Successfully downloaded WPPF Summary!",
                          fillColor: Colors.green,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        return;
                      }
                      bool downloaded = await _apiService.getWPPFSummary(pdfFile.path);
                      if (!downloaded) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                              "Sorry, failed to download WPPF Summary! Please check your premissions and network connectivity!",
                          fillColor: Colors.red,
                        );
                      } else {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Successfully downloaded WPPF Summary!",
                          fillColor: Colors.green,
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                            "Sorry, failed to download WPPF Summary! Please check your premissions and network connectivity!",
                        fillColor: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          "View",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () async {
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
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Directory appDocDir;
                      if(Platform.isAndroid){
                        appDocDir = Directory("/storage/emulated/0/Download");
                      }
                      else if(Platform.isIOS){
                        appDocDir = await getApplicationDocumentsDirectory();
                      }
                      final pdfFile = File("${appDocDir.path}/wppf_summary.pdf");

                      if (!pdfFile.existsSync()) {
                        bool downloaded = await _apiService.getWPPFSummary(pdfFile.path);
                        if (!downloaded) {
                          showSnackBarMessage(
                            scaffoldKey: _scaffoldKey,
                            message:
                                "Sorry, failed to download WPPF Summary! Please check your premissions and network connectivity!",
                            fillColor: Colors.red,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                      }

                      if (pdfFile.existsSync()) {
                        await OpenFile.open(pdfFile.path);
                      } else {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                              "Sorry, failed to open WPPF Summary! Please check your premissions network and connectivity!file!",
                          fillColor: Colors.red,
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                            "Sorry, failed to open WPPF Summary! Please check your premissions network and connectivity!file!",
                        fillColor: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else if (pageScreen == SelfPayrollScreen.LoanSummary) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        width: double.infinity,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Loan Summary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: kPrimaryColor,
                  ),
                  child: Transform.rotate(
                    angle: Math.pi * 0.25,
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          "Download",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () async {
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
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Directory appDocDir;
                      if(Platform.isAndroid){
                        appDocDir = Directory("/storage/emulated/0/Download");
                      }
                      else if(Platform.isIOS){
                        appDocDir = await getApplicationDocumentsDirectory();
                      }
                      final pdfFile = File("${appDocDir.path}/loan_summary.pdf");
                      if (pdfFile.existsSync()) {
                        print("Already Exists - " + pdfFile.path);
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Successfully downloaded Loan Summary!",
                          fillColor: Colors.green,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        return;
                      }
                      bool downloaded = await _apiService.getLoanSummary(pdfFile.path);
                      if (!downloaded) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                              "Sorry, failed to download Loan Summary! Please check your premissions and network connectivity!",
                          fillColor: Colors.red,
                        );
                      } else {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Successfully downloaded Loan Summary!",
                          fillColor: Colors.green,
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                            "Sorry, failed to download Loan Summary! Please check your premissions and network connectivity!",
                        fillColor: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          "View",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () async {
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
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Directory appDocDir;
                      if(Platform.isAndroid){
                        appDocDir = Directory("/storage/emulated/0/Download");
                      }
                      else if(Platform.isIOS){
                        appDocDir = await getApplicationDocumentsDirectory();
                      }
                      final pdfFile = File("${appDocDir.path}/loan_summary.pdf");

                      if (!pdfFile.existsSync()) {
                        bool downloaded = await _apiService.getLoanSummary(pdfFile.path);
                        if (!downloaded) {
                          showSnackBarMessage(
                            scaffoldKey: _scaffoldKey,
                            message:
                                "Sorry, failed to download Loan Summary! Please check your premissions and network connectivity!",
                            fillColor: Colors.red,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                      }

                      if (pdfFile.existsSync()) {
                        await OpenFile.open(pdfFile.path);
                      } else {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                              "Sorry, failed to open Loan Summary! Please check your premissions network and connectivity!file!",
                          fillColor: Colors.red,
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                            "Sorry, failed to open Loan Summary! Please check your premissions network and connectivity!file!",
                        fillColor: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else if (pageScreen == SelfPayrollScreen.GratuityFundInfo) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        width: double.infinity,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Gratuity Fund Info Summary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: kPrimaryColor,
                  ),
                  child: Transform.rotate(
                    angle: Math.pi * 0.25,
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          "Download",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () async {
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
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Directory appDocDir;
                      if(Platform.isAndroid){
                        appDocDir = Directory("/storage/emulated/0/Download");
                      }
                      else if(Platform.isIOS){
                        appDocDir = await getApplicationDocumentsDirectory();
                      }
                      final pdfFile = File("${appDocDir.path}/gratuity_fund_summary.pdf");
                      if (pdfFile.existsSync()) {
                        print("Already Exists - " + pdfFile.path);
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Successfully downloaded GratuityFundInfo!",
                          fillColor: Colors.green,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        return;
                      }
                      bool downloaded = await _apiService.getGFSummary(pdfFile.path);
                      if (!downloaded) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                              "Sorry, failed to download GratuityFundInfo! Please check your premissions and network connectivity!",
                          fillColor: Colors.red,
                        );
                      } else {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Successfully downloaded GratuityFundInfo!",
                          fillColor: Colors.green,
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                            "Sorry, failed to download GratuityFundInfo! Please check your premissions and network connectivity!",
                        fillColor: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          "View",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  onPressed: () async {
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
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Directory appDocDir;
                      if(Platform.isAndroid){
                        appDocDir = Directory("/storage/emulated/0/Download");
                      }
                      else if(Platform.isIOS){
                        appDocDir = await getApplicationDocumentsDirectory();
                      }
                      final pdfFile = File("${appDocDir.path}/gratuity_fund_summary.pdf");

                      if (!pdfFile.existsSync()) {
                        bool downloaded = await _apiService.getGFSummary(pdfFile.path);
                        if (!downloaded) {
                          showSnackBarMessage(
                            scaffoldKey: _scaffoldKey,
                            message:
                                "Sorry, failed to download GratuityFundInfo! Please check your premissions and network connectivity!",
                            fillColor: Colors.red,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          return;
                        }
                      }

                      if (pdfFile.existsSync()) {
                        await OpenFile.open(pdfFile.path);
                      } else {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message:
                              "Sorry, failed to open GratuityFundInfo! Please check your premissions network and connectivity!file!",
                          fillColor: Colors.red,
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      showSnackBarMessage(
                        scaffoldKey: _scaffoldKey,
                        message:
                            "Sorry, failed to open GratuityFundInfo! Please check your premissions network and connectivity!file!",
                        fillColor: Colors.red,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SizedBox();
  }
}

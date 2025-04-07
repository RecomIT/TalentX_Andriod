import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../data/models/scheduler_request_data.dart';
import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import '../widgets/attendance_page_screens.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/rounded_bottom_navbar.dart';
import '../widgets/scheduler_request_item.dart';
import '../widgets/selectable_svg_icon_button.dart';
import '../widgets/user_schedule_attendance_screen.dart';
import '../widgets/user_time_edit_request_screen.dart';
import '../widgets/wide_filled_button.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  AttendancePageScreen pageScreen;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _dailyAttendanceFormKey = GlobalKey<FormState>();
  final _timeEditFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  ApiService _apiService;
  User _currentUser;
  Location _location;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  List<SchedulerRequest> schedulerRequestList;

  @override
  void initState() {
    super.initState();
    _location = new Location();
    _apiService = Provider.of<ApiService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;
    _currentUser = Provider.of<UserProvider>(context).user;
    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      height: _currentUser.isAdmin ? 120 : 100,
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
                              "Attendance",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SelectabelSvgIconButton(
                                  text: "Self Attendance",
                                  svgFile: "assets/icons/self_attendance.svg",
                                  onTapFunction: () {
                                    if (pageScreen == AttendancePageScreen.SelfAttendance) return;
                                    setState(() {
                                      pageScreen = AttendancePageScreen.SelfAttendance;
                                    });
                                  },
                                  isSelected: pageScreen == AttendancePageScreen.SelfAttendance,
                                ),
                                SelectabelSvgIconButton(
                                  text: _currentUser.isAdmin ? "Attendance" : "Schedule Attendance",
                                  svgFile: "assets/icons/daily_attendance.svg",
                                  paddingVertical: _currentUser.isAdmin ? 27 : 18,
                                  onTapFunction: () async {
                                    if (pageScreen == AttendancePageScreen.Attendance) return;
                                    _serviceEnabled = await _location.serviceEnabled();
                                    if (!_serviceEnabled) {
                                      _serviceEnabled = await _location.requestService();
                                      if (!_serviceEnabled) {
                                        return;
                                      }
                                    }

                                    _permissionGranted = await _location.hasPermission();
                                    if (_permissionGranted == PermissionStatus.denied) {
                                      _permissionGranted = await _location.requestPermission();
                                      if (_permissionGranted != PermissionStatus.granted) {
                                        return;
                                      }
                                    }
                                    setState(() {
                                      pageScreen = AttendancePageScreen.Attendance;
                                    });
                                  },
                                  isSelected: pageScreen == AttendancePageScreen.Attendance,
                                ),
                              ],
                            ),
                            SizedBox(height: _currentUser.isAdmin ? 20 : 0),
                            !_currentUser.isAdmin
                                ? SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SelectabelSvgIconButton(
                                        text: "Home Attendance",
                                        svgFile: "assets/icons/home_attendance.svg",
                                        onTapFunction: () async {
                                          if (pageScreen == AttendancePageScreen.HomeAttendance) return;

                                          _serviceEnabled = await _location.serviceEnabled();
                                          if (!_serviceEnabled) {
                                            _serviceEnabled = await _location.requestService();
                                            if (!_serviceEnabled) {
                                              return;
                                            }
                                          }

                                          _permissionGranted = await _location.hasPermission();
                                          if (_permissionGranted == PermissionStatus.denied) {
                                            _permissionGranted = await _location.requestPermission();
                                            if (_permissionGranted != PermissionStatus.granted) {
                                              return;
                                            }
                                          }
                                          setState(() {
                                            pageScreen = AttendancePageScreen.HomeAttendance;
                                          });
                                        },
                                        isSelected: pageScreen == AttendancePageScreen.HomeAttendance,
                                      ),
                                      SelectabelSvgIconButton(
                                        text: "Schedule Attendance",
                                        svgFile: "assets/icons/schedule_attendance.svg",
                                        onTapFunction: () {
                                          if (pageScreen == AttendancePageScreen.ScheduleAttendance) return;
                                          setState(() {
                                            pageScreen = AttendancePageScreen.ScheduleAttendance;
                                          });
                                        },
                                        isSelected: pageScreen == AttendancePageScreen.ScheduleAttendance,
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                _getAttendaceScreen(),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
        isActive: false,
      ),
    );
  }

  Widget _getAttendaceScreen() {
    switch (pageScreen) {
      case AttendancePageScreen.SelfAttendance:
        return Column(
          children: [
            SelfAttendanceScreen(
              scaffoldKey: _scaffoldKey,
              apiService: _apiService,
            ),
            SizedBox(height: 20),
            !_currentUser.isAdmin
                ? UserTimeEditRequestScreen(
                    scaffoldKey: _scaffoldKey,
                    formKey: _timeEditFormKey,
                  )
                : SizedBox(),
          ],
        );
      case AttendancePageScreen.Attendance:
        return _currentUser.isAdmin
            ?
            // SizedBox()
            AttendaceScreen(
                scaffoldKey: _scaffoldKey,
                dailyAttendanceFormKey: _dailyAttendanceFormKey,
                apiService: _apiService,
              )
            : UserScheduleAttendanceScreen(
                scaffoldKey: _scaffoldKey,
                dailyAttendanceFormKey: _dailyAttendanceFormKey,
                location: _location,
              );
      case AttendancePageScreen.ScheduleAttendance:
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black26,
                offset: Offset.fromDirection(Math.pi * .5, 10),
              )
            ],
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: FutureBuilder<SchedulerRequestData>(
              future: _apiService.getSchedulerRequest(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  schedulerRequestList = snapshot.data.schedulerRequest;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      (schedulerRequestList?.length ?? 0) + 1,
                      (idx) {
                        if (idx == 0) {
                          return Text(
                            "SCHEDULER REQUEST",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          );
                        } else
                          return Column(
                            children: [
                              SchedulerRequestItem(
                                title: snapshot.data.schedulerRequest[idx - 1].scheduler.subject,
                                description: snapshot.data.schedulerRequest[idx - 1].scheduler.details,
                                onApprove: () async {
                                  try {
                                    final response = await _apiService.approveOrRejectSchedulerRequest({
                                      "requestIds": [snapshot.data.schedulerRequest[idx - 1].scheduler.sID],
                                      "remarks": " ",
                                      "action": "Approved"
                                    });
                                    if (response.statusCode == 200) {
                                      showSnackBarMessage(
                                        scaffoldKey: _scaffoldKey,
                                        message: "Approved Scheduler Request!",
                                        fillColor: Colors.green,
                                      );
                                      setState(() {
                                        snapshot.data.schedulerRequest.removeWhere(
                                            (sr) => sr.scheduler.sID == schedulerRequestList[idx - 1].scheduler.sID);
                                      });
                                    } else {
                                      showSnackBarMessage(
                                        scaffoldKey: _scaffoldKey,
                                        message: response.data["message"],
                                        fillColor: Colors.red,
                                      );
                                    }
                                  } catch (ex) {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: "Failed to approve scheduler request!",
                                      fillColor: Colors.red,
                                    );
                                  }
                                },
                                onReject: () async {
                                  try {
                                    final response = await _apiService.approveOrRejectSchedulerRequest({
                                      "requestIds": [snapshot.data.schedulerRequest[idx - 1].scheduler.sID],
                                      "remarks": " ",
                                      "action": "Rejected"
                                    });
                                    if (response.statusCode == 200) {
                                      showSnackBarMessage(
                                        scaffoldKey: _scaffoldKey,
                                        message: "Rejected Scheduler Request!",
                                        fillColor: Colors.green,
                                      );
                                      setState(() {
                                        snapshot.data.schedulerRequest.removeWhere(
                                            (sr) => sr.scheduler.sID == schedulerRequestList[idx - 1].scheduler.sID);
                                      });
                                    } else {
                                      showSnackBarMessage(
                                        scaffoldKey: _scaffoldKey,
                                        message: response.data["message"],
                                        fillColor: Colors.red,
                                      );
                                    }
                                  } catch (ex) {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: "Failed to reject scheduler request!",
                                      fillColor: Colors.red,
                                    );
                                  }
                                },
                              ),
                              idx < snapshot.data.schedulerRequest?.length ? Divider() : SizedBox(),
                            ],
                          );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox();
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        );
      case AttendancePageScreen.HomeAttendance:
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attendance Report (Home)",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : WideFilledButton(
                      buttonText: "Home Attendance",
                      onTapFunction: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final date = DateFormat("y-MM-dd").format(DateTime.now());
                        final time = DateFormat.jm().format(DateTime.now());

                        try {
                          final response = await _apiService.submitAttendance({
                            "AttendanceDate": date,
                            "AttendanceTime": time,
                            "AttendanceType": "In",
                            "AttendanceLocation": "Home"
                          });
                          if (response.statusCode == 200) {
                            showSnackBarMessage(
                              scaffoldKey: _scaffoldKey,
                              message: "Successfully submitted Home Attendace for $date $time!",
                              fillColor: Colors.green,
                            );
                          } else {
                            showSnackBarMessage(
                              scaffoldKey: _scaffoldKey,
                              message: response.data["Message"],
                              fillColor: Colors.red,
                            );
                          }
                        } catch (ex) {
                          showSnackBarMessage(
                            scaffoldKey: _scaffoldKey,
                            message: "Failed to submit Home Attendace!",
                            fillColor: Colors.red,
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
            ],
          ),
        );
      default:
        return SizedBox();
    }
  }
}

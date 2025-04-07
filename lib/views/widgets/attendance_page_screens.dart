import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:recom_app/data/models/attendance_query_list.dart';
import 'package:recom_app/data/models/company_hr_info.dart';
import 'package:recom_app/views/widgets/custom_table.dart';
import 'leave_request_cell.dart';
import 'neomorphic_datetime_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/models/attendance_calendar_data.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import 'neomorphic_radio_list.dart';

class SelfAttendanceScreen extends StatefulWidget {
  SelfAttendanceScreen({
    Key key,
    @required this.scaffoldKey,
    @required this.apiService,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final ApiService apiService;

  @override
  _SelfAttendanceScreenState createState() => _SelfAttendanceScreenState();
}

class _SelfAttendanceScreenState extends State<SelfAttendanceScreen> {
  AttendanceData attendance;
  int month;
  int year;
  CalendarController _calendarController;
  ApiService _apiService;
  bool checkIn = false;
  bool checkOut = false;
  bool daySelected = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    month = DateTime.now().month;
    year = DateTime.now().year;
    _apiService = widget.apiService;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      margin: const EdgeInsets.symmetric(
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
        children: [
          Text(
            "Calendar",
            style: TextStyle(
              color: kSecondaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 7,
                  right: 3,
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      color: Colors.black26,
                      offset: Offset.fromDirection(Math.pi * .5, 10),
                    ),
                  ],
                ),
                child: DropdownButton(
                  isDense: true,
                  underline: SizedBox(),
                  value: month,
                  items: List<DropdownMenuItem<int>>.generate(
                    months?.length,
                    (idx) => DropdownMenuItem<int>(
                      value: idx + 1,
                      child: Text(
                        months[idx],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
              Container(
                padding: EdgeInsets.only(
                  left: 7,
                  right: 3,
                  top: 5,
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      color: Colors.black26,
                      offset: Offset.fromDirection(Math.pi * .5, 10),
                    ),
                  ],
                ),
                child: DropdownButton(
                  isDense: true,
                  underline: SizedBox(),
                  value: year,
                  items: years
                      .map((year) => DropdownMenuItem<int>(
                            value: year,
                            child: Text(
                              year.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (int yr) {
                    this.setState(() {
                      year = yr;
                    });
                  },
                ),
              ),
              RaisedButton(
                visualDensity: VisualDensity.comfortable,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
                child: Text(
                  "Show",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                onPressed: () async {
                  if (month != null && year != null) {
                    setState(() {
                      _calendarController.setFocusedDay(DateTime(year, month = month));
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          FutureBuilder<AttendanceCalendarData>(
              future: _apiService.getAttendanceCalendarData(month, year),
              initialData: AttendanceCalendarData(attendance: []),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  final attendanceMap = Map<DateTime, List<dynamic>>();
                  snapshot.data?.attendance?.forEach((attendance) {
                    attendanceMap[DateTime.tryParse(attendance.attendanceDate)] = [attendance];
                  });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TableCalendar(
                        availableGestures: AvailableGestures.none,
                        onDaySelected: (day, events, holidays) {
                          setState(() {
                            daySelected = true;
                          });
                          if (events != null && events.length > 0) {
                            setState(() {
                              attendance = events[0];
                              checkIn = false;
                              checkOut = day.day == DateTime.now().day &&
                                  day.month == DateTime.now().month &&
                                  day.year == DateTime.now().year &&
                                  attendance.inTime == attendance.outTime;
                            });
                          } else {
                            setState(() {
                              attendance = null;
                              checkIn = day.day == DateTime.now().day &&
                                  day.month == DateTime.now().month &&
                                  day.year == DateTime.now().year;
                              checkOut = false;
                            });
                          }
                        },
                        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                        headerStyle: HeaderStyle(
                            centerHeaderTitle: true,
                            titleTextBuilder: (date, locale) => DateFormat('dd MMM, y').format(date)),
                        calendarController: _calendarController,
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        weekendDays: [
                          DateTime.friday,
                          DateTime.saturday,
                        ],
                        events: attendanceMap,
                      ),
                      Divider(),
                      attendance == null
                          ? SizedBox()
                          : RaisedButton(
                              onPressed: null,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              disabledColor: kPrimaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    attendance?.inTime != null && attendance?.outTime != null
                                        ? "${attendance.inTime} - ${attendance.outTime}"
                                        : " ",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 5),
                      attendance == null
                          ? SizedBox()
                          : RaisedButton(
                              onPressed: null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              disabledColor: kPrimaryColor,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Icon(
                                      Icons.place,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        attendance?.checkinLocation ?? " ",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      !daySelected
                          ? RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              color: kPrimaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.info_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Please select a date!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: null,
                            )
                          : SizedBox(),
                      checkIn
                          ? RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              color: kPrimaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Text(
                                          "Check-In",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ],
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                final date = DateFormat("y-MM-dd").format(DateTime.now());
                                final time = DateFormat.jm().format(DateTime.now());
                                print(date + " " + time);

                                try {
                                  final loc = await Location().getLocation();
                                  final curLoc = await _apiService.getOpenStreetMapLocation(
                                    loc.latitude,
                                    loc.longitude,
                                  );
                                  print(curLoc.displayName);
                                  final response = await _apiService.submitAttendance({
                                    "AttendanceDate": date,
                                    "AttendanceTime": time,
                                    "AttendanceType": "In",
                                    "AttendanceLocation": curLoc.displayName
                                  });
                                  if (response.statusCode == 200) {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message: "Successfully submitted Attendace for $date $time!",
                                      fillColor: Colors.green,
                                    );
                                    setState(() {
                                      checkIn = false;
                                    });
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message: response.data["Message"],
                                      fillColor: Colors.red,
                                    );
                                  }
                                } catch (ex) {
                                  showSnackBarMessage(
                                    scaffoldKey: widget.scaffoldKey,
                                    message: "Failed to submit Attendace!",
                                    fillColor: Colors.red,
                                  );
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            )
                          : SizedBox(),
                      checkOut
                          ? RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                              color: kPrimaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Text(
                                          "Check-Out",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ],
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                final date = DateFormat("y-MM-dd").format(DateTime.now());
                                final time = DateFormat.jm().format(DateTime.now());
                                print(date + " " + time);

                                try {
                                  final loc = await Location().getLocation();
                                  final curLoc = await _apiService.getOpenStreetMapLocation(
                                    loc.latitude,
                                    loc.longitude,
                                  );
                                  print(curLoc.displayName);
                                  final response = await _apiService.submitAttendance({
                                    "AttendanceDate": date,
                                    "AttendanceTime": time,
                                    "AttendanceType": "Out",
                                    "AttendanceLocation": curLoc.displayName
                                  });
                                  if (response.statusCode == 200) {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message: "Successfully submitted Attendace for $date $time!",
                                      fillColor: Colors.green,
                                    );
                                    setState(() {
                                      checkOut = false;
                                    });
                                  } else {
                                    showSnackBarMessage(
                                      scaffoldKey: widget.scaffoldKey,
                                      message: response.data["Message"],
                                      fillColor: Colors.red,
                                    );
                                  }
                                } catch (ex) {
                                  showSnackBarMessage(
                                    scaffoldKey: widget.scaffoldKey,
                                    message: "Failed to submit Attendace!",
                                    fillColor: Colors.red,
                                  );
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Container(
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
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }
}

class AttendaceScreen extends StatefulWidget {
  const AttendaceScreen(
      {Key key,
      @required Key dailyAttendanceFormKey,
      @required GlobalKey<ScaffoldState> scaffoldKey,
      @required this.apiService})
      : _dailyAttendanceFormKey = dailyAttendanceFormKey,
        _scaffoldKey = scaffoldKey,
        super(key: key);

  final Key _dailyAttendanceFormKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final ApiService apiService;

  @override
  _AttendaceScreenState createState() => _AttendaceScreenState();
}

class _AttendaceScreenState extends State<AttendaceScreen> {
  List<String> attendanceType = []; //["Present","Absent",”Late”]
  String fromDate;
  String toDate;
  List<AttendanceQuery> attendanceList;
  String empId;
  String deptId;
  String sDeptId;
  String sSDeptId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
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
            child: Form(
              key: widget._dailyAttendanceFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daily Attendance",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  NeomorphicDatetimePicker(
                    hintText: "From Date",
                    updateValue: (String newValue) {
                      fromDate = newValue;
                    },
                    width: double.infinity,
                  ),
                  SizedBox(height: 10),
                  NeomorphicDatetimePicker(
                    hintText: "To Date",
                    updateValue: (String newValue) {
                      toDate = newValue;
                    },
                    width: double.infinity,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NeomorphicRadio(
                        value: "Present",
                        isSelected: attendanceType.contains("Present"),
                        onChangeFunction: () {
                          setState(() {
                            if (attendanceType.contains("Present")) {
                              attendanceType.remove("Present");
                            } else {
                              attendanceType.add("Present");
                            }
                          });
                        },
                      ),
                      NeomorphicRadio(
                        value: "Absent",
                        isSelected: attendanceType.contains("Absent"),
                        onChangeFunction: () {
                          setState(() {
                            if (attendanceType.contains("Absent")) {
                              attendanceType.remove("Absent");
                            } else {
                              attendanceType.add("Absent");
                            }
                          });
                        },
                      ),
                      NeomorphicRadio(
                        value: "Late",
                        isSelected: attendanceType.contains("Late"),
                        onChangeFunction: () {
                          setState(() {
                            if (attendanceType.contains("Late")) {
                              attendanceType.remove("Late");
                            } else {
                              attendanceType.add("Late");
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // RaisedButton(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(7)),
                      //   ),
                      //   onPressed: () {},
                      //   padding: EdgeInsets.symmetric(vertical: 8),
                      //   color: kPrimaryColor,
                      //   child: Text(
                      //     "Import",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 12,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),

                      // RaisedButton(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(7)),
                      //   ),
                      //   onPressed: () {},
                      //   padding: EdgeInsets.symmetric(vertical: 8),
                      //   color: kPrimaryColor,
                      //   child: Text(
                      //     "Update",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 12,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),

                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          onPressed: () async {
                            if (fromDate == null || toDate == null || fromDate.isEmpty || toDate.isEmpty) {
                              showSnackBarMessage(
                                scaffoldKey: widget._scaffoldKey,
                                fillColor: Colors.red,
                                message: "Please select From Date & To Date!",
                              );
                              return;
                            }
                            final Map<String, dynamic> formData = {
                              "FromDate": fromDate.split("T")[0],
                              "ToDate": toDate.split("T")[0],
                            };
                            if (attendanceType != null && attendanceType.isNotEmpty) {
                              formData["Status"] = attendanceType;
                            }
                            if (empId != null && empId.isNotEmpty) {
                              formData["EmpId"] = empId;
                            }
                            if (deptId != null && deptId.isNotEmpty) {
                              formData["DepartmentCode"] = deptId;
                            }
                            if (sDeptId != null && sDeptId.isNotEmpty) {
                              formData["SubDepartmentCode"] = sDeptId;
                            }
                            if (sSDeptId != null && sSDeptId.isNotEmpty) {
                              formData["SSubDepartmentCode"] = sSDeptId;
                            }
                            try {
                              setState(() {
                                attendanceList = [];
                              });
                              final list = await widget.apiService.attendanceQuery(formData);
                              setState(() {
                                attendanceList = list;
                              });
                            } catch (ex) {
                              showSnackBarMessage(
                                scaffoldKey: widget._scaffoldKey,
                                message: ex.toString().replaceAll("Exception:", ""),
                                fillColor: Colors.red,
                              );
                            }
                          },
                          padding: EdgeInsets.symmetric(vertical: 8),
                          color: kPrimaryColor,
                          child: Text(
                            "Show",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25),
          FutureBuilder<CompanyHRInfo>(
              future: widget.apiService.getCompanyHRInfo(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  return Container(
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Employee Id",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                          child: DropdownButton<String>(
                            isDense: true,
                            underline: SizedBox(),
                            value: empId,
                            items: List<DropdownMenuItem<String>>.generate(
                              snapshot.data.employeeIDs.length,
                              (idx) => DropdownMenuItem<String>(
                                value: snapshot.data.employeeIDs[idx].iD,
                                child: Container(
                                  padding: EdgeInsets.only(left: 20),
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    '#' +
                                        snapshot.data.employeeIDs[idx].iD +
                                        ': ' +
                                        snapshot.data.employeeIDs[idx].name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (String id) {
                              setState(() {
                                empId = id;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Department Id",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                          child: DropdownButton<String>(
                            isDense: true,
                            underline: SizedBox(),
                            value: deptId,
                            items: List<DropdownMenuItem<String>>.generate(
                              snapshot.data.departments.length,
                              (idx) => DropdownMenuItem<String>(
                                value: snapshot.data.departments[idx].departmentCode.toString(),
                                child: Container(
                                  padding: EdgeInsets.only(left: 20),
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    '#' +
                                        snapshot.data.departments[idx].departmentCode.toString() +
                                        ': ' +
                                        snapshot.data.departments[idx].name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (String id) {
                              setState(() {
                                deptId = id;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "SubDepartment Id",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                          child: DropdownButton<String>(
                            isDense: true,
                            underline: SizedBox(),
                            value: sDeptId,
                            items: List<DropdownMenuItem<String>>.generate(
                              snapshot.data.subDepartments.length,
                              (idx) => DropdownMenuItem<String>(
                                value: snapshot.data.subDepartments[idx].subDepartmentCode.toString(),
                                child: Container(
                                  padding: EdgeInsets.only(left: 20),
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    '#' +
                                        snapshot.data.subDepartments[idx].subDepartmentCode.toString() +
                                        ': ' +
                                        snapshot.data.subDepartments[idx].name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (String id) {
                              setState(() {
                                sDeptId = id;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "SSubDepartment Id",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                          child: DropdownButton<String>(
                            isDense: true,
                            underline: SizedBox(),
                            value: sSDeptId,
                            items: List<DropdownMenuItem<String>>.generate(
                              snapshot.data.sSubDepartments.length,
                              (idx) => DropdownMenuItem<String>(
                                value: snapshot.data.sSubDepartments[idx].sSubDepartmentCode.toString(),
                                child: Container(
                                  padding: EdgeInsets.only(left: 20),
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    '#' +
                                        snapshot.data.sSubDepartments[idx].sSubDepartmentCode.toString() +
                                        ': ' +
                                        snapshot.data.sSubDepartments[idx].name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (String id) {
                              setState(() {
                                sSDeptId = id;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox();
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
          SizedBox(height: 20),
          attendanceList == null || attendanceList.isEmpty
              ? SizedBox()
              : Container(
                  height: 400,
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
                  child: ListView.builder(
                    itemCount: attendanceList?.length ?? 0,
                    itemBuilder: (context, idx) => Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CustomTableBody(
                          colSizes: [1, 1],
                          bodyData: [
                            ["Date", attendanceList[idx].date.split("T")[0] ?? " "],
                            ["Day", attendanceList[idx].day ?? " "],
                            ["EmpId", attendanceList[idx].empId ?? " "],
                            ["Name", attendanceList[idx].name ?? " "],
                            ["Status", attendanceList[idx].status ?? " "],
                            ["LateStatus", attendanceList[idx].lateStatus ?? " "],
                            ["InTime", attendanceList[idx].inTime ?? " "],
                            ["OutTime", attendanceList[idx].outTime ?? " "],
                            ["CheckInLocation", attendanceList[idx].checkinLocation ?? " "],
                            ["CheckOutLocation", attendanceList[idx].checkoutLocation ?? " "],
                            ["Remarks", attendanceList[idx].remarks ?? " "],
                            ["Late", attendanceList[idx].lateHour ?? " "],
                            ["WorkingHour", attendanceList[idx].workingHour ?? " "],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

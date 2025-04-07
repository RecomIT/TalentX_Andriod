import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../data/models/employee_id_list.dart';
import '../../data/models/open_street_map_location.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart' as validator;
import 'neomorphic_datetime_picker.dart';
import 'neomorphic_text_form_field.dart';
import 'wide_filled_button.dart';

class UserScheduleAttendanceScreen extends StatefulWidget {
  UserScheduleAttendanceScreen({
    Key key,
    @required this.scaffoldKey,
    @required GlobalKey<FormState> dailyAttendanceFormKey,
    @required Location location,
  })  : _dailyAttendanceFormKey = dailyAttendanceFormKey,
        _location = location,
        super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<FormState> _dailyAttendanceFormKey;
  final Location _location;

  @override
  _UserScheduleAttendanceScreenState createState() => _UserScheduleAttendanceScreenState();
}

class _UserScheduleAttendanceScreenState extends State<UserScheduleAttendanceScreen> {
  ApiService _apiService;

  String _address;
  String _subject;
  String _details;
  String _date;
  String _time;
  List<String> _selectedGuestList = [];
  String _currentGuest;
  List<EmployeeListItem> _guestList;

  @override
  Widget build(BuildContext context) {
    _apiService = Provider.of<ApiService>(context, listen: false);
    return Column(
      children: [
        Container(
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
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          width: double.infinity,
          child: Form(
            key: widget._dailyAttendanceFormKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Scheduler",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget._dailyAttendanceFormKey.currentState.reset();
                        this.setState(() {
                          _subject = null;
                          _details = null;
                          _date = null;
                          _time = null;
                          _currentGuest = null;
                          _selectedGuestList = [];
                        });
                      },
                      child: Icon(
                        Icons.refresh,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Event Subject",
                  onChangeFunction: (String val) {
                    _subject = val;
                  },
                  validatorFunction: validator.validateNotEmpty,
                ),
                SizedBox(height: 5),
                NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Event Details",
                  onChangeFunction: (String val) {
                    _details = val;
                  },
                  numOfMaxLines: 4,
                  validatorFunction: validator.validateNotEmpty,
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: FutureBuilder<OpenStreetMapLocation>(
                    future: widget._location.getLocation().then(
                          (loc) => _apiService.getOpenStreetMapLocation(
                            loc.latitude,
                            loc.longitude,
                          ),
                        ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        _address = snapshot.data.displayName;
                        return Text(snapshot.data.displayName);
                      } else if (snapshot.hasError) {
                        _address = "Unknown";
                        return Text(snapshot.error.toString());
                      } else
                        return Column(
                          children: [
                            Text(
                              "Location",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                            SizedBox(height: 10),
                            CircularProgressIndicator(),
                          ],
                        );
                    },
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NeomorphicDatetimePicker(
                      hintText: "Date",
                      width: MediaQuery.of(context).size.width * 0.375,
                      isTimePicker: false,
                      updateValue: (date) {
                        _date = date;
                      },
                    ),
                    NeomorphicDatetimePicker(
                      hintText: "Time",
                      width: MediaQuery.of(context).size.width * 0.375,
                      isTimePicker: true,
                      updateValue: (time) {
                        _time = time;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                WideFilledButton(
                  buttonText: "Submit",
                  onTapFunction: () async {
                    if (widget._dailyAttendanceFormKey.currentState.validate() && !isInputValid()) {
                      showSnackBarMessage(
                        scaffoldKey: widget.scaffoldKey,
                        message: "Please fill up the form.",
                        fillColor: Colors.red,
                      );
                      return;
                    }
                    try {
                      final response = await _apiService.createScheduler(getFormData());
                      showSnackBarMessage(
                        scaffoldKey: widget.scaffoldKey,
                        message:
                            response.statusCode == 200 ? "Succcessfully Created Scheduler" : response.data["message"],
                        fillColor: response.statusCode == 200 ? Colors.green : Colors.red,
                      );
                    } catch (ex) {
                      showSnackBarMessage(
                        scaffoldKey: widget.scaffoldKey,
                        message: "Failed to Create Scheduler.",
                        fillColor: Colors.red,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
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
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Guest",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<EmployeeIdList>(
                future: _apiService.getEmployeeIds(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    _guestList = snapshot.data.employeeList;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            value: _currentGuest,
                            items: List<DropdownMenuItem<String>>.generate(
                              _guestList?.length,
                              (idx) => DropdownMenuItem<String>(
                                value: _guestList[idx].iD,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  child: _selectedGuestList.contains(_guestList[idx].iD)
                                      ? SizedBox(width: 0, height: 0)
                                      : Text(
                                          _guestList[idx].name,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            onChanged: (String guest) {
                              if (!_selectedGuestList.contains(guest)) {
                                setState(() {
                                  _currentGuest = guest;
                                });
                              }
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedGuestList.add(_currentGuest);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("Sorry, failed to fetch guest list!");
                  }
                  return CircularProgressIndicator();
                },
              ),
              SizedBox(height: 10),
              ...List<Widget>.generate(
                _selectedGuestList?.length ?? 0,
                (idx) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    _guestList.singleWhere((g) => g.iD == _selectedGuestList[idx]).name,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool isInputValid() {
    return _subject != null &&
        _subject.length > 0 &&
        _details != null &&
        _details.length > 0 &&
        _date != null &&
        _date.length > 0 &&
        _time != null &&
        _time.length > 0 &&
        _address != null &&
        _address.length > 0;
  }

  Map<String, dynamic> getFormData() {
    return {
      "Subject": _subject,
      "Details": _details,
      "Location": _address,
      "Date": _date,
      "Time": _time,
      "GuestIds": _selectedGuestList
    };
  }
}

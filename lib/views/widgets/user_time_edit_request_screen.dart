import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/api/api.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart' as validator;
import 'neomorphic_datetime_picker.dart';
import 'neomorphic_text_form_field.dart';
import 'wide_filled_button.dart';

class UserTimeEditRequestScreen extends StatefulWidget {
  UserTimeEditRequestScreen({
    Key key,
    @required this.scaffoldKey,
    @required this.formKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<FormState> formKey;

  @override
  _UserTimeEditRequestScreenState createState() => _UserTimeEditRequestScreenState();
}

class _UserTimeEditRequestScreenState extends State<UserTimeEditRequestScreen> {
  ApiService _apiService;

  String _date;
  String _reason;
  String _inTime;
  String _outTime;

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
            key: widget.formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Time Edit Request",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.formKey.currentState.reset();
                        setState(() {
                          _date = null;
                          _reason = null;
                          _inTime = null;
                          _outTime = null;
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
                NeomorphicDatetimePicker(
                  hintText: "Date",
                  width: double.infinity,
                  isTimePicker: false,
                  updateValue: (date) {
                    _date = date;
                  },
                ),
                SizedBox(height: 5),
                NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Amendment For",
                  onChangeFunction: (String val) {
                    _reason = val;
                  },
                  numOfMaxLines: 4,
                  validatorFunction: validator.validateNotEmpty,
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NeomorphicDatetimePicker(
                      hintText: "In Time",
                      width: MediaQuery.of(context).size.width * 0.375,
                      isTimePicker: true,
                      updateValue: (inTime) {
                        _inTime = inTime;
                      },
                    ),
                    NeomorphicDatetimePicker(
                      hintText: "Out Time",
                      width: MediaQuery.of(context).size.width * 0.375,
                      isTimePicker: true,
                      updateValue: (outTime) {
                        _outTime = outTime;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                WideFilledButton(
                  buttonText: "Submit",
                  onTapFunction: () async {
                    if (widget.formKey.currentState.validate() && !isInputValid()) {
                      showSnackBarMessage(
                        scaffoldKey: widget.scaffoldKey,
                        message: "Please fill up the form.",
                        fillColor: Colors.red,
                      );
                      return;
                    }
                    try {
                      final response = await _apiService.timeEditRequest(getFormData());
                      print(response.statusCode);
                      showSnackBarMessage(
                        scaffoldKey: widget.scaffoldKey,
                        message: response.statusCode == 200
                            ? "Succcessfully Requested For Time Edit"
                            : response.data["message"],
                        fillColor: response.statusCode == 200 || response.statusCode == 201 ? Colors.green : Colors.red,
                      );
                    } catch (ex) {
                      showSnackBarMessage(
                        scaffoldKey: widget.scaffoldKey,
                        message: "Failed to Requst Time Edit.",
                        fillColor: Colors.red,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool isInputValid() {
    return _inTime != null &&
        _inTime.length > 0 &&
        _date != null &&
        _date.length > 0 &&
        _outTime != null &&
        _outTime.length > 0 &&
        _reason != null &&
        _reason.length > 0;
  }

  Map<String, dynamic> getFormData() {
    return {
      "AttendanceDate": _date,
      "InTime": _inTime,
      "OutTime": _outTime,
      "Reason": _reason,
    };
  }
}

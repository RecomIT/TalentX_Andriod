import 'dart:convert';
import 'dart:math' as Math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_datetime_picker.dart';
import '../widgets/neomorphic_text_form_field.dart';
import '../widgets/rounded_bottom_navbar.dart';
import '../widgets/selectable_svg_icon_button.dart';
import '../widgets/wide_filled_button.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  EventsPageScreen pageScreen;
  final _formKey = GlobalKey<FormState>();

  User _currentUser;
  ApiService _apiService;

  String eventName;
  String venue;
  String date;
  String time;
  String details;
  String photo;
  String photoName;

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
                            "Events",
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
                                text: "Events",
                                svgFile: "assets/icons/events.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = EventsPageScreen.CreateEvent;
                                  });
                                },
                                isSelected: pageScreen == EventsPageScreen.CreateEvent,
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
              getEventScreen(),
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

  Widget getEventScreen() {
    if (pageScreen == EventsPageScreen.CreateEvent) {
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
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Events",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _formKey.currentState.reset();
                    this.setState(() {
                      eventName = null;
                      venue = null;
                      date = null;
                      time = null;
                      details = null;
                      photoName = null;
                      photo = null;
                    });
                  },
                  child: Icon(
                    Icons.refresh,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  NeomorphicTextFormField(
                    inputType: TextInputType.text,
                    hintText: "Event Name",
                    onChangeFunction: (String name) {
                      setState(() {
                        eventName = name;
                      });
                    },
                  ),
                  NeomorphicTextFormField(
                    inputType: TextInputType.text,
                    hintText: "Event Venue",
                    onChangeFunction: (String vn) {
                      setState(() {
                        venue = vn;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NeomorphicDatetimePicker(
                        hintText: "Event Date",
                        updateValue: (String dt) {
                          setState(() {
                            date = dt;
                          });
                        },
                        width: MediaQuery.of(context).size.width * 0.365,
                      ),
                      NeomorphicDatetimePicker(
                        hintText: "Event Time",
                        isTimePicker: true,
                        updateValue: (String tm) {
                          setState(() {
                            time = tm;
                          });
                        },
                        width: MediaQuery.of(context).size.width * 0.365,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  NeomorphicTextFormField(
                    inputType: TextInputType.text,
                    numOfMaxLines: 5,
                    hintText: "Event Details",
                    onChangeFunction: (String dtls) {
                      setState(() {
                        details = dtls;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: (MediaQuery.of(context).size.width - 80) * 0.7,
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
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
                        child: Text(
                          photoName ?? "Photo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: photoName == null ? Colors.black45 : Colors.black,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
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
                          final pickedFile = await FilePicker.getFile(
                            type: FileType.custom,
                            allowedExtensions: ["jpeg", "jpg", "png"],
                          );
                          if (pickedFile == null) return;
                          final fileCotent = base64Encode(pickedFile.readAsBytesSync());
                          setState(() {
                            photoName = pickedFile.path.split("/").last;
                            photo = fileCotent;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          width: (MediaQuery.of(context).size.width - 80) * 0.28,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.camera_enhance_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  WideFilledButton(
                    buttonText: "Submit",
                    onTapFunction: () async {
                      if (eventName == null) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Please enter event name!",
                          fillColor: Colors.red,
                        );
                        return;
                      }
                      if (venue == null) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Please enter venue!",
                          fillColor: Colors.red,
                        );
                        return;
                      }
                      if (date == null) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Please select date!",
                          fillColor: Colors.red,
                        );
                        return;
                      }

                      if (time == null) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Please select time!",
                          fillColor: Colors.red,
                        );
                        return;
                      }
                      if (details == null) {
                        showSnackBarMessage(
                          scaffoldKey: _scaffoldKey,
                          message: "Please enter event details!",
                          fillColor: Colors.red,
                        );
                        return;
                      }

                      try {
                        final formData = {
                          "Name": eventName,
                          "Venue": venue,
                          "Date": date,
                          "Time": time,
                          "Details": details,
                        };
                        if (photo != null) formData["Photo"] = photo;

                        final response = await _apiService.createEvent(formData);

                        if (response.statusCode == 200 || response.statusCode == 201) {
                          showSnackBarMessage(
                            scaffoldKey: _scaffoldKey,
                            message: "Successfully create event!",
                            fillColor: Colors.green,
                          );
                          _formKey.currentState.reset();
                          this.setState(() {
                            eventName = null;
                            venue = null;
                            date = null;
                            time = null;
                            details = null;
                            photoName = null;
                            photo = null;
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
                          message: "Failed to create event!",
                          fillColor: Colors.red,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }
}

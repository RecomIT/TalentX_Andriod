import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/user_profile.dart';
import 'package:recom_app/services/google-auth-service.dart';
import 'package:recom_app/views/pages/requisition_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/attendance_overview_chart_data.dart';
import '../../data/models/birthday_data.dart';
import '../../data/models/leave_balance_chart_data.dart';
import '../../data/models/quick_announcement_list.dart';
import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/bar_chart.dart';
import '../widgets/bday_list_item.dart';
import '../widgets/event_list_item.dart';
import '../widgets/feed_list_item.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/pie_chart.dart';
import '../widgets/rounded_bottom_navbar.dart';
import '../widgets/svg_icon_button.dart';
import 'dart:io' as Io;
import 'package:in_app_update/in_app_update.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Future<dynamic> notificationBackgroundHandler(Map<String, dynamic> message) {
  //FlutterAppBadger.updateBadgeCount(1);
  return _HomePageState()._showNotification(message);
}

class _HomePageState extends State<HomePage> {
  int graphState = 0;
  static const TOTAL_GRAPHS = 1;
  //static const TOTAL_GRAPHS = 2;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiService _apiService;
  User _currentUser;
  BasicInfo userBasicInfo;
  ContactInfo userContactInfo;
  PersonalInfo userPersonalInfo;
  String dp;
  Future<UserProfile> _userProfile;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();



  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _userProfile=_apiService.getUserProfile();
    //_saveDeviceToken();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_notification');

    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    _firebaseMessaging.configure(
      onBackgroundMessage:  notificationBackgroundHandler,
      onMessage: notificationBackgroundHandler,
      //  (message) async{
      //print(message["notification"]["title"]);
      //print("New Notification Alert");
      // setState(() {
      //   GlobalVariable.countNotification++;
      // });
      //return;
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: Text('Notification'),
      //         content: Text(
      //             '${message['notification']['title']}\n${message['notification']['body']}'),
      //         actions: <Widget>[
      //           FlatButton(
      //             child: Text('Ok'),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           ),
      //         ],
      //       );
      //     });
      //},
      onResume: (message) async{
        //print(message["notification"]["title"]);
        //print("Application opened from Notification");
        //FlutterAppBadger.removeBadge();
        ///GlobalVariable.countNotification=0;
        Navigator.of(context).pushNamed(NOTIFICATION_PAGE);

      },
      // onLaunch: (Map<String, dynamic> message) async {
      //   print("Application opened onLaunch from Notification");
      //   //Navigator.of(context).pushNamed(NOTIFICATION_PAGE);
      // },
    );
  }

  _saveDeviceToken() async {
    // Get the token for this device
    String fcmToken = await _firebaseMessaging.getToken();
    print('fcmToken: ' + fcmToken.toString());
  }

  @override
  Widget build(BuildContext context) {
    final kScreenSize = MediaQuery.of(context).size;
    print(kScreenSize.toString());
    _currentUser = Provider.of<UserProvider>(context).user;

    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
        leadingIcon: Icon(Icons.login),
        onTapLeadingIcon: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                  title: Text(
                    "Logout Confirmation",
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Do you want to logout?",
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: kPrimaryColor,
                            onPressed: () async {
                              final _prefs =  await SharedPreferences.getInstance();
                              await _prefs.setString(
                                SHARED_PREF_RECOM_USER_KEY,
                                null,
                              );
                              // await _prefs.remove(
                              //   SHARED_PREF_RECOM_USER_KEY,
                              // );
                              _apiService.setAuthToken(null);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                SIGN_IN_PAGE,
                                    (_) => false,
                              );
                            },
                          ),
                          SizedBox(width: 20),
                          RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              "No",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
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
                    height: kScreenSize.height * 0.1,//80,
                    color: kPrimaryColor,
                  ),
                  Container(
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.all(Radius.circular(20)),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       blurRadius: 15,
                    //       color: Colors.black12,
                    //       offset: Offset.fromDirection(Math.pi * .5, 10),
                    //     )
                    //   ],
                    // ),
                    margin: EdgeInsets.only(
                      left: kScreenSize.width * 0.30,
                      right: kScreenSize.width * 0.30,
                      top: kScreenSize.width * 0.08,//15,
                    ),
                    width: kScreenSize.width * 0.5,
                    height: kScreenSize.height * 0.2, //150,
                    child: FutureBuilder<UserProfile>(
                      future: _userProfile,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && !snapshot.hasError) {
                          userBasicInfo = snapshot.data.basicInfo;
                          userContactInfo=snapshot.data.contactInfo;
                          userPersonalInfo= snapshot.data.personalInfo;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 115,
                                height: 115,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 115,
                                      height: 115,
                                      padding: EdgeInsets.all(2.5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(55)),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(55)),
                                          image: DecorationImage(
                                            image: MemoryImage(base64Decode(dp ?? snapshot.data.photo)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              // Text(
                              //   '${userBasicInfo.name}',
                              //   style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Colors.grey[600]),
                              // ),

                            ],
                          );
                        }
                        else
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                      },
                    ),
                  ),
                ],
              ),
              // Stack(
              //   overflow: Overflow.visible,
              //   children: [
              //     Container(
              //       height: 120,
              //       color: kPrimaryColor,
              //     ),
              //     GestureDetector(
              //       onHorizontalDragStart: (dragDetails) {
              //         setState(() {
              //           graphState = (graphState + 1) % TOTAL_GRAPHS;
              //
              //         });
              //       },
              //       child: Container(
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.all(Radius.circular(20)),
              //           boxShadow: [
              //             BoxShadow(
              //               blurRadius: 15,
              //               color: Colors.black26,
              //               offset: Offset.fromDirection(Math.pi * .5, 10),
              //             )
              //           ],
              //         ),
              //         margin: EdgeInsets.only(
              //           left: kScreenSize.width * 0.05,
              //           right: kScreenSize.width * 0.05,
              //           top: 15,
              //         ),
              //         width: kScreenSize.width * 0.9,
              //         height: 210,
              //         child: FutureBuilder<List>(
              //          future: Future.wait([
              //             //_apiService.getAttendanceOverviewChartData(),
              //             _apiService.getLeaveBalanceChartData(),
              //           ]),
              //           builder: (context, AsyncSnapshot<List> snapshot) {
              //             // print('----------Rakib calling-------------');
              //             //print(snapshot.toString());
              //             if (snapshot.hasData && !snapshot.hasError) {
              //               //final AttendanceOverviewChartData attendance = snapshot.data[0];
              //               final LeaveBalanceChartData leave = snapshot.data[0];
              //
              //               return graphState == 0
              //                   ? CustomPieChart(data: leave.leaveBalanceList)
              //                   : CustomBarChart(
              //                       // labels: attendance.labels,
              //                       // values: attendance.valueForLabels,
              //                     );
              //
              //             } else
              //               return Center(
              //                 child: CircularProgressIndicator(),
              //               );
              //           },
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: List.generate(
              //     TOTAL_GRAPHS,
              //     (idx) => Container(
              //       width: idx == graphState ? 20 : 5,
              //       height: 5,
              //       margin: EdgeInsets.symmetric(horizontal: 5),
              //       decoration: BoxDecoration(
              //         color: kPrimaryColor,
              //         borderRadius: BorderRadius.all(Radius.circular(20)),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20),

              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kScreenSize.width * 0.085,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //--------------Rakib----------------
                    // SvgIconButton(
                    //   text: "Attendance",
                    //   svgFile: "assets/icons/attendance.svg",
                    //   onTapFunction: () {
                    //     Navigator.of(context).pushNamed(ATTENDANCE_PAGE);
                    //   },
                    //   paddingHorizontal: 12,
                    // ),
                    SvgIconButton(
                      text: "Payroll",
                      svgFile: "assets/icons/payroll.svg",
                      size: kScreenSize.width * 0.13,//65,
                      onTapFunction: () {
                        Navigator.of(context).pushNamed(PAYROLL_PAGE);
                      },
                      paddingHorizontal: 15,

                    ),
                    Spacer(),
                    SvgIconButton(
                      text: "Leave",
                      svgFile: "assets/icons/leave.svg",
                      size:kScreenSize.width * 0.13,//70,
                      onTapFunction: () {
                        Navigator.of(context).pushNamed(LEAVE_PAGE);
                      },
                      paddingHorizontal: 18,
                    ),
                    Spacer(),
                    SvgIconButton(
                      text: "Travel",
                      svgFile: "assets/icons/promotion.svg",
                      size: kScreenSize.width * 0.13,//65,
                      onTapFunction: () {
                        Navigator.of(context).pushNamed(TRAVEL_PLAN_PAGE,arguments: TravelPlanPageScreen.TravelPlans);
                      },
                      paddingHorizontal: 15,
                    ),

                    //! INFO: HR Utils Excluded
                    // SvgIconButton(
                    //   text: "HR Utils",
                    //   svgFile: "assets/icons/hr_utils.svg",
                    //   onTapFunction: () {},
                    //   paddingHorizontal: 12,
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kScreenSize.width * 0.085,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //! INFO: HR Utils Excluded

                    SvgIconButton(
                      text: "Resignation",
                      svgFile: "assets/icons/leave_report.svg",
                      onTapFunction: () {
                        Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationApplication);
                      },
                      size: kScreenSize.width * 0.13,//65,
                      paddingHorizontal: 15,
                    ),
                    Spacer(),
                    SvgIconButton(
                      text: "Requisition",
                      svgFile: "assets/icons/create_absence.svg",
                      onTapFunction: () {
                        Navigator.of(context).pushNamed(REQUISITION_PAGE); //,arguments:RequisitionPageScreen.VisitingCard
                        },
                      size: kScreenSize.width * 0.13,//65,
                      paddingHorizontal: 15,
                    ),
                    Spacer(),
                    SvgIconButton(
                      text: "Meal Subscription",
                      svgFile: "assets/icons/confirmation.svg",
                      onTapFunction: () {
                        Navigator.of(context).pushNamed(MEAL_SUBSCRIPTION_PAGE);
                      },
                      size: kScreenSize.width * 0.13,//65,
                      paddingHorizontal: 10,
                    ),
                    // SvgIconButton(
                    //   text: "Lunch Subscription",
                    //   svgFile: "assets/icons/confirmation.svg",
                    //   onTapFunction: () {
                    //     Navigator.of(context).pushNamed(LUNCH_SUBSCRIPTION_PAGE,arguments:LunchSubscriptionPageScreen.LunchSubscription);
                    //   },
                    //   size: kScreenSize.width * 0.13,//65,
                    //   paddingHorizontal: 10,
                    // ),

                    //Spacer(),
                    // SvgIconButton(
                    //   text: "Work From Home",
                    //   svgFile: "assets/icons/home_attendance.svg",
                    //   onTapFunction: () {
                    //     Navigator.of(context).pushNamed(WORK_FROM_HOME_PAGE,arguments:WorkFromHomePageScreen.WorkFromHomeApplication);
                    //   },
                    //   size: 65,
                    //   paddingHorizontal: 10,
                    // ),
                    // Spacer(flex: 4,),

                    // SvgIconButton(
                    //   text: "OSD",
                    //   svgFile: "assets/icons/transfer.svg",
                    //   onTapFunction: () {
                    //     //Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationApplication);
                    //   },
                    //   size: 65,
                    //   paddingHorizontal: 15,
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kScreenSize.width * 0.085,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgIconButton(
                      text: "Off-Site Attendance", //"Work From Home",
                      svgFile: "assets/icons/home_attendance.svg",
                      onTapFunction: () {
                        Navigator.of(context).pushNamed(WORK_FROM_HOME_PAGE,arguments:WorkFromHomePageScreen.WorkFromHomeApplication);
                      },
                      size: kScreenSize.width * 0.13,//65,
                      paddingHorizontal: 13,
                    ),
                    Spacer(),
                    SvgIconButton(
                      text: "Conveyance", //"Work From Home",
                      svgFile: "assets/icons/loan_summary.svg",
                      onTapFunction: () {
                        Navigator.of(context).pushNamed(CONVEYANCE_PAGE,arguments:ConveyancePageScreen.ConveyanceApplication);
                      },
                      size: kScreenSize.width * 0.13,//65,
                      paddingHorizontal: 13,
                    ),
                    Spacer(),
                    SvgIconButton(
                      text: "Clearance",
                      svgFile: "assets/icons/daily_attendance.svg",
                      onTapFunction: () {
                        Navigator.of(context).pushNamed(CLEARANCE_PAGE,arguments:ClearancePageScreen.Clearance);
                      },
                      size: kScreenSize.width * 0.13,//65,
                      paddingHorizontal: 10,
                    ),

                    // Spacer(),
                    // SvgIconButton(
                    //   text: "Meal Subscription",
                    //   svgFile: "assets/icons/confirmation.svg",
                    //   onTapFunction: () {
                    //     Navigator.of(context).pushNamed(MEAL_SUBSCRIPTION_PAGE);
                    //   },
                    //   size: kScreenSize.width * 0.13,//65,
                    //   paddingHorizontal: 10,
                    // ),

                    // SvgIconButton(
                    //   text: "Iftar Booking",
                    //   svgFile: "assets/icons/confirmation.svg",
                    //   onTapFunction: () {
                    //     Navigator.of(context).pushNamed(IFTER_SUBSCRIPTION_PAGE,arguments:IfterSubscriptionPageScreen.IfterSubscription);
                    //   },
                    //   size: kScreenSize.width * 0.13,//65,
                    //   paddingHorizontal: 10,
                    // ),


                  ],
                ),
              ),
              //-----------------Rakib---------------------
              //Events Weidge
              //SizedBox(height: 30),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: kScreenSize.width * 0.07,
              //     vertical: 10,
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       InkWell(
              //         onTap: () => Navigator.of(context).pushNamed(EVENTS_PAGE),
              //         child: Text(
              //           "Events",
              //           style: TextStyle(
              //             fontSize: 15,
              //             fontWeight: FontWeight.bold,
              //             color: kPrimaryColor,
              //           ),
              //         ),
              //       ),
              //       InkWell(
              //         onTap: () => Navigator.of(context).pushNamed(EVENTS_PAGE),
              //         child: Text(
              //           "See More",
              //           style: TextStyle(
              //             fontSize: 10,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.black54,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.all(Radius.circular(20)),
              //     boxShadow: [
              //       BoxShadow(
              //         blurRadius: 15,
              //         color: Colors.black26,
              //         offset: Offset.fromDirection(Math.pi * .5, 10),
              //       )
              //     ],
              //   ),
              //   margin: EdgeInsets.symmetric(
              //     horizontal: kScreenSize.width * 0.05,
              //   ),
              //   width: kScreenSize.width * 0.9,
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 15,
              //     vertical: 15,
              //   ),
              //   //-----------------Rakib------------------
              //   // child: FutureBuilder<List>(
              //   //   future: _apiService.getAllEvents(),
              //   //   builder: (context, snapshot) {
              //   //     if (snapshot.hasData && !snapshot.hasError) {
              //   //       return Column(
              //   //         crossAxisAlignment: CrossAxisAlignment.start,
              //   //         children: snapshot.data?.map(
              //   //               (event) {
              //   //                 return EventListItem(
              //   //                   photo: event["Photo"],
              //   //                   name: event["Name"],
              //   //                   details: event["Details"],
              //   //                   date: event["Date"],
              //   //                 );
              //   //               },
              //   //             )?.toList() ??
              //   //             [],
              //   //       );
              //   //     } else if (snapshot.hasError) {
              //   //       return SizedBox();
              //   //     } else {
              //   //       return Center(
              //   //         child: CircularProgressIndicator(),
              //   //       );
              //   //     }
              //   //   },
              //   // ),
              // ),
              SizedBox(height: 20),
              Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: kScreenSize.width * 0.07,
                  //     vertical: 10,
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         "Announcement",
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.bold,
                  //           color: kPrimaryColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.all(Radius.circular(20)),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         blurRadius: 15,
                  //         color: Colors.black12,
                  //         offset: Offset.fromDirection(Math.pi * .5, 10),
                  //       )
                  //     ],
                  //   ),
                  //   margin: EdgeInsets.symmetric(
                  //     horizontal: kScreenSize.width * 0.05,
                  //   ),
                  //   width: kScreenSize.width * 0.9,
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 15,
                  //     vertical: 15,
                  //   ),
                  //   child: FutureBuilder<QuickAnnouncementList>(
                  //     future: _apiService.getQuickAnnouncementList(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData && !snapshot.hasError) {
                  //         return Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: List.generate(
                  //             snapshot.data.quickAnnouncementList?.length ?? 0,
                  //             (idx) {
                  //               final feed = snapshot.data.quickAnnouncementList[idx];
                  //               return Column(
                  //                 children: [
                  //                   FeedListItem(
                  //                     title: feed.title,
                  //                     description: feed.purpose,
                  //                     start: DateFormat.yMMMMd().format(DateTime.parse(feed.startDate)),
                  //                     end: DateFormat.yMMMMd().format(DateTime.parse(feed.endDate)),
                  //                   ),
                  //                   idx == snapshot.data.quickAnnouncementList.length - 1
                  //                       ? SizedBox()
                  //                       : Divider(),
                  //                 ],
                  //               );
                  //             },
                  //           ),
                  //         );
                  //       } else if (snapshot.hasError) {
                  //         return SizedBox();
                  //       } else {
                  //         return SizedBox(
                  //           height: 50,
                  //           child: Center(
                  //             child: CircularProgressIndicator(),
                  //           ),
                  //         );
                  //       }
                  //     },
                  //   ),
                  // )
                ],
              ),
              SizedBox(height: 20),

              // Container(
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.all(Radius.circular(20)),
              //           boxShadow: [
              //             BoxShadow(
              //               blurRadius: 15,
              //               color: Colors.black26,
              //               offset: Offset.fromDirection(Math.pi * .5, 10),
              //             )
              //           ],
              //         ),
              //         margin: EdgeInsets.symmetric(
              //           horizontal: 20,
              //         ),
              //         width: double.infinity,
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 15,
              //           vertical: 15,
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Feed",
              //               style: TextStyle(
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.bold,
              //                 color: kPrimaryColor,
              //               ),
              //             ),
              //             SizedBox(height: 10),
              //             FeedListItem(
              //               title: "dsadas",
              //               description: "dsadasd asdasdasd asdasd",
              //               onTapFunction: () {},
              //             ),
              //             Divider(),
              //             FeedListItem(
              //               title: "dsadas",
              //               description: "dsadasd asdasdasd asdasd",
              //               onTapFunction: () {},
              //             ),
              //             Divider(),
              //             FeedListItem(
              //               title: "dsadas",
              //               description: "dsadasd asdasdasd asdasd",
              //               onTapFunction: () {},
              //             ),
              //           ],
              //         ),
              //       )

              // SizedBox(height: _currentUser.isAdmin ? 30 : 0),
              // _currentUser.isAdmin
              //     ?
              //     Padding(
              //         padding: EdgeInsets.symmetric(
              //           horizontal: kScreenSize.width * 0.05,
              //         ),
              //         child: Column(
              //           children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 SvgIconButton(
              //                   text: "New Joiner",
              //                   size: 50,
              //                   svgFile: "assets/icons/new_joiner.svg",
              //                   paddingHorizontal: 20,
              //                   paddingVertical: 15,
              //                   onTapFunction: () {},
              //                 ),
              //                 SvgIconButton(
              //                   text: "Promotion",
              //                   size: 50,
              //                   svgFile: "assets/icons/promotion.svg",
              //                   paddingHorizontal: 20,
              //                   paddingVertical: 15,
              //                   onTapFunction: () {},
              //                 ),
              //                 SvgIconButton(
              //                   text: "Confirmation",
              //                   size: 50,
              //                   svgFile: "assets/icons/confirmation.svg",
              //                   paddingHorizontal: 20,
              //                   paddingVertical: 15,
              //                   onTapFunction: () {},
              //                 ),
              //               ],
              //             ),
              //             SizedBox(height: 15),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 SvgIconButton(
              //                   text: "Resignation",
              //                   svgFile: "assets/icons/resignation.svg",
              //                   paddingHorizontal: 20,
              //                   paddingVertical: 15,
              //                   onTapFunction: () {},
              //                 ),
              //                 SvgIconButton(
              //                   text: "Transfer",
              //                   svgFile: "assets/icons/transfer.svg",
              //                   paddingHorizontal: 20,
              //                   paddingVertical: 15,
              //                   onTapFunction: () {},
              //                 ),
              //                 SvgIconButton(
              //                   text: "Salary Revision",
              //                   svgFile: "assets/icons/salary_revision.svg",
              //                   paddingHorizontal: 20,
              //                   paddingVertical: 15,
              //                   onTapFunction: () {},
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       )
              //     : SizedBox(),
              //SizedBox(height: _currentUser.isAdmin ? 30 : 0),

              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: kScreenSize.width * 0.07,
              //     vertical: 10,
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         "Birthday",
              //         style: TextStyle(
              //           fontSize: 15,
              //           fontWeight: FontWeight.bold,
              //           color: kPrimaryColor,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.all(Radius.circular(20)),
              //     boxShadow: [
              //       BoxShadow(
              //         blurRadius: 15,
              //         color: Colors.black26,
              //         offset: Offset.fromDirection(Math.pi * .5, 10),
              //       )
              //     ],
              //   ),
              //   margin: EdgeInsets.symmetric(
              //     horizontal: kScreenSize.width * 0.05,
              //   ),
              //   width: kScreenSize.width * 0.9,
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 15,
              //     vertical: 15,
              //   ),
              //
              //   child: FutureBuilder<BirthdayData>(
              //     future: _apiService.getUpcomingBdays(),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData && !snapshot.hasError) {
              //         return Row(
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children:
              //                 snapshot.data.birthday
              //                     .map((bday) => BirthdayListItem(
              //                           photo: getBdAvaterImage(),
              //                           name:  '${bday.first_name} ${bday.middle_name } ${bday.last_name}',
              //                           department:'Date of Birth : ${bday.dob}',
              //                           designation: 'Designation : ${bday.designation_name} ${'\n'}'
              //                               'Department : ${bday.department_name} ${'\n'}'
              //                               'Division : ${bday.division_name}',
              //                           phone:  bday.phone,
              //                         )).toList(),
              //
              //
              //             ),
              //           ],
              //         );
              //       } else if (snapshot.hasError) {
              //         return SizedBox();
              //       } else {
              //         return SizedBox(
              //           height: 50,
              //           child: Center(
              //             child: CircularProgressIndicator(),
              //           ),
              //         );
              //       }
              //     },
              //   ),
              // ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: 0,
      ),
    );
  }

  String getBdAvaterImage() {
    // final bytes = Io.File('/assets/images/bd_avatar.png').readAsBytesSync();
    // String img64 = base64Encode(bytes);
    String BdImage='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';
    return BdImage;
  }

  Future _showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel desc',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
    new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '${message['notification']['title']}',
      '${message['notification']['body']}',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future selectNotification(String payload) async {
    Navigator.of(context).pushNamed(NOTIFICATION_PAGE);
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

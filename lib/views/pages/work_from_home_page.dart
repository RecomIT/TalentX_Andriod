import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/data/providers/UserProvider.dart';
import 'package:recom_app/services/api/api.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/utils/constants.dart';
import 'package:recom_app/views/widgets/flat_app_bar.dart';
import 'package:recom_app/views/widgets/new_travel_plan_screen.dart';
import 'package:recom_app/views/widgets/resignation_application_screen.dart';
import 'package:recom_app/views/widgets/resignation_awaiting_screen.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:recom_app/views/widgets/selectable_svg_icon_button.dart';
import 'package:recom_app/views/widgets/settlement_approval_screen.dart';
import 'package:recom_app/views/widgets/travel_plans_screen.dart';
import 'package:recom_app/views/widgets/settlement_requests_screen.dart';
import 'package:recom_app/views/widgets/work_from_home_application_screen.dart';
import 'package:recom_app/views/widgets/work_from_home_awaiting_screen.dart';

class WorkFromHomePage extends StatefulWidget {
  final WorkFromHomePageScreen initialScreen;

  const WorkFromHomePage ({Key key, this.initialScreen}) : super(key: key);

  @override
  _WorkFromHomePage createState() => _WorkFromHomePage();
}

class _WorkFromHomePage extends State<WorkFromHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  WorkFromHomePageScreen pageScreen;
  User _currentUser;
  ApiService _apiService;

  @override
  void initState() {
    super.initState();
    pageScreen = widget.initialScreen;
    _apiService = Provider.of<ApiService>(context, listen: false);
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
  }

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
                    height: !_currentUser.isAdmin ? 90 : 100,
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
                            "Off-Site Attendance Records",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:  _currentUser.isSupervisor ? MainAxisAlignment.spaceAround : MainAxisAlignment.center ,
                            children: [
                              SelectabelSvgIconButton(
                                text: "My\nApplications",
                                svgFile: "assets/icons/home_attendance.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = WorkFromHomePageScreen.WorkFromHomeApplication;
                                  });
                                },
                                isSelected: pageScreen == WorkFromHomePageScreen.WorkFromHomeApplication,
                              ),
                              _currentUser.isSupervisor ?
                              SelectabelSvgIconButton(
                                text: "Team's Applications",
                                svgFile: "assets/icons/view_leave.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = WorkFromHomePageScreen.WorkFromHomeAwaitingApproval;
                                  });
                                },
                                isSelected: pageScreen == WorkFromHomePageScreen.WorkFromHomeAwaitingApproval,
                              )
                                  : Container(),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SelectabelSvgIconButton(
                              //   text: "New Travel Plan",
                              //   svgFile: "assets/icons/self_leave.svg",
                              //   onTapFunction: () {
                              //     setState(() {
                              //       pageScreen = TravelPlanPageScreen.NewTravelPlan;
                              //     });
                              //   },
                              //   isSelected: pageScreen == TravelPlanPageScreen.NewTravelPlan,
                              // ),
                              // SelectabelSvgIconButton(
                              //   text: "Leave Report",
                              //   svgFile: "assets/icons/leave_report.svg",
                              //   onTapFunction: () {
                              //     setState(() {
                              //       pageScreen = LeavePageScreen.LeaveReport;
                              //     });
                              //   },
                              //   isSelected: pageScreen == LeavePageScreen.LeaveReport,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _getPageScreen(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CREATE_WORK_FROM_HOME_PAGE);
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
        isActive: pageScreen == WorkFromHomePageScreen.WorkFromHomeApplication,
      ),
    );
  }

  Widget _getPageScreen() {
    switch (pageScreen) {
      case WorkFromHomePageScreen.WorkFromHomeApplication:
        return WorkFromHomeApplicationScreen(
          scaffoldKey: _scaffoldKey,
          apiService: _apiService,
          currentUser: _currentUser,);

      case WorkFromHomePageScreen.WorkFromHomeAwaitingApproval:
        return WorkFromHomeAwaitingScreen(
          scaffoldKey: _scaffoldKey,
          apiService: _apiService,
          currentUser: _currentUser,
        );
    // case TravelPlanPageScreen.SettlementApprovalList:
    //   return SettlementApprovalScreen(
    //     scaffoldKey: _scaffoldKey,
    //     apiService: _apiService,
    //     currentUser: _currentUser,
    //   );
      default:
        return SizedBox();
    }
  }

}


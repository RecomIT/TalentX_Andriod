import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/views/widgets/leave_requests_screen.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/holiday_list_screen.dart';
import '../widgets/rounded_bottom_navbar.dart';
import '../widgets/selectable_svg_icon_button.dart';
import '../widgets/user_self_leave_screen.dart';
import '../widgets/view_leave_screen.dart';

class LeavePage extends StatefulWidget {
  final LeavePageScreen initialScreen;

  const LeavePage({Key key, this.initialScreen}) : super(key: key);

  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LeavePageScreen pageScreen;
  User _currentUser;

  ApiService _apiService;

  @override
  void initState() {
    super.initState();
    pageScreen = widget.initialScreen;
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
                            "Leave",
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
                                //size: kScreenSize.width * 0.15,//55,
                                text: "Holiday List",
                                svgFile: "assets/icons/holiday_list.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = LeavePageScreen.HolidayList;
                                  });
                                },
                                isSelected: pageScreen == LeavePageScreen.HolidayList,
                              ),
                              SelectabelSvgIconButton(
                                //size: kScreenSize.width * 0.15,//55,
                                text: "Leave",
                                svgFile: "assets/icons/self_leave.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = LeavePageScreen.SelfLeave;
                                  });
                                },
                                isSelected: pageScreen == LeavePageScreen.SelfLeave,
                              ),
                            ],
                          ),
                            SizedBox(height: 20),
                          !_currentUser.supervisor
                              ? SizedBox()
                              :
                          Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SelectabelSvgIconButton(
                                      //size: kScreenSize.width * 0.15,//55,
                                      text: "Leave Requests",
                                      svgFile: "assets/icons/view_leave.svg",
                                      onTapFunction: () {
                                        setState(() {
                                          pageScreen = LeavePageScreen.LeaveRequests;
                                        });
                                      },
                                      isSelected: pageScreen == LeavePageScreen.LeaveRequests,
                                    ),
                                    // SelectabelSvgIconButton(
                                    //size: kScreenSize.width * 0.18,//55,
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
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
        isActive: pageScreen == LeavePageScreen.SelfLeave,
      ),
    );
  }

  Widget _getPageScreen() {
    switch (pageScreen) {
      case LeavePageScreen.HolidayList:
        return HolidayListScreen(apiService: _apiService);
      case LeavePageScreen.SelfLeave:
        return UserSelfLeaveScreen(
          scaffoldKey: _scaffoldKey,
          apiService: _apiService,
          currentUser: _currentUser,
        );
      case LeavePageScreen.ViewLeave:
        return ViewLeaveScreen(apiService: _apiService);
      case LeavePageScreen.LeaveRequests:
      case LeavePageScreen.LeaveRequests:
        return LeaveRequestsScreen(
      scaffoldKey: _scaffoldKey,
      apiService: _apiService,
      currentUser: _currentUser,
    );
      default:
        return SizedBox();
    }
  }
}

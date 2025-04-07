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

class ResignationPage extends StatefulWidget {
  final ResignationPageScreen initialScreen;

  const ResignationPage ({Key key, this.initialScreen}) : super(key: key);

  @override
  _ResignationPage createState() => _ResignationPage();
}

class _ResignationPage extends State<ResignationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ResignationPageScreen pageScreen;
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
                            "Resignation",
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
                                text: "Resignation Application",
                                svgFile: "assets/icons/self_leave.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = ResignationPageScreen.ResignationApplication;
                                  });
                                },
                                isSelected: pageScreen == ResignationPageScreen.ResignationApplication,
                              ),
                              _currentUser.isSupervisor ?
                              SelectabelSvgIconButton(
                                text: "Awaiting for Approval",
                                svgFile: "assets/icons/view_leave.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = ResignationPageScreen.ResignationAwaitingApproval;
                                  });
                                },
                                isSelected: pageScreen == ResignationPageScreen.ResignationAwaitingApproval,
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
          Navigator.of(context).pushNamed(CREATE_RESIGNATION_PAGE);
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
        isActive: pageScreen == ResignationPageScreen.ResignationApplication,
      ),
    );
  }

  Widget _getPageScreen() {
    switch (pageScreen) {
      case ResignationPageScreen.ResignationApplication:
        return ResignationApplicationScreen(
          scaffoldKey: _scaffoldKey,
          apiService: _apiService,
          currentUser: _currentUser,);

      case ResignationPageScreen.ResignationAwaitingApproval:
        return ResignationAwaitingScreen(
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


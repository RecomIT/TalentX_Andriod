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
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';
import 'package:recom_app/views/widgets/selectable_svg_icon_button.dart';
import 'package:recom_app/views/widgets/settlement_approval_screen.dart';
import 'package:recom_app/views/widgets/travel_plans_screen.dart';
import 'package:recom_app/views/widgets/settlement_requests_screen.dart';

class TravelPlanPage extends StatefulWidget {
  final TravelPlanPageScreen initialScreen;
  
  const TravelPlanPage ({Key key, this.initialScreen}) : super(key: key);

  @override
  _TravelPlanPage createState() => _TravelPlanPage();
}

class _TravelPlanPage extends State<TravelPlanPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TravelPlanPageScreen pageScreen;
  User _currentUser;
  ApiService _apiService;
  bool _isSettlementVisible= false;

  @override
  void initState() {
    super.initState();
    pageScreen = widget.initialScreen;
    _apiService = Provider.of<ApiService>(context, listen: false);
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
    _isBusinessUnit();
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
                            "Travel",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:  MainAxisAlignment.spaceBetween ,
                            children: [
                              SelectabelSvgIconButton(
                                text: "Travel Plans Requests",
                                svgFile: "assets/icons/self_leave.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = TravelPlanPageScreen.TravelPlans;
                                  });
                                },
                                isSelected: pageScreen == TravelPlanPageScreen.TravelPlans,
                              ),
                              SelectabelSvgIconButton(
                                text: "Settlement Requests",
                                svgFile: "assets/icons/view_leave.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = TravelPlanPageScreen.SettlementRequests;
                                  });
                                },
                                isSelected: pageScreen == TravelPlanPageScreen.SettlementRequests,
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          _isSettlementVisible ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectabelSvgIconButton(
                                text: "Settlement Approval List",
                                svgFile: "assets/icons/view_leave.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = TravelPlanPageScreen.SettlementApprovalList;
                                  });
                                },
                                isSelected: pageScreen == TravelPlanPageScreen.SettlementApprovalList,
                              ),
                            ],
                          ) : Container(),
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
          Navigator.of(context).pushNamed(NEW_TRAVEL_PLAN_PAGE);
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
        isActive: pageScreen == TravelPlanPageScreen.TravelPlans,
      ),
    );
  }

  Widget _getPageScreen() {
    switch (pageScreen) {
      case TravelPlanPageScreen.TravelPlans:
        return TravelPlansScreen(
            scaffoldKey: _scaffoldKey,
            apiService: _apiService,
          currentUser: _currentUser,);

      case TravelPlanPageScreen.SettlementRequests:
        return SettlementRequestsScreen(
          scaffoldKey: _scaffoldKey,
          apiService: _apiService,
          currentUser: _currentUser,
        );
      case TravelPlanPageScreen.SettlementApprovalList:
        return SettlementApprovalScreen(
          scaffoldKey: _scaffoldKey,
          apiService: _apiService,
          currentUser: _currentUser,
        );
      default:
        return SizedBox();
    }
  }

  void _isBusinessUnit() async {
    var response =  await _apiService.getBusinessUnit(_currentUser.business_unit_id);
    setState(() {
      if(response){
        _isSettlementVisible = true;
      }
      else{
        _isSettlementVisible = false;
      }
    });

  }
}


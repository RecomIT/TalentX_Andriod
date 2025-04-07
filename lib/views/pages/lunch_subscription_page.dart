import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/views/widgets/id_card_ad_screen.dart';
import 'package:recom_app/views/widgets/id_card_lm_screen.dart';
import 'package:recom_app/views/widgets/id_card_screen.dart';
import 'package:recom_app/views/widgets/lunch_subscription_dashboard_screen.dart';
import 'package:recom_app/views/widgets/lunch_subscription_screen.dart';
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

class LunchSubscriptionPage extends StatefulWidget {
  final LunchSubscriptionPageScreen initialScreen;

  const LunchSubscriptionPage({Key key, this.initialScreen}) : super(key: key);

  @override
  _LunchSubscriptionPageState createState() => _LunchSubscriptionPageState();
}

class _LunchSubscriptionPageState extends State<LunchSubscriptionPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LunchSubscriptionPageScreen pageScreen;
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
                            "Lunch Subscription",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SelectabelSvgIconButton(
                                text: "Subscriptions",
                                textSize: 12,
                                svgFile: "assets/icons/confirmation.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = LunchSubscriptionPageScreen.LunchSubscription;
                                  });
                                },
                                isSelected: pageScreen == LunchSubscriptionPageScreen.LunchSubscription,
                              ),
                              SelectabelSvgIconButton(
                                text: "Dashboard",
                                textSize: 12,
                                svgFile: "assets/icons/view_leave.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = LunchSubscriptionPageScreen.Dashboard;
                                  });
                                },
                                isSelected: pageScreen == LunchSubscriptionPageScreen.Dashboard,
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          // SizedBox(height: 20),
                          // !_currentUser.supervisor
                          //     ? SizedBox()
                          //     :
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     SelectabelSvgIconButton(
                          //       text: "Leave Requests",
                          //       svgFile: "assets/icons/view_leave.svg",
                          //       onTapFunction: () {
                          //         setState(() {
                          //           pageScreen = RequisitionPageScreen.IdCard;
                          //         });
                          //       },
                          //       isSelected: pageScreen == LeavePageScreen.LeaveRequests,
                          //     ),
                          //     // SelectabelSvgIconButton(
                          //     //   text: "Leave Report",
                          //     //   svgFile: "assets/icons/leave_report.svg",
                          //     //   onTapFunction: () {
                          //     //     setState(() {
                          //     //       pageScreen = LeavePageScreen.LeaveReport;
                          //     //     });
                          //     //   },
                          //     //   isSelected: pageScreen == LeavePageScreen.LeaveReport,
                          //     // ),
                          //   ],
                          // ),
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
        isActive: pageScreen == LunchSubscriptionPageScreen.LunchSubscription,
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CREATE_LUNCH_SUBSCRIPTION_PAGE);
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
    );
  }

  Widget _getPageScreen() {
    switch (pageScreen) {
      case LunchSubscriptionPageScreen.LunchSubscription:
        return LunchSubscriptionScreen(apiService: _apiService, scaffoldKey: _scaffoldKey,);

      case LunchSubscriptionPageScreen.Dashboard:
        return LunchSubscriptionDashboardScreen(apiService: _apiService, scaffoldKey: _scaffoldKey,);

      default:
        return SizedBox();
    }
  }
}

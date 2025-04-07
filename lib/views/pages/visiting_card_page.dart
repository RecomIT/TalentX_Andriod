import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/views/widgets/leave_requests_screen.dart';
import 'package:recom_app/views/widgets/visiting_card_ad_screen.dart';
import 'package:recom_app/views/widgets/visiting_card_bh_screen.dart';
import 'package:recom_app/views/widgets/visiting_card_screen.dart';

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

class VisitingCardPage extends StatefulWidget {
  final VisitingCardPageScreen initialScreen;

  const VisitingCardPage({Key key, this.initialScreen}) : super(key: key);

  @override
  _VisitingCardPageState createState() => _VisitingCardPageState();
}

class _VisitingCardPageState extends State<VisitingCardPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  VisitingCardPageScreen pageScreen;
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
                            "Visiting Card",
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
                                text: "Requisition List",
                                textSize: 12,
                                svgFile: "assets/icons/personal_info.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = VisitingCardPageScreen.VisitingCard;
                                  });
                                },
                                isSelected: pageScreen == VisitingCardPageScreen.VisitingCard,
                              ),
                              SelectabelSvgIconButton(
                                text: "Requested List BH",
                                textSize: 12,
                                svgFile: "assets/icons/personal_info.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = VisitingCardPageScreen.VisitingCardBH;
                                  });
                                },
                                isSelected: pageScreen == VisitingCardPageScreen.VisitingCardBH,
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectabelSvgIconButton(
                                text: "Requisition List AD",
                                textSize: 12,
                                svgFile: "assets/icons/personal_info.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = VisitingCardPageScreen.VisitingCardAD;
                                  });
                                },
                                isSelected: pageScreen == VisitingCardPageScreen.VisitingCardAD,
                              ),
                            ],
                          ),
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
                          //           pageScreen = RequisitionPageScreen.VisitingCard;
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
        isActive: pageScreen == VisitingCardPageScreen.VisitingCard,
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CREATE_VISITING_CARD_PAGE);
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
    );
  }

  Widget _getPageScreen() {
    switch (pageScreen) {
      case VisitingCardPageScreen.VisitingCard:
        return VisitingCardScreen(apiService: _apiService);

      case VisitingCardPageScreen.VisitingCardBH:
        return VisitingCardBHScreen(apiService: _apiService);

      case VisitingCardPageScreen.VisitingCardAD:
        return VisitingCardADScreen(apiService: _apiService);

    // case LeavePageScreen.SelfLeave:
    //   return UserSelfLeaveScreen(
    //     scaffoldKey: _scaffoldKey,
    //     apiService: _apiService,
    //     currentUser: _currentUser,
    //   );
    // case RequisitionPageScreen.VisitingCard:
    //   return ViewLeaveScreen(apiService: _apiService);
    // case RequisitionPageScreen.VisitingCard:
    // case RequisitionPageScreen.VisitingCard:
    //   return LeaveRequestsScreen(
    //     scaffoldKey: _scaffoldKey,
    //     apiService: _apiService,
    //     currentUser: _currentUser,
    //   );
      default:
        return SizedBox();
    }
  }
}

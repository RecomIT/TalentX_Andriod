import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/views/widgets/id_card_ad_screen.dart';
import 'package:recom_app/views/widgets/id_card_lm_screen.dart';
import 'package:recom_app/views/widgets/id_card_screen.dart';
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

class IdCardPage extends StatefulWidget {
  final IdCardPageScreen initialScreen;

  const IdCardPage({Key key, this.initialScreen}) : super(key: key);

  @override
  _IdCardPageState createState() => _IdCardPageState();
}

class _IdCardPageState extends State<IdCardPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  IdCardPageScreen pageScreen;
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
                            "ID Card",
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
                                    pageScreen = IdCardPageScreen.IdCard;
                                  });
                                },
                                isSelected: pageScreen == IdCardPageScreen.IdCard,
                              ),
                              SelectabelSvgIconButton(
                                text: "Requested List LM",
                                textSize: 12,
                                svgFile: "assets/icons/personal_info.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = IdCardPageScreen.IdCardLM;
                                  });
                                },
                                isSelected: pageScreen == IdCardPageScreen.IdCardLM,
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
                                    pageScreen = IdCardPageScreen.IdCardAD;
                                  });
                                },
                                isSelected: pageScreen == IdCardPageScreen.IdCardAD,
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
        isActive: pageScreen == IdCardPageScreen.IdCard,
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CREATE_ID_CARD_PAGE);
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
    );
  }

  Widget _getPageScreen() {
    switch (pageScreen) {
      case IdCardPageScreen.IdCard:
        return IdCardScreen(apiService: _apiService);

      case IdCardPageScreen.IdCardLM:
        return IdCardLMScreen(apiService: _apiService);

      case IdCardPageScreen.IdCardAD:
        return IdCardADScreen(apiService: _apiService);

    // case LeavePageScreen.SelfLeave:
    //   return UserSelfLeaveScreen(
    //     scaffoldKey: _scaffoldKey,
    //     apiService: _apiService,
    //     currentUser: _currentUser,
    //   );
    // case RequisitionPageScreen.IdCard:
    //   return ViewLeaveScreen(apiService: _apiService);
    // case RequisitionPageScreen.IdCard:
    // case RequisitionPageScreen.IdCard:
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

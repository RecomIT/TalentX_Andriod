import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/visiting_card.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/views/widgets/leave_requests_screen.dart';
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

class RequisitionPage extends StatefulWidget {

  const RequisitionPage({Key key,}) : super(key: key);

  @override
  _RequisitionPageState createState() => _RequisitionPageState();
}

class _RequisitionPageState extends State<RequisitionPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  User _currentUser;
  ApiService _apiService;
  bool _isTabbed;

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _isTabbed=false;
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
                            "Requisition",
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
                                text: "Visiting Card",
                                svgFile: "assets/icons/personal_info.svg",
                                onTapFunction: () {
                                  Navigator.of(context).pushNamed(VISITING_CARD_PAGE,arguments:VisitingCardPageScreen.VisitingCard); //,
                                },
                                isSelected: false,
                              ),
                              SelectabelSvgIconButton(
                                text: "ID Card",
                                svgFile: "assets/icons/personal_info.svg",
                                onTapFunction: () {
                                  Navigator.of(context).pushNamed(ID_CARD_PAGE,arguments:IdCardPageScreen.IdCard);
                                },
                                isSelected: false,
                              ),
                            ],
                          ),

                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectabelSvgIconButton(
                                text: "Letter",
                                svgFile: "assets/icons/leave_report.svg",
                                onTapFunction: () {
                                  Navigator.of(context).pushNamed(LETTER_PAGE,arguments:LetterPageScreen.Letter); //,
                                },
                                isSelected: false,
                              ),
                              // SelectabelSvgIconButton(
                              //   text: "ID Card",
                              //   svgFile: "assets/icons/personal_info.svg",
                              //   onTapFunction: () {
                              //     Navigator.of(context).pushNamed(ID_CARD_PAGE,arguments:IdCardPageScreen.IdCard);
                              //   },
                              //   isSelected: false,
                              // ),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
        isActive: false,
      ),
      floatingActionButton: _isTabbed ?
      FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CREATE_VISITING_CARD_PAGE);
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      )
      : Container(),
    );
  }

}

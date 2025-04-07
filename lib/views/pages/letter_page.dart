import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:recom_app/views/widgets/id_card_ad_screen.dart';
import 'package:recom_app/views/widgets/id_card_lm_screen.dart';
import 'package:recom_app/views/widgets/id_card_screen.dart';
import 'package:recom_app/views/widgets/letter_lm_screen.dart';
import 'package:recom_app/views/widgets/letter_screen.dart';
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

class LetterPage extends StatefulWidget {
  final LetterPageScreen initialScreen;

  const LetterPage({Key key, this.initialScreen}) : super(key: key);

  @override
  _LetterPageState createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  LetterPageScreen pageScreen;
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
                            "Letter",
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
                                text: "Requested Letters",
                                textSize: 12,
                                svgFile: "assets/icons/leave_report.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = LetterPageScreen.Letter;
                                  });
                                },
                                isSelected: pageScreen == LetterPageScreen.Letter,
                              ),
                              SelectabelSvgIconButton(
                                text: "Req. Letters LM",
                                textSize: 12,
                                svgFile: "assets/icons/leave_report.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = LetterPageScreen.LetterLM;
                                  });
                                },
                                isSelected: pageScreen == LetterPageScreen.LetterLM,
                              ),
                            ],
                          ),
                          // SizedBox(height: 15),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     SelectabelSvgIconButton(
                          //       text: "Requisition List AD",
                          //       textSize: 12,
                          //       svgFile: "assets/icons/personal_info.svg",
                          //       onTapFunction: () {
                          //         setState(() {
                          //           pageScreen = LetterPageScreen.LetterAD;
                          //         });
                          //       },
                          //       isSelected: pageScreen == LetterPageScreen.LetterAD,
                          //     ),
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
        isActive: pageScreen == LetterPageScreen.Letter,
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CREATE_LETTER_PAGE);
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
      ),
    );
  }

  Widget _getPageScreen() {
    switch (pageScreen) {
      case LetterPageScreen.Letter:
        return LetterScreen(apiService: _apiService);

      case LetterPageScreen.LetterLM:
        return LetterLMScreen(apiService: _apiService);

      // case LetterPageScreen.LetterAD:
      //   return LetterADScreen(apiService: _apiService);
      default:
        return SizedBox();
    }
  }
}

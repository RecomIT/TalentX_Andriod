import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/meal_setting.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';

import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/holiday_list_screen.dart';
import '../widgets/rounded_bottom_navbar.dart';
import '../widgets/selectable_svg_icon_button.dart';

class MealSubscriptionPage extends StatefulWidget {
  final MealSubscriptionPageScreen initialScreen;

  const MealSubscriptionPage({Key key, this.initialScreen}) : super(key: key);

  @override
  _MealSubscriptionPageState createState() => _MealSubscriptionPageState();
}

class _MealSubscriptionPageState extends State<MealSubscriptionPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  MealSubscriptionPageScreen pageScreen;
  User _currentUser;
  ApiService _apiService;
  Future<MealSetting> _mealSetting;
  MealSetting mealSetting = MealSetting();

  @override
  void initState() {
    super.initState();
    pageScreen = widget.initialScreen;
    _apiService = Provider.of<ApiService>(context, listen: false);
    _mealSetting = _apiService.getMealSetting();
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
                            "Meal Subscription",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          FutureBuilder<MealSetting>(
                              future: _mealSetting,
                              builder: (context, snapshot) {
                                if (snapshot.hasData && !snapshot.hasError) {
                                  mealSetting = snapshot.data;
                                  //mealSetting.showIftarLink=true;
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: mealSetting.showIftarLink ? MainAxisAlignment.spaceBetween :MainAxisAlignment.center,
                                          children: [
                                            SelectabelSvgIconButton(
                                              //size: kScreenSize.width * 0.15,//55,
                                              text: "Lunch\nSubscription",
                                              svgFile:
                                                  "assets/icons/confirmation.svg",
                                              onTapFunction: () {
                                                Navigator.of(context).pushNamed(
                                                    LUNCH_SUBSCRIPTION_PAGE,
                                                    arguments:
                                                        LunchSubscriptionPageScreen
                                                            .LunchSubscription);
                                              },
                                              isSelected:
                                                  false, //pageScreen == MealSubscriptionPageScreen.HolidayList,
                                            ),
                                            mealSetting.showIftarLink
                                                ? SelectabelSvgIconButton(
                                                    //size: kScreenSize.width * 0.15,//55,
                                                    text: "Iftar\nBooking",
                                                    svgFile:
                                                        "assets/icons/confirmation.svg",
                                                    onTapFunction: () {
                                                      Navigator.of(context).pushNamed(
                                                          IFTER_SUBSCRIPTION_PAGE,
                                                          arguments:
                                                              IfterSubscriptionPageScreen
                                                                  .IfterSubscription);
                                                    },
                                                    isSelected: false)
                                                : Container(),
                                          ],
                                        ),
                                      ]);
                                } else if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
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
    );
  }

// Widget _getPageScreen() {
//   switch (pageScreen) {
//     case MealPageScreen.HolidayList:
//       return HolidayListScreen(apiService: _apiService);
//     case MealPageScreen.SelfMeal:
//       return UserSelfMealScreen(
//         scaffoldKey: _scaffoldKey,
//         apiService: _apiService,
//         currentUser: _currentUser,
//       );
//     case MealPageScreen.ViewMeal:
//       return ViewMealScreen(apiService: _apiService);
//     case MealPageScreen.MealRequests:
//     case MealPageScreen.MealRequests:
//       return MealRequestsScreen(
//     scaffoldKey: _scaffoldKey,
//     apiService: _apiService,
//     currentUser: _currentUser,
//   );
//     default:
//       return SizedBox();
//   }
// }
}

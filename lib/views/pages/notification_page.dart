import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/user.dart';
import 'package:recom_app/data/providers/UserProvider.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';

import '../../data/models/notification_data.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import '../widgets/rounded_bottom_navbar.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiService _apiService;
  User _currentUser;

  NotificationPageScreen pageScreen = NotificationPageScreen.ShowNotification;

  List<NotificationInfo> notificationList;
  int counter=0;
  bool isSwitched = true;

  Future<NotificationData> _allNotificationList;
  Future<NotificationData> _unreadNotificationList;

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _allNotificationList = _apiService.getNotificationList();
    _unreadNotificationList = _apiService.getUnreadNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      key: _scaffoldKey,
      appBar:AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: double.infinity,
                color: kPrimaryColor,
                child: Column(
                  children: [
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: IconButton(
                    //     icon: Icon(
                    //       Icons.arrow_back_ios,
                    //       color: Colors.white,
                    //     ),
                    //     onPressed: () {
                    //       if (pageScreen == NotificationPageScreen.FilterNotification) {
                    //         setState(() {
                    //           pageScreen = NotificationPageScreen.ShowNotification;
                    //         });
                    //       } else {
                    //         Navigator.of(context).pop();
                    //       }
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                    //print(isSwitched);
                                  });
                                },
                                activeTrackColor: Colors.white,
                                activeColor: kPrimaryColor,
                              ),
                              Text(
                                "Unread / All",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   "Notifications",
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 16,
                          //   ),
                          // ),
                          Stack(
                            children: <Widget>[
                              IconButton(icon: Icon(Icons.notifications_active,color: Colors.white,size: 32,),
                                  onPressed: () {
                                  }),
                              Positioned(
                                right: 9,
                                top: 8,
                                child: new Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: FutureBuilder(
                                      future: _apiService.getNotificationCount(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData && !snapshot.hasError) {
                                          counter = snapshot.data;
                                        }
                                        else{counter=0;}
                                        return Text(
                                          counter > 99 ? '99+' : counter.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),

                          // IconButton(
                          //   icon: Icon(
                          //     Icons.refresh,
                          //     color: Colors.white,
                          //   ),
                          //   onPressed: () {},
                          // ),
                          // IconButton(
                          //   icon: Icon(
                          //     Icons.filter_alt_outlined,
                          //     color: Colors.white,
                          //   ),
                          //   onPressed: () {
                          //     if (pageScreen == NotificationPageScreen.FilterNotification) {
                          //       setState(() {
                          //         pageScreen = NotificationPageScreen.ShowNotification;
                          //       });
                          //     } else {
                          //       setState(() {
                          //         pageScreen = NotificationPageScreen.FilterNotification;
                          //       });
                          //     }
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
              _getNotificationScreen(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        },
        child: const Icon(Icons.refresh),
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: 2,
      ),
    );
  }

  Widget _getNotificationScreen() {
    return pageScreen == NotificationPageScreen.ShowNotification
        ? Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () async {
                //print(notificationList.length);
                if (notificationList == null || notificationList?.length == 0) return;
                try {
                  final response = await _apiService.markNotificationListAsRead();

                  if (response.statusCode == 200) {
                    //call noti api
                    setState(() {
                      isSwitched =true;
                    });
                    showSnackBarMessage(
                      scaffoldKey: _scaffoldKey,
                      message: "Successfully marked notifications as seen.",
                      fillColor: Colors.green,
                    );
                  } else {
                    showSnackBarMessage(
                      scaffoldKey: _scaffoldKey,
                      message: response.data["message"],
                      fillColor: Colors.red,
                    );
                  }
                } catch (ex) {
                  showSnackBarMessage(
                    scaffoldKey: _scaffoldKey,
                    message: "Failed to mark notifications as seen.",
                    fillColor: Colors.red,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Mark all as read",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        //SwitchNotificationTab(),
        FutureBuilder<NotificationData>(
          //isSwitched =true => All; false=> unread
          future: isSwitched ? _allNotificationList : _unreadNotificationList, //_apiService.getNotificationList() :  _apiService.getUnreadNotificationList(),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              notificationList = snapshot.data.notification;
              counter=notificationList.length;
              var unReadColor=  Colors.grey[100];
              var readColor=  Colors.white;
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: notificationList.map((noti) {
                    final sentTime = DateTime.now().difference(DateTime.parse(noti.createdAt));

                    final minutes = sentTime.inMinutes;
                    final hours = sentTime.inHours;
                    final days = sentTime.inDays;
                    final notiType= noti.type;

                    String agoMessage = "$minutes minutes ago";
                    if (hours > 0) agoMessage = "$hours hours ago";
                    if (days > 0) agoMessage = "$days days ago";

                    return
                      // Dismissible(
                      // key: Key(noti.id.toString()),
                      // onDismissed: (_) async {
                      //   // try {
                      //   //   final response = await _apiService.deleteNotification(noti.id);
                      //   //   if (response.statusCode == 200) {
                      //   //     setState(() {
                      //   //       notificationList.removeWhere((element) => element.id == noti.id);
                      //   //     });
                      //   //     showSnackBarMessage(
                      //   //       scaffoldKey: _scaffoldKey,
                      //   //       message: "Successfully deleted notification.",
                      //   //       fillColor: Colors.green,
                      //   //     );
                      //   //   } else {
                      //   //     showSnackBarMessage(
                      //   //       scaffoldKey: _scaffoldKey,
                      //   //       message: response.data["message"],
                      //   //       fillColor: Colors.red,
                      //   //     );
                      //   //   }
                      //   // } catch (ex) {
                      //   //   showSnackBarMessage(
                      //   //     scaffoldKey: _scaffoldKey,
                      //   //     message: "Failed to delete notification.",
                      //   //     fillColor: Colors.red,
                      //   //   );
                      //   // }
                      // },
                      // direction: DismissDirection.endToStart,
                      // background: Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 20,
                      //   ),
                      //   color: kPrimaryColor,
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Icon(
                      //       Icons.delete_forever,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      // child:
                      Container(
                        color: !isSwitched ? unReadColor: readColor,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.5,
                          horizontal: 20,
                        ),
                        child:
                        InkWell(
                          onTap: () async =>{
                            //print(_currentUser.isAdmin),
                            if(notiType =='App\\Notifications\\LeaveNotification' && _currentUser.isSupervisor){

                              Navigator.of(context).pushNamed(LEAVE_PAGE,arguments: LeavePageScreen.LeaveRequests)
                            }
                            else if(notiType =='Modules\\TravelPlan\\Notifications\\TravelPlanNotification'){
                              Navigator.of(context).pushNamed(TRAVEL_PLAN_PAGE,arguments: TravelPlanPageScreen.TravelPlans)
                            }

                            else if(notiType =='App\\Notifications\\ResignationNotification' && _currentUser.isSupervisor){
                                Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationAwaitingApproval)
                            }
                            else if(notiType =='App\\Notifications\\ResignationNotification' && !_currentUser.isSupervisor){
                                  Navigator.of(context).pushNamed(RESIGNATION_PAGE,arguments:ResignationPageScreen.ResignationApplication)
                            }
                            else if(notiType =='Modules\\ClearanceAutomation\\Notifications\\ClearanceAutomationNotification'){
                                Navigator.of(context).pushNamed(CLEARANCE_PAGE,arguments:ClearancePageScreen.Clearance)
                            }
                            // else if(notiType =='App\\Notifications\\WorkFromHomeNotification' && !_currentUser.isSupervisor){
                            //         Navigator.of(context).pushNamed(WORK_FROM_HOME_PAGE,arguments: WorkFromHomePageScreen.WorkFromHomeApplication)}
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                noti.data.type,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                noti.data.subject,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                agoMessage,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    //);
                  }).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              );
            } else
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          },
        )
      ],
    )
        : Container();
  }
}

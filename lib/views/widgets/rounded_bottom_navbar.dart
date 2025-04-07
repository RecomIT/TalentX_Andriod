import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';

class RoundedBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final bool isActive;

  const RoundedBottomNavBar({
    Key key,
    @required this.activeIndex,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isAndroid ? 55 :85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
        ),
        child: BottomNavigationBar(
          currentIndex: activeIndex < 0 ? 0 : activeIndex,
          onTap: (idx) {
            if (idx == activeIndex) return;
            switch (idx) {
              case 0:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HOME_PAGE,
                  (_) => false,
                );
                return;
              // case 1:
              //   Navigator.of(context).pushNamed(
              //     LEAVE_PAGE,
              //     arguments: LeavePageScreen.SelfLeave,
              //   );
              //   return;
              case 1:
                Navigator.of(context).pushNamed(COLLEAGUES_PAGE);
                return;
              case 2:
                Navigator.of(context).pushNamed(NOTIFICATION_PAGE);
                return;
              case 3:
                Navigator.of(context).pushNamed(PROFILE_PAGE);
                return;

              default:
                return;
            }
          },
          showUnselectedLabels: true,
          selectedItemColor:
              isActive ? kPrimaryColor : Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
          unselectedItemColor: Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
          selectedLabelStyle: isActive
              ? TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                )
              : TextStyle(
                  fontSize: 10.0,
                  color: Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
                ),
          unselectedLabelStyle: TextStyle(
            fontSize: 10.0,
            color: Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
          ),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/home.svg",
                height: 20,
                width: 20,
                color: this.activeIndex == 0 && isActive
                    ? kPrimaryColor
                    : Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
              ),
              label: "Home",
            ),
            // BottomNavigationBarItem(
            //   icon: SvgPicture.asset(
            //     "assets/icons/create_absence.svg",
            //     height: 20,
            //     width: 20,
            //     color: this.activeIndex == 1 && isActive
            //         ? kPrimaryColor
            //         : Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
            //   ),
            //   label: "Leave Apply",
            // ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/colleagues.svg",
                height: 20,
                width: 20,
                color: this.activeIndex == 1 && isActive
                    ? kPrimaryColor
                    : Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
              ),
              label: "Colleagues",
            ),
            BottomNavigationBarItem(
              icon:  Stack(
                  children: <Widget>[
                     Icon(Icons.notifications_active_outlined),
                     Positioned(  // draw a red marble
                      top: 0.0,
                      right: 0.0,
                      child:  Icon(Icons.brightness_1, size: 8.0,
                          color: Colors.redAccent),
                    )
                  ]
              ),
              // icon: SvgPicture.asset(
              //   "assets/icons/notification.svg",
              //   height: 20,
              //   width: 20,
              //   color: this.activeIndex == 2 && isActive
              //       ? kPrimaryColor
              //       : Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
              // ),
               label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/my_profile.svg",
                height: 20,
                width: 20,
                color: this.activeIndex == 3 && isActive
                    ? kPrimaryColor
                    : Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
              ),
              label: "My Profile ",
            ),

          ],
        ),
      ),
    );
  }
}

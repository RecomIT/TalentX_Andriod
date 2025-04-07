import 'package:flutter/material.dart';

//const kPrimaryColor = const Color.fromARGB(0xff, 0x43, 0x7d, 0xdd);
//const kSecondaryColor = const Color.fromARGB(0xff, 0x17, 0x3d, 0x7b);
const kPrimaryColor = const Color(0xff2891a6);
const kSecondaryColor = const Color(0xff1a788b);

const kFormInputFieldDecoration = const InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(7)),
  ),
  contentPadding: EdgeInsets.all(15),
  hintStyle: TextStyle(fontSize: 16),
);

const months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

List<int> years = List<int>.generate(
  (DateTime.now().year +1) - 2020 + 1,
  (id) => ((DateTime.now().year +1) - id),
);

void showSnackBarMessage({
  @required GlobalKey<ScaffoldState> scaffoldKey,
  @required String message,
  @required Color fillColor,
}) {
  scaffoldKey.currentState.showSnackBar(
    SnackBar(
      // behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: fillColor,
      duration: Duration(seconds: 2),
    ),
  );
}

Color getColorFromNumber(int number) {
  number %= 12;
  switch (number) {
    case 0:
      return Colors.greenAccent;
    case 1:
      return Colors.redAccent;
    case 2:
      return Colors.blueAccent;
    case 3:
      return Colors.pinkAccent;
    case 4:
      return Colors.purpleAccent;
    case 5:
      return Colors.yellowAccent;
    case 6:
      return Colors.cyanAccent;
    case 7:
      return Colors.orangeAccent;
    case 8:
      return Colors.green;
    case 9:
      return Colors.red;
    case 10:
      return Colors.blue;
    case 11:
      return Colors.yellow;

    default:
      return kPrimaryColor;
  }
}

// ---------------------- Pages Enums -----------------------------

enum AttendancePageScreen {
  SelfAttendance,
  Attendance,
  HomeAttendance,
  ScheduleAttendance,
}

enum LeavePageScreen {
  HolidayList,
  SelfLeave,
  ViewLeave,
  LeaveReport,
  LeaveRequests
}

enum VisitingCardPageScreen {
  VisitingCard,
  VisitingCardBH,
  VisitingCardAD
}

enum IdCardPageScreen {
  IdCard,
  IdCardLM,
  IdCardAD
}

enum LetterPageScreen {
  Letter,
  LetterLM,
  // VisitingCardBH,
  // VisitingCardAD
}

enum MealSubscriptionPageScreen {
  LunchSubscription,
  IfterSubscription
}

enum LunchSubscriptionPageScreen {
  LunchSubscription,
  Dashboard
}

enum IfterSubscriptionPageScreen {
  IfterSubscription,
  Dashboard
}

enum TravelPlanPageScreen {
  TravelPlans,
  SettlementRequests,
  SettlementApprovalList
}

enum ResignationPageScreen {
  ResignationApplication,
  ResignationAwaitingApproval
}

enum WorkFromHomePageScreen {
  WorkFromHomeApplication,
  WorkFromHomeAwaitingApproval
}

enum ConveyancePageScreen {
  ConveyanceApplication,
  ConveyanceAwaitingApproval,
  ConveyanceSettlement
}


enum SelfPayrollScreen {
  SelfPayroll,
  SalaryPaySlip,
  TaxCard,
  EditYearlyInvestment,
  GratuityFundInfo,
  PFSummary,
  LoanSummary,
  WPPFSummary,
  TaxReturnSubmission,
}

enum ColleaguesPageScreen {
  SearchColleagues,
}

enum EventsPageScreen {
  CreateEvent,
}

enum NotificationPageScreen {
  ShowNotification,
  FilterNotification,
}

enum ProfilePageScreen {
  BasicInfo,
  ContactInfo,
  PersonalInfo,
}

enum ClearancePageScreen {
  Clearance
}

// ---------------------- SharedPref Keys -------------------------
const SHARED_PREF_RECOM_USER_KEY = "recom_user";

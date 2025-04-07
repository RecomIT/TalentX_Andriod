import 'package:flutter/material.dart';
import 'package:recom_app/data/models/Id_card.dart';
import 'package:recom_app/data/models/clearance.dart';
import 'package:recom_app/data/models/conveyance.dart';
import 'package:recom_app/data/models/edit_settlement.dart';
import 'package:recom_app/data/models/id_card_bh_details.dart';
import 'package:recom_app/data/models/ifter_subscription.dart';
import 'package:recom_app/data/models/letter.dart';
import 'package:recom_app/data/models/lunch_subscription.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/my_settlement_list.dart';
import 'package:recom_app/data/models/resignation_awaiting.dart';
import 'package:recom_app/data/models/settlement_request_data.dart';
import 'package:recom_app/data/models/travel_plan.dart';
import 'package:recom_app/data/models/travel_settlement.dart';
import 'package:recom_app/data/models/visiting_card.dart';
import 'package:recom_app/data/models/visiting_card_bh_details.dart';
import 'package:recom_app/data/models/work_from_home.dart';
import 'package:recom_app/data/models/work_from_home_awaiting.dart';
import 'package:recom_app/views/pages/Ifter_subscription_page.dart';
import 'package:recom_app/views/pages/clearance_page.dart';
import 'package:recom_app/views/pages/clearance_detail_page.dart';
import 'package:recom_app/views/pages/colleague_detail_page.dart';
import 'package:recom_app/views/pages/conveyance_page.dart';
import 'package:recom_app/views/pages/conveyance_page_detail.dart';
import 'package:recom_app/views/pages/conveyance_settlement_page_detail.dart';
import 'package:recom_app/views/pages/create_conveyance_page.dart';
import 'package:recom_app/views/pages/create_id_card_page.dart';
import 'package:recom_app/views/pages/create_ifter_subscription_page.dart';
import 'package:recom_app/views/pages/create_letter_page.dart';
import 'package:recom_app/views/pages/create_lunch_subscription_page.dart';
import 'package:recom_app/views/pages/create_resignation_page.dart';
import 'package:recom_app/views/pages/create_visiting_card_page.dart';
import 'package:recom_app/views/pages/create_work_from_home_page.dart';
import 'package:recom_app/views/pages/edit_conveyance_page.dart';
import 'package:recom_app/views/pages/edit_id_card_page.dart';
import 'package:recom_app/views/pages/edit_letter_page.dart';
import 'package:recom_app/views/pages/edit_resignation_page.dart';
import 'package:recom_app/views/pages/edit_settlement_page.dart';
import 'package:recom_app/views/pages/edit_travel_plan_page.dart';
import 'package:recom_app/views/pages/edit_visiting_card_page.dart';
import 'package:recom_app/views/pages/id_card_page.dart';
import 'package:recom_app/views/pages/id_card_page_detail.dart';
import 'package:recom_app/views/pages/ifter_subscription_page_detail.dart';
import 'package:recom_app/views/pages/letter_page.dart';
import 'package:recom_app/views/pages/letter_page_detail.dart';
import 'package:recom_app/views/pages/lunch_subscription_page.dart';
import 'package:recom_app/views/pages/lunch_subscription_page_detail.dart';
import 'package:recom_app/views/pages/meal_subscription_page.dart';
import 'package:recom_app/views/pages/new_travel_plan_page.dart';
import 'package:recom_app/views/pages/policies_page.dart';
import 'package:recom_app/views/pages/requisition_page.dart';
import 'package:recom_app/views/pages/reset_password_page.dart';
import 'package:recom_app/views/pages/resignation_page.dart';
import 'package:recom_app/views/pages/resignation_page_approval_detail.dart';
import 'package:recom_app/views/pages/resignation_page_detail.dart';
import 'package:recom_app/views/pages/settlement_request_detail_page.dart';
import 'package:recom_app/views/pages/travel_plan_detail_page.dart';
import 'package:recom_app/views/pages/travel_plan_page.dart';
import 'package:recom_app/views/pages/travel_plan_settlement_page.dart';
import 'package:recom_app/views/pages/visiting_card_page.dart';
import 'package:recom_app/views/pages/visiting_card_page_detail.dart';
import 'package:recom_app/views/pages/work_from_home_page.dart';
import 'package:recom_app/views/pages/work_from_home_page_approval_detail.dart';
import 'package:recom_app/views/pages/work_from_home_page_detail.dart';
import 'package:recom_app/views/widgets/travel_plans_screen.dart';
import '../../data/models/search_colleague_data.dart';
import '../../utils/constants.dart';
import '../../views/pages/pages.dart';
import 'routing_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case SIGN_IN_PAGE:
      return MaterialPageRoute(builder: (_) => SignInPage());

    case FORGOT_PASSWORD_PAGE:
      return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
    // case RESET_PASSWORD_PAGE:
    //   return MaterialPageRoute(builder: (_) => ResetPasswordPage());

    case RESET_PASSWORD_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
              settings.arguments is String && settings.arguments != null
                  ? ResetPasswordPage(email: settings.arguments)
                  : HomePage());

    case HOME_PAGE:
      return MaterialPageRoute(builder: (_) => HomePage());

    case ATTENDANCE_PAGE:
      return MaterialPageRoute(builder: (_) => AttendancePage());

    case LEAVE_PAGE:
      return MaterialPageRoute(
          builder: (_) => LeavePage(
              initialScreen: settings.arguments is LeavePageScreen
                  ? settings.arguments
                  : null));

    case RESIGNATION_PAGE:
      return MaterialPageRoute(
          builder: (_) => ResignationPage(
              initialScreen: settings.arguments is ResignationPageScreen
                  ? settings.arguments
                  : null));

    case RESIGNATION_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is MyResignation
              ? ResignationPageDetail(myResignation: settings.arguments)
              : HomePage());

    case RESIGNATION_PAGE_APPROVAL_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is ResignationAwaiting
              ? ResignationPageApprovalDetail(resignationAwaiting: settings.arguments)
              : HomePage());

    case CREATE_RESIGNATION_PAGE:
      return MaterialPageRoute(builder: (_) => CreateResignationPage());

    case EDIT_RESIGNATION_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is MyResignation
              ? EditResignationPage(myResignation: settings.arguments)
              : HomePage());


    case WORK_FROM_HOME_PAGE:
      return MaterialPageRoute(
          builder: (_) => WorkFromHomePage(
              initialScreen: settings.arguments is WorkFromHomePageScreen
                  ? settings.arguments
                  : null));

    case WORK_FROM_HOME_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is WorkFromHome
              ? WorkFromHomePageDetail(workFromHome: settings.arguments)
              : HomePage());

    case WORK_FROM_HOME_PAGE_APPROVAL_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is WorkFromHomeAwaiting
              ? WorkFromHomePageApprovalDetail(workFromHomeAwaiting: settings.arguments)
              : HomePage());

    case CREATE_WORK_FROM_HOME_PAGE:
      return MaterialPageRoute(builder: (_) => CreateWorkFromHomePage());

    case EDIT_WORK_FROM_HOME_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is MyResignation
              ? EditResignationPage(myResignation: settings.arguments)
              : HomePage());


    case TRAVEL_PLAN_PAGE:
      return MaterialPageRoute(
          builder: (_) => TravelPlanPage(
              initialScreen: settings.arguments is TravelPlanPageScreen
                  ? settings.arguments
                  : null));

    case TRAVEL_PLAN_DETAIL_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is TravelPlan
              ? TravelPlanDetailPage(travelPlan: settings.arguments)
              : HomePage());

    case SETTLEMENT_REQUEST_DETAIL_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is MySettlement
              ? SettlementRequestDetailPage(settlementRequest: settings.arguments)
              :
          settings.arguments != null && settings.arguments is SettlementRequest
          ? SettlementRequestDetailPage(settlementReq: settings.arguments) :
          HomePage());

    case TRAVEL_PLAN_SETTLEMENT_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is TravelSettlement
              ? TravelPlanSettlementPage(settlementPlan: settings.arguments)
              : HomePage());

    case NEW_TRAVEL_PLAN_PAGE:
      return MaterialPageRoute(builder: (_) => NewTravelPlanPage());

    case EDIT_TRAVEL_PLAN_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is TravelPlan
              ? EditTravelPlanPage(travelPlan: settings.arguments)
              : HomePage());

    case EDIT_SETTLEMENT_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is EditSettlement
              ? EditSettlementPage(settlementPlan : settings.arguments)
              : HomePage());

    case MSG_COLLEAGUE_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
              settings.arguments != null && settings.arguments is Colleague
                  ? MsgColleaguesPage(colleague: settings.arguments)
                  : HomePage());

    case COLLEAGUE_Detail_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
              settings.arguments != null && settings.arguments is Colleague
                  ? ColleagueDetailPage(colleague: settings.arguments)
                  : HomePage());

    case EMAIL_COLLEAGUE_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
              settings.arguments != null && settings.arguments is Colleague
                  ? EmailColleaguesPage(colleague: settings.arguments)
                  : HomePage());

    case PROFILE_PAGE:
      return MaterialPageRoute(builder: (_) => ProfilePage());

    case EVENTS_PAGE:
      return MaterialPageRoute(builder: (_) => EventsPage());

    case COLLEAGUES_PAGE:
      return MaterialPageRoute(builder: (_) => ColleaguesPage());

    case PAYROLL_PAGE:
      return MaterialPageRoute(builder: (_) => PayrollPage());

    case NOTIFICATION_PAGE:
      return MaterialPageRoute(builder: (_) => NotificationPage());

    case POLICIES_PAGE:
      return MaterialPageRoute(builder: (_) => PolicesPage());


    case REQUISITION_PAGE:
      return MaterialPageRoute(
          builder: (_) => RequisitionPage());

    case VISITING_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) => VisitingCardPage(
              initialScreen: settings.arguments is VisitingCardPageScreen
                  ? settings.arguments
                  : null));

      case CREATE_VISITING_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) => CreateVisitingCardPage());

    case VISITING_CARD_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is VisitingCard
              ? VisitingCardPageDetail(myVisitingCard: settings.arguments) :
          settings.arguments != null && settings.arguments is VisitingCardBHDetails
          ? VisitingCardPageDetail(visitingCardBH: settings.arguments)
              : HomePage());

    case EDIT_VISITING_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is VisitingCard
              ? EditVisitingCardPage(myVisitingCard: settings.arguments)
              : HomePage());



    case ID_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) => IdCardPage(
              initialScreen: settings.arguments is IdCardPageScreen
                  ? settings.arguments
                  : null));

    case CREATE_ID_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) => CreateIdCardPage());

    case ID_CARD_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is IdCard
              ? IdCardPageDetail(myIdCard: settings.arguments) :
          settings.arguments != null && settings.arguments is IdCardBHDetails
              ? IdCardPageDetail(idCardBH: settings.arguments)
              : HomePage());

    case EDIT_ID_CARD_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is IdCard
              ? EditIdCardPage(myIdCard: settings.arguments)
              : HomePage());


    case LETTER_PAGE:
      return MaterialPageRoute(
          builder: (_) => LetterPage(
              initialScreen: settings.arguments is LetterPageScreen
                  ? settings.arguments
                  : null));

    case CREATE_LETTER_PAGE:
      return MaterialPageRoute(
          builder: (_) => CreateLetterPage());

    case LETTER_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Letter
              ? LetterPageDetail(myLetter: settings.arguments)
              : HomePage());

    case EDIT_LETTER_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Letter
              ? EditLetterPage(myLetter: settings.arguments)
              : HomePage());

    case MEAL_SUBSCRIPTION_PAGE:
      return MaterialPageRoute(
          builder: (_) => MealSubscriptionPage());

    case LUNCH_SUBSCRIPTION_PAGE:
      return MaterialPageRoute(
          builder: (_) => LunchSubscriptionPage(
              initialScreen: settings.arguments is LunchSubscriptionPageScreen
                  ? settings.arguments
                  : null));

    case LUNCH_SUBSCRIPTION_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is LunchSubscription
              ? LunchSubscriptionPageDetail(myLunchSubscription: settings.arguments)
              : HomePage());

    case CREATE_LUNCH_SUBSCRIPTION_PAGE:
      return MaterialPageRoute(
          builder: (_) => CreateLunchSubscriptionPage());


    case IFTER_SUBSCRIPTION_PAGE:
      return MaterialPageRoute(
          builder: (_) => IfterSubscriptionPage(
              initialScreen: settings.arguments is IfterSubscriptionPageScreen
                  ? settings.arguments
                  : null));

    case IFTER_SUBSCRIPTION_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is IfterSubscription
              ? IfterSubscriptionPageDetail(myIfterSubscription: settings.arguments)
              : HomePage());

    case CREATE_IFTER_SUBSCRIPTION_PAGE:
      return MaterialPageRoute(
          builder: (_) => CreateIfterSubscriptionPage());


    case CONVEYANCE_PAGE:
      return MaterialPageRoute(
          builder: (_) => ConveyancePage(
              initialScreen: settings.arguments is ConveyancePageScreen
                  ? settings.arguments
                  : null));

    case CREATE_CONVEYANCE_PAGE:
      return MaterialPageRoute(builder: (_) => CreateConveyancePage());

    case CONVEYANCE_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Conveyance
              ? ConveyancePageDetail(myConveyance: settings.arguments)
              : HomePage());

    case EDIT_CONVEYANCE_PAGE:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Conveyance
              ? EditConveyancePage(myConveyance: settings.arguments)
              : HomePage());

    case CONVEYANCE_SETTLEMENT_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Conveyance
              ? ConveyanceSettlementPageDetail(myConveyance: settings.arguments)
              : HomePage());

    // case RESIGNATION_PAGE_APPROVAL_DETAIL:
    //   return MaterialPageRoute(
    //       builder: (_) =>
    //       settings.arguments != null && settings.arguments is ResignationAwaiting
    //           ? ResignationPageApprovalDetail(resignationAwaiting: settings.arguments)
    //           : HomePage());
    //

    case CLEARANCE_PAGE:
      return MaterialPageRoute(
          builder: (_) => ClearancePage(
              initialScreen: settings.arguments is ClearancePageScreen
                  ? settings.arguments
                  : null));

    case CLEARANCE_PAGE_DETAIL:
      return MaterialPageRoute(
          builder: (_) =>
          settings.arguments != null && settings.arguments is Clearance
              ? ClearanceDetailPage(clearance: settings.arguments)
              : HomePage());


    case ROOT:
    default:
      //return  _errorRoute();
      return MaterialPageRoute(builder: null);
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('ERROR'),
      ),
    );
  });
}

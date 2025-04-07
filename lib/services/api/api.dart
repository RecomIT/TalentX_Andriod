import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recom_app/data/models/EditResignation.dart';
import 'package:recom_app/data/models/Id_card.dart';
import 'package:recom_app/data/models/clearance.dart';
import 'package:recom_app/data/models/clearance_details.dart';
import 'package:recom_app/data/models/conveyance.dart';
import 'package:recom_app/data/models/conveyance_info.dart';
import 'package:recom_app/data/models/conveyance_info_details.dart';
import 'package:recom_app/data/models/edit_conveyance_info.dart';
import 'package:recom_app/data/models/edit_id_card_request.dart';
import 'package:recom_app/data/models/edit_letter_request.dart';
import 'package:recom_app/data/models/edit_settlement.dart';
import 'package:recom_app/data/models/edit_travel_plan.dart';
import 'package:recom_app/data/models/edit_visiting_card_request.dart';
import 'package:recom_app/data/models/id_card_bh_details.dart';
import 'package:recom_app/data/models/id_card_details.dart';
import 'package:recom_app/data/models/id_card_request.dart';
import 'package:recom_app/data/models/ifter_subscription.dart';
import 'package:recom_app/data/models/ifter_subscription_request.dart';
import 'package:recom_app/data/models/key_value_pair.dart';
import 'package:recom_app/data/models/leave_type.dart';
import 'package:recom_app/data/models/letter.dart';
import 'package:recom_app/data/models/letter_details.dart';
import 'package:recom_app/data/models/letter_request.dart';
import 'package:recom_app/data/models/lunch_subscription.dart';
import 'package:recom_app/data/models/lunch_subscription_details.dart';
import 'package:recom_app/data/models/lunch_subscription_request.dart';
import 'package:recom_app/data/models/meal_setting.dart';
import 'package:recom_app/data/models/my_resignation.dart';
import 'package:recom_app/data/models/my_settlement_list.dart';
import 'package:recom_app/data/models/notice_period_policy.dart';
import 'package:recom_app/data/models/policy.dart';
import 'package:recom_app/data/models/resignation_awaiting.dart';
import 'package:recom_app/data/models/resignation_details.dart';
import 'package:recom_app/data/models/resignation_info.dart';
import 'package:recom_app/data/models/settlement_request_data.dart';
import 'package:recom_app/data/models/settlement_request_detail.dart';
import 'package:recom_app/data/models/travel_plan.dart';
import 'package:recom_app/data/models/travel_plan_detail.dart';
import 'package:recom_app/data/models/travel_purpose.dart';
import 'package:recom_app/data/models/travel_settlement.dart';
import 'package:recom_app/data/models/travel_type.dart';
import 'package:recom_app/data/models/visiting_card.dart';
import 'package:recom_app/data/models/visiting_card_bh_details.dart';
import 'package:recom_app/data/models/visiting_card_details.dart';
import 'package:recom_app/data/models/visiting_card_request.dart';
import 'package:recom_app/data/models/work_from_home.dart';
import 'package:recom_app/data/models/work_from_home_awaiting.dart';
import 'package:recom_app/data/models/work_from_home_details.dart';
import 'package:recom_app/data/models/work_from_home_reason.dart';

import '../../data/models/all_leave_report.dart';
import '../../data/models/attendance_calendar_data.dart';
import '../../data/models/attendance_overview_chart_data.dart';
import '../../data/models/attendance_query_list.dart';
import '../../data/models/birthday_data.dart';
import '../../data/models/business_unit_wise_cost_center.dart';
import '../../data/models/company_hr_info.dart';
import '../../data/models/employee_id_list.dart';
import '../../data/models/holiday_data.dart';
import '../../data/models/leave_balance_chart_data.dart';
import '../../data/models/leave_request_list.dart';
import '../../data/models/notification_data.dart';
import '../../data/models/open_street_map_location.dart';
import '../../data/models/quick_announcement_list.dart';
import '../../data/models/scheduler_request_data.dart';
import '../../data/models/search_colleague_data.dart';
import '../../data/models/user.dart';
import '../../data/models/user_profile.dart';

class ApiService {
  Dio _client;
  String _authToken;

  //static const BASE_URL = 'http://13.234.38.195:1010/api';
  //static const BASE_URL = 'http://uat.hrmisbd.com/api/v1';
  static const BASE_URL = 'http://staging.hrmisbd.com/api/v1';
  //static const BASE_URL = 'https://talentx.shopf.co/api/v1';


  ApiService({String token}) {
    _client = Dio();
    _client.options.baseUrl = BASE_URL;
    _client.options.connectTimeout = 30000;
    _client.options.receiveTimeout = 30000;
    _client.options.sendTimeout = 30000;
    if (token != null) {_client.options.headers["Authorization"] = token;}
  }

  String getAuthToken() {
    return _authToken;
  }

  void setAuthToken(String token) {
    _authToken = token;
    _client.options.headers["Authorization"] = token;
  }

  bool isAuthorized() {
    return _client.options.headers["Authorization"] != null;
  }

  // ------------------- Auth -----------------------------------------

  Future<User> signInUser(Map<String, String> signInCreds) async {
    try {
      final response = await _client.post(
        //"/Authentication/AccessToken",
        "/login",
        data: json.encode(signInCreds),
      );
      // print("-------Rakib------");
      //print(response.data['data'].toString());
      User user = User.fromJson(response.data['data']);

      // print("-------Rakib------");
      this.setAuthToken('Bearer '+ user.accessToken);

      return user;
    } on DioError catch (err) {
      print("---------------" + err.request.path + "----------------");

      if (err.response != null) {
        print("err.response.data: " + err.response.data['data'].toString());
        print("err.response.headers: " + err.response.headers.toString());
        print("err.response.request.data: " + err.response.request.data.toString());
        print("err.message: " + err.message);
        // print('----------Rakib----------');
        // print(err.response.data['message'].toString());
        throw Exception(err.response.data['message'].toString());
      } else {
        print(err.request.data);
        print(err.message);
        throw Exception("Failed to Sign In due to Network Error. Please try again.");
      }
    }
  }

  Future<User> signInUserWithSocialProvider(Map<String, String> signInCreds) async {
    try {
      final response = await _client.post(
        "/login-through-social-provider",
        data: json.encode(signInCreds),
      );

      User user = User.fromJson(response.data['data']);
      this.setAuthToken('Bearer '+ user.accessToken);

      return user;
    } on DioError catch (err) {
      print("---------------" + err.request.path + "----------------");

      if (err.response != null) {
        print("err.response.data: " + err.response.data['data'].toString());
        print("err.response.headers: " + err.response.headers.toString());
        print("err.response.request.data: " + err.response.request.data.toString());
        print("err.message: " + err.message);
        // print('----------Rakib----------');
        // print(err.response.data['message'].toString());
        throw Exception(err.response.data['message'].toString());
      } else {
        print(err.request.data);
        print(err.message);
        throw Exception("Failed to Sign In due to Network Error. Please try again.");
      }
    }
  }

  // ----------------------- Generic API Calls --------------------------

  Future<Response> _getRequest(String path) async {
    try {
      return await _client.get(path);
    } on DioError catch (err) {
      print("---------------" + err.request.path + "----------------");
      if (err.response != null) {
        print("err.response.data: " + err.response.data.toString());
        print("err.response.headers: " + err.response.headers.toString());
        print("err.response.request.data: " + err.response.request.data.toString());
        print("err.message: " + err.message);
        throw Exception(err.response.data["message"]);
      } else {
        print(err.request.data);
        print(err.message);
        throw Exception("Failed to send request.");
      }
    }
  }

  Future<Response> _postRequest(String path, dynamic data) async {
    try {
      return await _client.post(path, data: data);
    } on DioError catch (err) {
      print("---------------" + err.request.path + "----------------");
      if (err.response != null) {
        print("err.response.data: " + err.response.data.toString());
        print("err.response.headers: " + err.response.headers.toString());
        print("err.response.request.data: " + err.response.request.data.toString());
        print("err.message: " + err.message);
        return err.response;
      } else {
        print(err.request.data);
        print(err.message);
        throw Exception("Failed to send request.");
      }
    }
  }

  // Future<Response> _putRequest(String path, dynamic data) async {
  //   try {
  //     return await _client.put(path, data: data);
  //   } on DioError catch (err) {
  //     print("---------------" + err.request.path + "----------------");
  //     if (err.response != null) {
  //       print("err.response.data: " + err.response.data.toString());
  //       print("err.response.headers: " + err.response.headers.toString());
  //       print("err.response.request.data: " + err.response.request.data.toString());
  //       print("err.message: " + err.message);
  //       return err.response;
  //     } else {
  //       print(err.request.data);
  //       print(err.message);
  //       throw Exception("Failed to send request.");
  //     }
  //   }
  // }

  Future<Response> _deleteRequest(String path, {dynamic data}) async {
    try {
      return await _client.delete(path, data: data);
    } on DioError catch (err) {
      print("---------------" + err.request.path + "----------------");
      if (err.response != null) {
        print("err.response.data: " + err.response.data.toString());
        print("err.response.headers: " + err.response.headers.toString());
        print("err.response.request.data: " + err.response.request.data.toString());
        print("err.message: " + err.message);
        return err.response;
      } else {
        print(err.request.data);
        print(err.message);
        throw Exception("Failed to send request.");
      }
    }
  }

  // --------------------- Specific API Calls ----------------------
  Future<Response> forgotPassword(String email) async {
    try {
      return await _postRequest("/forgot/password", {'username':email});
    } catch (ex) {
      throw Exception("Failed to send Forgot Password request.");
    }
  }

  Future<Response> resetPassword(Map<String, dynamic> formData) async {
    try {
      return await _postRequest("/password/reset", formData);
    } catch (ex) {
      throw Exception("Failed to send Reset Password request.");
    }
  }

  Future<AttendanceOverviewChartData> getAttendanceOverviewChartData() async {
    try {
      final response = await _getRequest("/Employee/AttendanceOverviewGraph");
      if (response.statusCode == 200)
        return AttendanceOverviewChartData.fromJson(response.data);
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception("Failed to get AttendanceOverviewChartData.");
    }
  }

  Future<LeaveBalanceChartData> getLeaveBalanceChartData() async {
    try {
      print('Called getLeaveBalanceChartData()');
      final response = await _getRequest("/leave/balance");
      //print('----------Rakib -------------');
      if (response.statusCode == 200)
         return LeaveBalanceChartData.fromJson({'leaveBalance': response.data['data']});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception("Failed to get LeaveBalanceChartData.");
    }
  }

  Future<LeaveRequestList> getLeaveRequestList() async {
    try {
      print('Called getLeaveRequestList()');
      final response = await _getRequest("/my-leaves");
      if (response.statusCode == 200)
        return LeaveRequestList.fromJson({'leaveRequest': response.data['data']});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      //print("LeaveRequestList: " + ex.toString());
      throw Exception("Failed to get Leave Request List.");
    }
  }

  Future<LeaveRequestList> getWaitingForApprovalLeaveRequestList() async {
    try {
      final response = await _getRequest("/leave/waiting-for-approval");
      if (response.statusCode == 200)
        return LeaveRequestList.fromJson({'leaveRequest': response.data['data']});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      //print("LeaveRequestList: " + ex.toString());
      throw Exception("Failed to get Leave Request List.");
    }
  }

  Future<CompanyHRInfo> getCompanyHRInfo() async {
    try {
      final empResponse = await _getRequest("/Info/GetEmployeeIDs");
      final deptResponse = await _getRequest("/Info/GetDepartments");
      final sDeptResponse = await _getRequest("/Info/GetSubDepartments");
      final sSDeptResponse = await _getRequest("/Info/GetSSubDepartments");

      return CompanyHRInfo.fromJson({
        "employeeIDs": empResponse.data is List ? empResponse.data : [],
        "departments": deptResponse.data is List ? deptResponse.data : [],
        "subDepartments": sDeptResponse.data is List ? sDeptResponse.data : [],
        "sSubDepartments": sSDeptResponse.data is List ? sSDeptResponse.data : [],
      });
    } catch (ex) {
      print("CompanyHRInfo: " + ex.toString());
      throw Exception("Failed to get CompanyHRInfo.");
    }
  }

  Future<QuickAnnouncementList> getQuickAnnouncementList() async {
    try {

      var data= [
        {
          "Id": 1,
          "Title": "Meeting",
          "StartDate": "2020-11-17T00:00:00",
          "EndDate": "2020-11-17T00:00:00",
          "Purpose": "Quick Meeting"
        },
        {
          "Id": 2,
          "Title": "Monthly Meeting",
          "StartDate": "2020-11-17T11:30:31.957",
          "EndDate": "2020-11-17T11:30:31.957",
          "Purpose": "Regular Colaboration"
        }
      ];
      return QuickAnnouncementList.fromJson({'quickAnnouncement': data});
      final response = await _getRequest("/HRUtility/GetAllQuickAnnouncement");
      if (response.statusCode == 200)
        return QuickAnnouncementList.fromJson({'quickAnnouncement': response.data});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print("QuickAnnouncementList: " + ex.toString());
      throw Exception("Failed to get QuickAnnouncementList.");
    }
  }

  Future<OpenStreetMapLocation> getOpenStreetMapLocation(double lat, double lon) async {
    try {
      final response = await _getRequest(
          "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&accept-language=en-US");
      if (response.statusCode == 200)
        return OpenStreetMapLocation.fromJson(response.data);
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception("Failed to get location.");
    }
  }

  Future<Response> createScheduler(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Attendance/CreateScheduler",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to create scheduler!");
    }
  }

  Future<List<AttendanceQuery>> attendanceQuery(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Attendance/AttendanceQuery",
        formData,
      );
      if (response.data is List) {
        return AttendanceQueryList.fromJson({"AttendanceQueryList": response.data}).attendanceQueryList;
      } else {
        throw Exception("No result found!");
      }
    } catch (ex) {
      throw Exception(ex.message ?? "Failed to retrieve attendance query!");
    }
  }

  Future<Response> timeEditRequest(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Attendance/TimeEditRequest",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to create scheduler!");
    }
  }

  Future<Response> approveOrRejectSchedulerRequest(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Attendance/ApproveOrRejectSchedulerRequest",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to process approve or reject scheduler request!");
    }
  }

  Future<Response> submitAttendance(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Attendance/AttendanceSubmit",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to submit attendance!");
    }
  }

  Future<Response> sendMessage(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Notification/SendMessage",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to send message!");
    }
  }

  Future<Response> updateProfileInfo(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/employee/update-basic-info",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to update profile basic info!");
    }
  }

  Future<Response> updateProfileBasicInfo(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Employee/UpdateProfileBasicInfo",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to update profile basic info!");
    }
  }

  Future<Response> updateProfileContactInfo(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Employee/UpdateProfileContactInfo",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to update profile basic info!");
    }
  }

  Future<Response> updateProfilePersonalInfo(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Employee/UpdateProfilePersonalInfo",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to update profile basic info!");
    }
  }

  Future<Response> applyForLeave(FormData formData) async {
    try {
      final response = await _postRequest(
        "/leaves/store",
          formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to apply for leave!");
    }
  }

  Future<Response> applyForVisitingCard(FormData formData) async {
    try {
      final response = await _postRequest(
        "/visiting-card/store",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to apply for visiting card requisition!");
    }
  }

  Future<Response> applyForIdCard(FormData formData) async {
    try {
      final response = await _postRequest(
        "/id-card/store",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to apply for ID card requisition!");
    }
  }

  Future<Response> applyForLetter(FormData formData) async {
    try {
      final response = await _postRequest(
        "/requisition-letter/store",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to apply for Letter requisition!");
    }
  }


  Future<Response> applyForLunchSubscription(FormData formData) async {
    try {
      final response = await _postRequest(
        "/lunch-subscription/store",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to apply for Lunch-Subscription!");
    }
  }



  Future<Response> applyForIfterSubscription(FormData formData) async {
    try {
      final response = await _postRequest(
        "/iftar-booking/create",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to apply for Iftar-Booking!");
    }
  }

  Future<Response> applyForUnSubscriptionDecision(FormData formData) async {
    try {
      final response = await _postRequest(
        "/lunch-subscription/unsubscribe-decision",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to apply for Lunch-Unsubscription decision!");
    }
  }

  Future<Response> applyForUnSubscription(FormData formData) async {
    try {
      final response = await _postRequest(
        "/lunch-subscription/unsubscribe",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to apply for Lunch-Unsubscription!");
    }
  }

  Future<Response> updateForVisitingCard(FormData formData) async {
    try {
      final response = await _postRequest(
        "/visiting-card/update",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to update for visiting card requisition!");
    }
  }

  Future<Response> updateForIdCard(FormData formData) async {
    try {
      final response = await _postRequest(
        "/id-card/update",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to update for ID card requisition!");
    }
  }

  Future<Response> updateForLetter(FormData formData,int id) async {
    try {
      final response = await _postRequest(
        "/requisition-letter/update/$id",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to update for Letter requisition!");
    }
  }

  Future<Response> applyForWFH(FormData formData) async {
    try {
      final response = await _postRequest(
        "/work-from-home/store",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to apply for Off-Site Attendance!");
    }
  }

  Future<Response> applyForResignation(FormData formData) async {
    try {
      final response = await _postRequest(
        "/resignations/store",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to apply for resignation!");
    }
  }

  Future<Response> applyForConveyance(FormData formData) async {
    try {
      final response = await _postRequest(
        "/conveyance/store",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to apply for conveyance!");
    }
  }

  Future<Response> applyForEditConveyance(FormData formData) async {
    try {
      final response = await _postRequest(
        "/conveyance/update",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to apply for edit conveyance!");
    }
  }

  Future<Response> applyForResignationUpdate(FormData formData) async {
    try {
      final response = await _postRequest(
        "/resignations/update",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to Update for resignation!");
    }
  }

  Future<Response> updateProfilePhoto(FormData formData) async {
    try {
      final response = await _postRequest(
        "/employee/update-photo",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to update photo!");
    }
  }

  Future<Response> sendEmail(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/Notification/SendEmail",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to update photo!");
    }
  }

  Future<Response> createEvent(Map<String, dynamic> formData) async {
    try {
      final response = await _postRequest(
        "/HRUtility/CreateEvent",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to create event!");
    }
  }

  Future<AttendanceCalendarData> getAttendanceCalendarData(int month, int year) async {
    try {
      final response = await _getRequest("/Attendance/AttendanceCalendar?month=$month&year=$year");
      if (response.statusCode == 200)
        return AttendanceCalendarData.fromJson({'attendance': response.data});
      else
        return AttendanceCalendarData(attendance: []);
    } catch (ex) {
      return AttendanceCalendarData(attendance: []);
      // throw Exception("Failed to get AttendanceCalendarData.");
    }
  }

  Future<HolidayData> getHolidayList() async {
    print('Called getHolidayList()');
    try {
      final response = await _getRequest("/holidays");
      //print(response.data['data'].toString());
      if (response.statusCode == 200)
        return HolidayData.fromJson({'holiday': response.data['data']});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Holiday List.");
    }
  }

  Future<SchedulerRequestData> getSchedulerRequest() async {
    try {
      final response = await _getRequest("/Attendance/GetSchedulerRequests");

      if (response.statusCode == 200)
        return SchedulerRequestData.fromJson({'schedulerRequest': response.data});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception("Failed to get Scheduler Request Data.");
    }
  }

  Future<SearchColleagueData> getSearhColleagueList() async {
    print('Called getSearhColleagueList()');
    try {
      final response = await _getRequest("/employee/search-colleagues");
      if (response.statusCode == 200)
        return SearchColleagueData.fromJson({'colleague': response.data['data']});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception("Failed to get Holiday List.");
    }
  }
  Future<PolicyData> getPolicieList() async {
    try {
      final response = await _getRequest("/policies");
      if (response.statusCode == 200)
        return PolicyData.fromJson({'policy': response.data['data']});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception("Failed to get Policy List.");
    }
  }

  Future<NotificationData> getNotificationList() async {
    print('Called getNotificationList()');
    try {
      final response = await _getRequest("/user-notification-all");
      //print(response.data['data'].toString());
      if (response.statusCode == 200)
        return NotificationData.fromJson({'notification': response.data['data']});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception("Failed to get Notification List.");
    }
  }

  Future<NotificationData> getUnreadNotificationList() async {
    print('Called getUnreadNotificationList()');
    try {
      final response = await _getRequest("/user-unread-notification");
      //print(response.data['data'].toString());
      if (response.statusCode == 200)
        return NotificationData.fromJson({'notification': response.data['data']});
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception("Failed to get Notification List.");
    }
  }

  Future getNotificationCount() async {
    try {
      final response = await _getRequest("/user-notification-count");
      //print(response.data['data'].toString());
      if (response.statusCode == 200)
        return response.data['data'];
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception("Failed to get Notification Count");
    }
  }

  Future<BirthdayData> getUpcomingBdays() async {
    try {
      final response = await _getRequest("/employee/upcoming-birthdays");
      //print(response.data['data'].toString());
      if (response.statusCode == 200)
        return BirthdayData.fromJson({'birthday': response.data['data']});
      else
        return BirthdayData(birthday: []);
    } catch (ex) {
      return BirthdayData(birthday: []);
    }
  }

  Future<List> getAllEvents() async {
    try {
      final response = await _getRequest("/HRUtitity/GetAllEvents");
      if (response.statusCode == 200)
        return response.data;
      else
        return [];
    } catch (ex) {
      return [];
    }
  }
  Future<UserProfile> getUserProfile() async {
    try {
      print('Called getUserProfile()');
      final response = await _getRequest("/employee/profile");
      //print(response.data.toString());
      if (response.statusCode == 200)
        return UserProfile.fromJson(response.data['data']);

      else
        return UserProfile();
    } catch (ex) {
      return UserProfile();
    }
  }

  Future<UserProfile> getUserProfile1() async {
    try {
      print('Called getUserProfile1()');
      final response = await _getRequest("/employee/profile");
      //print(response.data.toString());
      if (response.statusCode == 200)
        return UserProfile.fromJson(response.data['data']);

      else
        return UserProfile();
    } catch (ex) {
      return UserProfile();
    }
  }

  Future<EmployeeIdList> getEmployeeIds() async {
    try {
      final response = await _getRequest("/Info/GetEmployeeIDs");
      if (response.statusCode == 200)
        return EmployeeIdList.fromJson({"employeeList": response.data});
      else
        return EmployeeIdList();
    } catch (ex) {
      return EmployeeIdList();
    }
  }

  Future<List<AllLeaveReport>> getAllLeaveReportList() async {
    try {
      final response = await _getRequest("/Leave/PersonnelLeaveDetails");
      if (response.statusCode == 200)
        return AllLeaveReportList.fromJson({"allLeaveReport": response.data}).allLeaveReports;
      else
        return [];
    } catch (ex) {
      return [];
    }
  }

  // Future<EmployeeIdList> getReliverIds() async {
  //   try {
  //     final response = await _getRequest("/to-cc-releiver");
  //     if (response.statusCode == 200)
  //       return EmployeeIdList.fromJson({"employeeList": response.data});
  //     else
  //       return EmployeeIdList();
  //   } catch (ex) {
  //     return EmployeeIdList();
  //   }
  // }
  Future<EmployeeIdList> getReliverIds() async {
    try {
      final response = await _getRequest("/to-cc-releiver");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').replaceAll('Md,', 'Md.').split(',').toList();
        List<Map<String, dynamic>> data = [];
        var employeeList = <EmployeeListItem>[];
        res.forEach((r) {
          var emp = r.split(':').toList();
          var e =  EmployeeListItem();
          e.iD=emp[0].trim().toString();
          e.name=emp[1].toString();
          employeeList.add(e);
          data.add(e.toJson());
        });
        return EmployeeIdList.fromJson({"employeeList": data});
      }

      else
        return EmployeeIdList();
    } catch (ex) {
      return EmployeeIdList();
    }
  }

  Future<EmployeeIdList> getReliverIds2() async {
    try {
      final response = await _getRequest("/to-cc-releiver");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').replaceAll('Md,', 'Md.').split(',').toList();
        List<Map<String, dynamic>> data = [];
        var employeeList = <EmployeeListItem>[];
        res.forEach((r) {
          var emp = r.split(':').toList();
          var e =  EmployeeListItem();
          e.iD=emp[0].toString();
          e.name=emp[1].toString();
          employeeList.add(e);
          data.add(e.toJson());
        });
        // EmployeeIdList c = new EmployeeIdList();
        // c.employeeList=employeeList;
         return EmployeeIdList.fromJson({"employeeList": data});
      }

      else
        return EmployeeIdList();
    } catch (ex) {
      return EmployeeIdList();
    }
  }

  Future<Response> applyForTravelPlan(FormData formData) async {
    try {
      final response = await _postRequest(
        "/travel-plans/store",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to apply for Travel Plan!");
    }
  }

  Future<Response> applyForUpdateTravelPlan(FormData formData) async {
    try {
      final response = await _postRequest(
        "/travel-plans/update",
        formData,
      );
      return response;
    } catch (ex) {
      //print("-----------------Rakib-------Failed to apply for leave!");
      throw Exception("Failed to update for Travel Plan!");
    }
  }

  Future<Response> applyForTravelPlanSettlement(FormData formData) async {
    try {
      final response = await _postRequest(
        "/travel-settlement/store",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to apply for Travel Plan Settlement!");
    }
  }

  Future<Response> applyForUpdateSettlement(FormData formData) async {
    try {
      final response = await _postRequest(
        "/travel-settlement/update",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to update Travel Plan Settlement!");
    }
  }

  Future<LeaveTypeList> getLeaveTypes() async {
    try {
      print('Called getLeaveTypes()');
      final response = await _getRequest("/leave-types");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        var leaveTypeList = <LeaveType>[];
        res.forEach((type) {
          var emp = type.split(':').toList();
          var e =  LeaveType();
          e.id=emp[0].toString();
          e.name=emp[1].toString();
          leaveTypeList.add(e);
          data.add(e.toJson());
        });
        return LeaveTypeList.fromJson({"leaveTypeList": data});
      }

      else
        return LeaveTypeList();
    } catch (ex) {
      return LeaveTypeList();
    }
  }

  //Travels APIs
  Future<TravelPlanData> getTravelPlanList() async {
    try {
      print('Called getTravelPlanList()');
      final response = await _getRequest("/travel-plans");
      if (response.statusCode == 200){
        return TravelPlanData.fromJson({'travelPlan': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Travel Plan List.");
    }
  }

  Future<TravelPlanDetail> getTravelPlanDetail(String travel_plan_id) async {
    try {
      print('Called getTravelPlanDetail()');
      final response = await _getRequest("/travelplan/view?travel_plan_id=$travel_plan_id");
      if (response.statusCode == 200){
        return TravelPlanDetail.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Travel Plan Details.");
    }
  }

  Future<SettlementRequestDetail> getSettlementRequestDetail(String travel_settlement_id) async {
    try {
      print('Called getSettlementRequestDetail()');
      final response = await _getRequest("/travel-settlement/view?travel_settlement_id=$travel_settlement_id");
      if (response.statusCode == 200){
        return SettlementRequestDetail.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Travel Plan Details.");
    }
  }

  Future<TravelSettlement> getTravelPlanSettlement(String travel_plan_id) async {
    try {
      print('Called getTravelPlanSettlement()');
      final response = await _getRequest("/travel-settlement/create?travel_plan_id=$travel_plan_id");
      if (response.statusCode == 200){
        return TravelSettlement.fromJson(response.data['data']);
      }
      else
        //return TravelSettlement();
        throw Exception(response.data["message"]);
    } catch (ex) {
        throw Exception(ex);
    }
  }

  Future<EditTavelPlan> getEditTravelPlan(String travel_plan_id) async {
    try {
      print('Called getEditTravelPlan()');
      final response = await _getRequest("/travel-plans/edit?travel_plan_id=$travel_plan_id");
      if (response.statusCode == 200){
        return EditTavelPlan.fromJson(response.data['data']);
      }
      else
        //return TravelSettlement();
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  Future<EditSettlement> getEditSettlement(String travel_settlement_id) async {
    try {
      print('Called getEditSettlement()');
      final response = await _getRequest("/travel-settlement/edit?travel_settlement_id=$travel_settlement_id");
      if (response.statusCode == 200){
        return EditSettlement.fromJson(response.data['data']);
      }
      else
        //return TravelSettlement();
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  Future<Response> approveSettlementRequest(String travel_settlement_id) async {
    try {
      print('Called approveSettlementRequest()');
      var formData={
        "travel_settlement_id":travel_settlement_id,
      };
      final response = await _postRequest("/travel-settlement/approved", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Approved request");
    }
  }

  Future<Response> revertSettlementRequest(String travel_settlement_id) async {
    try {
      print('Called revertSettlementRequest()');
      var formData={
        "travel_settlement_id":travel_settlement_id,
      };
      final response = await _postRequest("/travel-settlement/reverted", formData,);
      return response;
    } catch (ex) {
      throw Exception("Failed to Reveret request");
    }
  }

  Future<Response> approveTravelPlan(String travel_plan_id) async {
    try {
      print('Called approveTravelPlan()');
      var formData={
        "travel_plan_id":travel_plan_id,
      };
      final response = await _postRequest("/travelplan/approved", formData,);
      return response;
    } catch (ex) {
      throw Exception("Failed to Approved request");
    }
  }

  Future<Response> revertTravelPlan(String travel_plan_id) async {
    try {
      print('Called revertTravelPlan()');
      var formData={
        "travel_plan_id":travel_plan_id,
      };
      final response = await _postRequest("/travelplan/reverted", formData,);
      return response;
    } catch (ex) {
      throw Exception("Failed to Reveret request");
    }
  }

  Future<Response> rejectTravelPlan(String travel_plan_id) async {
    try {
      print('Called rejectTravelPlan()');
      var formData={
        "travel_plan_id":travel_plan_id,
      };
      final response = await _postRequest("/travelplan/rejected", formData,);
      return response;
    } catch (ex) {
      throw Exception("Failed to Reject request");
    }
  }

  Future<TravelTypeList> getTravelTypes() async {
    try {
      print('Called getTravelTypes()');
      final response = await _getRequest("/travel-type");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        //var travelTypeList = <TravelType>[];
        res.forEach((type) {
          var travel = type.split(':').toList();
          var e =  TravelType();
          e.id=travel[0].toString().trim();
          e.name=travel[1].toString().trim();
          //travelTypeList.add(e);
          data.add(e.toJson());
        });
        return TravelTypeList.fromJson({"travelTypeList": data});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }

  Future<TravelPurposeList> getTravelPurposes (String travel_type) async {
    try {
      print('Called getTravelPurpose()');
      final response = await _getRequest("/purpose?travel_type=$travel_type");
      if (response.statusCode == 200) {
        return TravelPurposeList.fromJson({"travelPurpose": response.data['data']});
      }

      else
        return TravelPurposeList();
    } catch (ex) {
      return TravelPurposeList();
    }
  }
  Future<String> getNoOfDaysWFH(String start_date, String end_date) async {
    try {
      print('Called getNoOfDaysWFH()');
      final response = await _client.get("/work-from-home/number-of-days?start_date=$start_date&end_date=$end_date");
      if (response.statusCode == 200)
        return  response.data['data'].toString();
      else
        return '';
        //throw Exception(response.data["message"]);

    } catch (ex) {
      return '';
      // throw Exception("Failed to Generate Reference Code.");
    }
  }

  Future<String> getReferenceCode(String travel_type, String purpose) async {
    try {
      print('Called getReferenceCode()');
      final response = await _client.get("/generate-reference?travel_type=$travel_type&purpose=$purpose");
      if (response.statusCode == 200)
        return  response.data['data'];
      else
        throw Exception(response.data["message"]);

    } catch (ex) {
      throw Exception("Failed to Generate Reference Code.");
    }
  }

  Future<String> getCurrentDateFormat() async {
    try {
      print('Called getCurrentDateFormat()');
      final response = await _client.get("/current/date-format");
      if (response.statusCode == 200)
        return  response.data['data'];
      else
        throw Exception(response.data["message"]);

    } catch (ex) {
      throw Exception("Failed to Generate Reference Code.");
    }
  }

  Future<TravelTypeList> getTransportModes(String travel_type) async {
    try {
      final response = await _client.get("/transport-mode?travel_type=$travel_type");
      print('Called getTransportModes()');
      if (response.statusCode == 200) {
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        res.forEach((type) {
          if(type.contains(':')){
            var travel = type.split(':').toList();
            var e = TravelType();
            e.id = travel[0].toString().trim();
            e.name = travel[1].toString().trim();
            //travelTypeList.add(e);
            data.add(e.toJson());
          }
        });

        return TravelTypeList.fromJson({"travelTypeList": data});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }

  Future<TravelTypeList> getCurrencies() async {
    try {
      print('Called getCurrencies()');
      final response = await _getRequest("/currency");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        res.forEach((type) {
          var travel = type.split(':').toList();
          var e =  TravelType();
          e.id=travel[0].toString().trim();
          e.name=travel[1].toString().trim();
          //travelTypeList.add(e);
          data.add(e.toJson());
        });
        return TravelTypeList.fromJson({"travelTypeList": data});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }

  Future<TravelTypeList> getTravellers() async {
    try {
      print('Called getTravellers()');
      final response = await _getRequest("/traveller");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        res.forEach((type) {
          var travel = type.split(':').toList();
          var e =  TravelType();
          e.id=travel[0].toString().trim();
          e.name=travel[1].toString().trim();
          if(travel.length==3)
            {
              e.name+=' : '+ travel[2].toString().trim();
            }
          data.add(e.toJson());
        });
        return TravelTypeList.fromJson({"travelTypeList": data});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }

  Future<TravelTypeList> getCCs() async {
    try {
      print('Called getCCs()');
      final response = await _getRequest("/cc");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        res.forEach((type) {
          var travel = type.split(':').toList();
          var e =  TravelType();
          e.id=travel[0].toString().trim();
          e.name=travel[1].toString().trim();
          // if(travel.length==3)
          // {
          //   e.name+=' : '+ travel[2].toString().trim();
          // }
          data.add(e.toJson());
        });
        return TravelTypeList.fromJson({"travelTypeList": data});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }

  Future<String> getDefaultHRGroup() async {
    try {
      print('Called getDefaultHRGroup()');
      final response = await _getRequest("/get-hr-group");
      if (response.statusCode == 200){
        var res = response.data['data'].toString();
        return res;
      }
      else
        return 'N/A';
    } catch (ex) {
      return 'N/A';
    }
  }

  Future<TravelTypeList> getResignationCCs() async {
    try {
      print('Called getResignationCCs()');
      final response = await _getRequest("/resignations/cc");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        res.forEach((type) {
          var travel = type.split(':').toList();
          var e =  TravelType();
          e.id=travel[0].toString().trim();
          e.name=travel[1].toString().trim();
          // if(travel.length==3)
          // {
          //   e.name+=' : '+ travel[2].toString().trim();
          // }
          data.add(e.toJson());
        });
        return TravelTypeList.fromJson({"travelTypeList": data});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }

  Future<TravelTypeList> getBusinessHead() async {
    try {
      print('Called getBusinessHead()');
      final response = await _getRequest("/business-head");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        res.forEach((type) {
          var travel = type.split(':').toList();
          var e =  TravelType();
          e.id=travel[0].toString().trim();
          e.name=travel[1].toString().trim();
          // if(travel.length==3)
          // {
          //   e.name+=' : '+ travel[2].toString().trim();
          // }
          data.add(e.toJson());
        });
        return TravelTypeList.fromJson({"travelTypeList": data});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }

  Future<TravelTypeList> getFinanceBp() async {
    try {
      print('Called getFinanceBp()');
      final response = await _getRequest("/finance-bp");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        res.forEach((type) {
          var travel = type.split(':').toList();
          var e =  TravelType();
          e.id=travel[0].toString().trim();
          e.name=travel[1].toString().trim();
          // if(travel.length==3)
          // {
          //   e.name+=' : '+ travel[2].toString().trim();
          // }
          data.add(e.toJson());
        });
        return TravelTypeList.fromJson({"travelTypeList": data});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }
  Future<TravelTypeList> getCEO() async {
    try {
      print('Called getCEO()');
      final response = await _getRequest("/ceo");
      if (response.statusCode == 200){
        var res = response.data['data'].toString().replaceAll('{', '').replaceAll('}', '').split(',').toList();
        List<Map<String, dynamic>> data = [];
        res.forEach((type) {
          var travel = type.split(':').toList();
          var e =  TravelType();
          e.id=travel[0].toString().trim();
          e.name=travel[1].toString().trim();
          // if(travel.length==3)
          // {
          //   e.name+=' : '+ travel[2].toString().trim();
          // }
          data.add(e.toJson());
        });
        return TravelTypeList.fromJson({"travelTypeList": data});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }

  Future<BusinessUnitWiseCostCenter> getCostCenter() async {
    try {
      print('Called getCostCenter()');
      final response = await _getRequest("/business-unit-wise-cost-center");
      if (response.statusCode == 200){
        return BusinessUnitWiseCostCenter.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Business Unit Wise Cost Center");
    }
  }

  Future<TravelTypeList> getDestinations(String travel_type) async {
    var travelTypeD = <TravelType>[
      TravelType(id: '50',name: 'Barisal, Barguna '),
      TravelType(id: '56',name: 'Chittagong, Bandarban '),
      TravelType(id: '67',name: 'Dhaka, Dhaka '),
      TravelType(id: '80',name: 'Khulna, Bagerhat '),
      TravelType(id: '91',name: 'Mymensingh, Mymensingh ')];

    var travelTypeI = <TravelType>[
      TravelType(id: '1',name: 'Australia-Sydney-Sydney Kingsford Smith International Airport'),
      TravelType(id: '2',name: 'Australia-Melbourne-Melbourne International Airport'),
      TravelType(id: '3',name: 'Bhutan -Paro Valley-Paro International Airport'),
      TravelType(id: '4',name: 'Brazil-Guarulhos-Brazil São Paulo/Guarulhos International Airpor'),
      TravelType(id: '5',name: 'Canada-Toronto-Toronto Pearson International Airport')];

    // if(travel_type.contains('domestic')){
    //   return TravelTypeList(travelType: travelTypeD);
    // }
    // else{
    //   return TravelTypeList(travelType: travelTypeI);
    // }

    try {
      print('Called getDestinations()');
      final response = await _getRequest("/destination?travel_type=$travel_type");
      if (response.statusCode == 200) {
        return TravelTypeList.fromJson({'travelTypeList': response.data['data']});
      }
      else
        return TravelTypeList();
    } catch (ex) {
      return TravelTypeList();
    }
  }

  Future<bool> getBusinessUnit(String business_unit_id) async {

    try {
      print('Called getBusinessUnit()');
      final response = await _getRequest("/business-unit/finance-employees?business_unit_id=$business_unit_id");
      if (response.statusCode == 200) {
        var result = response.data['data']['finance_employee'] as bool;
        return result;
      }
      else
        return false;
    } catch (ex) {
      return false;
    }
  }

  Future<MySettlementList> getSettlementRequestList() async {
    try {
      print('Called getSettlementRequestList()');
      final response = await _getRequest("/my-settlements/request");
      if (response.statusCode == 200){
        return MySettlementList.fromJson({'mySettlements': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Settlement Request List.");
    }
  }

  Future<SettlementRequestData> getSettlementApproveList() async {
    try {
      print('Called getSettlementApproveList()');
      final response = await _getRequest("/travel-settlement/requested-list");
      if (response.statusCode == 200){
        return SettlementRequestData.fromJson({'settlementRequest': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Settlement Request List.");
    }
  }

  Future<MyResignationList> getMyResignationList() async {
    try {
      print('Called getMyResignationList()');
      final response = await _getRequest("/resignations");
      if (response.statusCode == 200){
        return MyResignationList.fromJson({'myResignationList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get My Resignation List.");
    }
  }

  Future<ConveyanceList> getMyConveyanceList() async {
    try {
      print('Called getMyConveyanceList()');
      final response = await _getRequest("/conveyance/my-list");
      if (response.statusCode == 200){
        return ConveyanceList.fromJson({'conveyanceList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get My Conveyance List.");
    }
  }

  Future<ConveyanceList> getAwaitingConveyanceList() async {
    try {
      print('Called getAwaitingConveyanceList()');
      final response = await _getRequest("/conveyance/approval-list");
      if (response.statusCode == 200){
        return ConveyanceList.fromJson({'conveyanceList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Awaiting Conveyance List.");
    }
  }

  Future<ConveyanceList> getConveyanceSettlementList() async {
    try {
      print('Called getConveyanceSettlementList()');
      final response = await _getRequest("/conveyance-settlement/approval-list");
      if (response.statusCode == 200){
        var data= [{
          "settlement_id": 1,
          "conveyance_id": 1,
          "requester_id": "C/4417/2022-09-10/1",
          "employee_name": " Shaolin  Akter (4417) ",
          "line_manager": " Dibyendu Das Sourav (4439) ",
          "division": "ShopUp Services",
          "department": "Human Resources",
          "cost_enter": "Human Resources",
          "business_unit": "ShopUp",
          "contact_no": "+8801321151635",
          "application_date": "10-Sep-2022",
          "total_bill": 17300,
          "payment_method": "Nagad",
          "payment_date": 'n/a',
          "pending_at": " S H M Shanawaz (7) ",
          "status": "Settlement In Progress",
          "settlement_status": "Not Yet",
          "settlement_approval": true
        }];
        //return ConveyanceList.fromJson({'conveyanceList': data});
        return ConveyanceList.fromJson({'conveyanceList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Conveyance Settlement List.");
    }
  }



  Future<VisitingCardList> getMyVisitingCardList() async {
    try {
      print('Called getMyVisitingCardList()');
      final response = await _getRequest("/visiting-card/my-request-list");
      if (response.statusCode == 200){
        return VisitingCardList.fromJson({'visitingCardList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get My Visiting Card List.");
    }
  }

  Future<IdCardList> getMyIdCardList() async {
    try {
      print('Called getMyIdCardList()');
      // var data = [
      //   {
      //     "id": 4,
      //     "blood_group": "A-",
      //     "reason": "New",
      //     "supervisor": " Afeef Zubaer Zaman (1) ",
      //     "requisition_date": "31-Mar-2022",
      //     "required_status": "Within 7 days",
      //     "application_status": "In process"
      //   },
      //   {
      //     "id": 3,
      //     "blood_group": "B+",
      //     "reason": "Lost",
      //     "supervisor": " Afeef Zubaer Zaman (1) ",
      //     "requisition_date": "31-Mar-2022",
      //     "required_status": "Urgent",
      //     "application_status": "In process"
      //   }
      // ];
      //
      // return IdCardList.fromJson({'idCardList': data});

      final response = await _getRequest("/id-card/my-request-list");
      if (response.statusCode == 200){
        return IdCardList.fromJson({'idCardList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get My Id Card List.");
    }
  }

  Future<LetterList> getMyLetterList() async {
    try {
      print('Called getMyLetterList()');
      var data =
      [{
          "id": 18,
      "requisition_type": "Salary Certificate",
      "reason": "Credit Card",
      "supervisor": " Afeef Zubaer Zaman (1) ",
      "requisition_date": "21-May-2022",
      "application_status": "Waiting For Line Manager Approval"
      },
      {
      "id": 15,
      "requisition_type": "Introductory Letter",
      "reason": "Tourist Visa",
      "supervisor": " Afeef Zubaer Zaman (1) ",
      "requisition_date": "18-May-2022",
      "application_status": "In process"
      },
      {
      "id": 14,
      "requisition_type": "Invitation Letter",
      "reason": "Personal Purpose",
      "supervisor": " Afeef Zubaer Zaman (1) ",
      "requisition_date": "15-May-2022",
      "application_status": "Ready To Collect"
      },
      {
      "id": 13,
      "requisition_type": "Introductory Letter",
      "reason": "Tourist Visa",
      "supervisor": " Afeef Zubaer Zaman (1) ",
      "requisition_date": "15-May-2022",
      "application_status": "Ready To Collect"
      },
      {
      "id": 12,
      "requisition_type": "Experience Letter",
      "reason": "Higher Education",
      "supervisor": " Afeef Zubaer Zaman (1) ",
      "requisition_date": "15-May-2022",
      "application_status": "Ready To Collect"
      }];

      //return LetterList.fromJson({'letterList': data});

      final response = await _getRequest("/requisition-letter/my-request-list");
      if (response.statusCode == 200){
        return LetterList.fromJson({'letterList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get My Requested Letter List.");
    }
  }

  Future<LetterList> getLetterListLM() async {
    try {
      print('Called getMyLetterList()');
      var data =
      [{
          "id": 18,
          "requisition_type": "Salary Certificate",
          "reason": "Credit Card",
          "supervisor": " Afeef Zubaer Zaman (1) ",
          "requisition_date": "21-May-2022",
          "application_status": "Waiting For Line Manager Approval"
        },
        {
          "id": 15,
          "requisition_type": "Introductory Letter",
          "reason": "Tourist Visa",
          "supervisor": " Afeef Zubaer Zaman (1) ",
          "requisition_date": "18-May-2022",
          "application_status": "In process"
        },
        {
          "id": 14,
          "requisition_type": "Invitation Letter",
          "reason": "Personal Purpose",
          "supervisor": " Afeef Zubaer Zaman (1) ",
          "requisition_date": "15-May-2022",
          "application_status": "Ready To Collect"
        },
        {
          "id": 13,
          "requisition_type": "Introductory Letter",
          "reason": "Tourist Visa",
          "supervisor": " Afeef Zubaer Zaman (1) ",
          "requisition_date": "15-May-2022",
          "application_status": "Ready To Collect"
        },
        {
          "id": 12,
          "requisition_type": "Experience Letter",
          "reason": "Higher Education",
          "supervisor": " Afeef Zubaer Zaman (1) ",
          "requisition_date": "15-May-2022",
          "application_status": "Ready To Collect"
        },
        {
          "id": 10,
          "requisition_type": "Salary Certificate",
          "reason": "Personal Loan",
          "supervisor": " Afeef Zubaer Zaman (1) ",
          "requisition_date": "15-May-2022",
          "application_status": "Ready To Collect"
        }];

      //return LetterList.fromJson({'letterList': data});

      final response = await _getRequest("/requisition-letter/line-manager-list");
      if (response.statusCode == 200){
        return LetterList.fromJson({'letterList': response.data['data']['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Requested Letter List.");
    }
  }

  Future<LunchSubscriptionList> getMyLunchSubscriptionList() async {
    try {
      print('Called getMyLunchSubscriptionList()');

      // var data = [
      //   {
      //     "id": 3,
      //     "subscription_date": "09-Apr-2022",
      //     "from_date": "09-Apr-2022",
      //     "to_date": "Continue",
      //     "deduction_amount": 60,
      //     "subsidy_amount": 70,
      //     "status": "Subscribed"
      //   }
      // ];
      //
      // return LunchSubscriptionList.fromJson({'lunchSubscriptionList': data});

      final response = await _getRequest("/lunch-subscription/list");
      if (response.statusCode == 200){
        //print(response.data['data'].toString());
        return LunchSubscriptionList.fromJson({'lunchSubscriptionList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get My Lunch-Subscription List.");
    }
  }

  Future<IfterSubscriptionList> getMyIfterSubscriptionList() async {
    try {
      print('Called getMyIfterSubscriptionList()');
      // var data = [
      //   {
      //     "id": 1,
      //     "request_raise_date": "09-Feb-2023",
      //     "availing_date": "10-Feb-2023",
      //     "quantity": 10
      //   },
      //   {
      //     "id": 2,
      //     "request_raise_date": "10-Feb-2023",
      //     "availing_date": "11-Feb-2023",
      //     "quantity": 20
      //   }
      // ];
      // return IfterSubscriptionList.fromJson({'ifterSubscriptionList': data});

      final response = await _getRequest("/iftar-booking/list");
      if (response.statusCode == 200){
        //print(response.data['data'].toString());
        return IfterSubscriptionList.fromJson({'ifterSubscriptionList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get My Iftar-Subscription List.");
    }
  }

  Future<MealSetting> getMealSetting() async {

    try {
      print('Called getMealSetting()');
      final response = await _getRequest("/meal-settings");
      if (response.statusCode == 200){
        return MealSetting.fromJson(response.data['data']);
      }
      else
        return MealSetting();
    } catch (ex) {
      return MealSetting();
    }
  }

  Future<ClearanceList> getClearancelList() async {
    try {
      print('Called getClearancelList()');

      final response = await _getRequest("/clearance-feedbacks/list");
      if (response.statusCode == 200){
        return ClearanceList.fromJson({'clearanceList': response.data['data']['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Clearance List.");
    }
  }

  Future<ClearanceDetails> getClearanceDetails(String id) async {
    try {
      print('Called getClearanceDetails()');

      final response = await _getRequest("/clearance-feedbacks/create/$id");
      if (response.statusCode == 200){
        return ClearanceDetails.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Clearance Feedback Details.");
    }
  }

  Future<Response> applyForClearanceFeedbacks(FormData formData,String id) async {
    try {
      final response = await _postRequest(
        "/clearance-feedbacks/store/${id}",
        formData,
      );
      return response;
    } catch (ex) {
      throw Exception("Failed to apply for Clearance Feedbacks!");
    }
  }


  Future<VisitingCardBHDetailsList> getVisitingCardBHDetailList() async {
    try {
      print('Called getVisitingCardBHDetailList()');

    //   var data = [
    //     {"id": 23,
    // "employee_code": "EMP000",
    // "employee_name": "Md Sohel Rana",
    // "short_name": "Jasmine Atkins",
    // "employee_role": "Operations Analyst - IT",
    // "employee_division": "ShopUp Services",
    // "employee_department": "Admin, Security & IT Support",
    // "official_email": "ripomuzehe@mailinator.com",
    // "official_contact": "349",
    // "official_address": "<p><strong>Shopfront Limited</strong><br />\r\n50, Lake Circus, Kalabagan,<br />\r\nDhaka -1205, Bangladesh</p>",
    // "business_head": " Ataur Rahim Chowdhury (3) ",
    // "requisition_date": "26-Mar-2022",
    // "required_status": "Urgent",
    // "application_status": "Waiting For Business Unit Head Approval"
    // },
    //     {
    //       "id": 22,
    //       "employee_code": "EMP000",
    //       "employee_name": "Md Sohel Rana",
    //       "short_name": "Sohel",
    //       "employee_role": "Operations Analyst - IT",
    //       "employee_division": "ShopUp Services",
    //       "employee_department": "Admin, Security & IT Support",
    //       "official_email": "info.kmsohel@gmail.com",
    //       "official_contact": "01674961086",
    //       "official_address": "<p><strong>Shopfront Limited</strong><br />\r\n50, Lake Circus, Kalabagan,<br />\r\nDhaka -1205, Bangladesh</p>",
    //       "business_head": " Ataur Rahim Chowdhury (3) ",
    //       "requisition_date": "26-Mar-2022",
    //       "required_status": "Urgent",
    //       "application_status": "Waiting For Admin Approval"
    //     }];
    //
    //   return VisitingCardBHDetailsList.fromJson({'visitingCardBHDetailsList': data});
      final response = await _getRequest("/visiting-card/business-head-list");
      if (response.statusCode == 200){
        return VisitingCardBHDetailsList.fromJson({'visitingCardBHDetailsList': response.data['data']['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Requested List.");
    }
  }
  Future<VisitingCardBHDetailsList> getVisitingCardADDetailList() async {
    try {
      print('Called getVisitingCardADDetailList()');

      //   var data = [
      //     {"id": 23,
      // "employee_code": "EMP000",
      // "employee_name": "Md Sohel Rana",
      // "short_name": "Jasmine Atkins",
      // "employee_role": "Operations Analyst - IT",
      // "employee_division": "ShopUp Services",
      // "employee_department": "Admin, Security & IT Support",
      // "official_email": "ripomuzehe@mailinator.com",
      // "official_contact": "349",
      // "official_address": "<p><strong>Shopfront Limited</strong><br />\r\n50, Lake Circus, Kalabagan,<br />\r\nDhaka -1205, Bangladesh</p>",
      // "business_head": " Ataur Rahim Chowdhury (3) ",
      // "requisition_date": "26-Mar-2022",
      // "required_status": "Urgent",
      // "application_status": "Waiting For Business Unit Head Approval"
      // },
      //     {
      //       "id": 22,
      //       "employee_code": "EMP000",
      //       "employee_name": "Md Sohel Rana",
      //       "short_name": "Sohel",
      //       "employee_role": "Operations Analyst - IT",
      //       "employee_division": "ShopUp Services",
      //       "employee_department": "Admin, Security & IT Support",
      //       "official_email": "info.kmsohel@gmail.com",
      //       "official_contact": "01674961086",
      //       "official_address": "<p><strong>Shopfront Limited</strong><br />\r\n50, Lake Circus, Kalabagan,<br />\r\nDhaka -1205, Bangladesh</p>",
      //       "business_head": " Ataur Rahim Chowdhury (3) ",
      //       "requisition_date": "26-Mar-2022",
      //       "required_status": "Urgent",
      //       "application_status": "Waiting For Admin Approval"
      //     }];
      //
      //   return VisitingCardBHDetailsList.fromJson({'visitingCardBHDetailsList': data});
      final response = await _getRequest("/visiting-card/admin-list");
      if (response.statusCode == 200){
        return VisitingCardBHDetailsList.fromJson({'visitingCardBHDetailsList': response.data['data']['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Requested List.");
    }
  }

  Future<IdCardBHDetailsList> getIdCardADDetailList() async {
    try {
      print('Called getIdCardADDetailList()');
        // var data = [
        //   {
        //     "id": 4,
        //     "employee_code": "EMP000",
        //     "employee_name": "Md Sohel Rana",
        //     "employee_role": "Operations Analyst - IT",
        //     "employee_division": "ShopUp Services",
        //     "employee_department": "Admin, Security & IT Support",
        //     "line_manager": " Afeef Zubaer Zaman (1) ",
        //     "requisition_date": "31-Mar-2022",
        //     "required_status": "Within 7 days",
        //     "application_status": "In process",
        //     "delivery_date": "N/A",
        //     "completion_days": "N/A"
        //   },
        //   {
        //     "id": 3,
        //     "employee_code": "EMP000",
        //     "employee_name": "Md Sohel Rana",
        //     "employee_role": "Operations Analyst - IT",
        //     "employee_division": "ShopUp Services",
        //     "employee_department": "Admin, Security & IT Support",
        //     "line_manager": " Afeef Zubaer Zaman (1) ",
        //     "requisition_date": "31-Mar-2022",
        //     "required_status": "Urgent",
        //     "application_status": "In process",
        //     "delivery_date": "N/A",
        //     "completion_days": "N/A"
        //   }
        // ];
        //
        // return IdCardBHDetailsList.fromJson({'idCardBHDetailsList': data});
      final response = await _getRequest("/id-card/admin-list");
      if (response.statusCode == 200){
        return IdCardBHDetailsList.fromJson({'idCardBHDetailsList': response.data['data']['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Requested List.");
    }
  }

  Future<IdCardBHDetailsList> getIdCardLMDetailList() async {
    try {
      print('Called getIdCardLMDetailList()');
      // var data = [
      //   {
      //     "id": 4,
      //     "employee_code": "EMP000",
      //     "employee_name": "Md Sohel Rana",
      //     "employee_role": "Operations Analyst - IT",
      //     "employee_division": "ShopUp Services",
      //     "employee_department": "Admin, Security & IT Support",
      //     "requisition_date": "31-Mar-2022",
      //     "required_status": "Within 7 days",
      //     "application_status": "In process"
      //   },
      //   {
      //     "id": 3,
      //     "employee_code": "EMP000",
      //     "employee_name": "Md Sohel Rana",
      //     "employee_role": "Operations Analyst - IT",
      //     "employee_division": "ShopUp Services",
      //     "employee_department": "Admin, Security & IT Support",
      //     "requisition_date": "31-Mar-2022",
      //     "required_status": "Urgent",
      //     "application_status": "In process"
      //   }
      //
      // ];
      //
      // return IdCardBHDetailsList.fromJson({'idCardBHDetailsList': data});
      final response = await _getRequest("/id-card/line-manager-list");
      if (response.statusCode == 200){
        return IdCardBHDetailsList.fromJson({'idCardBHDetailsList': response.data['data']['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Requested List.");
    }
  }

  Future<WorkFromHomeList> getWorkFromHomeList() async {
    try {
      print('Called getWorkFromHomeList()');
      // var data= [{
      //   "wfh_id": 1,
      //   "first_name": "Jubaer",
      //   "middle_name": "Al",
      //   "last_name": "Hasan",
      //   "start_date": "2021-04-20",
      //   "end_date": "2021-04-21",
      //   "number_of_days": "02",
      //   "status": "approved"
      // }];
      //
      // return WorkFromHomeList.fromJson({'workFromHomeList': data});
      final response = await _getRequest("/work-from-home");
      if (response.statusCode == 200){
        return WorkFromHomeList.fromJson({'workFromHomeList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Off-Site Attendance List.");
    }
  }

  Future<ResignationDetails> getResignationDetail(int separation_id) async {
    try {
      print('Called getResignationDetail()');
      final response = await _getRequest("/resignations/show?separation_id=$separation_id");
      if (response.statusCode == 200){
        //print(response.data['data'].toString());
        return ResignationDetails.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Resignation Details.");
    }
  }

  Future<VisitingCardRequest> getVisitingCardRequest() async {
    try {
      print('Called getVisitingCardRequest()');
      final response = await _getRequest("/visiting-card/request");
      if (response.statusCode == 200){
        return VisitingCardRequest.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Visiting Card Request Details.");
    }
  }

  Future<IdCardRequest> getIdCardRequest() async {
    try {
      print('Called getIdCardRequest()');
      final response = await _getRequest("/id-card/request");
      if (response.statusCode == 200){
        return IdCardRequest.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get ID Card Request Details.");
    }
  }

  Future<LetterRequest> getLetterRequest() async {
    try {
      print('Called getLetterRequest()');

      var data = {
        "employee_division": "ShopUp Services",
        "employee_department": "Co-founder",
        "date_of_join": "08-Aug-2016",
        "employee_role": "Managing Director & CEO",
        "line_manager": "N/A",
        "requisition_for": [
          {
            "key": "Salary Certificate",
            "value": "Salary Certificate"
          },
          {
            "key": "Introductory Letter",
            "value": "Introductory Letter"
          },
          {
            "key": "Invitation Letter",
            "value": "Invitation Letter"
          },
          {
            "key": "Experience Letter",
            "value": "Experience Letter"
          }
        ],
        "salary_certificate": [
          {
            "key": "Personal Loan",
            "value": "Personal Loan"
          },
          {
            "key": "Credit Card",
            "value": "Credit Card"
          },
          {
            "key": "Others",
            "value": "Others (Please Specify)"
          }
        ],
        "introductory_letter": [
          {
            "key": "Tourist Visa",
            "value": "Tourist Visa"
          },
          {
            "key": "Business Visa",
            "value": "Business Visa"
          },
          {
            "key": "Medical Visa",
            "value": "Medical Visa"
          },
          {
            "key": "Others",
            "value": "Others (Please Specify)"
          }
        ],
        "experience_letter": [
          {
            "key": "Higher Education",
            "value": "Higher Education"
          },
          {
            "key": "Personal Purpose",
            "value": "Personal Purpose"
          }
        ],
        "invitation_letter": [
          {
            "key": "Personal Purpose",
            "value": "Personal Purpose"
          }
        ],
        "embassy": [
          {
            "embassy_name": "High Commission Of Malaysia",
            "address": "House No. 19 Road No. 6, Baridhara Diplomatic Enclave  Dhaka, Bangladesh"
          },
          {
            "embassy_name": "High Commission Of India",
            "address": "Floor - G1, South Court, Jamuna Future Park, Progoti Sharani, Baridhara, Dhaka-1229, Bangladesh"
          },
          {
            "embassy_name": "Embassy Of The Republic Of Maldives",
            "address": "House 20, Road No.4 Baridhara, Dhaka 1212, Bangladesh"
          },
          {
            "embassy_name": "Embassy Of Japan",
            "address": "Plot No. 5 & 7, Dutabash Rd, Dhaka 1212, Bangladesh"
          },
          {
            "embassy_name": "The Royal Embassy Of Saudi Arabia",
            "address": "House 5 (NE) L, Road 83 Gulshan 2 P.O. Box 6001 Dhaka 1212, Bangladesh"
          },
          {
            "embassy_name": "Embassy of Nepal",
            "address": "Diplomatic Enclave, 2 Number, United Nations Rd, Dhaka 1212, Bangladesh"
          },
          {
            "embassy_name": "Royal Thai Embassy",
            "address": "18 & 20, Madani Avenue, Baridhara, Dhaka-1212 Bangladesh"
          },
          {
            "embassy_name": "Others",
            "address": "Others"
          },
          {
            "embassy_name": "Ariana Maynard",
            "address": "Sint ullam consectet"
          },
          {
            "embassy_name": "Christine Welch",
            "address": "Animi voluptatem D"
          },
          {
            "embassy_name": "Other embassy",
            "address": "dfdef"
          }
        ]
      };
      //return LetterRequest.fromJson(data);

      final response = await _getRequest("/requisition-letter/create");
      if (response.statusCode == 200){
        return LetterRequest.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Letter Request Details.");
    }
  }

  Future<WorkFromHomeReason> getWFHReason() async {
    try {
      print('Called getWFHReason()');
      final response = await _getRequest("/work-from-home/reason");
      if (response.statusCode == 200){
        return WorkFromHomeReason.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Letter Request Details.");
    }
  }

  Future<LunchSubscriptionRequest> getLunchSubscriptionRequest() async {
    try {
      print('Called getLunchSubscriptionRequest()');
      // var data = {
      //   "employee_code": "EMP000",
      //   "employee_name": "Md Sohel Rana",
      //   "employee_role": "Operations Analyst - IT",
      //   "subscription_date": "20-Apr-2022",
      //   "subscription_request_time_line": "10:20:00",
      //   "per_meal": "60",
      //   "office_location": [
      //     {
      //       "id": 1,
      //       "name": "ShopUp HQ-1",
      //       "address": "SKS Tower",
      //       "floors": [
      //         {
      //           "id": 1,
      //           "name": "1st Floor",
      //           "office_location_id": 1,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         },
      //         {
      //           "id": 2,
      //           "name": "2nd Floor",
      //           "office_location_id": 1,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         }
      //       ]
      //     },
      //     {
      //       "id": 2,
      //       "name": "ShopUp HQ-2",
      //       "address": "H-112, Road-6, Mohakhali DOHS,Dhaka-1206",
      //       "floors": [
      //         {
      //           "id": 3,
      //           "name": "3rd Floor",
      //           "office_location_id": 2,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         },
      //         {
      //           "id": 4,
      //           "name": "4th Floor",
      //           "office_location_id": 2,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         }
      //       ]
      //     },
      //     {
      //       "id": 3,
      //       "name": "ShopUp HQ-3",
      //       "address": "H-190, Road-2, Mohakhali DOHS, Dhaka-1206",
      //       "floors": [
      //         {
      //           "id": 5,
      //           "name": "5th Floor",
      //           "office_location_id": 3,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         },
      //         {
      //           "id": 6,
      //           "name": "6th Floor",
      //           "office_location_id": 3,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         }
      //       ]
      //     },
      //     {
      //       "id": 4,
      //       "name": "Customer Experience",
      //       "address": "H-12, Road-09, Nikunja-1, Dhaka",
      //       "floors": [
      //         {
      //           "id": 7,
      //           "name": "7th Floor",
      //           "office_location_id": 4,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         }
      //       ]
      //     },
      //     {
      //       "id": 5,
      //       "name": "Tejgaon",
      //       "address": "Nabisko",
      //       "floors": []
      //     },
      //     {
      //       "id": 6,
      //       "name": "Yoshio Mcleod",
      //       "address": "Ipsum obcaecati vel",
      //       "floors": []
      //     },
      //     {
      //       "id": 7,
      //       "name": "Myra Griffith",
      //       "address": "Similique laboris co",
      //       "floors": [
      //         {
      //           "id": 9,
      //           "name": "Amethyst Brown",
      //           "office_location_id": 7,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 4607,
      //           "updated_by": null,
      //           "created_at": "2022-04-19T15:40:22.000000Z",
      //           "updated_at": "2022-04-19T15:40:22.000000Z",
      //           "deleted_at": null
      //         }
      //       ]
      //     }
      //   ]
      // };
      //
      // return LunchSubscriptionRequest.fromJson(data);

      final response = await _getRequest("/lunch-subscription/create");
      if (response.statusCode == 200){
        //print(response.data['data'].toString());
        return LunchSubscriptionRequest.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Lunch-Subscription Request Details.");
    }
  }

  Future<IfterSubscriptionRequest> getIfterSubscriptionRequest() async {
    try {
      print('Called getIfterSubscriptionRequest()');
      // var data = {
      //   "employee_code": "EMP000",
      //   "employee_name": "Md Sohel Rana",
      //   "employee_role": "Operations Analyst - IT",
      //   "subscription_date": "20-Apr-2022",
      //   "subscription_request_time_line": "10:20:00",
      //   "per_meal": "60",
      //   "office_location": [
      //     {
      //       "id": 1,
      //       "name": "ShopUp HQ-1",
      //       "address": "SKS Tower",
      //       "floors": [
      //         {
      //           "id": 1,
      //           "name": "1st Floor",
      //           "office_location_id": 1,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         },
      //         {
      //           "id": 2,
      //           "name": "2nd Floor",
      //           "office_location_id": 1,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         }
      //       ]
      //     },
      //     {
      //       "id": 2,
      //       "name": "ShopUp HQ-2",
      //       "address": "H-112, Road-6, Mohakhali DOHS,Dhaka-1206",
      //       "floors": [
      //         {
      //           "id": 3,
      //           "name": "3rd Floor",
      //           "office_location_id": 2,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         },
      //         {
      //           "id": 4,
      //           "name": "4th Floor",
      //           "office_location_id": 2,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         }
      //       ]
      //     },
      //     {
      //       "id": 3,
      //       "name": "ShopUp HQ-3",
      //       "address": "H-190, Road-2, Mohakhali DOHS, Dhaka-1206",
      //       "floors": [
      //         {
      //           "id": 5,
      //           "name": "5th Floor",
      //           "office_location_id": 3,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         },
      //         {
      //           "id": 6,
      //           "name": "6th Floor",
      //           "office_location_id": 3,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         }
      //       ]
      //     },
      //     {
      //       "id": 4,
      //       "name": "Customer Experience",
      //       "address": "H-12, Road-09, Nikunja-1, Dhaka",
      //       "floors": [
      //         {
      //           "id": 7,
      //           "name": "7th Floor",
      //           "office_location_id": 4,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 1,
      //           "updated_by": null,
      //           "created_at": null,
      //           "updated_at": null,
      //           "deleted_at": null
      //         }
      //       ]
      //     },
      //     {
      //       "id": 5,
      //       "name": "Tejgaon",
      //       "address": "Nabisko",
      //       "floors": []
      //     },
      //     {
      //       "id": 6,
      //       "name": "Yoshio Mcleod",
      //       "address": "Ipsum obcaecati vel",
      //       "floors": []
      //     },
      //     {
      //       "id": 7,
      //       "name": "Myra Griffith",
      //       "address": "Similique laboris co",
      //       "floors": [
      //         {
      //           "id": 9,
      //           "name": "Amethyst Brown",
      //           "office_location_id": 7,
      //           "status": 1,
      //           "remarks": null,
      //           "created_by": 4607,
      //           "updated_by": null,
      //           "created_at": "2022-04-19T15:40:22.000000Z",
      //           "updated_at": "2022-04-19T15:40:22.000000Z",
      //           "deleted_at": null
      //         }
      //       ]
      //     }
      //   ]
      // };
      //
      // return LunchSubscriptionRequest.fromJson(data);

      final response = await _getRequest("/iftar-booking/create");
      if (response.statusCode == 200){
        return IfterSubscriptionRequest.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Iftar-Subscription Request Details.");
    }
  }

  Future<EditVisitingCardRequest> getEditVisitingCardRequest(int visiting_card_id) async {
    try {
      print('Called getEditVisitingCardRequest()');
      // var data ={
      //   "employee_details": {
      //     "employee_code": "EMP000",
      //     "employee_name": "Md Sohel Rana",
      //     "employee_role": "Operations Analyst - IT",
      //     "employee_division": "ShopUp Services",
      //     "employee_department": "Admin, Security & IT Support",
      //     "requisition_date": "2022-04-01T05:59:53.502966Z",
      //     "business_heads": [
      //       {
      //         "id": 3,
      //         "name": "Ataur Rahim Chowdhury 3"
      //       }
      //     ],
      //     "visiting_card_quantity": "300",
      //     "required_status": [
      //       {
      //         "key": "Urgent",
      //         "value": "Urgent"
      //       },
      //       {
      //         "key": "Within 7 days",
      //         "value": "Within 7 days"
      //       },
      //       {
      //         "key": "As early as possible",
      //         "value": "As early as possible"
      //       }
      //     ],
      //     "office_address": [
      //       {
      //         "key": "SKS Tower (4th Floor) VIP Road, Mohakhali, Dhaka-1208",
      //         "value": "SKS Tower (4th Floor) VIP Road, Mohakhali, Dhaka-1208"
      //       },
      //       {
      //         "key": "House-112, Road-06, Mohakhali DOHS, Dhaka-1206",
      //         "value": "House-112, Road-06, Mohakhali DOHS, Dhaka-1206"
      //       },
      //       {
      //         "key": "House-184, Road-02, Mohakhali DOHS, Dhaka-1206",
      //         "value": "House-184, Road-02, Mohakhali DOHS, Dhaka-1206"
      //       },
      //       {
      //         "key": "House-190, Road-02, Mohakhali DOHS, Dhaka 1206",
      //         "value": "House-190, Road-02, Mohakhali DOHS, Dhaka 1206"
      //       },
      //       {
      //         "key": "1327 Tejgaon Industrial Area, Dhaka- 1208, Bangladesh",
      //         "value": "1327 Tejgaon Industrial Area, Dhaka- 1208, Bangladesh"
      //       },
      //       {
      //         "key": "199, Tejgaon Industrial Area, Dhaka- 1208, Bangladesh",
      //         "value": "199, Tejgaon Industrial Area, Dhaka- 1208, Bangladesh"
      //       },
      //       {
      //         "key": "205, 1 Bir Uttam Mir Shawkat Sarak, Dhaka 1208",
      //         "value": "205, 1 Bir Uttam Mir Shawkat Sarak, Dhaka 1208"
      //       }
      //     ]
      //   },
      //   "visiting_card_details": {
      //     "id": 34,
      //     "employee_id": 8705,
      //     "approval_authority_id": 3,
      //     "short_name": "Madaline Byrd",
      //     "official_email": "lodyxafif@mailinator.com",
      //     "official_contact": "545454545",
      //     "official_address": "House-184, Road-02, Mohakhali DOHS, Dhaka-1206",
      //     "requisition_date": "2022-04-01",
      //     "quantity": 300,
      //     "required_status": "Within 7 days",
      //     "remarks": "fgfg"
      //   }
      // };
      // return EditVisitingCardRequest.fromJson(data);

      final response = await _getRequest("/visiting-card/edit?visiting_card_id=$visiting_card_id");
      if (response.statusCode == 200){
        return EditVisitingCardRequest.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Visiting Card Request Details.");
    }
  }

  Future<EditLetterRequest> getEditLetterRequest(int requisition_letter_id) async {
    try {
      print('Called getEditLetterRequest()');


      final response = await _getRequest("/requisition-letter/edit?requisition_letter_id=$requisition_letter_id");
      if (response.statusCode == 200){
        return EditLetterRequest.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Letter Request Details.");
    }
  }

  Future<EditIdCardRequest> getEditIdCardRequest(int id_card_id) async {
    try {
      print('Called getEditIdCardRequest()');
      // var data ={
      //   "employee_details": {
      //     "employee_code": "EMP000",
      //     "employee_name": "Md Sohel Rana",
      //     "employee_role": "Operations Analyst - IT",
      //     "employee_division": "ShopUp Services",
      //     "employee_department": "Admin, Security & IT Support",
      //     "line_manager": " Afeef Zubaer Zaman (1) ",
      //     "requisition_date": "2022-04-03",
      //     "required_status": [
      //       {
      //         "key": "Urgent",
      //         "value": "Urgent"
      //       },
      //       {
      //         "key": "Within 7 days",
      //         "value": "Within 7 days"
      //       },
      //       {
      //         "key": "As early as possible",
      //         "value": "As early as possible"
      //       }
      //     ],
      //     "blood_group": [
      //       {
      //         "key": "A+",
      //         "value": "A+"
      //       },
      //       {
      //         "key": "A-",
      //         "value": "A-"
      //       },
      //       {
      //         "key": "B+",
      //         "value": "B+"
      //       },
      //       {
      //         "key": "B-",
      //         "value": "B-"
      //       },
      //       {
      //         "key": "AB+",
      //         "value": "AB+"
      //       },
      //       {
      //         "key": "AB-",
      //         "value": "AB-"
      //       },
      //       {
      //         "key": "O+",
      //         "value": "O+"
      //       },
      //       {
      //         "key": "O-",
      //         "value": "O-"
      //       }
      //     ],
      //     "reason": [
      //       {
      //         "key": "New",
      //         "value": "New"
      //       },
      //       {
      //         "key": "Lost",
      //         "value": "Lost"
      //       }
      //     ]
      //   },
      //   "id_card_details": {
      //     "id": 6,
      //     "employee_id": 8705,
      //     "line_manager_id": 1,
      //     "blood_group": "O+",
      //     "reason": "Lost",
      //     "photo": "uploads/requisition/id-card-attachment/62473cc1f0e881648835777.jpg",
      //     "attachment": "uploads/requisition/id-card-attachment/62473cc203dae1648835778.jpg",
      //     "requisition_date": "2022-04-01",
      //     "required_status": "Within 7 days",
      //     "remarks": "N/A",
      //     "application_status": "Reverted"
      //   },
      //   "photo": "http://127.0.0.1:8000/storage/uploads/requisition/id-card-attachment/62473cc1f0e881648835777.jpg",
      //   "attachment": "http://127.0.0.1:8000/storage/uploads/requisition/id-card-attachment/62473cc203dae1648835778.jpg"
      // };
      // return EditIdCardRequest.fromJson(data);

      final response = await _getRequest("/id-card/edit?id_card_id=$id_card_id");
      if (response.statusCode == 200){
        return EditIdCardRequest.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get ID Card Request Details.");
    }
  }

  Future<VisitingCardDetails> getVisitingCardDetails(int id) async {
    try {
      print('Called getVisitingCardDetails()');
      final response = await _getRequest("/visiting-card/view?visiting_card_id=$id");
      if (response.statusCode == 200){
        return VisitingCardDetails.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Visiting Card Details.");
    }
  }


  Future<IdCardDetails> getIdCardDetails(int id) async {
    try {
      print('Called getIdCardDetails()');
      final response = await _getRequest("/id-card/view?id_card_id=$id");
      if (response.statusCode == 200){
        return IdCardDetails.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Id Card Details.");
    }
  }

  Future<ConveyanceInfoDetails> getConveyanceDetails(int id) async {
    try {
      print('Called getConveyanceDetails()');
      final response = await _getRequest("/conveyance/view/$id");
      if (response.statusCode == 200){
        return ConveyanceInfoDetails.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Id Card Details.");
    }
  }

  Future<LetterDetails> getLetterDetails(int id) async {
    try {
      print('Called getLetterDetails()');
      final response = await _getRequest("/requisition-letter/view?requisition_letter_id=$id");
      if (response.statusCode == 200){
        var data = {
          "id": 28,
          "employee_code": "4417",
          "employee_name": "Shaolin  Akter",
          "employee_role": "Employee Experience Expert",
          "employee_division": "ShopUp Services",
          "employee_department": "Human Resources",
          "line_manager": "N/A",
          "requisition_type": "Introductory Letter",
          "reason": "Tourism",
          "requisition_date": "20-Jun-2022",
          "start_date": "28-Jun-2022",
          "end_date": "30-Jun-2022",
          "date_of_birth": "20-Jan-1991",
          "reference_no": "ShopUp/Human Resources/LOI/4417#9905/2022",
          "application_status": "Waiting For Line Manager Approval",
          "salary_display": 1,
          "embassy_name": "dffd",
          "embassy_address": "dfdfd",
          "passport_no": "1232343",
          "attachment": "http://127.0.0.1:8000/uploads/requisition/letter-attachment/62b0adc03b73d1655745984.jpg",
          "approval_authorities": [
            {
              "authority_name": " Dibyendu Das Sourav (4439) ",
              "authority_order": 1,
              "authority_status": "In Progress",
              "processed_employee": null,
              "created_at": "2022-06-20T17:26:24.000000Z",
              "remarks": null
            }
          ],
          "application_approval": false
        };
        //return LetterDetails.fromJson(data);

        return LetterDetails.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Letter Details.");
    }
  }

  Future<LunchSubscriptionDetailsList> getLunchSubscriptionDetails() async {
    try {
      print('Called getLunchSubscriptionDetails()');

      // var data = [
      //   {
      //     "id": 179,
      //     "lunch_subscription_id": 3,
      //     "total_lunch_bill": 1320,
      //     "total_lunch_taken": 22,
      //     "month": "April-22",
      //     "subscription_date": "2022-04-09",
      //     "un_subscription_date": null
      //   },
      //   {
      //     "id": 223,
      //     "lunch_subscription_id": 3,
      //     "total_lunch_bill": 1200,
      //     "total_lunch_taken": 20,
      //     "month": "May-22",
      //     "subscription_date": "2022-04-09",
      //     "un_subscription_date": null
      //   }
      // ];
      //
      // return LunchSubscriptionDetailsList.fromJson({'lunchSubscriptionDetailList': data});

      final response = await _getRequest("/lunch-subscription/view"); //?lunch_subscription_id=$id
      if (response.statusCode == 200){
        return LunchSubscriptionDetailsList.fromJson({'lunchSubscriptionDetailList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Lunch-Subscription Details.");
    }
  }

  Future<WorkFromHomeDetails> getWorkFromHomeDetail(int wfh_id) async {
    try {
      print('Called getWorkFromHomeDetail()');
      String id= wfh_id.toString();
      final response = await _getRequest("/work-from-home/application/$id");
      if (response.statusCode == 200){
        //print(response.data['data'].toString());
        return WorkFromHomeDetails.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Off-Site Attendance Details.");
    }
  }

  Future<ResignationAwaitingList> getResignationAwaitingList() async {
    try {
      print('Called getResignationAwaitingList()');
      final response = await _getRequest("/resignations/awaiting-approval");
      if (response.statusCode == 200){
        return ResignationAwaitingList.fromJson({'resignationAwaitingList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Resignation Awaiting List.");
    }
  }

  Future<WorkFromHomeAwaitingList> getWorkFromHomeAwaitingList() async {
    try {
      print('Called getWorkFromHomeAwaitingList()');
      final response = await _getRequest("/work-from-home/waiting-for-approval");
      if (response.statusCode == 200){
        //print(response.data['data']);
        return WorkFromHomeAwaitingList.fromJson({'workFromHomeAwaitingList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Off-Site Attendance Awaiting List");
    }
  }

  Future<ResignationAwaitingList> getResignationApprovedList() async {
    try {
      print('Called getResignationApprovedList()');
      final response = await _getRequest("/resignations/approved-list");
      if (response.statusCode == 200){
        return ResignationAwaitingList.fromJson({'resignationAwaitingList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Resignation Approved List.");
    }
  }

  Future<ResignationAwaitingList> getResignationPendingList() async {
    try {
      print('Called getResignationPendingList()');
      final response = await _getRequest("/resignations/pending");
      if (response.statusCode == 200){
        return ResignationAwaitingList.fromJson({'resignationAwaitingList': response.data['data']});
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Resignation Pending List.");
    }
  }


  Future<ResignationInfo> getResignationInfo() async {
    try {
      print('Called getResignationInfo()');
      final response = await _getRequest("/resignations/create");
      //print(response.data.toString());
      if (response.statusCode == 200)
        return ResignationInfo.fromJson(response.data['data']);

      else
        return ResignationInfo();
    } catch (ex) {
      return ResignationInfo();
    }
  }

  Future<ConveyanceInfo> getConveyanceInfo() async {
    try {
      print('Called getConveyanceInfo()');
      final response = await _getRequest("/conveyance/create");
      //print(response.data.toString());
      if (response.statusCode == 200)
        return ConveyanceInfo.fromJson(response.data['data']);

      else
        return ConveyanceInfo();
    } catch (ex) {
      return ConveyanceInfo();
    }
  }

  Future<EditConveyanceInfo> getEditConveyanceInfo(int id) async {
    try {
      print('Called getEditConveyanceInfo()');
      final response = await _getRequest("/conveyance/edit/$id");
      //print(response.data.toString());
      if (response.statusCode == 200)
        return EditConveyanceInfo.fromJson(response.data['data']);

      else
        return EditConveyanceInfo();
    } catch (ex) {
      return EditConveyanceInfo();
    }
  }

  Future<KeyValuePairList> getResignationReason() async {
    try {
      print('Called getResignationReason()');
      final response = await _getRequest("/resignations/resignation-reason");

      if (response.statusCode == 200) {
        var res = response.data['data']
            .toString()
            .replaceAll('{', '')
            .replaceAll('}', '')
            .split(',')
            .toList();
        List<Map<String, dynamic>> data = [];
        res.forEach((type) {
          var travel = type.split(':').toList();
          var e = TravelType();
          e.id = travel[0].toString().trim();
          e.name = travel[1].toString().trim();
          data.add(e.toJson());
        });
        return KeyValuePairList.fromJson({"keyValuePairList": data});
      } else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Resignation Reason List.");
    }
  }

  Future<NoticePeriodPolicy> getNoticePeriodPolicyList() async {
    try {
      print('Called getNoticePeriodPolicyList()');
      final response = await _getRequest("/resignation-notice-period-policy");
      if (response.statusCode == 200){
        return NoticePeriodPolicy.fromJson(response.data['data']);
      }
      else
        throw Exception(response.data["message"]);
    } catch (ex) {
      print(ex);
      throw Exception("Failed to get Notice Period Policy");
    }
  }

  Future<Response> approveResignationRequest(String token,String note,String policy) async {
    try {
      print('Called approveResignationRequest()');
      var formData={
        "token":token,
        "note":note,
        "notice_period_policy":policy
      };
      final response = await _postRequest("/resignations/approved", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Approved request");
    }
  }

  Future<Response> approvalVisitingCardRequest(int visiting_card_id,String remarks,String submit) async {
    try {
      print('Called approvalVisitingCardRequest()');
      var formData={
        "visiting_card_id":visiting_card_id,
        "remarks":remarks,
        "submit":submit
      };
      final response = await _postRequest("/visiting-card/status-update", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Approved request");
    }
  }

  Future<Response> approvalIdCardRequest(int id_card_id,String remarks,String submit) async {
    try {
      print('Called approvalIdCardRequest()');
      var formData={
        "id_card_id":id_card_id,
        "remarks":remarks,
        "submit":submit
      };
      final response = await _postRequest("/id-card/status-update", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Approved request");
    }
  }

  Future<Response> approvalConveyanceRequest(int id,String remarks,String submit) async {
    try {
      print('Called approvalConveyanceRequest()');
      var formData={
        "id":id,
        "remarks":remarks,
        "submit":submit
      };
      final response = await _postRequest("/conveyance/status-update", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Approved request");
    }
  }

  Future<Response> approvalConveyanceSettlementRequest(int id,String remarks,String submit) async {
    try {
      print('Called approvalConveyanceSettlementRequest()');
      var formData={
        "id":id,
        "remarks":remarks,
        "submit":submit
      };
      final response = await _postRequest("/conveyance-settlement/status-update", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Approved request");
    }
  }

  Future<Response> approvalLetterRequest(int requisition_letter_id,String remarks,String submit) async {
    try {
      print('Called approvalLetterRequest()');
      var formData={
        "requisition_letter_id":requisition_letter_id,
        "remarks":remarks,
        "submit":submit
      };
      final response = await _postRequest("/requisition-letter/status-update", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Approved request");
    }
  }

  Future<Response> approveRejectWFHRequest(String wfh_id,String note,String application_event) async {
    try {
      print('Called approveRejectWFHRequest()');
      var formData={
        "wfh_id":wfh_id,
        "note":note,
        "application_event":application_event
      };
      final response = await _postRequest("/work-from-home/process", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Proces the request");
    }
  }

  Future<Response> rejectResignationRequest(String token,String note) async {
    try {
      print('Called rejectResignationRequest()');
      var formData={
        "token":token,
        "note":note
      };
      final response = await _postRequest("/resignations/rejected", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Reject request");
    }
  }

  Future<Response> revertResignationRequest(String token,String note) async {
    try {
      print('Called revertResignationRequest()');
      var formData={
        "token":token,
        "note":note
      };
      final response = await _postRequest("/resignations/reverted", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Revert request");
    }
  }

  Future<Response> deleteResignationRequest(int separation_id) async {
    try {
      print('Called deleteResignationRequest()');
      var formData={
        "separation_id":separation_id,
      };
      final response = await _postRequest("/resignations/delete", formData);
      return response;
    } catch (ex) {
      throw Exception("Failed to Delete request");
    }
  }

  Future<EditResignation> getEditResignation(int separation_id) async {
    try {
      print('Called getEditResignation()');
      final response = await _getRequest("/resignations/edit?separation_id=$separation_id");
      if (response.statusCode == 200){
        return EditResignation.fromJson(response.data['data']);
      }
      else
        //return TravelSettlement();
        throw Exception(response.data["message"]);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  Future<bool> getSalaryPaySlip(int month, int year, String filePath) async {
    try {
      //Adding zero before int
      String  mn = month.toString().padLeft(2, '0');
      final response = await _client.download("/my-payslip?year=$year&month=$mn", filePath);

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (ex) {
      print("Salary Pay Slip: " + ex.toString());
      return false;
    }
  }

  Future<bool> getLeaveAttachment(String leave_id, String filePath) async {
    try {

      final response = await _client.download("/leave/download?leave_id=$leave_id", filePath);

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (ex) {
      print("Leave Attachment: " + ex.toString());
      return false;
    }
  }

  Future<bool> getTravellPlan(String travel_id, String filePath) async {
    try {

      final response = await _client.download("/travelplan/download?travel_plan_id=$travel_id", filePath);

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (ex) {
      print("travelplan download: " + ex.toString());
      return false;
    }
  }

  Future<bool> getTaxCard(int month, int year, String filePath) async {
    try {
      String  mn = month.toString().padLeft(2, '0');
      final response = await _client.download("/my-tax-card?year=$year&month=$mn", filePath);

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (ex) {
      print("Tax Card: " + ex.toString());
      return false;
    }
  }

  Future<bool> getWFHAttachment(int wfh_id, String filePath) async {
    print("Called getWFHAttachment()");
    try {
      final response = await _client.download("/work-from-home/attachment?wfh_id=$wfh_id", filePath);

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (ex) {
      print("WFH Attachment: " + ex.toString());
      return false;
    }
  }

  Future<bool> getPFSummary(int year, String filePath) async {
    try {
      final response = await _client.download("/PF/PFSummary?&year=$year", filePath);

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (ex) {
      print("PF Summary: " + ex.toString());
      return false;
    }
  }

  Future<bool> getWPPFSummary(String filePath) async {
    try {
      final response = await _client.download("/WPPF/WPPFSummary", filePath);

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (ex) {
      print("WPPF Summary: " + ex.toString());
      return false;
    }
  }

  Future<bool> getLoanSummary(String filePath) async {
    try {
      final response = await _client.download("/Loan/LoanSummary", filePath);

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (ex) {
      print("Loan Summary: " + ex.toString());
      return false;
    }
  }

  Future<bool> getGFSummary(String filePath) async {
    try {
      final response = await _client.download("/GF/GFSummary", filePath);

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (ex) {
      print("GF Summary: " + ex.toString());
      return false;
    }
  }

  Future<Response> markNotificationListAsRead() async {
    try {
      return await _getRequest("/mark-as-read");
    } catch (ex) {
      throw Exception("Failed to mark notifications as seen.");
    }
  }
  // Future<Response> markNotificationListAsRead(List<int> notificationList) async {
  //   try {
  //     return await _postRequest("/Notification/MarkAsRead", notificationList);
  //   } catch (ex) {
  //     throw Exception("Failed to mark notifications as seen.");
  //   }
  // }

  Future<Response> approvelLeave(int leaveId) async {
    print('Called approvelLeave()');
    try {
      //Map<String, dynamic>  formData;
      var formData={
        "leave_id":leaveId.toString(),
        "note":"",
      };

      return await _postRequest("/leave/approve", formData);
    } catch (ex) {
      throw Exception("Failed to approve leave request.");
    }
  }

  Future<Response> cancelLeave(int leaveId) async {
    print('Called cancelLeave()');
    try {
      //Map<String, dynamic>  formData;
      var formData={
        "leave_id":leaveId.toString(),
        "note":"",
      };

      return await _postRequest("/leave/cancel", formData);
    } catch (ex) {
      throw Exception("Failed to cancel leave request.");
    }
  }

  Future<Response> deleteNotification(int id) async {
    try {
      return await _deleteRequest("/Notification/DeleteNotification/$id");
    } catch (ex) {
      throw Exception("Failed to delete notification.");
    }
  }

  // --------------------------------------------------------------
}

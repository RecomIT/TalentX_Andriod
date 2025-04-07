import 'package:recom_app/data/models/key_value_pair.dart';

class ClearanceDetails {
  EmployeeInfo employeeInfo;
  StatusDropdown statusDropdown;
  bool clearanceAuthority;

  ClearanceDetails(
      {this.employeeInfo, this.statusDropdown, this.clearanceAuthority});

  ClearanceDetails.fromJson(Map<String, dynamic> json) {
    employeeInfo = json['employee_info'] != null
        ? new EmployeeInfo.fromJson(json['employee_info'])
        : null;
    statusDropdown = json['status_dropdown'] != null
        ? new StatusDropdown.fromJson(json['status_dropdown'])
        : null;
    clearanceAuthority = json['clearance_authority']?? false;
  }
}

class EmployeeInfo {
  String employeeName;
  String joiningDate;
  String personalPhone;
  String personalEmail;
  String officialPhone;
  String officialEmail;
  String employeeLocation;
  String supervisorId;
  String supervisorName;
  String supervisorPhone;
  String supervisorEmail;
  int noticePeriod;
  int noticePeriodServed;
  String applicationDate;
  String resignationEffectiveDate;
  String leavingReason;

  EmployeeInfo(
      {this.employeeName,
        this.joiningDate,
        this.personalPhone,
        this.personalEmail,
        this.officialPhone,
        this.officialEmail,
        this.employeeLocation,
        this.supervisorId,
        this.supervisorName,
        this.supervisorPhone,
        this.supervisorEmail,
        this.noticePeriod,
        this.noticePeriodServed,
        this.applicationDate,
        this.resignationEffectiveDate,
        this.leavingReason});

  EmployeeInfo.fromJson(Map<String, dynamic> json) {
    employeeName = json['employee_name']?? '-';
    joiningDate = json['joining_date']?? '-';
    personalPhone = json['personal_phone']?? '-';
    personalEmail = json['personal_email']?? '-';
    officialPhone = json['official_phone']?? '-';
    officialEmail = json['official_email']?? '-';
    employeeLocation = json['employee_location']?? '-';
    supervisorId = json['supervisor_id']?? '-';
    supervisorName = json['supervisor_name']?? '-';
    supervisorPhone = json['supervisor_phone']?? '-';
    supervisorEmail = json['supervisor_email']?? '-';
    noticePeriod = json['notice_period']?? 0;
    noticePeriodServed = json['notice_period_served']?? 0;
    applicationDate = json['application_date']?? '-';
    resignationEffectiveDate = json['resignation_effective_date']?? '-';
    leavingReason = json['leaving_reason']?? '-';
  }
}

class StatusDropdown {

  List<KeyValuePair> statusDropdownList=<KeyValuePair>[];
  StatusDropdown({this.statusDropdownList});

  StatusDropdown.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      statusDropdownList.add(KeyValuePair(id: key.trim(),name: value.trim() ));
    });
  }
}

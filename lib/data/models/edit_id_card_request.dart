import 'package:recom_app/data/models/id_card_details.dart';
import 'package:recom_app/data/models/id_card_request.dart';

class EditIdCardRequest {
  EmployeeDetails employeeDetails;
  IdCardDetails idCardDetails;
  String photo;
  String attachment;

  EditIdCardRequest(
      {this.employeeDetails, this.idCardDetails, this.photo, this.attachment});

  EditIdCardRequest.fromJson(Map<String, dynamic> json) {
    employeeDetails = json['employee_details'] != null
        ? new EmployeeDetails.fromJson(json['employee_details'])
        : null;
    idCardDetails = json['id_card_details'] != null
        ? new IdCardDetails.fromJson(json['id_card_details'])
        : null;
    photo = json['photo']??'N/A';
    attachment = json['attachment']??'N/A';
  }
}

class EmployeeDetails {
  String employeeCode;
  String employeeName;
  String employeeRole;
  String employeeDivision;
  String employeeDepartment;
  String lineManager;
  String requisitionDate;
  List<RequiredStatus> requiredStatus;
  List<BloodGroup> bloodGroup;
  List<Reason> reason;

  EmployeeDetails(
      {this.employeeCode,
        this.employeeName,
        this.employeeRole,
        this.employeeDivision,
        this.employeeDepartment,
        this.lineManager,
        this.requisitionDate,
        this.requiredStatus,
        this.bloodGroup,
        this.reason});

  EmployeeDetails.fromJson(Map<String, dynamic> json) {
    employeeCode = json['employee_code']??'';
    employeeName = json['employee_name']??'';
    employeeRole = json['employee_role']??'';
    employeeDivision = json['employee_division']??'';
    employeeDepartment = json['employee_department']??'';
    lineManager = json['line_manager']??'';
    requisitionDate = json['requisition_date']??'N/A';
    if (json['required_status'] != null) {
      requiredStatus = <RequiredStatus>[];
      json['required_status'].forEach((v) {
        requiredStatus.add(new RequiredStatus.fromJson(v));
      });
    }
    if (json['blood_group'] != null) {
      bloodGroup = <BloodGroup>[];
      json['blood_group'].forEach((v) {
        bloodGroup.add(new BloodGroup.fromJson(v));
      });
    }
    if (json['reason'] != null) {
      reason = <Reason>[];
      json['reason'].forEach((v) {
        reason.add(new Reason.fromJson(v));
      });
    }
  }
}



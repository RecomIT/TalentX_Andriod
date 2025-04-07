import 'package:recom_app/data/models/visiting_card_details.dart';
import 'package:recom_app/data/models/visiting_card_request.dart';

class EditVisitingCardRequest {
  EmployeeDetails employeeDetails;
  VisitingCardDetails visitingCardDetails;

  EditVisitingCardRequest({this.employeeDetails, this.visitingCardDetails});

  EditVisitingCardRequest.fromJson(Map<String, dynamic> json) {
    employeeDetails = json['employee_details'] != null
        ? new EmployeeDetails.fromJson(json['employee_details'])
        : null;
    visitingCardDetails = json['visiting_card_details'] != null
        ? new VisitingCardDetails.fromJson(json['visiting_card_details'])
        : null;
  }
}

class EmployeeDetails {
  int id;
  String employeeCode;
  String employeeName;
  String employeeRole;
  String employeeDivision;
  String employeeDepartment;
  String requisitionDate;
  List<BusinessHeads> businessHeads;
  String visitingCardQuantity;
  List<RequiredStatus> requiredStatus;
  List<OfficeAddress> officeAddress;

  EmployeeDetails(
      {this.id,this.employeeCode,
        this.employeeName,
        this.employeeRole,
        this.employeeDivision,
        this.employeeDepartment,
        this.requisitionDate,
        this.businessHeads,
        this.visitingCardQuantity,
        this.requiredStatus,
        this.officeAddress});

  EmployeeDetails.fromJson(Map<String, dynamic> json) {
    id=json['id']??0;
    employeeCode = json['employee_code']??'';
    employeeName = json['employee_name']??'';
    employeeRole = json['employee_role']??'';
    employeeDivision = json['employee_division']??'';
    employeeDepartment = json['employee_department']??'';
    requisitionDate = json['requisition_date']??'';
    if (json['business_heads'] != null) {
      businessHeads = <BusinessHeads>[];
      json['business_heads'].forEach((v) {
        businessHeads.add(new BusinessHeads.fromJson(v));
      });
    }
    visitingCardQuantity = json['visiting_card_quantity']??'0';
    if (json['required_status'] != null) {
      requiredStatus = <RequiredStatus>[];
      json['required_status'].forEach((v) {
        requiredStatus.add(new RequiredStatus.fromJson(v));
      });
    }
    if (json['office_address'] != null) {
      officeAddress = <OfficeAddress>[];
      json['office_address'].forEach((v) {
        officeAddress.add(new OfficeAddress.fromJson(v));
      });
    }
  }
}

class VisitingCardBHDetailsList {
  var visitingCardBHDetailsList = <VisitingCardBHDetails>[];

  VisitingCardBHDetailsList({this.visitingCardBHDetailsList});

  VisitingCardBHDetailsList.fromJson(Map<String, dynamic> json) {
    if (json['visitingCardBHDetailsList'] != null) {
      visitingCardBHDetailsList = <VisitingCardBHDetails>[];
      json['visitingCardBHDetailsList'].forEach((v) {
        visitingCardBHDetailsList.add(VisitingCardBHDetails.fromJson(v));
      });
    }
  }
}


class VisitingCardBHDetails {
  int id;
  String employeeCode;
  String employeeName;
  String shortName;
  String employeeRole;
  String employeeDivision;
  String employeeDepartment;
  String officialEmail;
  String officialContact;
  String officialAddress;
  String businessHead;
  String requisitionDate;
  String requiredStatus;
  String applicationStatus;
  int quantity;
  String deliveryDate;
  String completionDays;

  VisitingCardBHDetails(
      {this.id,
        this.employeeCode,
        this.employeeName,
        this.shortName,
        this.employeeRole,
        this.employeeDivision,
        this.employeeDepartment,
        this.officialEmail,
        this.officialContact,
        this.officialAddress,
        this.businessHead,
        this.requisitionDate,
        this.requiredStatus,
        this.applicationStatus,
        this.quantity,
        this.completionDays,
        this.deliveryDate});

  VisitingCardBHDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeCode = json['employee_code'] ??'';
    employeeName = json['employee_name']??'';
    shortName = json['short_name']??'';
    employeeRole = json['employee_role']??'';
    employeeDivision = json['employee_division']??'';
    employeeDepartment = json['employee_department']??'';
    officialEmail = json['official_email']??'';
    officialContact = json['official_contact']??'';
    officialAddress = json['official_address']??'';
    businessHead = json['business_head']??'';
    requisitionDate = json['requisition_date']??'N/A';
    requiredStatus = json['required_status']??'';
    applicationStatus = json['application_status']??'';

    quantity = json['quantity']??0;
    completionDays = json['completion_days']??'N/A';
    deliveryDate = json['delivery_date']??'N/A';
  }
}
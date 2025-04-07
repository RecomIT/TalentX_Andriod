class IdCardBHDetailsList {
  var idCardBHDetailsList = <IdCardBHDetails>[];

  IdCardBHDetailsList({this.idCardBHDetailsList});

  IdCardBHDetailsList.fromJson(Map<String, dynamic> json) {
    if (json['idCardBHDetailsList'] != null) {
      idCardBHDetailsList = <IdCardBHDetails>[];
      json['idCardBHDetailsList'].forEach((v) {
        idCardBHDetailsList.add(IdCardBHDetails.fromJson(v));
      });
    }
  }
}

class IdCardBHDetails {
  int id;
  String employeeCode;
  String employeeName;
  String employeeRole;
  String employeeDivision;
  String employeeDepartment;
  String lineManager;
  String requisitionDate;
  String requiredStatus;
  String applicationStatus;
  String deliveryDate;
  String completionDays;

  IdCardBHDetails(
      {this.id,
        this.employeeCode,
        this.employeeName,
        this.employeeRole,
        this.employeeDivision,
        this.employeeDepartment,
        this.lineManager,
        this.requisitionDate,
        this.requiredStatus,
        this.applicationStatus,
        this.deliveryDate,
        this.completionDays});

  IdCardBHDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    employeeCode = json['employee_code']??'';
    employeeName = json['employee_name']??'';
    employeeRole = json['employee_role']??'';
    employeeDivision = json['employee_division']??'';
    employeeDepartment = json['employee_department']??'';
    lineManager = json['line_manager']??'';
    requisitionDate = json['requisition_date']??'N/A';
    requiredStatus = json['required_status']??'';
    applicationStatus = json['application_status']??'';
    deliveryDate = json['delivery_date']??'N/A';
    completionDays = json['completion_days']==null ? 'N/A' : json['completion_days'].toString();
  }
}
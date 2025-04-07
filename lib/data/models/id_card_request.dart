class IdCardRequest {
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

  IdCardRequest(
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

  IdCardRequest.fromJson(Map<String, dynamic> json) {
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

class RequiredStatus {
  String key;
  String value;

  RequiredStatus({this.key, this.value});

  RequiredStatus.fromJson(Map<String, dynamic> json) {
    key = json['key']??'';
    value = json['value']??'';
  }
}

class BloodGroup {
  String key;
  String value;

  BloodGroup({this.key, this.value});

  BloodGroup.fromJson(Map<String, dynamic> json) {
    key = json['key']??'';
    value = json['value']??'';
  }
}

class Reason {
  String key;
  String value;

  Reason({this.key, this.value});

  Reason.fromJson(Map<String, dynamic> json) {
    key = json['key']??'';
    value = json['value']??'';
  }
}



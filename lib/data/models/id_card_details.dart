class IdCardDetails {
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
  String photo;
  String attachment;
  List<ApprovalAuthorities> approvalAuthorities;
  bool applicationApproval;

  int employeeId;
  int lineManagerId;
  String bloodGroup;
  String reason;
  String remarks;
  IdCardDetails(
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
        this.photo,
        this.attachment,
        this.approvalAuthorities,
        this.applicationApproval,
        this.employeeId,this.lineManagerId,this.bloodGroup,this.reason,this.remarks});

  IdCardDetails.fromJson(Map<String, dynamic> json) {
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
    photo = json['photo']??'N/A';
    attachment = json['attachment']??'N/A';
    if (json['approval_authorities'] != null) {
      approvalAuthorities = <ApprovalAuthorities>[];
      json['approval_authorities'].forEach((v) {
        approvalAuthorities.add(new ApprovalAuthorities.fromJson(v));
      });
    }
    applicationApproval = json['application_approval']?? false;

    employeeId = json['employee_id']??0;
    lineManagerId = json['line_manager_id']??0;
    bloodGroup = json['blood_group']??'';
    reason = json['reason']??'';
    remarks = json['remarks']??'';

    //this.employeeId,this.lineManagerId,this.bloodGroup,this.reason,this.remarks});
  }
}

class ApprovalAuthorities {
  String authorityName;
  int authorityOrder;
  String authorityStatus;
  String processedEmployee;
  String createdAt;
  String remarks;

  ApprovalAuthorities(
      {this.authorityName,
        this.authorityOrder,
        this.authorityStatus,
        this.processedEmployee,
        this.createdAt,
        this.remarks});

  ApprovalAuthorities.fromJson(Map<String, dynamic> json) {
    authorityName = json['authority_name']??'';
    authorityOrder = json['authority_order']??0;
    authorityStatus = json['authority_status']??'';
    processedEmployee = json['processed_employee']??'';
    createdAt = json['created_at']??'';
    remarks = json['remarks']??'';
  }
}

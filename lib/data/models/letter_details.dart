class LetterDetails {
  int id;
  String employeeCode;
  String employeeName;
  String employeeRole;
  String employeeDivision;
  String employeeDepartment;
  String lineManager;
  String requisitionType;
  String reason;
  String requisitionDate;
  String startDate;
  String endDate;
  String dateOfBirth;
  String referenceNo;
  String applicationStatus;
  int salaryDisplay;
  String embassyName;
  String embassyAddress;
  String passportNo;
  String attachment;
  List<ApprovalAuthorities> approvalAuthorities;
  bool applicationApproval;

  LetterDetails(
      {this.id,
        this.employeeCode,
        this.employeeName,
        this.employeeRole,
        this.employeeDivision,
        this.employeeDepartment,
        this.lineManager,
        this.requisitionType,
        this.reason,
        this.requisitionDate,
        this.startDate,
        this.endDate,
        this.dateOfBirth,
        this.referenceNo,
        this.applicationStatus,
        this.salaryDisplay,
        this.embassyName,
        this.embassyAddress,
        this.passportNo,
        this.attachment,
        this.approvalAuthorities,
        this.applicationApproval});

  LetterDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    employeeCode = json['employee_code']??'';
    employeeName = json['employee_name']??'';
    employeeRole = json['employee_role']??'';
    employeeDivision = json['employee_division']??'';
    employeeDepartment = json['employee_department']??'';
    lineManager = json['line_manager']??'';
    requisitionType = json['requisition_type']??'';
    reason = json['reason']??'';
    requisitionDate = json['requisition_date']??'N/A';
    startDate = json['start_date']??'N/A';
    endDate = json['end_date']??'N/A';
    dateOfBirth = json['date_of_birth']??'N/A';
    referenceNo = json['reference_no']??'';
    applicationStatus = json['application_status']??'';
    salaryDisplay = json['salary_display']??0;
    embassyName = json['embassy_name']??'';
    embassyAddress = json['embassy_address']??'';
    passportNo = json['passport_no']??'';
    attachment = json['attachment']??'N/A';
    if (json['approval_authorities'] != null) {
      approvalAuthorities = <ApprovalAuthorities>[];
      json['approval_authorities'].forEach((v) {
        approvalAuthorities.add(new ApprovalAuthorities.fromJson(v));
      });
    }
    applicationApproval = json['application_approval']?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_code'] = this.employeeCode;
    data['employee_name'] = this.employeeName;
    data['employee_role'] = this.employeeRole;
    data['employee_division'] = this.employeeDivision;
    data['employee_department'] = this.employeeDepartment;
    data['line_manager'] = this.lineManager;
    data['requisition_type'] = this.requisitionType;
    data['reason'] = this.reason;
    data['requisition_date'] = this.requisitionDate;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['date_of_birth'] = this.dateOfBirth;
    data['reference_no'] = this.referenceNo;
    data['application_status'] = this.applicationStatus;
    data['salary_display'] = this.salaryDisplay;
    data['embassy_name'] = this.embassyName;
    data['embassy_address'] = this.embassyAddress;
    data['passport_no'] = this.passportNo;
    data['attachment'] = this.attachment;
    if (this.approvalAuthorities != null) {
      data['approval_authorities'] =
          this.approvalAuthorities.map((v) => v.toJson()).toList();
    }
    data['application_approval'] = this.applicationApproval;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authority_name'] = this.authorityName;
    data['authority_order'] = this.authorityOrder;
    data['authority_status'] = this.authorityStatus;
    data['processed_employee'] = this.processedEmployee;
    data['created_at'] = this.createdAt;
    data['remarks'] = this.remarks;
    return data;
  }
}



// class LetterDetails {
//   int id;
//   String employeeCode;
//   String employeeName;
//   String employeeRole;
//   String employeeDivision;
//   String employeeDepartment;
//   String lineManager;
//   String requisitionDate;
//   String requiredStatus;
//   String applicationStatus;
//   String photo;
//   String attachment;
//   List<ApprovalAuthorities> approvalAuthorities;
//   bool applicationApproval;
//
//   int employeeId;
//   int lineManagerId;
//   String bloodGroup;
//   String reason;
//   String remarks;
//   LetterDetails(
//       {this.id,
//         this.employeeCode,
//         this.employeeName,
//         this.employeeRole,
//         this.employeeDivision,
//         this.employeeDepartment,
//         this.lineManager,
//         this.requisitionDate,
//         this.requiredStatus,
//         this.applicationStatus,
//         this.photo,
//         this.attachment,
//         this.approvalAuthorities,
//         this.applicationApproval,
//         this.employeeId,this.lineManagerId,this.bloodGroup,this.reason,this.remarks});
//
//   LetterDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id']??0;
//     employeeCode = json['employee_code']??'';
//     employeeName = json['employee_name']??'';
//     employeeRole = json['employee_role']??'';
//     employeeDivision = json['employee_division']??'';
//     employeeDepartment = json['employee_department']??'';
//     lineManager = json['line_manager']??'';
//     requisitionDate = json['requisition_date']??'N/A';
//     requiredStatus = json['required_status']??'';
//     applicationStatus = json['application_status']??'';
//     photo = json['photo']??'N/A';
//     attachment = json['attachment']??'N/A';
//     if (json['approval_authorities'] != null) {
//       approvalAuthorities = <ApprovalAuthorities>[];
//       json['approval_authorities'].forEach((v) {
//         approvalAuthorities.add(new ApprovalAuthorities.fromJson(v));
//       });
//     }
//     applicationApproval = json['application_approval']?? false;
//
//     employeeId = json['employee_id']??0;
//     lineManagerId = json['line_manager_id']??0;
//     bloodGroup = json['blood_group']??'';
//     reason = json['reason']??'';
//     remarks = json['remarks']??'';
//
//     //this.employeeId,this.lineManagerId,this.bloodGroup,this.reason,this.remarks});
//   }
// }
//
// class ApprovalAuthorities {
//   String authorityName;
//   int authorityOrder;
//   String authorityStatus;
//   String processedEmployee;
//   String createdAt;
//   String remarks;
//
//   ApprovalAuthorities(
//       {this.authorityName,
//         this.authorityOrder,
//         this.authorityStatus,
//         this.processedEmployee,
//         this.createdAt,
//         this.remarks});
//
//   ApprovalAuthorities.fromJson(Map<String, dynamic> json) {
//     authorityName = json['authority_name']??'';
//     authorityOrder = json['authority_order']??0;
//     authorityStatus = json['authority_status']??'';
//     processedEmployee = json['processed_employee']??'';
//     createdAt = json['created_at']??'';
//     remarks = json['remarks']??'';
//   }
// }

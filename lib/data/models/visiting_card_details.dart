class VisitingCardDetails {
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
  String remarks;
  int approvalAuthorityId;

  List<ApprovalAuthorities> approvalAuthorities;
  bool applicationApproval;

  VisitingCardDetails(
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
        this.approvalAuthorities,
        this.applicationApproval,
      this.quantity,
      this.remarks,this.approvalAuthorityId});

  VisitingCardDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeCode = json['employee_code'] ?? '';
    employeeName = json['employee_name']?? '';
    shortName = json['short_name']?? '';
    employeeRole = json['employee_role']?? '';
    employeeDivision = json['employee_division']?? '';
    employeeDepartment = json['employee_department']?? '';
    officialEmail = json['official_email']?? '';
    officialContact = json['official_contact']?? '';
    officialAddress = json['official_address']?? '';
    businessHead = json['business_head']?? '';
    requisitionDate = json['requisition_date']?? '';
    requiredStatus = json['required_status']?? '';
    applicationStatus = json['application_status']?? '';
    quantity = json['quantity'] ?? 0;
    remarks = json['remarks']?? '';
    approvalAuthorityId = json['approval_authority_id']?? 0;

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
    data['short_name'] = this.shortName;
    data['employee_role'] = this.employeeRole;
    data['employee_division'] = this.employeeDivision;
    data['employee_department'] = this.employeeDepartment;
    data['official_email'] = this.officialEmail;
    data['official_contact'] = this.officialContact;
    data['official_address'] = this.officialAddress;
    data['business_head'] = this.businessHead;
    data['requisition_date'] = this.requisitionDate;
    data['required_status'] = this.requiredStatus;
    data['application_status'] = this.applicationStatus;
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
    authorityName = json['authority_name']?? '';
    authorityOrder = json['authority_order']?? 0;
    authorityStatus = json['authority_status']?? '';
    processedEmployee = json['processed_employee']?? '';
    createdAt = json['created_at']?? 'N/A';
    remarks = json['remarks']?? 'N/A';
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
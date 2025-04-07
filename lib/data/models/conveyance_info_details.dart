class ConveyanceInfoDetails {
  int id;
  String referenceNo;
  String applicationDate;
  String employeeCode;
  String employeeName;
  String division;
  String department;
  String costCenter;
  String contactNo;
  String workPlace;
  String lineManager;
  String finalApprover;
  String businessHead;
  String cc;
  String status;
  List<ConveyanceDetails> conveyanceDetails;
  int totalBill;
  String description;
  List<ApprovalAuthorities> approvalAuthorities;
  bool applicationApproval;
  String paymentMethod;
  String bankName;
  String bankAccountName;
  String bankAccountNumber;
  String branchName;
  String routingNo;
  String applicableCostCenter;
  int totalIncurredAmount;
  int pendingForApproval;

  ConveyanceInfoDetails(
      {this.id,
        this.referenceNo,
        this.applicationDate,
        this.employeeCode,
        this.employeeName,
        this.division,
        this.department,
        this.costCenter,
        this.contactNo,
        this.workPlace,
        this.lineManager,
        this.finalApprover,
        this.businessHead,
        this.cc,
        this.status,
        this.conveyanceDetails,
        this.totalBill,
        this.paymentMethod,
        this.description,
        this.approvalAuthorities,
        this.applicationApproval,
        this.bankName,
        this.bankAccountName,
        this.bankAccountNumber,
        this.branchName,
        this.routingNo,
        this.applicableCostCenter,this.pendingForApproval,this.totalIncurredAmount});

  ConveyanceInfoDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    referenceNo = json['reference_no']??'N/A';
    applicationDate = json['application_date']??'N/A';
    employeeCode = json['employee_code']??'N/A';
    employeeName = json['employee_name']??'N/A';
    division = json['division']??'N/A';
    department = json['department']??'N/A';
    costCenter = json['cost_center']??'N/A';
    contactNo = json['contact_no']??'N/A';
    workPlace = json['work_place']??'N/A';
    lineManager = json['line_manager']??'N/A';
    finalApprover = json['final_approver']??'N/A';
    businessHead = json['businessHead']??'N/A';
    cc = json['cc']??'N/A';
    status = json['status']??'N/A';
    totalIncurredAmount=json['total_incurred_amount']??0;
    pendingForApproval=json['pending_for_approval']??0;

    if (json['conveyance_details'] != null) {
      conveyanceDetails = <ConveyanceDetails>[];
      json['conveyance_details'].forEach((v) {
        conveyanceDetails.add(new ConveyanceDetails.fromJson(v));
      });
    }
    totalBill = json['total_bill']??0;
    paymentMethod = json['payment_method']??'N/A';
    description = json['description']??'N/A';
    if (json['approval_authorities'] != null) {
      approvalAuthorities = <ApprovalAuthorities>[];
      json['approval_authorities'].forEach((v) {
        approvalAuthorities.add(new ApprovalAuthorities.fromJson(v));
      });
    }
    applicationApproval = json['application_approval']??false;
    bankName = json['bank_name']??'N/A';
    bankAccountName = json['bank_account_name']??'N/A';
    bankAccountNumber = json['bank_account_number']??'N/A';
    branchName = json['branch_name']??'N/A';
    routingNo = json['routing_no']??'N/A';
    applicableCostCenter= json['applicable_cost_center']??'N/A';
  }
}

class ConveyanceDetails {
  String travelDate;
  String purpose;
  String location;
  String modeOfTransport;
  int transport;
  int food;
  int other;
  int total;
  String remarks;
  String attachment;

  ConveyanceDetails(
      {this.travelDate,
        this.purpose,
        this.location,
        this.modeOfTransport,
        this.transport,
        this.food,
        this.other,
        this.total,
        this.remarks,
        this.attachment});

  ConveyanceDetails.fromJson(Map<String, dynamic> json) {
    travelDate = json['travel_date']??'N/A';
    purpose = json['purpose']??'N/A';
    location = json['location']??'N/A';
    modeOfTransport = json['mode_of_transport']??'N/A';
    transport = json['transport']??0;
    food = json['food']??0;
    other = json['other']??0;
    total = json['total']??0;
    remarks = json['remarks']??'N/A';
    attachment = json['attachment']??'N/A';
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
    authorityName = json['authority_name']??'N/A';
    authorityOrder = json['authority_order']??0;
    authorityStatus = json['authority_status']??'N/A';
    processedEmployee = json['processed_employee']??'N/A';
    createdAt = json['created_at']??'N/A';
    remarks = json['remarks']??'N/A';
  }
}



// class ConveyanceInfoDetails {
//   ConveyanceModel conveyance;
//   String cc;
//
//   ConveyanceInfoDetails({this.conveyance, this.cc});
//
//   ConveyanceInfoDetails.fromJson(Map<String, dynamic> json) {
//     conveyance = json['conveyance'] != null ? new ConveyanceModel.fromJson(json['conveyance']) : null;
//     cc = json['cc'] ??'N/A';
//   }
//
// }
//
// class ConveyanceModel {
//   int id;
//   int employeeId;
//   int businessUnitId;
//   int supervisorId;
//   int divisionId;
//   int departmentId;
//   int costCenterId;
//   String contactNo;
//   String referenceNo;
//   String applicationDate;
//   String paymentMethod;
//   String bankName;
//   String bankAccountName;
//   String bankAccountNumber;
//   String routingNo;
//   String accountName;
//   String accountNumber;
//   String workPlace;
//   String description;
//   int totalBill;
//   String hrGroup;
//   List<int> hrGroupEmployee;
//   int businessHeadEmployeeId;
//   int finalApproverId;
//   int pendingAt;
//   String status;
//   String revertFrom;
//   int settlement;
//   int createdBy;
//   int updatedBy;
//   String deletedAt;
//   String createdAt;
//   String updatedAt;
//   String branchName;
//   FinalApprover finalApprover;
//   Employee employee;
//   Supervisor supervisor;
//   Division division;
//   Division department;
//   Division costCenter;
//   Division businessUnit;
//   String latestApproval;
//   List<ConveyanceDetails> conveyanceDetails;
//   List<ApprovalProcesses> approvalProcesses;
//
//   ConveyanceModel(
//       {this.id,
//         this.employeeId,
//         this.businessUnitId,
//         this.supervisorId,
//         this.divisionId,
//         this.departmentId,
//         this.costCenterId,
//         this.contactNo,
//         this.referenceNo,
//         this.applicationDate,
//         this.paymentMethod,
//         this.bankName,
//         this.bankAccountName,
//         this.bankAccountNumber,
//         this.routingNo,
//         this.accountName,
//         this.accountNumber,
//         this.workPlace,
//         this.description,
//         this.totalBill,
//         this.hrGroup,
//         this.hrGroupEmployee,
//         this.businessHeadEmployeeId,
//         this.finalApproverId,
//         this.pendingAt,
//         this.status,
//         this.revertFrom,
//         this.settlement,
//         this.createdBy,
//         this.updatedBy,
//         this.deletedAt,
//         this.createdAt,
//         this.updatedAt,
//         this.branchName,
//         this.finalApprover,
//         this.employee,
//         this.supervisor,
//         this.division,
//         this.department,
//         this.costCenter,
//         this.businessUnit,
//         this.latestApproval,
//         this.conveyanceDetails,
//         this.approvalProcesses});
//
//   ConveyanceModel.fromJson(Map<String, dynamic> json) {
//     id = json['id']??0;
//     employeeId = json['employee_id']??0;
//     businessUnitId = json['business_unit_id']??0;
//     supervisorId = json['supervisor_id']??0;
//     divisionId = json['division_id']??0;
//     departmentId = json['department_id']??0;
//     costCenterId = json['cost_center_id']??0;
//     contactNo = json['contact_no']??'N/A';
//     referenceNo = json['reference_no']??'N/A';
//     applicationDate = json['application_date']??'N/A';
//     paymentMethod = json['payment_method']??'N/A';
//     bankName = json['bank_name']??'N/A';
//     bankAccountName = json['bank_account_name']??'N/A';
//     bankAccountNumber = json['bank_account_number']??'N/A';
//     routingNo = json['routing_no']??'N/A';
//     accountName = json['account_name']??'N/A';
//     accountNumber = json['account_number']??'N/A';
//     workPlace = json['work_place']??'N/A';
//     description = json['description']??'N/A';
//     totalBill = json['total_bill']??0;
//     hrGroup = json['hr_group']??'N/A';
//     hrGroupEmployee = json['hr_group_employee'].cast<int>();
//     businessHeadEmployeeId = json['business_head_employee_id']??0;
//     finalApproverId = json['final_approver_id']??0;
//     pendingAt = json['pending_at']??'N/A';
//     status = json['status']??'N/A';
//     revertFrom = json['revert_from']??'N/A';
//     settlement = json['settlement']??0;
//     createdBy = json['created_by']??0;
//     updatedBy = json['updated_by']??0;
//     deletedAt = json['deleted_at']??'N/A';
//     createdAt = json['created_at']??'N/A';
//     updatedAt = json['updated_at']??'N/A';
//     branchName = json['branch_name']??'N/A';
//
//     finalApprover = json['final_approver'] != null? new FinalApprover.fromJson(json['final_approver']) : null;
//     employee = json['employee'] != null? new Employee.fromJson(json['employee']) : null;
//     supervisor = json['supervisor'] != null? new Supervisor.fromJson(json['supervisor']) : null;
//     division = json['division'] != null? new Division.fromJson(json['division']) : null;
//     department = json['department'] != null? new Division.fromJson(json['department']) : null;
//     costCenter = json['cost_center'] != null? new Division.fromJson(json['cost_center']) : null;
//     businessUnit = json['business_unit'] != null? new Division.fromJson(json['business_unit']) : null;
//     latestApproval = json['latest_approval']??'N/A';
//
//     if (json['conveyance_details'] != null) {
//       conveyanceDetails = <ConveyanceDetails>[];
//       json['conveyance_details'].forEach((v) {
//         conveyanceDetails.add(new ConveyanceDetails.fromJson(v));
//       });
//     }
//     if (json['approval_processes'] != null) {
//       approvalProcesses = <ApprovalProcesses>[];
//       json['approval_processes'].forEach((v) {
//         approvalProcesses.add(new ApprovalProcesses.fromJson(v));
//       });
//     }
//   }
//
// }
//
// class FinalApprover {
//   int id;
//   String fullName;
//   String firstName;
//   String middleName;
//   String lastName;
//   String code;
//
//   FinalApprover({this.id,this.fullName, this.firstName, this.middleName, this.lastName, this.code});
//
//   FinalApprover.fromJson(Map<String, dynamic> json) {
//     id = json['id']??0;
//
//     firstName = json['first_name']??'N/A';
//     middleName = json['middle_name']??'N/A';
//     lastName = json['last_name']??'N/A';
//
//     String fName = json['first_name'].toString() == 'null' ? '': json['first_name'].toString().trim();
//     String mName = json['middle_name'].toString() == 'null' ? '': json['middle_name'].toString().trim();
//     String lName = json['last_name'].toString() == 'null' ? '': json['last_name'].toString().trim();
//
//
//     fullName= fName;
//     if(mName.isNotEmpty) {
//       fullName = fullName + ' ' + mName;
//     }
//     if (lName.isNotEmpty) {
//       fullName=  fullName + ' ' + lName;
//     }
//
//     code = json['code']??'N/A';
//   }
//
//
// }
//
//
// class Employee {
//   int id;
//   String fullName;
//   String firstName;
//   String middleName;
//   String lastName;
//   String code;
//
//   Employee({this.id,this.fullName, this.firstName, this.middleName, this.lastName, this.code});
//
//   Employee.fromJson(Map<String, dynamic> json) {
//     id = json['id']??0;
//
//     firstName = json['first_name']??'N/A';
//     middleName = json['middle_name']??'N/A';
//     lastName = json['last_name']??'N/A';
//
//     String fName = json['first_name'].toString() == 'null' ? '': json['first_name'].toString().trim();
//     String mName = json['middle_name'].toString() == 'null' ? '': json['middle_name'].toString().trim();
//     String lName = json['last_name'].toString() == 'null' ? '': json['last_name'].toString().trim();
//
//
//     fullName= fName;
//     if(mName.isNotEmpty) {
//       fullName = fullName + ' ' + mName;
//     }
//     if (lName.isNotEmpty) {
//       fullName=  fullName + ' ' + lName;
//     }
//
//     code = json['code']??'N/A';
//   }
//
//
// }
//
// class Supervisor {
//   int id;
//   String fullName;
//   String firstName;
//   String middleName;
//   String lastName;
//   String code;
//
//   Supervisor({this.id,this.fullName, this.firstName, this.middleName, this.lastName, this.code});
//
//   Supervisor.fromJson(Map<String, dynamic> json) {
//     id = json['id']??0;
//
//     firstName = json['first_name']??'N/A';
//     middleName = json['middle_name']??'N/A';
//     lastName = json['last_name']??'N/A';
//
//     String fName = json['first_name'].toString() == 'null' ? '': json['first_name'].toString().trim();
//     String mName = json['middle_name'].toString() == 'null' ? '': json['middle_name'].toString().trim();
//     String lName = json['last_name'].toString() == 'null' ? '': json['last_name'].toString().trim();
//
//
//     fullName= fName;
//     if(mName.isNotEmpty) {
//       fullName = fullName + ' ' + mName;
//     }
//     if (lName.isNotEmpty) {
//       fullName=  fullName + ' ' + lName;
//     }
//
//     code = json['code']??'N/A';
//   }
//
// }
//
// class Division {
//   int id;
//   String name;
//
//   Division({this.id, this.name});
//
//   Division.fromJson(Map<String, dynamic> json) {
//     id = json['id']??0;
//     name = json['name']??'N/A';
//   }
//
// }
//
// class ConveyanceDetails {
//   int id;
//   int conveyanceId;
//   String travelDate;
//   String purpose;
//   String location;
//   String modeOfTransport;
//   int transport;
//   int food;
//   int other;
//   int total;
//   String attachment;
//   String remarks;
//   int createdBy;
//   int updatedBy;
//   String deletedAt;
//   String createdAt;
//   String updatedAt;
//
//   ConveyanceDetails(
//       {this.id,
//         this.conveyanceId,
//         this.travelDate,
//         this.purpose,
//         this.location,
//         this.modeOfTransport,
//         this.transport,
//         this.food,
//         this.other,
//         this.total,
//         this.attachment,
//         this.remarks,
//         this.createdBy,
//         this.updatedBy,
//         this.deletedAt,
//         this.createdAt,
//         this.updatedAt});
//
//   ConveyanceDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id']??0;
//     conveyanceId = json['conveyance_id']??0;
//     travelDate = json['travel_date']??'N/A';
//     purpose = json['purpose']??'N/A';
//     location = json['location']??'N/A';
//     modeOfTransport = json['mode_of_transport']??'N/A';
//     transport = json['transport']??0;
//     food = json['food']??0;
//     other = json['other']??0;
//     total = json['total']??0;
//     attachment = json['attachment']??'N/A';
//     remarks = json['remarks'];
//     createdBy = json['created_by']??0;
//     updatedBy = json['updated_by']??0;
//     deletedAt = json['deleted_at']??'N/A';
//     createdAt = json['created_at']??'N/A';
//     updatedAt = json['updated_at']??'N/A';
//   }
//
// }
//
// class ApprovalProcesses {
//   int id;
//   int employeeId;
//   String approvableType;
//   int approvableId;
//   int authorityOrder;
//   String remarks;
//   String status;
//   String processedAt;
//   int processedBy;
//   String deletedAt;
//   String createdAt;
//   String updatedAt;
//
//   ApprovalProcesses(
//       {this.id,
//         this.employeeId,
//         this.approvableType,
//         this.approvableId,
//         this.authorityOrder,
//         this.remarks,
//         this.status,
//         this.processedAt,
//         this.processedBy,
//         this.deletedAt,
//         this.createdAt,
//         this.updatedAt});
//
//   ApprovalProcesses.fromJson(Map<String, dynamic> json) {
//     id = json['id']??0;
//     employeeId = json['employee_id']??0;
//     approvableType = json['approvable_type']??'N/A';
//     approvableId = json['approvable_id']??0;
//     authorityOrder = json['authority_order']??0;
//     remarks = json['remarks']??'N/A';
//     status = json['status']??'N/A';
//     processedAt = json['processed_at']??'N/A';
//     processedBy = json['processed_by']??0;
//     deletedAt = json['deleted_at']??'N/A';
//     createdAt = json['created_at']??'N/A';
//     updatedAt = json['updated_at']??'N/A';
//   }
// }

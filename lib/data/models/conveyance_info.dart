import 'package:recom_app/data/models/id_name_pair.dart';
import 'business_unit_wise_cost_center.dart';
import 'key_value_pair.dart';

class ConveyanceInfo {
  String referenceNo;
  String ticketRaiseDate;
  Employee employee;
  String workPlace;
  ConveyancePurpose purpose;
  ModeOfTransportForConveyance modeOfTransport;
  String firstApprover;
  PaymentMethod paymentMethod;
  BankDetail bankDetail;
  String cc;
  FinalApprover finalApprover;
  BusinessHead businessHead;
  BusinessUnitWiseCostCenter costCenters;

  ConveyanceInfo(
      {this.referenceNo,
        this.ticketRaiseDate,
        this.employee,
        this.workPlace,
        this.purpose,
        this.modeOfTransport,
        this.firstApprover,
        this.paymentMethod,
        this.cc,
        this.finalApprover,
        this.businessHead,
        this.costCenters});

    ConveyanceInfo.fromJson(Map<String, dynamic> json) {
    referenceNo = json['reference_no']??'N/A';
    ticketRaiseDate = json['ticket_raise_date']??'N/A';
    employee = json['employee'] != null ? new Employee.fromJson(json['employee']) : Employee(division: IdNamePair(),
    department: IdNamePair(),costCenter: IdNamePair(),businessUnit: IdNamePair(),payment: Payment(),);
    workPlace = json['work_place']??'N/A';
    purpose = json['purpose'] != null ? new ConveyancePurpose.fromJson(json['purpose']) : ConveyancePurpose();
    modeOfTransport = json['mode_of_transport'] != null ? new ModeOfTransportForConveyance.fromJson(json['mode_of_transport']) : ModeOfTransportForConveyance();
    firstApprover = json['first_approver']??'N/A';
    paymentMethod = json['payment_method'] != null ? new PaymentMethod.fromJson(json['payment_method']) : PaymentMethod();
    bankDetail = json['bank_detail'] != null ? new BankDetail.fromJson(json['bank_detail']) : BankDetail();
    cc = json['cc']??'N/A';
    finalApprover = json['final_approver'] != null ? new FinalApprover.fromJson(json['final_approver']) : FinalApprover();
    businessHead = json['business_head'] != null ? new BusinessHead.fromJson(json['business_head']) : BusinessHead();
    costCenters = json['costCenters'] != null ?  BusinessUnitWiseCostCenter.fromJson(json['costCenters']) : BusinessUnitWiseCostCenter(businessUnitWiseCostCenter: []);
  }
}

class Employee {
  int id;
  String fullName;
  String firstName;
  String middleName;
  String lastName;
  String code;
  int supervisorId;
  String phone;
  // int? divisionId;
  // int? departmentId;
  // int? costCenterId;
  // int? businessUnitId;
  // int? expatriate;
  //Supervisor supervisor;
  Payment payment;
  IdNamePair division;
  IdNamePair department;
  IdNamePair costCenter;
  IdNamePair businessUnit;

  Employee(
      {this.id,
        this.fullName,
        this.firstName,
        this.middleName,
        this.lastName,
        this.code,
        this.supervisorId,
        this.phone,
        // this.divisionId,
        // this.departmentId,
        // this.costCenterId,
        // this.businessUnitId,
        // this.expatriate,
        //this.supervisor,
        this.payment,
        this.division,
        this.department,
        this.costCenter,
        this.businessUnit});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    firstName = json['first_name']??'N/A';
    middleName = json['middle_name']??'N/A';
    lastName = json['last_name']??'N/A';

    String fName = json['first_name'].toString() == 'null' ? '': json['first_name'].toString().trim();
    String mName = json['middle_name'].toString() == 'null' ? '': json['middle_name'].toString().trim();
    String lName = json['last_name'].toString() == 'null' ? '': json['last_name'].toString().trim();


    fullName= fName;
    if(mName.isNotEmpty) {
      fullName = fullName + ' ' + mName;
    }
    if (lName.isNotEmpty) {
      fullName=  fullName + ' ' + lName;
    }

    code = json['code']??'N/A';
    supervisorId = json['supervisor_id']??0;
    phone = json['phone']??'N/A';
    // divisionId = json['division_id'];
    // departmentId = json['department_id'];
    // costCenterId = json['cost_center_id'];
    // businessUnitId = json['business_unit_id'];
    // expatriate = json['expatriate'];
    //supervisor = json['supervisor'] != null ? new Supervisor.fromJson(json['supervisor']) : null;

    payment =  json['payment'] != null ? new Payment.fromJson(json['payment']) : Payment();

    division = json['division'] != null
        ? new IdNamePair.fromJson(json['division'])
        : IdNamePair();
    department = json['department'] != null
        ? new IdNamePair.fromJson(json['department'])
        : IdNamePair;
    costCenter = json['cost_center'] != null
        ? new IdNamePair.fromJson(json['cost_center'])
        : IdNamePair;
    businessUnit = json['business_unit'] != null
        ? new IdNamePair.fromJson(json['business_unit'])
        : IdNamePair;
  }
}

// class Supervisor {
//   int? id;
//   int? userId;
//   int? noticePeriod;
//   int? temporaryPeriod;
//   int? departmentId;
//   int? designationId;
//   int? divisionId;
//   int? gradeId;
//   int? employeeRoleId;
//   int? areaId;
//   Null? projectId;
//   String? simBundleCode;
//   Null? bankId;
//   Null? branchId;
//   int? supervisorId;
//   Null? teamId;
//   int? employeetypeId;
//   int? locationId;
//   Null? fundNameId;
//   int? unitId;
//   Null? categoryId;
//   int? salaryDisburseId;
//   String? payroll;
//   String? code;
//   String? firstName;
//   Null? middleName;
//   String? lastName;
//   String? joiningDate;
//   String? confirmationDate;
//   String? phone;
//   String? email;
//   String? profilePhoto;
//   String? presentAddress;
//   String? permanentAddress;
//   String? religion;
//   String? gender;
//   String? dob;
//   String? nationality;
//   String? maritalStatus;
//   String? fatherName;
//   String? motherName;
//   Null? spouse;
//   Null? spouseMobile;
//   String? tinNumber;
//   String? nationalId;
//   Null? drivingLicenseNumber;
//   String? birthCertificateNumber;
//   String? passportNo;
//   String? passportValidityTill;
//   Null? accountType;
//   Null? accountNumber;
//   Payment? payment;
//   Null? confirmedBy;
//   Null? confirmedAt;
//   Null? pf;
//   Null? pfStartDate;
//   int? expatriate;
//   int? status;
//   Null? remark;
//   String? altEmail;
//   String? altPhone;
//   String? emergencyContactName;
//   String? emergencyContactRelation;
//   String? emergencyContactPhone;
//   Null? emergencyContactNid;
//   String? emergencyContactAddress;
//   Null? education;
//   String? bloodGroup;
//   int? costCenterId;
//   int? businessUnitId;
//   String? costType;
//   int? salaryHold;
//   Null? salaryHoldReason;
//   int? createdBy;
//   int? updatedBy;
//   Null? deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   Null? resignedDate;
//
//   Supervisor(
//       {this.id,
//         this.userId,
//         this.noticePeriod,
//         this.temporaryPeriod,
//         this.departmentId,
//         this.designationId,
//         this.divisionId,
//         this.gradeId,
//         this.employeeRoleId,
//         this.areaId,
//         this.projectId,
//         this.simBundleCode,
//         this.bankId,
//         this.branchId,
//         this.supervisorId,
//         this.teamId,
//         this.employeetypeId,
//         this.locationId,
//         this.fundNameId,
//         this.unitId,
//         this.categoryId,
//         this.salaryDisburseId,
//         this.payroll,
//         this.code,
//         this.firstName,
//         this.middleName,
//         this.lastName,
//         this.joiningDate,
//         this.confirmationDate,
//         this.phone,
//         this.email,
//         this.profilePhoto,
//         this.presentAddress,
//         this.permanentAddress,
//         this.religion,
//         this.gender,
//         this.dob,
//         this.nationality,
//         this.maritalStatus,
//         this.fatherName,
//         this.motherName,
//         this.spouse,
//         this.spouseMobile,
//         this.tinNumber,
//         this.nationalId,
//         this.drivingLicenseNumber,
//         this.birthCertificateNumber,
//         this.passportNo,
//         this.passportValidityTill,
//         this.accountType,
//         this.accountNumber,
//         this.payment,
//         this.confirmedBy,
//         this.confirmedAt,
//         this.pf,
//         this.pfStartDate,
//         this.expatriate,
//         this.status,
//         this.remark,
//         this.altEmail,
//         this.altPhone,
//         this.emergencyContactName,
//         this.emergencyContactRelation,
//         this.emergencyContactPhone,
//         this.emergencyContactNid,
//         this.emergencyContactAddress,
//         this.education,
//         this.bloodGroup,
//         this.costCenterId,
//         this.businessUnitId,
//         this.costType,
//         this.salaryHold,
//         this.salaryHoldReason,
//         this.createdBy,
//         this.updatedBy,
//         this.deletedAt,
//         this.createdAt,
//         this.updatedAt,
//         this.resignedDate});
//
//   Supervisor.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     noticePeriod = json['notice_period'];
//     temporaryPeriod = json['temporary_period'];
//     departmentId = json['department_id'];
//     designationId = json['designation_id'];
//     divisionId = json['division_id'];
//     gradeId = json['grade_id'];
//     employeeRoleId = json['employee_role_id'];
//     areaId = json['area_id'];
//     projectId = json['project_id'];
//     simBundleCode = json['sim_bundle_code'];
//     bankId = json['bank_id'];
//     branchId = json['branch_id'];
//     supervisorId = json['supervisor_id'];
//     teamId = json['team_id'];
//     employeetypeId = json['employeetype_id'];
//     locationId = json['location_id'];
//     fundNameId = json['fund_name_id'];
//     unitId = json['unit_id'];
//     categoryId = json['category_id'];
//     salaryDisburseId = json['salary_disburse_id'];
//     payroll = json['payroll'];
//     code = json['code'];
//     firstName = json['first_name'];
//     middleName = json['middle_name'];
//     lastName = json['last_name'];
//     joiningDate = json['joining_date'];
//     confirmationDate = json['confirmation_date'];
//     phone = json['phone'];
//     email = json['email'];
//     profilePhoto = json['profile_photo'];
//     presentAddress = json['present_address'];
//     permanentAddress = json['permanent_address'];
//     religion = json['religion'];
//     gender = json['gender'];
//     dob = json['dob'];
//     nationality = json['nationality'];
//     maritalStatus = json['marital_status'];
//     fatherName = json['father_name'];
//     motherName = json['mother_name'];
//     spouse = json['spouse'];
//     spouseMobile = json['spouse_mobile'];
//     tinNumber = json['tin_number'];
//     nationalId = json['national_id'];
//     drivingLicenseNumber = json['driving_license_number'];
//     birthCertificateNumber = json['birth_certificate_number'];
//     passportNo = json['passport_no'];
//     passportValidityTill = json['passport_validity_till'];
//     accountType = json['account_type'];
//     accountNumber = json['account_number'];
//     payment =
//     json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
//     confirmedBy = json['confirmed_by'];
//     confirmedAt = json['confirmed_at'];
//     pf = json['pf'];
//     pfStartDate = json['pf_start_date'];
//     expatriate = json['expatriate'];
//     status = json['status'];
//     remark = json['remark'];
//     altEmail = json['alt_email'];
//     altPhone = json['alt_phone'];
//     emergencyContactName = json['emergency_contact_name'];
//     emergencyContactRelation = json['emergency_contact_relation'];
//     emergencyContactPhone = json['emergency_contact_phone'];
//     emergencyContactNid = json['emergency_contact_nid'];
//     emergencyContactAddress = json['emergency_contact_address'];
//     education = json['education'];
//     bloodGroup = json['blood_group'];
//     costCenterId = json['cost_center_id'];
//     businessUnitId = json['business_unit_id'];
//     costType = json['cost_type'];
//     salaryHold = json['salary_hold'];
//     salaryHoldReason = json['salary_hold_reason'];
//     createdBy = json['created_by'];
//     updatedBy = json['updated_by'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     resignedDate = json['resigned_date'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['notice_period'] = this.noticePeriod;
//     data['temporary_period'] = this.temporaryPeriod;
//     data['department_id'] = this.departmentId;
//     data['designation_id'] = this.designationId;
//     data['division_id'] = this.divisionId;
//     data['grade_id'] = this.gradeId;
//     data['employee_role_id'] = this.employeeRoleId;
//     data['area_id'] = this.areaId;
//     data['project_id'] = this.projectId;
//     data['sim_bundle_code'] = this.simBundleCode;
//     data['bank_id'] = this.bankId;
//     data['branch_id'] = this.branchId;
//     data['supervisor_id'] = this.supervisorId;
//     data['team_id'] = this.teamId;
//     data['employeetype_id'] = this.employeetypeId;
//     data['location_id'] = this.locationId;
//     data['fund_name_id'] = this.fundNameId;
//     data['unit_id'] = this.unitId;
//     data['category_id'] = this.categoryId;
//     data['salary_disburse_id'] = this.salaryDisburseId;
//     data['payroll'] = this.payroll;
//     data['code'] = this.code;
//     data['first_name'] = this.firstName;
//     data['middle_name'] = this.middleName;
//     data['last_name'] = this.lastName;
//     data['joining_date'] = this.joiningDate;
//     data['confirmation_date'] = this.confirmationDate;
//     data['phone'] = this.phone;
//     data['email'] = this.email;
//     data['profile_photo'] = this.profilePhoto;
//     data['present_address'] = this.presentAddress;
//     data['permanent_address'] = this.permanentAddress;
//     data['religion'] = this.religion;
//     data['gender'] = this.gender;
//     data['dob'] = this.dob;
//     data['nationality'] = this.nationality;
//     data['marital_status'] = this.maritalStatus;
//     data['father_name'] = this.fatherName;
//     data['mother_name'] = this.motherName;
//     data['spouse'] = this.spouse;
//     data['spouse_mobile'] = this.spouseMobile;
//     data['tin_number'] = this.tinNumber;
//     data['national_id'] = this.nationalId;
//     data['driving_license_number'] = this.drivingLicenseNumber;
//     data['birth_certificate_number'] = this.birthCertificateNumber;
//     data['passport_no'] = this.passportNo;
//     data['passport_validity_till'] = this.passportValidityTill;
//     data['account_type'] = this.accountType;
//     data['account_number'] = this.accountNumber;
//     if (this.payment != null) {
//       data['payment'] = this.payment!.toJson();
//     }
//     data['confirmed_by'] = this.confirmedBy;
//     data['confirmed_at'] = this.confirmedAt;
//     data['pf'] = this.pf;
//     data['pf_start_date'] = this.pfStartDate;
//     data['expatriate'] = this.expatriate;
//     data['status'] = this.status;
//     data['remark'] = this.remark;
//     data['alt_email'] = this.altEmail;
//     data['alt_phone'] = this.altPhone;
//     data['emergency_contact_name'] = this.emergencyContactName;
//     data['emergency_contact_relation'] = this.emergencyContactRelation;
//     data['emergency_contact_phone'] = this.emergencyContactPhone;
//     data['emergency_contact_nid'] = this.emergencyContactNid;
//     data['emergency_contact_address'] = this.emergencyContactAddress;
//     data['education'] = this.education;
//     data['blood_group'] = this.bloodGroup;
//     data['cost_center_id'] = this.costCenterId;
//     data['business_unit_id'] = this.businessUnitId;
//     data['cost_type'] = this.costType;
//     data['salary_hold'] = this.salaryHold;
//     data['salary_hold_reason'] = this.salaryHoldReason;
//     data['created_by'] = this.createdBy;
//     data['updated_by'] = this.updatedBy;
//     data['deleted_at'] = this.deletedAt;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['resigned_date'] = this.resignedDate;
//     return data;
//   }
// }

class Payment {
  String bankId;
  String accountName;
  String paymentType;
  String bankRoutingNo;
  String bankName;
  String bankBranchName;
  String bankAccountNumber;

  Payment(
      {this.bankId,
        this.accountName,
        this.paymentType,
        this.bankRoutingNo,
        this.bankName,
        this.bankBranchName,
        this.bankAccountNumber});

  Payment.fromJson(Map<String, dynamic> json) {
    bankId = json['bank_id']??'0';
    accountName = json['account_name']??'N/A';
    paymentType = json['payment_type']??'N/A';
    bankRoutingNo = json['bank_routing_no']??'N/A';
    bankName = json['bank_name'] ??'N/A';
    bankBranchName = json['bank_branch_name']??'N/A';
    bankAccountNumber = json['bank_account_number']??'N/A';
  }

}

class BankDetail {
  String paymentType;
  String bankName;
  String accountName;
  String bankAccountNumber;
  String bankBranchName;
  String bankRoutingNo;

  BankDetail(
      {this.paymentType,
        this.bankName,
        this.accountName,
        this.bankAccountNumber,
        this.bankBranchName,
        this.bankRoutingNo});

  BankDetail.fromJson(Map<String, dynamic> json) {
    paymentType = json['payment_type']??'N/A';
    bankName = json['bank_name']??'N/A';
    accountName = json['account_name']??'N/A';
    bankAccountNumber = json['bank_account_number']??'N/A';
    bankBranchName = json['bank_branch_name']??'N/A';
    bankRoutingNo = json['bank_routing_no']??'N/A';
  }
}

class ConveyancePurpose {
  List<KeyValuePair> conveyancePurposeList=<KeyValuePair>[];
  ConveyancePurpose({this.conveyancePurposeList});

  ConveyancePurpose.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      conveyancePurposeList.add(KeyValuePair(id: key.trim(),name: value.trim() ));
    });
  }
}

class ModeOfTransportForConveyance {
  List<KeyValuePair> modeOfTransportForConveyanceList=<KeyValuePair>[];
  ModeOfTransportForConveyance({this.modeOfTransportForConveyanceList});

  ModeOfTransportForConveyance.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      modeOfTransportForConveyanceList.add(KeyValuePair(id: key.trim(),name: value.trim() ));
    });
  }
}

class PaymentMethod {
  List<KeyValuePair> paymentMethodList=<KeyValuePair>[];
  PaymentMethod({this.paymentMethodList});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      paymentMethodList.add(KeyValuePair(id: key.trim(),name: value.trim() ));
    });
  }
}

class FinalApprover {
  List<KeyValuePair> finalApproverList=<KeyValuePair>[];
  FinalApprover({this.finalApproverList});

  FinalApprover.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      finalApproverList.add(KeyValuePair(id: key.trim(),name: value.trim() ));
    });
  }
}

class BusinessHead {
  List<KeyValuePair> businessHeadList=<KeyValuePair>[];
  BusinessHead({this.businessHeadList});

  BusinessHead.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      businessHeadList.add(KeyValuePair(id: key.trim(),name: value.trim() ));
    });
  }
}


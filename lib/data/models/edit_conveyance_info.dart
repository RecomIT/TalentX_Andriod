import 'business_unit_wise_cost_center.dart';
import 'key_value_pair.dart';

class EditConveyanceInfo {
  EditConveyance conveyance;
  String workPlace;
  ConveyancePurpose purpose;
  ModeOfTransportForConveyance modeOfTransport;
  PaymentMethod paymentMethod;
  String cc;
  FinalApprover finalApprover;
  BusinessHead businessHead;
  List<String> selectedCostCenter;
  BusinessUnitWiseCostCenter costCenters;

  EditConveyanceInfo(
      {this.conveyance,
        this.workPlace,
        this.purpose,
        this.modeOfTransport,
        this.paymentMethod,
        this.cc,
        this.finalApprover,
        this.businessHead,
        this.selectedCostCenter,
        this.costCenters});

  EditConveyanceInfo.fromJson(Map<String, dynamic> json) {
    conveyance = json['conveyance'] != null ?
         new EditConveyance.fromJson(json['conveyance'])
        : null;
    workPlace = json['work_place']??'N/A';

    purpose = json['purpose'] != null ? new ConveyancePurpose.fromJson(json['purpose']) : ConveyancePurpose();
    modeOfTransport = json['mode_of_transport'] != null ? new ModeOfTransportForConveyance.fromJson(json['mode_of_transport']) : ModeOfTransportForConveyance();
    paymentMethod = json['payment_method'] != null ? new PaymentMethod.fromJson(json['payment_method']) : PaymentMethod();
    cc = json['cc']??'N/A';
    finalApprover = json['final_approver'] != null ? new FinalApprover.fromJson(json['final_approver']) : FinalApprover();
    businessHead = json['business_head'] != null ? new BusinessHead.fromJson(json['business_head']) : BusinessHead();
    costCenters = json['costCenters'] != null ?  BusinessUnitWiseCostCenter.fromJson(json['costCenters']) : BusinessUnitWiseCostCenter(businessUnitWiseCostCenter: []);
    selectedCostCenter =  json['cost_center'] == null ? [] : json['cost_center'].cast<String>();
    // purpose = json['purpose'] != null ? new Purpose.fromJson(json['purpose']) : null;
    // modeOfTransport = json['mode_of_transport'] != null ? new ModeOfTransport.fromJson(json['mode_of_transport']) : null;
    // paymentMethod = json['payment_method'] != null ? new PaymentMethod.fromJson(json['payment_method']) : null;
    // cc = json['cc']??'N/A';;
    // finalApprover = json['final_approver'] != null ? new FinalApprover.fromJson(json['final_approver']) : null;
    // businessHead = json['business_head'] != null ? new BusinessHead.fromJson(json['business_head']) : null;
  }
}

class EditConveyance {
  int id;
  int employeeId;
  int businessUnitId;
  int supervisorId;
  int divisionId;
  int departmentId;
  int costCenterId;
  String contactNo;
  String referenceNo;
  String applicationDate;
  String paymentMethod;
  String bankName;
  String bankBranchName;

  String bankAccountName;
  String bankAccountNumber;
  String routingNo;
  String accountName;
  String accountNumber;
  String workPlace;
  String description;
  int totalBill;
  String hrGroup;
  List<int> hrGroupEmployee;
  int businessHeadEmployeeId;
  int finalApproverId;
  int pendingAt;
  String status;
  String revertFrom;
  int settlement;
  int createdBy;
  int updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;
  String branchName;
  List<ConveyanceDetails> conveyanceDetails;
  Supervisor supervisor;
  Division division;
  Division department;
  Division costCenter;
  Division businessUnit;

  EditConveyance(
      {this.id,
        this.employeeId,
        this.businessUnitId,
        this.supervisorId,
        this.divisionId,
        this.departmentId,
        this.costCenterId,
        this.contactNo,
        this.referenceNo,
        this.applicationDate,
        this.paymentMethod,
        this.bankName,
        this.bankBranchName,
        this.bankAccountName,
        this.bankAccountNumber,
        this.routingNo,
        this.accountName,
        this.accountNumber,
        this.workPlace,
        this.description,
        this.totalBill,
        this.hrGroup,
        this.hrGroupEmployee,
        this.businessHeadEmployeeId,
        this.finalApproverId,
        this.pendingAt,
        this.status,
        this.revertFrom,
        this.settlement,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.branchName,
        this.conveyanceDetails,
        this.supervisor,
        this.division,
        this.department,
        this.costCenter,
        this.businessUnit});

  EditConveyance.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    employeeId = json['employee_id']??0;
    businessUnitId = json['business_unit_id']??0;
    supervisorId = json['supervisor_id']??0;
    divisionId = json['division_id']??0;
    departmentId = json['department_id']??0;
    costCenterId = json['cost_center_id']??0;
    contactNo = json['contact_no']??'N/A';
    referenceNo = json['reference_no']??'N/A';
    applicationDate = json['application_date']??'N/A';
    paymentMethod = json['payment_method']??'N/A';
    bankName = json['bank_name']??'N/A';
    bankBranchName= json['bank_branch_name']??'N/A';
    bankAccountName = json['bank_account_name']??'N/A';
    bankAccountNumber = json['bank_account_number']??'N/A';
    routingNo = json['routing_no']??'N/A';
    accountName = json['account_name']??'N/A';
    accountNumber = json['account_number']??'N/A';
    workPlace = json['work_place']??'N/A';
    description = json['description']??'N/A';
    totalBill = json['total_bill']??0;
    hrGroup = json['hr_group']??'N/A';
    hrGroupEmployee = json['hr_group_employee'].cast<int>();
    businessHeadEmployeeId = json['business_head_employee_id']??0;
    finalApproverId = json['final_approver_id']??0;
    pendingAt = json['pending_at']??'N/A';
    status = json['status']??'N/A';
    revertFrom = json['revert_from']??'N/A';
    settlement = json['settlement']??'N/A';
    createdBy = json['created_by']??0;
    updatedBy = json['updated_by']??0;
    deletedAt = json['deleted_at']??'N/A';
    createdAt = json['created_at']??'N/A';
    updatedAt = json['updated_at']??'N/A';
    branchName = json['branch_name']??'N/A';
    if (json['conveyance_details'] != null) {
      conveyanceDetails = <ConveyanceDetails>[];
      json['conveyance_details'].forEach((v) {
        conveyanceDetails.add(new ConveyanceDetails.fromJson(v));
      });
    }
    supervisor = json['supervisor'] != null ? new Supervisor.fromJson(json['supervisor']) : null;
    division = json['division'] != null ? new Division.fromJson(json['division']) : null;
    department = json['department'] != null ? new Division.fromJson(json['department']) : null;
    costCenter = json['cost_center'] != null ? new Division.fromJson(json['cost_center']) : null;
    businessUnit = json['business_unit'] != null ? new Division.fromJson(json['business_unit']) : null;
  }
}

class ConveyanceDetails {
  int id;
  int conveyanceId;
  String travelDate;
  String purpose;
  String location;
  String modeOfTransport;
  int transport;
  int food;
  int other;
  int total;
  String attachment;
  String remarks;
  int createdBy;
  int updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;

  ConveyanceDetails(
      {this.id,
        this.conveyanceId,
        this.travelDate,
        this.purpose,
        this.location,
        this.modeOfTransport,
        this.transport,
        this.food,
        this.other,
        this.total,
        this.attachment,
        this.remarks,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  ConveyanceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    conveyanceId = json['conveyance_id']??0;
    travelDate = json['travel_date']??'N/A';
    purpose = json['purpose']??'N/A';
    location = json['location']??'N/A';
    modeOfTransport = json['mode_of_transport']??'N/A';
    transport = json['transport']??0;
    food = json['food']??0;
    other = json['other']??0;
    total = json['total']??0;
    attachment = json['attachment']??'N/A';
    remarks = json['remarks']??'N/A';
    createdBy = json['created_by']??0;
    updatedBy = json['updated_by']??0;
    deletedAt = json['deleted_at']??'N/A';
    createdAt = json['created_at']??'N/A';
    updatedAt = json['updated_at']??'N/A';
  }
}

class Supervisor {
  int id;
  String firstName;
  String middleName;
  String lastName;
  String code;
  String fullName;

  Supervisor(
      {this.id, this.firstName, this.middleName, this.lastName, this.code,this.fullName});

  Supervisor.fromJson(Map<String, dynamic> json) {
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
  }

}

class Division {
  int id;
  String name;

  Division({this.id, this.name});

  Division.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    name = json['name']??'N/A';
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

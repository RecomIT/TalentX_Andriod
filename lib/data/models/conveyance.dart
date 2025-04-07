class ConveyanceList {
  var conveyanceList = <Conveyance>[];

  ConveyanceList({this.conveyanceList});

  ConveyanceList.fromJson(Map<String, dynamic> json) {
    if (json['conveyanceList'] != null) {
      conveyanceList = <Conveyance>[];
      json['conveyanceList'].forEach((v) {
        conveyanceList.add(Conveyance.fromJson(v));
      });
    }
  }
}


class Conveyance {
  int id;
  int employeeId;
  int settlementId;
  int conveyanceId;
  String requesterId;
  String employeeName;
  String lineManager;
  String division;
  String department;
  String costEnter;
  String businessUnit;
  String contactNo;
  String applicationDate;
  int totalBill;
  String paymentMethod;
  String pendingAt;
  String status;
  String settlementStatus;
  bool conveyanceApproval;
  bool settlementApproval;

  Conveyance(
      {this.id,
        this.employeeId,
        this.requesterId,
        this.conveyanceId,
        this.settlementId,
        this.employeeName,
        this.lineManager,
        this.division,
        this.department,
        this.costEnter,
        this.businessUnit,
        this.contactNo,
        this.applicationDate,
        this.totalBill,
        this.paymentMethod,
        this.pendingAt,
        this.status,
        this.settlementStatus,
        this.conveyanceApproval,
        this.settlementApproval});

  Conveyance.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    employeeId = json['employee_id']??0;
    conveyanceId = json['conveyance_id']??0;
    settlementId = json['settlement_id']??0;
    requesterId = json['requester_id']??'N/A';
    employeeName = json['employee_name']??'N/A';
    lineManager = json['line_manager']??'N/A';
    division = json['division']??'N/A';
    department = json['department']??'N/A';
    costEnter = json['cost_enter']??'N/A';
    businessUnit = json['business_unit']??'N/A';
    contactNo = json['contact_no']??'N/A';
    applicationDate = json['application_date']??'N/A';
    totalBill = json['total_bill']??0;
    paymentMethod = json['payment_method']??'N/A';
    pendingAt = json['pending_at']??'N/A';
    status = json['status']??'N/A';
    settlementStatus = json['settlement_status']??'N/A';
    conveyanceApproval = json['conveyance_approval']??false;
    settlementApproval = json['settlement_approval']??false;
  }
}

class SettlementRequestData {
  List<SettlementRequest> settlementRequest;

  SettlementRequestData({this.settlementRequest});

  SettlementRequestData.fromJson(Map<String, dynamic> json) {
    if (json['settlementRequest'] != null) {
      settlementRequest = <SettlementRequest>[];
      json['settlementRequest'].forEach((v) {
        settlementRequest.add(new SettlementRequest.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.settlementRequest != null) {
      data['settlementRequest'] = this.settlementRequest.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SettlementRequest {
  int travelSettlementId;
  String referenceNo;
  String employeeName;
  String divisionName;
  String departmentName;
  String costCenterName;
  String travelType;
  String purpose;
  String tripType;
  String transportMode;
  String year;
  String moth;
  String status;

  SettlementRequest(
      {this.travelSettlementId,
        this.referenceNo,
        this.employeeName,
        this.divisionName,
        this.departmentName,
        this.costCenterName,
        this.travelType,
        this.purpose,
        this.tripType,
        this.transportMode,
        this.year,
        this.moth,
        this.status});

  SettlementRequest.fromJson(Map<String, dynamic> json) {
    travelSettlementId = json['travel_settlement_id'];
    referenceNo = json['reference_no'] ?? '' ;
    employeeName = json['employee_name']?? '' ;
    divisionName = json['division_name']?? '' ;
    departmentName = json['department_name']?? '' ;
    costCenterName = json['cost_center_name']?? '' ;
    travelType = json['travel_type']?? '' ;
    purpose = json['purpose']?? '' ;
    tripType = json['trip_type']?? '' ;
    transportMode = json['transport_mode']?? '' ;
    year = json['year']?? '' ;
    moth = json['moth'];
    status = json['status']?? '' ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['travel_settlement_id'] = this.travelSettlementId;
    data['reference_no'] = this.referenceNo;
    data['employee_name'] = this.employeeName;
    data['division_name'] = this.divisionName;
    data['department_name'] = this.departmentName;
    data['cost_center_name'] = this.costCenterName;
    data['travel_type'] = this.travelType;
    data['purpose'] = this.purpose;
    data['trip_type'] = this.tripType;
    data['transport_mode'] = this.transportMode;
    data['year'] = this.year;
    data['moth'] = this.moth;
    data['status'] = this.status;
    return data;
  }
}
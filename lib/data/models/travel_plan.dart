class TravelPlanData {
  List<TravelPlan> travelPlan;

  TravelPlanData({this.travelPlan});

  TravelPlanData.fromJson(Map<String, dynamic> json) {
    if (json['travelPlan'] != null) {
      travelPlan = <TravelPlan>[];
      json['travelPlan'].forEach((v) {
        travelPlan.add(new TravelPlan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.travelPlan != null) {
      data['travelPlan'] = this.travelPlan.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TravelPlan {
  int id;
  String referenceNo;
  String employeeName;
  String divisionName;
  String costCenterName;
  String travelType;
  String purpose;
  String tripType;
  String transportMode;
  String year;
  String moth;
  String status;
  String applicableCostCenter;

  TravelPlan(
      {this.id,
        this.referenceNo,
        this.employeeName,
        this.divisionName,
        this.costCenterName,
        this.travelType,
        this.purpose,
        this.tripType,
        this.transportMode,
        this.year,
        this.moth,
        this.status,
      this.applicableCostCenter});

  TravelPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referenceNo = json['reference_no'].toString() == 'null' ? 'N/A': json['reference_no'].toString();;
    employeeName = json['employee_name'].toString() == 'null' ? 'N/A': json['employee_name'].toString();;
    divisionName = json['division_name'].toString() == 'null' ? 'N/A': json['division_name'].toString();;
    costCenterName = json['cost_center_name'].toString() == 'null' ? 'N/A': json['cost_center_name'].toString();;
    travelType = json['travel_type'].toString() == 'null' ? 'N/A': json['travel_type'].toString();;
    purpose = json['purpose'].toString() == 'null' ? 'N/A': json['purpose'].toString();;
    tripType = json['trip_type'].toString() == 'null' ? 'N/A': json['trip_type'].toString();;
    transportMode = json['transport_mode'].toString() == 'null' ? 'N/A': json['transport_mode'].toString();;
    year = json['year'].toString() == 'null' ? 'N/A': json['year'].toString();;
    moth = json['moth'].toString() == 'null' ? 'N/A': json['moth'].toString();;
    status = json['status'].toString() == 'null' ? 'N/A': json['status'].toString();;
    applicableCostCenter = json['applicable_cost_center'].toString() == 'null' ? 'N/A': json['applicable_cost_center'].toString();; //
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reference_no'] = this.referenceNo;
    data['employee_name'] = this.employeeName;
    data['division_name'] = this.divisionName;
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
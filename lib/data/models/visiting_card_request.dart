class VisitingCardRequest {
  String employeeCode;
  String employeeName;
  String employeeRole;
  String employeeDivision;
  String employeeDepartment;
  String employeeBusinessUnit;
  List<OfficeAddress> officeAddress;
  String requisitionDate;
  List<BusinessHeads> businessHeads;
  String visitingCardQuantity;
  List<RequiredStatus> requiredStatus;

  VisitingCardRequest(
      {this.employeeCode,
        this.employeeName,
        this.employeeRole,
        this.employeeDivision,
        this.employeeDepartment,
        this.officeAddress,
        this.requisitionDate,
        this.businessHeads,
        this.visitingCardQuantity,
        this.requiredStatus,
      this.employeeBusinessUnit});

  VisitingCardRequest.fromJson(Map<String, dynamic> json) {
    employeeCode = json['employee_code']??'';
    employeeName = json['employee_name']??'';
    employeeRole = json['employee_role']??'';
    employeeDivision = json['employee_division']??'';
    employeeDepartment = json['employee_department']??'';
    employeeBusinessUnit = json['employee_business_unit']??'';

    if (json['office_address'] != null) {
      officeAddress = <OfficeAddress>[];
      json['office_address'].forEach((v) {
        officeAddress.add(new OfficeAddress.fromJson(v));
      });
    }


    requisitionDate = json['requisition_date']??'N/A';
    if (json['business_heads'] != null) {
      businessHeads = <BusinessHeads>[];
      json['business_heads'].forEach((v) {
        businessHeads.add(new BusinessHeads.fromJson(v));
      });
    }
    visitingCardQuantity = json['visiting_card_quantity']?? '';
    if (json['required_status'] != null) {
      requiredStatus = <RequiredStatus>[];
      json['required_status'].forEach((v) {
        requiredStatus.add(new RequiredStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_code'] = this.employeeCode;
    data['employee_name'] = this.employeeName;
    data['employee_role'] = this.employeeRole;
    data['employee_division'] = this.employeeDivision;
    data['employee_department'] = this.employeeDepartment;
    data['office_address'] = this.officeAddress;
    data['requisition_date'] = this.requisitionDate;
    if (this.businessHeads != null) {
      data['business_heads'] =
          this.businessHeads.map((v) => v.toJson()).toList();
    }
    data['visiting_card_quantity'] = this.visitingCardQuantity;
    if (this.requiredStatus != null) {
      data['required_status'] =
          this.requiredStatus.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BusinessHeads {
  int id;
  String name;

  BusinessHeads({this.id, this.name});

  BusinessHeads.fromJson(Map<String, dynamic> json) {
    id = json['id']??'';
    name = json['name']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class OfficeAddress {
  String key;
  String value;

  OfficeAddress({this.key, this.value});

  OfficeAddress.fromJson(Map<String, dynamic> json) {
    key = json['key']??'';
    value = json['value']??'';
    // key = json.keys.first;
    // value = json.values.first;
  }
}
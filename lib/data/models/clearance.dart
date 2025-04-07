class ClearanceList {
  var clearanceList = <Clearance>[];

  ClearanceList({this.clearanceList});

  ClearanceList.fromJson(Map<String, dynamic> json) {
    if (json['clearanceList'] != null) {
      clearanceList = <Clearance>[];
      json['clearanceList'].forEach((v) {
        clearanceList.add(Clearance.fromJson(v));
      });
    }
  }
}

class Clearance {
  int id;
  String employeeName;
  String employeeRole;
  String employeeCode;
  String businessUnit;
  String costCenter;
  String lastWorkingDay;
  String clearanceGroup;
  String clearanceAuthority;
  String status;
  String createdAt;
  String checkedAt;

  Clearance({
    this.id,
    this.employeeName,
    this.employeeCode,
    this.employeeRole,
    this.businessUnit,
    this.costCenter,
    this.lastWorkingDay,
    this.clearanceGroup,
    this.clearanceAuthority,
    this.status,
    this.checkedAt,
    this.createdAt,
  });

  Clearance.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;

    String fName = json['employee']['first_name'].toString() == 'null' ? '' : json['employee']['first_name'].toString().trim();
    String mName = json['employee']['middle_name'].toString() == 'null' ? '' : json['employee']['middle_name'].toString().trim();
    String lName = json['employee']['last_name'].toString() == 'null' ? '' : json['employee']['last_name'].toString().trim();

    employeeName = fName;
    if(mName.isNotEmpty) {
      employeeName = employeeName + ' ' + mName;
    }
    if (lName.isNotEmpty) {
      employeeName=  employeeName + ' ' + lName;
    }

    employeeCode = json['employee']['code'] ?? '-';
    employeeRole = json['employee']['employee_role']['name'] ?? '-';
    businessUnit = json['employee']['business_unit']['name'] ?? '-';
    costCenter = json['employee']['cost_center']['name'] ?? '-';

    lastWorkingDay = json['separation']['resignation_effective_date']  ?? '-';
    clearanceGroup = json['clearance_log'] != null ? json['clearance_log']['clearance_group']['name']  ?? '-' : '-';
    clearanceAuthority = json['clearance_authority'] != null ? json['clearance_authority']['name']  ?? '-' : '-';
    status = json['status'] ?? '-';
    createdAt = json['created_at'] ?? '-';
    checkedAt = json['checked_at'] ?? '-';

    }
}


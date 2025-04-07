class CompanyHRInfo {
  List<EmployeeIDs> employeeIDs;
  List<Departments> departments;
  List<SubDepartments> subDepartments;
  List<SSubDepartments> sSubDepartments;

  CompanyHRInfo({this.employeeIDs, this.departments, this.subDepartments, this.sSubDepartments});

  CompanyHRInfo.fromJson(Map<String, dynamic> json) {
    if (json['employeeIDs'] != null) {
      employeeIDs = List<EmployeeIDs>();
      json['employeeIDs'].forEach((v) {
        employeeIDs.add(EmployeeIDs.fromJson(v));
      });
    }
    if (json['departments'] != null) {
      departments = List<Departments>();
      json['departments'].forEach((v) {
        departments.add(Departments.fromJson(v));
      });
    }
    if (json['subDepartments'] != null) {
      subDepartments = List<SubDepartments>();
      json['subDepartments'].forEach((v) {
        subDepartments.add(SubDepartments.fromJson(v));
      });
    }
    if (json['sSubDepartments'] != null) {
      sSubDepartments = List<SSubDepartments>();
      json['sSubDepartments'].forEach((v) {
        sSubDepartments.add(SSubDepartments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.employeeIDs != null) {
      data['employeeIDs'] = this.employeeIDs.map((v) => v.toJson()).toList();
    }
    if (this.departments != null) {
      data['departments'] = this.departments.map((v) => v.toJson()).toList();
    }
    if (this.subDepartments != null) {
      data['subDepartments'] = this.subDepartments.map((v) => v.toJson()).toList();
    }
    if (this.sSubDepartments != null) {
      data['sSubDepartments'] = this.sSubDepartments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeIDs {
  String iD;
  String name;

  EmployeeIDs({this.iD, this.name});

  EmployeeIDs.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    return data;
  }
}

class Departments {
  double departmentCode;
  String name;

  Departments({this.departmentCode, this.name});

  Departments.fromJson(Map<String, dynamic> json) {
    departmentCode = json['DepartmentCode'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['DepartmentCode'] = this.departmentCode;
    data['Name'] = this.name;
    return data;
  }
}

class SubDepartments {
  double subDepartmentCode;
  String name;

  SubDepartments({this.subDepartmentCode, this.name});

  SubDepartments.fromJson(Map<String, dynamic> json) {
    subDepartmentCode = json['SubDepartmentCode'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['SubDepartmentCode'] = this.subDepartmentCode;
    data['Name'] = this.name;
    return data;
  }
}

class SSubDepartments {
  double sSubDepartmentCode;
  String name;

  SSubDepartments({this.sSubDepartmentCode, this.name});

  SSubDepartments.fromJson(Map<String, dynamic> json) {
    sSubDepartmentCode = json['SSubDepartmentCode'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['SSubDepartmentCode'] = this.sSubDepartmentCode;
    data['Name'] = this.name;
    return data;
  }
}

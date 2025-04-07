class EmployeeIdList {
  List<EmployeeListItem> employeeList;

  EmployeeIdList({this.employeeList});

  EmployeeIdList.fromJson(Map<String, dynamic> json) {
    if (json['employeeList'] != null) {
      employeeList = <EmployeeListItem>[];
      json['employeeList'].forEach((v) {
        employeeList.add(EmployeeListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.employeeList != null) {
      data['employeeList'] = this.employeeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeListItem {
  String iD;
  String name;

  EmployeeListItem({this.iD, this.name});

  EmployeeListItem.fromJson(Map<String, dynamic> json) {
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

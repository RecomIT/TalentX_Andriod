import 'package:flutter/cupertino.dart';

class SearchColleagueData {
  //List<Colleague> colleague;
  var colleague = <Colleague>[];
  SearchColleagueData({this.colleague});

  SearchColleagueData.fromJson(Map<String, dynamic> json) {
    if (json['colleague'] != null && json['colleague'] is List) {
      colleague = <Colleague>[];
      json['colleague'].forEach((v) {
        colleague.add(new Colleague.fromJson(v));
      });
    }else {
      colleague = [];
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.colleague != null) {
      data['colleague'] = this.colleague.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Colleague {
  String iD;
  String code;
  String name;
  String phoneNo;
  String email;
  String employee_type_name;
  String designation;
  String location_name;
  String department;
  String division_name;
  String supervisor_name;
  String employee_role_name;



  Colleague(
      {this.iD,
      this.code,
      this.name,
      this.phoneNo,
      this.email,
      this.employee_type_name,
      this.location_name,
      this.designation,
      this.department,
      this.division_name,
      this.supervisor_name,
      this.employee_role_name});

  Colleague.fromJson(Map<String, dynamic> json) {
    iD = json['id'].toString()== 'null' ? 'N/A': json['id'].toString();
    code=json['code'].toString() == 'null' ? 'N/A': json['code'].toString();

    String fName = json['first_name'].toString() == 'null' ? '': json['first_name'].toString();
    String mName = json['middle_name'].toString() == 'null' ? '': json['middle_name'].toString();
    String lName = json['last_name'].toString() == 'null' ? '': json['last_name'].toString();

    name= fName;
    if(mName.isNotEmpty) {
      name = name + ' ' + mName;
    }
    if (lName.isNotEmpty) {
      name=  name + ' ' + lName;
    };
    //name = '$fName $mName $lName';

    phoneNo = json['phone'].toString() == 'null' ? 'N/A': json['phone'].toString();
    email = json['email'].toString() == 'null' ? 'N/A': json['email'].toString();

    employee_type_name = json['employee_type_name'].toString() == 'null' ? 'N/A': json['employee_type_name'].toString();
    designation = json['designation_name'].toString() == 'null' ? 'N/A': json['designation_name'].toString();
    department = json['department_name'].toString() == 'null' ? 'N/A': json['department_name'].toString();
    division_name = json['division_name'].toString() == 'null' ? 'N/A': json['division_name'].toString();
    location_name = json['location_name'].toString() == 'null' ? 'N/A': json['location_name'].toString();
    supervisor_name = json['supervisor_name'].toString() == 'null' ? 'N/A': json['supervisor_name'].toString();
    employee_role_name = json['employee_role_name'].toString() == 'null' ? 'N/A': json['employee_role_name'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['Designation'] = this.designation;
    data['Department'] = this.department;
    data['PhoneNo'] = this.phoneNo;
    return data;
  }
}

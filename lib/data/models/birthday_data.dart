import 'package:intl/intl.dart';
import 'package:recom_app/services/helper/date_services.dart';

class BirthdayData {
 // List<BirthdayInfo> birthday;
  var birthday = <BirthdayInfo>[];

  BirthdayData({this.birthday});

  BirthdayData.fromJson(Map<String, dynamic> json) {
    if (json['birthday'] != null) {
      birthday = <BirthdayInfo>[];
      json['birthday'].forEach((v) {
        birthday.add(BirthdayInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.birthday != null) {
      data['birthday'] = this.birthday.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BirthdayInfo {
  String id;
  String code;
  String first_name;
  String middle_name;
  String last_name;
  String dob;
  String phone;
  String email;
  String employee_type_name;
  String designation_name;
  String location_name;
  String department_name;
  String division_name;
  //String photo;

  BirthdayInfo({this.id,this.code, this.first_name,this.middle_name,this.last_name,this.dob, this.phone,this.email,
    this.employee_type_name, this.designation_name,this.location_name,this.department_name, this.division_name});

  BirthdayInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    code = json['code'];

    String fName = json['first_name'].toString() == 'null' ? '': json['first_name'].toString();
    String mName = json['middle_name'].toString() == 'null' ? '': json['middle_name'].toString();
    String lName = json['last_name'].toString() == 'null' ? '': json['last_name'].toString();
    String dathofBirth =json['dob'].toString() == 'null' ? '0000-01-01': json['dob'].toString();;
    String empTypeName=json['employee_type_name'].toString() == 'null' ? '': json['employee_type_name'].toString();
    String locationName=json['location_name'].toString() == 'null' ? '': json['location_name'].toString();
    String divName=json['division_name'].toString() == 'null' ? '': json['division_name'].toString();
    String deptName=json['department_name'].toString() == 'null' ? '': json['department_name'].toString();
    String desigName=json['designation_name'].toString() == 'null' ? '': json['designation_name'].toString();

    String phn=json['phone'].toString() == 'null' ? 'N/A': json['phone'].toString();
    String eml=json['Email'].toString() == 'null' ? 'N/A': json['Email'].toString();

    first_name = fName;
    middle_name = mName;
    last_name = lName;
    var dateFormatter = new DateFormat('MMM dd');
    dob= dateFormatter.format(DateTime.parse(dathofBirth));
    phone = phn;
    email = eml;
    employee_type_name = empTypeName;
    designation_name = desigName;
    location_name = locationName;
    department_name = deptName;
    division_name = divName;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['code'] =this.code;
    data['first_name'] =this.first_name;
    data['middle_name'] =this.middle_name;
    data['last_name'] =this.last_name;
    data['dob'] =this.dob;
    data['phone'] =this.phone;
    data['email'] =this.email;
    data['employee_type_name'] =this.employee_type_name;
    data['designation_name'] =this.designation_name;
    data['location_name'] =this.location_name;
    data['department_name'] =this.department_name;
    data['division_name'] =this.division_name;
    //data['photo'] =this.photo;
    return data;
  }
}

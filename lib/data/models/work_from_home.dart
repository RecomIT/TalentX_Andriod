class WorkFromHomeList {
  var workFromHomeList = <WorkFromHome>[];

  WorkFromHomeList({this.workFromHomeList});

  WorkFromHomeList.fromJson(Map<String, dynamic> json) {
    if (json['workFromHomeList'] != null) {
      workFromHomeList = <WorkFromHome>[];
      json['workFromHomeList'].forEach((v) {
        workFromHomeList.add(WorkFromHome.fromJson(v));
      });
    }
  }
}

class WorkFromHome {
  int wfhId;
  String type;
  String firstName;
  String middleName;
  String lastName;
  String startDate;
  String endDate;
  String numberOfDays;
  String status;
  String fullName;

  WorkFromHome(
      {this.wfhId,
        this.type,
        this.firstName,
        this.middleName,
        this.lastName,
        this.startDate,
        this.endDate,
        this.numberOfDays,
        this.status,this.fullName});

  WorkFromHome.fromJson(Map<String, dynamic> json) {
    wfhId = json['wfh_id']??0;
    type = json['type']??'N/A';
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    startDate = json['start_date'] ?? 'N/A';
    endDate = json['end_date']?? 'N/A';
    numberOfDays = json['number_of_days'].toString() == 'null' ? '0': json['number_of_days'].toString();
    status = json['status'] ?? 'N/A';

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wfh_id'] = this.wfhId;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['number_of_days'] = this.numberOfDays;
    data['status'] = this.status;
    return data;
  }
}
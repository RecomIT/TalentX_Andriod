class MyResignationList {
  var myResignationList = <MyResignation>[];

  MyResignationList({this.myResignationList});

  MyResignationList.fromJson(Map<String, dynamic> json) {
    if (json['myResignationList'] != null) {
      myResignationList = <MyResignation>[];
      json['myResignationList'].forEach((v) {
        myResignationList.add(MyResignation.fromJson(v));
      });
    }
  }
}


class MyResignation {
  int separationId;
  String applicationDate;
  String lastWorkingDate;
  String status;

  MyResignation(
      {this.separationId,
        this.applicationDate,
        this.lastWorkingDate,
        this.status});

  MyResignation.fromJson(Map<String, dynamic> json) {
    separationId = json['separation_id'];
    applicationDate = json['application_date'];
    lastWorkingDate = json['last_working_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['separation_id'] = this.separationId;
    data['application_date'] = this.applicationDate;
    data['last_working_date'] = this.lastWorkingDate;
    data['status'] = this.status;
    return data;
  }
}
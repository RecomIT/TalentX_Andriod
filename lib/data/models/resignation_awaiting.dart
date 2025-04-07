class ResignationAwaitingList {
  var resignationAwaitingList = <ResignationAwaiting>[];

  ResignationAwaitingList({this.resignationAwaitingList});

  ResignationAwaitingList.fromJson(Map<String, dynamic> json) {
    if (json['resignationAwaitingList'] != null) {
      resignationAwaitingList = <ResignationAwaiting>[];
      json['resignationAwaitingList'].forEach((v) {
        resignationAwaitingList.add(ResignationAwaiting.fromJson(v));
      });
    }
  }
}

class ResignationAwaiting {
  int separationId;
  int separationProcessedId;
  String rememberToken;
  String employeeName;
  String designationName;
  String submissionDate;
  String lastWorkingDate;
  String status;

  ResignationAwaiting(
      {
        this.separationId,
        this.separationProcessedId,
        this.rememberToken,
        this.employeeName,
        this.designationName,
        this.submissionDate,
        this.lastWorkingDate,
        this.status});

  ResignationAwaiting.fromJson(Map<String, dynamic> json) {

    separationId = json['separation_id'];
    separationProcessedId = json['separation_processed_id'];
    rememberToken = json['remember_token'];

    employeeName = json['employee_name'];
    designationName = json['designation_name'];
    submissionDate = json['submission_date'];
    lastWorkingDate = json['last_working_date'];
    status = json['status'];
  }
}
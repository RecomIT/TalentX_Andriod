class WorkFromHomeAwaitingList {
  var workFromHomeAwaitingList = <WorkFromHomeAwaiting>[];

  WorkFromHomeAwaitingList({this.workFromHomeAwaitingList});

  WorkFromHomeAwaitingList.fromJson(Map<String, dynamic> json) {
    if (json['workFromHomeAwaitingList'] != null) {
      workFromHomeAwaitingList = <WorkFromHomeAwaiting>[];
      json['workFromHomeAwaitingList'].forEach((v) {
        workFromHomeAwaitingList.add(WorkFromHomeAwaiting.fromJson(v));
      });
    }
  }
}

class WorkFromHomeAwaiting {
  int wfhId;
  String type;
  String startDate;
  String endDate;
  String numberOfDays;
  String description;
  String attachment;
  String status;
  String processedAt;
  String sentForApproval;
  String code;
  String firstName;
  String middleName;
  String lastName;
  String fullName;

  WorkFromHomeAwaiting(
      {this.wfhId,
        this.type,
        this.startDate,
        this.endDate,
        this.numberOfDays,
        this.description,
        this.attachment,
        this.status,
        this.processedAt,
        this.sentForApproval,
        this.code,
        this.firstName,
        this.middleName,
        this.lastName,
        this.fullName});

  WorkFromHomeAwaiting.fromJson(Map<String, dynamic> json) {
    wfhId = json['wfh_id']??0;
    type = json['type']??'N/A';
    startDate = json['start_date'] ??'N/A';
    endDate = json['end_date'] ??'N/A';
    numberOfDays = json['number_of_days'].toString() == 'null' ? '0': json['number_of_days'].toString();
    description = json['description'] ??'N/A';
    attachment = json['attachment'] ??'N/A';
    status = json['status'] ??'N/A';
    processedAt = json['processed_at'] ??'N/A';
    sentForApproval = json['sent_for_approval'] ??'N/A';
    code = json['code'] ??'N/A';
    firstName = json['first_name'] ??'N/A';
    middleName = json['middle_name'] ??'N/A';
    lastName = json['last_name'] ??'N/A';

    String fName = json['first_name'].toString() == 'null' ? '': json['first_name'].toString().trim();
    String mName = json['middle_name'].toString() == 'null' ? '': json['middle_name'].toString().trim();
    String lName = json['last_name'].toString() == 'null' ? '': json['last_name'].toString().trim();


    fullName= fName;
    if(mName.isNotEmpty) {
      fullName = fullName + ' ' + mName;
    }
    if (lName.isNotEmpty) {
      fullName=  fullName + ' ' + lName;
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wfh_id'] = this.wfhId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['number_of_days'] = this.numberOfDays;
    data['description'] = this.description;
    data['attachment'] = this.attachment;
    data['status'] = this.status;
    data['processed_at'] = this.processedAt;
    data['sent_for_approval'] = this.sentForApproval;
    data['code'] = this.code;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    return data;
  }
}
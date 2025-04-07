class WorkFromHomeDetails {
  int wfhId;
  String type;
  String name;
  String code;
  String applicationDate;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String numberOfDays;
  String description;
  String status;
  String attachment;
  String note;
  String supervisor;

  WorkFromHomeDetails(
      {this.wfhId,
        this.type,
        this.name,
        this.code,
        this.applicationDate,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.numberOfDays,
        this.description,
        this.status,
        this.attachment,
        this.note,
        this.supervisor});

  WorkFromHomeDetails.fromJson(Map<String, dynamic> json) {
    wfhId = json['wfh_id']??0;
    type=json['type']??'N/A';
    name = json['name'] ?? 'N/A';
    code = json['code'] ?? 'N/A';
    applicationDate = json['application_date'] ?? 'N/A';
    startDate = json['start_date'] ?? 'N/A';
    endDate = json['end_date'] ?? 'N/A';
    startTime = json['start_time'] ?? 'N/A';
    endTime = json['end_time'] ?? 'N/A';
    numberOfDays = json['number_of_days'].toString() == 'null' ? '0': json['number_of_days'].toString();
    description = json['description'] ?? 'N/A';
    status = json['status'] ?? 'N/A';
    attachment = json['attachment'] ?? 'N/A';
    note = json['note'] ?? '';
    supervisor = json['supervisor'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wfh_id'] = this.wfhId;
    data['name'] = this.name;
    data['code'] = this.code;
    data['application_date'] = this.applicationDate;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['number_of_days'] = this.numberOfDays;
    data['description'] = this.description;
    data['status'] = this.status;
    data['attachment'] = this.attachment;
    data['note'] = this.note;
    data['supervisor'] = this.supervisor;
    return data;
  }
}
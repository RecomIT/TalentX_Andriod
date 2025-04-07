class ResignationInfo {
  String employeeName;
  String joiningDate;
  int noticePeriod;
  String applicationDate;
  String resignationEffectiveDate;
  int seceondLevelSupervisorId;

  ResignationInfo(
      {this.employeeName,
        this.joiningDate,
        this.noticePeriod,
        this.applicationDate,
        this.resignationEffectiveDate,
        this.seceondLevelSupervisorId});

  ResignationInfo.fromJson(Map<String, dynamic> json) {
    employeeName = json['employee_name'];
    joiningDate = json['joining_date'];
    noticePeriod = json['notice_period'];
    applicationDate = json['application_date'];
    resignationEffectiveDate = json['resignation_effective_date'];
    seceondLevelSupervisorId = json['seceond_level_supervisor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_name'] = this.employeeName;
    data['joining_date'] = this.joiningDate;
    data['notice_period'] = this.noticePeriod;
    data['application_date'] = this.applicationDate;
    data['resignation_effective_date'] = this.resignationEffectiveDate;
    return data;
  }
}
class ResignationDetails {
  int separationId;
  String employeeName;
  String joiningDate;
  int noticePeriod;
  String applicationDate;
  //String resignationEffectiveDate;
  String lastWorkingDay;
  String leavingReason;
  String description;
  int noticePeriodWaive;
  String noticePeriodPolicy;
  String supervisorName;
  String seceondLineSupervisor;
  String concerningHr;
  String status;

  List<Attachment> attachment;
  List<SeparationProcesses> separationProcesses;

  ResignationDetails(
      {this.separationId,
        this.employeeName,
        this.joiningDate,
        this.noticePeriod,
        this.applicationDate,
        //this.resignationEffectiveDate,
        this.lastWorkingDay,
        this.leavingReason,
        this.description,
        this.noticePeriodWaive,
        this.supervisorName,
        this.seceondLineSupervisor,
        this.concerningHr,
        this.status,
        this.attachment,
        this.separationProcesses,this.noticePeriodPolicy});

  ResignationDetails.fromJson(Map<String, dynamic> json) {
    this.separationId = json['separation_id'];
    employeeName = json['employee_name'];
    joiningDate = json['joining_date'];
    noticePeriod = json['notice_period'];
    applicationDate = json['application_date'];
    //resignationEffectiveDate = json['resignation_effective_date'];
    lastWorkingDay = json['last_working_date'];
    print('lastWorkingDay ' + lastWorkingDay);
    leavingReason = json['leaving_reason'];
    description = json['description'] ?? 'N/A';
    noticePeriodWaive = json['notice_period_waive']?? 0;
    noticePeriodPolicy= json['notice_period_policy'] ?? 'N/A';
    supervisorName = json['supervisor_name'];
    seceondLineSupervisor = json['seceond_line_supervisor']?? 'N/A';
    concerningHr = json['concerning_hr'];
    status = json['status'];
    if (json['attachment'] != null) {
      attachment = new List<Attachment>();
      json['attachment'].forEach((v) {
        attachment.add(new Attachment.fromJson(v));
      });
    }
    if (json['separationProcesses'] != null) {
      separationProcesses =  <SeparationProcesses>[];
      json['separationProcesses'].forEach((v) {
        separationProcesses.add(new SeparationProcesses.fromJson(v));
      });
    }
  }

}

class Attachment {
  String attachment;

  Attachment({this.attachment});

  Attachment.fromJson(Map<String, dynamic> json) {
    attachment = json['attachment'] ?? 'N/A';
  }
}

class SeparationProcesses {
  String remarks;
  String processedBy;
  String statusDate;

  SeparationProcesses({this.remarks, this.processedBy, this.statusDate});

  SeparationProcesses.fromJson(Map<String, dynamic> json) {
    remarks = json['remarks']?? 'N/A';
    processedBy = json['processed_by']?? 'N/A';
    statusDate = json['status_date']?? 'N/A';
  }

}
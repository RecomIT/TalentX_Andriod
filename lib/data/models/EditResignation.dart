class EditResignation {
  String employeeName;
  String joiningDate;
  int noticePeriod;
  String applicationDate;
  String resignationEffectiveDate;
  int seceondLevelSupervisorId;
  int id;
  int employeeId;
  String resignationApplication;
  int currentSupervisorEmployeeId;
  int supervisorId2;
  String supervisorComment;
  String hrEmail;
  String separationType;
  String leavingReason;
  int noticePeriodWaive;
  String resignationApprovalStatus;
  String approvalDate;
  String hrNote;

  EditResignation(
      {this.employeeName,
        this.joiningDate,
        this.noticePeriod,
        this.applicationDate,
        this.resignationEffectiveDate,
        this.seceondLevelSupervisorId,
        this.id,
        this.employeeId,
        this.resignationApplication,
        this.currentSupervisorEmployeeId,
        this.supervisorId2,
        this.supervisorComment,
        this.hrEmail,
        this.separationType,
        this.leavingReason,
        this.noticePeriodWaive,
        this.resignationApprovalStatus,
        this.approvalDate,
        this.hrNote});

  EditResignation.fromJson(Map<String, dynamic> json) {
    employeeName = json['employee_name'];
    joiningDate = json['joining_date'];
    noticePeriod = json['notice_period'];
    applicationDate = json['application_date'];
    resignationEffectiveDate = json['resignation_effective_date'];
    seceondLevelSupervisorId = json['seceond_level_supervisor_id'];
    id = json['id'];
    employeeId = json['employee_id'];
    resignationApplication = json['resignation_application'];
    currentSupervisorEmployeeId = json['current_supervisor_employee_id'];
    supervisorId2 = json['supervisor_id_2'];
    supervisorComment = json['supervisor_comment']?? 'N/A';
    hrEmail = json['hr_email'];
    separationType = json['separation_type'];
    leavingReason = json['leaving_reason'];
    noticePeriodWaive = json['notice_period_waive'];
    resignationApprovalStatus = json['resignation_approval_status'];
    approvalDate = json['approval_date'];
    hrNote = json['hr_note'];
  }
}
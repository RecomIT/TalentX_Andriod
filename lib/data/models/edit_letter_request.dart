import 'letter_request.dart';

class EditLetterRequest {
  RequisitionDetails requisitionDetails;
  EmployeeDetails employeeDetails;
  String attachment;

  EditLetterRequest(
      {this.requisitionDetails, this.employeeDetails, this.attachment});

  EditLetterRequest.fromJson(Map<String, dynamic> json) {
    requisitionDetails = json['requisition_details'] != null ?
         new RequisitionDetails.fromJson(json['requisition_details'])
        : null;
    employeeDetails = json['employee_details'] != null ?
         new EmployeeDetails.fromJson(json['employee_details'])
        : null;
    attachment = json['attachment']??'';
  }
}

class RequisitionDetails {
  int id;
  int employeeId;
  int divisionId;
  int departmentId;
  int employeeRoleId;
  int supervisorId;
  String requisitionDate;
  String referenceNo;
  String hrEmail;
  String requisitionType;
  String reason;
  int salaryCertificateYear;
  int salaryCertificateMonth;
  int salary;
  int salaryDisplay;
  String passportNo;
  String startDate;
  String endDate;
  String dateOfBirth;
  String embassyName;
  String embassyAddress;
  String countryName;
  String remarks;
  String attachment;
  String deliveredDate;
  String applicationStatus;
  int completedBy;
  String completedAt;
  int createdBy;
  int updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;

  RequisitionDetails(
      {this.id,
        this.employeeId,
        this.divisionId,
        this.departmentId,
        this.employeeRoleId,
        this.supervisorId,
        this.requisitionDate,
        this.referenceNo,
        this.hrEmail,
        this.requisitionType,
        this.reason,
        this.salaryCertificateYear,
        this.salaryCertificateMonth,
        this.salary,
        this.salaryDisplay,
        this.passportNo,
        this.startDate,
        this.endDate,
        this.dateOfBirth,
        this.embassyName,
        this.embassyAddress,
        this.countryName,
        this.remarks,
        this.attachment,
        this.deliveredDate,
        this.applicationStatus,
        this.completedBy,
        this.completedAt,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  RequisitionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']?? 0;
    employeeId = json['employee_id']?? 0;
    divisionId = json['division_id']?? 0;
    departmentId = json['department_id']?? 0;
    employeeRoleId = json['employee_role_id']?? 0;
    supervisorId = json['supervisor_id']?? 0;
    requisitionDate = json['requisition_date']??'N/A';
    referenceNo = json['reference_no']??'N/A';
    hrEmail = json['hr_email']??'N/A';
    requisitionType = json['requisition_type']??'N/A';
    reason = json['reason']??'N/A';
    salaryCertificateYear = json['salary_certificate_year']??0;
    salaryCertificateMonth = json['salary_certificate_month']??0;
    salary = json['salary']??0;
    salaryDisplay = json['salary_display']??0;
    passportNo = json['passport_no']??'N/A';
    startDate = json['start_date']??'N/A';
    endDate = json['end_date']??'N/A';
    dateOfBirth = json['date_of_birth']??'N/A';
    embassyName = json['embassy_name']??'N/A';
    embassyAddress = json['embassy_address']??'N/A';
    countryName = json['country_name']??'N/A';
    remarks = json['remarks']??'N/A';
    attachment = json['attachment']??'';
    deliveredDate = json['delivered_date']??'N/A';
    applicationStatus = json['application_status']??'N/A';
    completedBy = json['completed_by']??0;
    completedAt = json['completed_at']??'N/A';
    createdBy = json['created_by']??0;
    updatedBy = json['updated_by']??0;
    deletedAt = json['deleted_at']??'N/A';
    createdAt = json['created_at']??'N/A';
    updatedAt = json['updated_at']??'N/A';
  }
}

class EmployeeDetails {
  String employeeDivision;
  String employeeDepartment;
  String dateOfJoin;
  String employeeRole;
  String lineManager;
  List<RequisitionFor> requisitionFor;
  List<LetterReason> salaryCertificate;
  List<LetterReason> introductoryLetter;
  List<LetterReason> invitationLetter;
  List<LetterReason> experienceLetter;
  List<Embassy> embassy;

  EmployeeDetails(
      {this.employeeDivision,
        this.employeeDepartment,
        this.dateOfJoin,
        this.employeeRole,
        this.lineManager,
        this.requisitionFor,
        this.salaryCertificate,
        this.introductoryLetter,this.invitationLetter,
        this.experienceLetter,
        this.embassy});

  EmployeeDetails.fromJson(Map<String, dynamic> json) {
    employeeDivision = json['employee_division']?? 'N/A';
    employeeDepartment = json['employee_department']?? 'N/A';
    dateOfJoin = json['date_of_join']?? 'N/A';
    employeeRole = json['employee_role']?? 'N/A';
    lineManager = json['line_manager']?? 'N/A';
    if (json['requisition_for'] != null) {
      requisitionFor = <RequisitionFor>[];
      json['requisition_for'].forEach((v) {
        requisitionFor.add(new RequisitionFor.fromJson(v));
      });
    }
    if (json['salary_certificate'] != null) {
      salaryCertificate = <LetterReason>[];
      json['salary_certificate'].forEach((v) {
        salaryCertificate.add(new LetterReason.fromJson(v));
      });
    }
    if (json['introductory_letter'] != null) {
      introductoryLetter = <LetterReason>[];
      json['introductory_letter'].forEach((v) {
        introductoryLetter.add(new LetterReason.fromJson(v));
      });
    }

    if (json['invitation_letter'] != null) {
      invitationLetter = <LetterReason>[];
      json['invitation_letter'].forEach((v) {
        invitationLetter.add(new LetterReason.fromJson(v));
      });
    }


    if (json['experience_letter'] != null) {
      experienceLetter = <LetterReason>[];
      json['experience_letter'].forEach((v) {
        experienceLetter.add(new LetterReason.fromJson(v));
      });
    }
    if (json['embassy'] != null) {
      embassy = <Embassy>[];
      json['embassy'].forEach((v) {
        embassy.add(new Embassy.fromJson(v));
      });
    }
  }
}


class AllLeaveReportList {
  List<AllLeaveReport> allLeaveReports;

  AllLeaveReportList({this.allLeaveReports});

  AllLeaveReportList.fromJson(Map<String, dynamic> json) {
    if (json['allLeaveReport'] != null) {
      allLeaveReports = List<AllLeaveReport>();
      json['allLeaveReport'].forEach((v) {
        allLeaveReports.add(AllLeaveReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.allLeaveReports != null) {
      data['allLeaveReport'] = this.allLeaveReports.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllLeaveReport {
  String id;
  String name;
  String designation;
  String joiningDate;
  String mobile;
  String email;
  String department;
  String workLocation;
  String gender;
  double casualLeaveAllocated;
  double casualLeaveAvailed;
  double casualLeaveBalance;
  double sickLeaveAllocated;
  double sickLeaveAvailed;
  double sickLeaveBalance;
  double annualLeaveAllocated;
  double annualLeaveAvailed;
  double annualLeaveBalance;
  double unpaidLeaveAllocated;
  double unpaidLeaveAvailed;
  double unpaidLeaveBalance;
  double maternityLeaveAllocated;
  double maternityLeaveAvailed;
  double maternityLeaveBalance;
  String leaveDetails;

  AllLeaveReport(
      {this.id,
      this.name,
      this.designation,
      this.joiningDate,
      this.mobile,
      this.email,
      this.department,
      this.workLocation,
      this.gender,
      this.casualLeaveAllocated,
      this.casualLeaveAvailed,
      this.casualLeaveBalance,
      this.sickLeaveAllocated,
      this.sickLeaveAvailed,
      this.sickLeaveBalance,
      this.annualLeaveAllocated,
      this.annualLeaveAvailed,
      this.annualLeaveBalance,
      this.unpaidLeaveAllocated,
      this.unpaidLeaveAvailed,
      this.unpaidLeaveBalance,
      this.maternityLeaveAllocated,
      this.maternityLeaveAvailed,
      this.maternityLeaveBalance,
      this.leaveDetails});

  AllLeaveReport.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    designation = json['Designation'];
    joiningDate = json['JoiningDate'];
    mobile = json['Mobile'];
    email = json['Email'];
    department = json['Department'];
    workLocation = json['WorkLocation'];
    gender = json['Gender'];
    casualLeaveAllocated = json['CasualLeaveAllocated'];
    casualLeaveAvailed = json['CasualLeaveAvailed'];
    casualLeaveBalance = json['CasualLeaveBalance'];
    sickLeaveAllocated = json['SickLeaveAllocated'];
    sickLeaveAvailed = json['SickLeaveAvailed'];
    sickLeaveBalance = json['SickLeaveBalance'];
    annualLeaveAllocated = json['AnnualLeaveAllocated'];
    annualLeaveAvailed = json['AnnualLeaveAvailed'];
    annualLeaveBalance = json['AnnualLeaveBalance'];
    unpaidLeaveAllocated = json['UnpaidLeaveAllocated'];
    unpaidLeaveAvailed = json['UnpaidLeaveAvailed'];
    unpaidLeaveBalance = json['UnpaidLeaveBalance'];
    maternityLeaveAllocated = json['MaternityLeaveAllocated'];
    maternityLeaveAvailed = json['MaternityLeaveAvailed'];
    maternityLeaveBalance = json['MaternityLeaveBalance'];
    leaveDetails = json['LeaveDetails'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Designation'] = this.designation;
    data['JoiningDate'] = this.joiningDate;
    data['Mobile'] = this.mobile;
    data['Email'] = this.email;
    data['Department'] = this.department;
    data['WorkLocation'] = this.workLocation;
    data['Gender'] = this.gender;
    data['CasualLeaveAllocated'] = this.casualLeaveAllocated;
    data['CasualLeaveAvailed'] = this.casualLeaveAvailed;
    data['CasualLeaveBalance'] = this.casualLeaveBalance;
    data['SickLeaveAllocated'] = this.sickLeaveAllocated;
    data['SickLeaveAvailed'] = this.sickLeaveAvailed;
    data['SickLeaveBalance'] = this.sickLeaveBalance;
    data['AnnualLeaveAllocated'] = this.annualLeaveAllocated;
    data['AnnualLeaveAvailed'] = this.annualLeaveAvailed;
    data['AnnualLeaveBalance'] = this.annualLeaveBalance;
    data['UnpaidLeaveAllocated'] = this.unpaidLeaveAllocated;
    data['UnpaidLeaveAvailed'] = this.unpaidLeaveAvailed;
    data['UnpaidLeaveBalance'] = this.unpaidLeaveBalance;
    data['MaternityLeaveAllocated'] = this.maternityLeaveAllocated;
    data['MaternityLeaveAvailed'] = this.maternityLeaveAvailed;
    data['MaternityLeaveBalance'] = this.maternityLeaveBalance;
    data['LeaveDetails'] = this.leaveDetails;
    return data;
  }
}

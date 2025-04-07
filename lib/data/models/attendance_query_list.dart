class AttendanceQueryList {
  List<AttendanceQuery> attendanceQueryList;

  AttendanceQueryList({this.attendanceQueryList});

  AttendanceQueryList.fromJson(Map<String, dynamic> json) {
    if (json['AttendanceQueryList'] != null) {
      attendanceQueryList = new List<AttendanceQuery>();
      json['AttendanceQueryList'].forEach((v) {
        attendanceQueryList.add(new AttendanceQuery.fromJson(v));
      });
    }
  }
}

class AttendanceQuery {
  String date;
  String day;
  String empId;
  String name;
  String status;
  String lateStatus;
  String inTime;
  String outTime;
  String checkinLocation;
  String checkoutLocation;
  String remarks;
  String lateHour;
  String workingHour;

  AttendanceQuery(
      {this.date,
      this.day,
      this.empId,
      this.name,
      this.status,
      this.lateStatus,
      this.inTime,
      this.outTime,
      this.checkinLocation,
      this.checkoutLocation,
      this.remarks,
      this.lateHour,
      this.workingHour});

  AttendanceQuery.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    day = json['Day'];
    empId = json['EmpId'];
    name = json['Name'];
    status = json['Status'];
    lateStatus = json['LateStatus'];
    inTime = json['InTime'];
    outTime = json['OutTime'];
    checkinLocation = json['CheckinLocation'];
    checkoutLocation = json['checkoutLocation'];
    remarks = json['Remarks'];
    lateHour = json['Late'];
    workingHour = json['WorkingHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['Day'] = this.day;
    data['EmpId'] = this.empId;
    data['Name'] = this.name;
    data['Status'] = this.status;
    data['LateStatus'] = this.lateStatus;
    data['InTime'] = this.inTime;
    data['OutTime'] = this.outTime;
    data['CheckinLocation'] = this.checkinLocation;
    data['checkoutLocation'] = this.checkoutLocation;
    data['Remarks'] = this.remarks;
    data['Late'] = this.lateHour;
    data['WorkingHour'] = this.workingHour;
    return data;
  }
}

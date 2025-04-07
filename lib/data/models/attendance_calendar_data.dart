class AttendanceCalendarData {
  List<AttendanceData> attendance;

  AttendanceCalendarData({this.attendance});

  AttendanceCalendarData.fromJson(Map<String, dynamic> json) {
    if (json['attendance'] != null) {
      attendance = new List<AttendanceData>();
      json['attendance'].forEach((v) {
        attendance.add(new AttendanceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.attendance != null) {
      data['attendance'] = this.attendance.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceData {
  String attendanceDate;
  String inTime;
  String outTime;
  String checkinLocation;
  String checkoutLocation;
  String reason;
  String status;

  AttendanceData(
      {this.attendanceDate,
      this.inTime,
      this.outTime,
      this.checkinLocation,
      this.checkoutLocation,
      this.reason,
      this.status});

  AttendanceData.fromJson(Map<String, dynamic> json) {
    attendanceDate = json['AttendanceDate'];
    inTime = json['InTime'];
    outTime = json['OutTime'];
    checkinLocation = json['CheckinLocation'];
    checkoutLocation = json['CheckoutLocation'];
    reason = json['Reason'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['AttendanceDate'] = this.attendanceDate;
    data['InTime'] = this.inTime;
    data['OutTime'] = this.outTime;
    data['CheckinLocation'] = this.checkinLocation;
    data['CheckoutLocation'] = this.checkoutLocation;
    data['Reason'] = this.reason;
    data['Status'] = this.status;
    return data;
  }
}

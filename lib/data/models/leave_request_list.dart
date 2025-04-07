class LeaveRequestList {
  List<LeaveRequest> leaveRequests;

  LeaveRequestList({this.leaveRequests});

  LeaveRequestList.fromJson(Map<String, dynamic> json) {
    if (json['leaveRequest'] != null && json['leaveRequest'] is List) {
      leaveRequests = <LeaveRequest>[];
      json['leaveRequest'].forEach((v) {
        leaveRequests.add(LeaveRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.leaveRequests != null) {
      data['leaveRequest'] = this.leaveRequests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveRequest {
  int leaveId;
  String empName;
  String leaveName;
  String leaveType;
  String halfLeaveType;
  String fromDate;
  String toDate;
  String totalDays;
  String leavePurpose;
  String status;
  String leaveDescription;
  String leaveDocument;

  String sVRmk;
  String mGRmk;
  String hODRmk;
  String hRRmk;
  String sVSts;
  String mGSts;
  String hODSts;
  String hRSts;

  LeaveRequest(
      {this.leaveId,
      this.empName,
      this.leaveName,
      this.leaveType,
      this.halfLeaveType,
      this.fromDate,
      this.toDate,
      this.totalDays,
      this.leavePurpose,
      this.status,
      this.leaveDescription,
      this.leaveDocument,
      this.sVRmk,
      this.mGRmk,
      this.hODRmk,
      this.hRRmk,
      this.sVSts,
      this.mGSts,
      this.hODSts,
      this.hRSts});

  LeaveRequest.fromJson(Map<String, dynamic> json) {

    leaveId = json['leave_id'].toString() == 'null' ? 0: json['leave_id'];
    String fName = json['first_name'].toString() == 'null' ? '': json['first_name'].toString();
    String mName = json['middle_name'].toString() == 'null' ? '': json['middle_name'].toString();
    String lName = json['last_name'].toString() == 'null' ? '': json['last_name'].toString();
    empName = '$fName $mName $lName';
    leaveType = json['leave_type']== 'null' ? '': json['leave_type'].toString();
    fromDate = json['start_date']== 'null' ? '': json['start_date'].toString();
    toDate = json['end_date']== 'null' ? '': json['end_date'].toString();
    totalDays = json['number_of_days'].toString()== 'null' ? '': json['number_of_days'].toString();
    status = json['leave_status'].toString() == 'null' ? '': json['leave_status'];
    leaveDescription = json['leave_description'].toString() == 'null' ? 'N/A': json['leave_description'];
    leaveDocument = json['leave_document'].toString() == 'null' ? 'N/A': json['leave_document'];


     var id = json['id'].toString() == 'null' ? 0: json['id'];
     var sts= json['status'].toString();

     var description=json['description'].toString();
     var document =json['document'].toString();
    //
     leaveId= leaveId != 0 ? leaveId : id;
     status = sts == 'null' ? status : sts;
     leaveDescription= description=='null' ? leaveDescription : description;
     leaveDocument = document=='null' ? leaveDocument : document;


    // leaveName = json['LeaveName'];
    // leaveType = json['LeaveType'];
    // halfLeaveType = json['HalfLeaveType'];
    //
    // totalDays = json['TotalDays'];
    // leavePurpose = json['LeavePurpose'];
    // status = json['Status'];
    // sVRmk = json['SVRmk'];
    // mGRmk = json['MGRmk'];
    // hODRmk = json['HODRmk'];
    // hRRmk = json['HRRmk'];
    // sVSts = json['SVSts'];
    // mGSts = json['MGSts'];
    // hODSts = json['HODSts'];
    // hRSts = json['HRSts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['LeaveId'] = this.leaveId;
    data['LeaveName'] = this.leaveName;
    data['LeaveType'] = this.leaveType;
    data['HalfLeaveType'] = this.halfLeaveType;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['TotalDays'] = this.totalDays;
    data['LeavePurpose'] = this.leavePurpose;
    data['Status'] = this.status;
    data['SVRmk'] = this.sVRmk;
    data['MGRmk'] = this.mGRmk;
    data['HODRmk'] = this.hODRmk;
    data['HRRmk'] = this.hRRmk;
    data['SVSts'] = this.sVSts;
    data['MGSts'] = this.mGSts;
    data['HODSts'] = this.hODSts;
    data['HRSts'] = this.hRSts;
    return data;
  }
}

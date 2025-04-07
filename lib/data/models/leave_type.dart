class LeaveTypeList {
  List<LeaveType> leaveTypes;

  LeaveTypeList({this.leaveTypes});

  LeaveTypeList.fromJson(Map<String, dynamic> json) {
    if (json['leaveTypeList'] != null && json['leaveTypeList'] is List) {
      leaveTypes = <LeaveType>[];
      json['leaveTypeList'].forEach((v) {
        leaveTypes.add(LeaveType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.leaveTypes != null) {
      data['leaveTypeList'] = this.leaveTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveType {
  String id;
  String name;

  LeaveType(
      {this.name,this.id});

  LeaveType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class LetterList {
  var letterList = <Letter>[];

  LetterList({this.letterList});

  LetterList.fromJson(Map<String, dynamic> json) {
    if (json['letterList'] != null) {
      letterList = <Letter>[];
      json['letterList'].forEach((v) {
        letterList.add(Letter.fromJson(v));
      });
    }
  }
}


class Letter {
  int id;
  String requisitionType;
  String reason;
  String supervisor;
  String requisitionDate;
  String applicationStatus;

  Letter(
      {this.id,
        this.requisitionType,
        this.reason,
        this.supervisor,
        this.requisitionDate,
        this.applicationStatus});

  Letter.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    requisitionType = json['requisition_type']??'';
    reason = json['reason']??'';
    supervisor = json['supervisor']??'';
    requisitionDate = json['requisition_date']??'N/A';
    applicationStatus = json['application_status']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requisition_type'] = this.requisitionType;
    data['reason'] = this.reason;
    data['supervisor'] = this.supervisor;
    data['requisition_date'] = this.requisitionDate;
    data['application_status'] = this.applicationStatus;
    return data;
  }
}

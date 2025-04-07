class IdCardList {
  var idCardList = <IdCard>[];

  IdCardList({this.idCardList});

  IdCardList.fromJson(Map<String, dynamic> json) {
    if (json['idCardList'] != null) {
      idCardList = <IdCard>[];
      json['idCardList'].forEach((v) {
        idCardList.add(IdCard.fromJson(v));
      });
    }
  }
}


class IdCard {
  int id;
  String bloodGroup;
  String reason;
  String supervisor;
  String requisitionDate;
  String requiredStatus;
  String applicationStatus;

  IdCard(
      {this.id,
        this.bloodGroup,
        this.reason,
        this.supervisor,
        this.requisitionDate,
        this.requiredStatus,
        this.applicationStatus});

  IdCard.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    bloodGroup = json['blood_group']??'';
    reason = json['reason']??'';
    supervisor = json['supervisor']??'';
    requisitionDate = json['requisition_date']??'N/A';
    requiredStatus = json['required_status']??'';
    applicationStatus = json['application_status']??'';
  }
}
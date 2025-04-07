class VisitingCardList {
  var visitingCardList = <VisitingCard>[];

  VisitingCardList({this.visitingCardList});

  VisitingCardList.fromJson(Map<String, dynamic> json) {
    if (json['visitingCardList'] != null) {
      visitingCardList = <VisitingCard>[];
      json['visitingCardList'].forEach((v) {
        visitingCardList.add(VisitingCard.fromJson(v));
      });
    }
  }
}


class VisitingCard {
  int id;
  String shortName;
  String officialEmail;
  String officialContact;
  String officialAddress;
  String businessHead;
  String requisitionDate;
  String requiredStatus;
  int quantity;
  String applicationStatus;

  VisitingCard(
      {this.id,
        this.shortName,
        this.officialEmail,
        this.officialContact,
        this.officialAddress,
        this.businessHead,
        this.requisitionDate,
        this.requiredStatus,
        this.quantity,
        this.applicationStatus});

  VisitingCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortName = json['short_name']??'';
    officialEmail = json['official_email']??'';
    officialContact = json['official_contact']??'';
    officialAddress = json['official_address']??'';
    businessHead = json['business_head']??'';
    requisitionDate = json['requisition_date']??'';
    requiredStatus = json['required_status']??'';
    quantity = json['quantity'] ?? 0;
    applicationStatus = json['application_status']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['short_name'] = this.shortName;
    data['official_email'] = this.officialEmail;
    data['official_contact'] = this.officialContact;
    data['official_address'] = this.officialAddress;
    data['business_head'] = this.businessHead;
    data['requisition_date'] = this.requisitionDate;
    data['required_status'] = this.requiredStatus;
    data['quantity'] = this.quantity;
    data['application_status'] = this.applicationStatus;
    return data;
  }
}
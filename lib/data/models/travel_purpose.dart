class TravelPurposeList {
  List<TravelPurpose> travelPurpose;

  TravelPurposeList({this.travelPurpose});

  TravelPurposeList.fromJson(Map<String, dynamic> json) {
    if (json['travelPurpose'] != null) {
      travelPurpose = <TravelPurpose>[];
      json['travelPurpose'].forEach((v) {
        travelPurpose.add(new TravelPurpose.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.travelPurpose != null) {
      data['travelPurpose'] = this.travelPurpose.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TravelPurpose {
  int id;
  String travelType;
  String purpose;

  TravelPurpose({this.id, this.travelType, this.purpose});

  TravelPurpose.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    travelType = json['travel_type'];
    purpose = json['purpose'].toString().trim();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['travel_type'] = this.travelType;
    data['purpose'] = this.purpose;
    return data;
  }
}
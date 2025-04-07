class TravelTypeList {
  List<TravelType> travelType;

  TravelTypeList({this.travelType});

  TravelTypeList.fromJson(Map<String, dynamic> json) {
    if (json['travelTypeList'] != null && json['travelTypeList'] is List) {
      travelType = <TravelType>[];
      json['travelTypeList'].forEach((v) {
        travelType.add(TravelType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.travelType != null) {
      data['travelTypeList'] = this.travelType.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TravelType {
  String id;
  String name;
  String value;

  TravelType(
      {this.name,this.id,this.value});

  TravelType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

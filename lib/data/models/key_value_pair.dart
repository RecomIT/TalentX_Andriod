class KeyValuePairList {
  List<KeyValuePair> keyValuePair;

  KeyValuePairList({this.keyValuePair});

  KeyValuePairList.fromJson(Map<String, dynamic> json) {
    if (json['keyValuePairList'] != null && json['keyValuePairList'] is List) {
      keyValuePair = <KeyValuePair>[];
      json['keyValuePairList'].forEach((v) {
        keyValuePair.add(KeyValuePair.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.keyValuePair != null) {
      data['keyValuePairList'] = this.keyValuePair.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KeyValuePair {
  String id;
  String name;

  KeyValuePair(
      {this.name,this.id});

  KeyValuePair.fromJson(Map<String, dynamic> json) {
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

class IdNamePairList {
  List<IdNamePair> idNamePairList;

  IdNamePairList({this.idNamePairList});

  IdNamePairList.fromJson(Map<String, dynamic> json) {
    if (json['idNamePairList'] != null && json['idNamePairList'] is List) {
      idNamePairList = <IdNamePair>[];
      json['idNamePairList'].forEach((v) {
        idNamePairList.add(IdNamePair.fromJson(v));
      });
    }
  }
}

class IdNamePair {
  int id;
  String name;

  IdNamePair({this.id, this.name});

  IdNamePair.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    name = json['name']??'N/A';
  }

}

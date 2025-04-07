class PolicyData {
  List<Policy> policy;

  PolicyData({this.policy});

  PolicyData.fromJson(Map<String, dynamic> json) {
    if (json['policy'] != null) {
      policy = <Policy>[];
      json['policy'].forEach((v) {
        policy.add(new Policy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.policy != null) {
      data['policy'] = this.policy.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




class Policy {
  int id;
  String name;
  Null businessUnitId;
  Null note;
  String fileName;
  int displayOrder;
  int createdBy;
  Null updatedBy;
  Null deletedAt;
  String createdAt;
  String updatedAt;

  Policy(
      {this.id,
        this.name,
        this.businessUnitId,
        this.note,
        this.fileName,
        this.displayOrder,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Policy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    businessUnitId = json['business_unit_id'];
    note = json['note'];
    fileName = json['file_name'];
    displayOrder = json['display_order'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['business_unit_id'] = this.businessUnitId;
    data['note'] = this.note;
    data['file_name'] = this.fileName;
    data['display_order'] = this.displayOrder;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

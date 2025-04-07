import 'key_value_pair.dart';

class BusinessUnitWiseCostCenter {
  List<KeyValuePair> businessUnitWiseCostCenter=<KeyValuePair>[];

  BusinessUnitWiseCostCenter({this.businessUnitWiseCostCenter});

  BusinessUnitWiseCostCenter.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      businessUnitWiseCostCenter.add(KeyValuePair(id: key.trim(),name: value.trim() ));
    });
  }
}
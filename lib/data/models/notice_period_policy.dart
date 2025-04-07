import 'key_value_pair.dart';

class NoticePeriodPolicy {
  List<KeyValuePair> policyList=<KeyValuePair>[];

  NoticePeriodPolicy({this.policyList});

  NoticePeriodPolicy.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      policyList.add(KeyValuePair(id: key.trim(),name: value.trim() ));
    });
  }
}
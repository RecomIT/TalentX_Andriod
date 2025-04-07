import 'key_value_pair.dart';

class WorkFromHomeReason {
  List<KeyValuePair> workFromHomeReasonList=<KeyValuePair>[];

  WorkFromHomeReason({this.workFromHomeReasonList});

  WorkFromHomeReason.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      workFromHomeReasonList.add(KeyValuePair(id: key.trim(),name: value.trim() ));
    });
  }
}
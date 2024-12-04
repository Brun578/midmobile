import 'dart:convert';

String getPrettyJSONString(jsonObject) {
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String jsonString = encoder.convert(jsonObject);
  return jsonString;
}

import 'package:json_annotation/json_annotation.dart';

const unixDateTime = _SecondsDateTimeConverter();

class _SecondsDateTimeConverter extends JsonConverter<DateTime, int> {
  const _SecondsDateTimeConverter();

  @override
  DateTime fromJson(int json) {
    return DateTime.fromMillisecondsSinceEpoch(json * 1000);
  }

  @override
  int toJson(DateTime object) {
    return object.millisecondsSinceEpoch ~/ 1000;
  }
}

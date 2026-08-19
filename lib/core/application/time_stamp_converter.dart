import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimeStampConverter implements JsonConverter<DateTime, Object> {
  const TimeStampConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);

    return DateTime.now();
  }

  @override
  Object toJson(DateTime date) => Timestamp.fromDate(date);
}

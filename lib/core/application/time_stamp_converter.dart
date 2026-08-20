import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loggy/loggy.dart';

class TimeStampConverter
    with UiLoggy
    implements JsonConverter<DateTime, Object> {
  const TimeStampConverter();

  @override
  DateTime fromJson(Object json) {
    loggy.debug('attempting to convert');
    if (json is Timestamp) {
      loggy.debug('timestamp date');
      final when = json.toDate();
      return when;
    }
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);

    return DateTime.now();
  }

  @override
  Object toJson(DateTime date) => date.toIso8601String();
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences.freezed.dart';
part 'preferences.g.dart';

@freezed
abstract class Preferences with _$Preferences {
  const factory Preferences({
    required String handle,
    required showIntro,
    required bool useDarkMode,
  }) = _Preferences;

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences.freezed.dart';

@freezed
abstract class Preferences with _$Preferences {
  // const Preferences._();

  const factory Preferences({
    required String handle,
    required showIntro,
    required bool useDarkMode,
  }) = _Preferences;
}

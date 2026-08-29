import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/core/application/user_handle_notifier.dart';
import 'package:tab_settle/core/preferences.dart';

part 'preference_notifier.g.dart';

@riverpod
class PreferenceNotifier extends _$PreferenceNotifier with UiLoggy {
  final _key = 'com.mcdona22.tab_settle.preferences';

  @override
  Preferences build() {
    loggy.info('creating the user preference object');
    final String fakeName =
        '${faker.person.firstName()} the ${faker.animal.name()}';
    final defaultPreferences = Preferences(
      handle: fakeName,
      showIntro: true,
      useDarkMode: true,
    );

    final prefs = ref.read(sharedPreferencesProvider);
    final rawJson = prefs.getString(_key);

    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        loggy.debug('preferences found', rawJson);
        return Preferences.fromJson(jsonDecode(rawJson));
      } catch (e) {
        loggy.error(
          'Something not right with the json.  Using defaults',
          rawJson,
        );
        _writePreferences(defaultPreferences, assignState: false);
        return defaultPreferences;
      }
    } else {
      loggy.debug('No preferences saved - using defaults');
      _writePreferences(defaultPreferences, assignState: false);
      return defaultPreferences;
    }
  }

  void toggleDarkMode() =>
      _writePreferences(state.copyWith(useDarkMode: !state.useDarkMode));

  void toggleShowIntroScreens() =>
      _writePreferences(state.copyWith(showIntro: !state.showIntro));

  void setHandle(String handle) {
    if (handle.trim().isEmpty) loggy.debug('Not saving empty handle');

    _writePreferences(state.copyWith(handle: handle));
  }

  void _writePreferences(Preferences preference, {bool assignState = true}) {
    loggy.debug('writing preferences', preference);
    if (assignState) state = preference;
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_key, jsonEncode(preference.toJson()));
  }
}

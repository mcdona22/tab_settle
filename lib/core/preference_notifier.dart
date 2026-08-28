import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/core/preferences.dart';

part 'preference_notifier.g.dart';

@riverpod
class PreferenceNotifier extends _$PreferenceNotifier with UiLoggy {
  @override
  Preferences build() =>
      Preferences(handle: 'JRM', showIntro: false, useDarkMode: true);

  void toggleDarkMode() =>
      state = state.copyWith(useDarkMode: !state.useDarkMode);

  void toggleShowIntroScreens() =>
      state = state.copyWith(showIntro: !state.showIntro);
}

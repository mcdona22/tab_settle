import 'package:faker/faker.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_handle_notifier.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main',
  );
}

@Riverpod(keepAlive: true)
class UserHandleNotifier extends _$UserHandleNotifier with UiLoggy {
  final _key = 'com.mcdona22.tab_settle.user_handle';

  @override
  FutureOr<String> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    if (!prefs.containsKey(_key)) {
      final faker = Faker();
      final createdName =
          '${faker.person.firstName()} the ${faker.animal.name()}';
      prefs.setString(_key, createdName);
    }
    final foundHandle = prefs.getString(_key) ?? 'Set your name';
    loggy.debug('retrieved handle of "$foundHandle"');

    return foundHandle;
  }

  void setHandle(String newHandle) {
    final handle = newHandle.trim();
    loggy.debug('Setting the handle "$newHandle" to preferences');
    if (handle.isEmpty) return;

    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_key, handle);
    state = AsyncData(handle);
  }
}

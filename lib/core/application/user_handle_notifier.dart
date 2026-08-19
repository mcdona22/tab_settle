import 'package:faker/faker.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_handle_notifier.g.dart';

// @Riverpod(keepAlive: true)
// Future<SharedPreferences> sharedPreferences(_) async =>
//     await SharedPreferences.getInstance();

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main',
  );
}

@Riverpod(keepAlive: true)
class UserHandleNotifier extends _$UserHandleNotifier with UiLoggy {
  final _handleKey = 'com.mcdona22.tab_settle.user_handle';

  @override
  FutureOr<String> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    if (!prefs.containsKey(_handleKey)) {
      final faker = Faker();
      final createdName =
          '${faker.person.firstName()} the ${faker.animal.name()}';
      prefs.setString(_handleKey, createdName);
    }
    final foundHandle = prefs.getString(_handleKey) ?? 'Set your name';
    loggy.debug('retrieved handle of "$foundHandle"');

    return foundHandle;
  }

  void setHandle(String newHandle) {
    final handle = newHandle.trim();
    loggy.debug('Setting the handle "$newHandle" to preferences');
    if (handle.isEmpty) return;

    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_handleKey, handle);
    state = AsyncData(handle);
  }
}

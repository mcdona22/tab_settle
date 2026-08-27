import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_settle/core/application/user_handle_notifier.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/core/theme/themes.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(logPrinter: const PrettyDeveloperPrinter());

  logDebug('Firebase init...');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logDebug('Firebase init... done');

  await dotenv.load(fileName: ".env");

  logInfo('🚀 Launching Tab Settle');

  logInfo('Create Provider Container');
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  container.read(userHandleProvider);

  runApp(UncontrolledProviderScope(container: container, child: const App()));

  logInfo('🥳 Tab Settle up and running');
}

class App extends HookConsumerWidget with UiLoggy {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      config: const ToastificationConfig(),
      child: MaterialApp.router(
        debugShowMaterialGrid: false,
        title: 'Tab Settle',
        debugShowCheckedModeBanner: true,
        routerConfig: routerConfig,
        theme: ThemeData.from(colorScheme: lightColorScheme),
        darkTheme: ThemeData.from(colorScheme: darkColorScheme),
        themeMode: ThemeMode.light,
        // builder: (_, child) => Scaffold(
        //   body: MobileFirstContainer(child: child ?? SizedBox.shrink()),
        // ),
      ),
    );
  }
}

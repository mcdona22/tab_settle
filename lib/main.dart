import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutter_web_plugins/url_strategy.dart'; // Import this
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_settle/app_config.dart';
import 'package:tab_settle/core/preference_notifier.dart';
import 'package:tab_settle/core/providers/camera_availability_provider.dart';
import 'package:tab_settle/core/providers/shared_preferences_provider.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/core/theme/themes.dart';
import 'package:toastification/toastification.dart';

import 'core/web_cache_stub.dart';
import 'firebase_options.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  killServiceWorkers();

  Loggy.initLoggy(logPrinter: const PrettyDeveloperPrinter());
  usePathUrlStrategy();
  logDebug('Firebase init...');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logDebug('Firebase init... done');

  await dotenv.load(fileName: ".env");

  logInfo('🚀 Launching ${AppConfig.appTitle}');

  logInfo('Create Provider Container');
  bool hasCamera = false;
  try {
    final cameras = await availableCameras();
    hasCamera = cameras.isNotEmpty;
    logDebug('Camera availability: $hasCamera');
  } catch (e) {
    logDebug('No camera available on platform: $e');
  }

  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      hasCameraProvider.overrideWithValue(hasCamera),
    ],
  );
  container.read(sharedPreferencesProvider);

  runApp(UncontrolledProviderScope(container: container, child: const App()));

  logInfo('🥳 ${AppConfig.appTitle} up and running');
}

class App extends HookConsumerWidget with UiLoggy {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      config: const ToastificationConfig(),
      child: MaterialApp.router(
        debugShowMaterialGrid: false,
        title: AppConfig.appTitle,
        debugShowCheckedModeBanner: true,
        routerConfig: routerConfig,
        theme: ThemeData.from(colorScheme: lightColorScheme),
        darkTheme: ThemeData.from(colorScheme: darkColorScheme),
        themeMode: ref.watch(preferenceProvider).useDarkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        themeAnimationDuration: Duration(milliseconds: 750),
        // builder: (_, child) => Scaffold(
        //   body: MobileFirstContainer(child: child ?? SizedBox.shrink()),
        // ),
      ),
    );
  }
}

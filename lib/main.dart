import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/core/theme/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  Loggy.initLoggy(logPrinter: const PrettyDeveloperPrinter());

  logInfo('🚀 Launching Tab Settle');

  logInfo('Create Provider Container');
  final container = ProviderContainer(overrides: []);

  runApp(UncontrolledProviderScope(container: container, child: const App()));

  logInfo('🥳 Tab Settle up and running');
}

class App extends HookConsumerWidget with UiLoggy {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowMaterialGrid: false,
      title: 'Tab Settle',
      debugShowCheckedModeBanner: true,
      routerConfig: routerConfig,
      theme: ThemeData.from(colorScheme: lightColorScheme),
      darkTheme: ThemeData.from(colorScheme: darkColorScheme),
      themeMode: ThemeMode.dark,
    );
  }
}

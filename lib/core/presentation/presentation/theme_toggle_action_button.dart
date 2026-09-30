import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/preference_notifier.dart';

class ThemeToggleActionButton extends HookConsumerWidget with UiLoggy {
  const ThemeToggleActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferenceProvider);
    final icon = Icon(
      preferences.useDarkMode ? Icons.light_mode : Icons.dark_mode,
    );
    return IconButton(
      onPressed: () {
        ref.read(preferenceProvider.notifier).toggleDarkMode();
      },
      icon: icon,
    );
  }
}

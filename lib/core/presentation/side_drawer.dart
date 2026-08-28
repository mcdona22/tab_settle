import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/preference_notifier.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/widgets/user_handle.dart';

class SideDrawer extends HookConsumerWidget with UiLoggy {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Drawer(
      elevation: 2.0,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: theme.colorScheme.surfaceContainerHigh,
              ),
              height: 190.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Settings',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    UserHandle(),
                    TextButton.icon(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      label: Text('Close'),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  DrawerItemWrapper(child: ToggleIntroScreensControl()),
                  DrawerItemWrapper(child: ToggleThemeMode()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleIntroScreensControl extends HookConsumerWidget with UiLoggy {
  const ToggleIntroScreensControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferenceProvider);

    return Row(
      spacing: 12.0,
      children: [
        Switch(
          value: preferences.showIntro,
          onChanged: (_) =>
              ref.read(preferenceProvider.notifier).toggleShowIntroScreens(),
        ),
        Text('Show Intro Screens'),
      ],
    );
  }
}

class ToggleThemeMode extends HookConsumerWidget with UiLoggy {
  const ToggleThemeMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferenceProvider);
    return Row(
      spacing: 12.0,
      children: [
        Switch(
          value: preferences.useDarkMode,
          onChanged: (_) =>
              ref.read(preferenceProvider.notifier).toggleDarkMode(),
        ),
        Text('Use Dark Theme'),
      ],
    );
  }
}

class DrawerItemWrapper extends StatelessWidget {
  const DrawerItemWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: child,
    );
  }
}

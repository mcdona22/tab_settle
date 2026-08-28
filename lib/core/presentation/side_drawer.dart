import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
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
                  Column(
                    children: List.generate(
                      30,
                      (i) => ListTile(
                        leading: Text('$i'),
                        title: Text('Menu Item $i'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

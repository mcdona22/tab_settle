import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/centred_constrained_widget.dart';

import '../../core/routing/router.dart';

class HomePage extends HookConsumerWidget with UiLoggy {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loggy.info('Rendering HomePage baseline');

    return Scaffold(
      appBar: AppBar(title: const Text('Tab Settle'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0),
        child: CentredConstrainedWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 28.0,
            children: [
              Icon(
                Icons.rocket_launch_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                'Welcome to Tab Settle',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              ActionButton(
                label: 'Toby Carvery',
                onPressed: () => context.pushNamed(
                  AppRoute.addReceipt.name,
                  pathParameters: {'path': 'toby.jpeg'},
                ),
              ),
              ActionButton(
                label: 'Sapore Italian',
                onPressed: () => context.pushNamed(
                  AppRoute.addReceipt.name,
                  pathParameters: {'path': 'sapore.jpeg'},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

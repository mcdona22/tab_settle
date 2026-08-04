import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/features/bill_analyse/data/text_receipts.dart';
import 'package:tab_settle/features/bill_analyse/service/gemini_service.dart';
import 'package:tab_settle/features/bill_analyse/service/generative_model_provider.dart';

import '../../core/routing/router.dart';

class HomePage extends HookConsumerWidget with UiLoggy {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(geminiServiceProvider); // warms up the service
    final models = ref.watch(geminiServiceProvider);
    final Future<List<dynamic>> modelsData = models.listAvailableModels(
      ref.watch(geminiApiKeyProvider),
    );
    loggy.info('Rendering HomePage baseline');
    final apiKey = ref.watch(geminiApiKeyProvider);
    // final json = ref.watch(geminiServiceProvider).listAvailableModels(apiKey);

    // loggy.debug('Available models: $json');

    return Scaffold(
      appBar: AppBar(title: const Text('Tab Settle'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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

            ...List.generate(mockReceipts.length, (i) {
              final receipt = mockReceipts[i];
              return ActionButton(
                label: receipt['name'] ?? 'Not found',
                onPressed: () => context.pushNamed(
                  AppRoute.addReceipt.name,
                  extra: receipt['receipt'] ?? '',
                ),
              );
            }),
            Text('Models'),
            FutureBuilder(
              future: modelsData,
              builder: (_, snapshot) {
                return snapshot.hasData
                    ? Wrap(
                        spacing: 13.0,
                        runSpacing: 13.0,

                        children: List.generate(snapshot.data!.length, (i) {
                          return Container(
                            padding: EdgeInsetsGeometry.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            child: Text(snapshot.data![i]),
                          );
                        }),
                      )
                    : CircularProgressIndicator();
              },

              //   return Wrap(
              //     children: snapshot.hasData
              //         // ? List.generate(snapshot.data!.length, (i) {
              //         ? List.generate(snapshot.data!.length, (i) {
              //             return Text(snapshot.data![i]);
              //           })
              //         : [Text('No Models')],
              //   );
              // },
            ),
          ],
        ),
      ),
    );
  }
}

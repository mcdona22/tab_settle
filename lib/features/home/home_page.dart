import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/bill_analyse/data/text_receipts.dart';
import 'package:tab_settle/features/home/image_card.dart';

final cards = [
  {
    'filename': 'scan.webp',
    'title': 'Scan Receipt',
    'description':
        'Take a '
        'pic of the receipt and let me break it down for you',
  },
  {
    'filename': 'check.webp',
    'title': 'Check and Correct',
    'description':
        "i'm usually pretty good at this but check "
        'that its right and correct if required',
  },
  {
    'filename': 'share-bill.webp',
    'title': 'Share the Items',
    'description':
        'Share  it with '
        'your friends to claim their items',
  },
];

class HomePage extends HookConsumerWidget with UiLoggy {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.read(geminiServiceProvider); // warms up the service
    // final models = ref.watch(geminiServiceProvider);
    // final Future<List<dynamic>> modelsData = models.listAvailableModels(
    //   ref.watch(geminiApiKeyProvider),
    // );
    final carouselController = useCarouselController();
    final currentPage = useState(0);
    final stepsCount = cards.length;

    useEffect(() {
      final timer = Timer.periodic(const Duration(milliseconds: 3000), (_) {
        if (!carouselController.hasClients) return;
        final nextIndex = (currentPage.value + 1) % stepsCount;
        currentPage.value = nextIndex;
        carouselController.animateToItem(
          nextIndex,
          duration: const Duration(milliseconds: 1500),
        );
      });

      return () => timer.cancel();
    }, [carouselController, stepsCount]);

    final cardHeight = 450.0;

    // final json = ref.watch(geminiServiceProvider).listAvailableModels(apiKey);

    // loggy.debug('Available models: $json');
    final theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(title: const Text('Tab Settle'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 28.0,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'Tab Settle',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Colors.white, // Color must be white for ShaderMask
                    ),
                  ),
                ),
              ),
              // Icon(
              //   Icons.rocket_launch_rounded,
              //   size: 64,
              //   color: Theme.of(context).colorScheme.primary,
              // ),
              // Text(
              //   'Welcome to Tab Settle',
              //   style: Theme.of(context).textTheme.headlineSmall,
              // ),
              SizedBox(
                height: cardHeight,
                child: CarouselView(
                  controller: carouselController,
                  itemExtent: MediaQuery.of(context).size.width * .85,
                  shrinkExtent: MediaQuery.of(context).size.width * 0.7,
                  children: cards
                      .map(
                        (card) => ImageCard(
                          title: card['title']!,
                          imageName: card['filename']!,
                          description: card['description']!,
                        ),
                      )
                      .toList(),
                ),
              ),

              ...List.generate(imageAssetReceipts.length, (i) {
                final path = imageAssetReceipts[i]['path'];
                final label = imageAssetReceipts[i]['name'];
                return ActionButton(
                  label: label!,
                  onPressed: () {
                    loggy.debug('Receipt $path');
                    context.pushNamed(AppRoute.addReceipt.name, extra: path);
                  },
                );
              }),
              // if (false)
              //   ...List.generate(mockReceipts.length, (i) {
              //     final receipt = mockReceipts[i];
              //     return ActionButton(
              //       label: receipt['name'] ?? 'Not found',
              //       onPressed: () => context.pushNamed(
              //         AppRoute.addReceipt.name,
              //         extra: receipt['receipt'] ?? '',
              //       ),
              //     );
              //   }),
              // if (false) Text('Models'),
              // if (false)
              //   FutureBuilder(
              //     future: modelsData,
              //     builder: (_, snapshot) {
              //       return snapshot.hasData
              //           ? Padding(
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 30.0,
              //               ),
              //               child: Wrap(
              //                 spacing: 13.0,
              //                 runSpacing: 13.0,
              //
              //                 children: List.generate(snapshot.data!.length, (
              //                   i,
              //                 ) {
              //                   final sorted = snapshot.data!.sort();
              //                   return Container(
              //                     padding: EdgeInsetsGeometry.all(12.0),
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(18.0),
              //                       border: Border.all(
              //                         color: Theme.of(
              //                           context,
              //                         ).colorScheme.onSurface,
              //                       ),
              //                     ),
              //                     child: Text(snapshot.data![i]),
              //                   );
              //                 }),
              //               ),
              //             )
              //           : CircularProgressIndicator();
              //     },

              //   return Wrap(
              //     children: snapshot.hasData
              //         // ? List.generate(snapshot.data!.length, (i) {
              //         ? List.generate(snapshot.data!.length, (i) {
              //             return Text(snapshot.data![i]);
              //           })
              //         : [Text('No Models')],
              //   );
              // },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  CarouselController useCarouselController({
    int initialItem = 0,
    List<Object>? keys,
  }) {
    final controller = useMemoized(
      () => CarouselController(initialItem: initialItem),
      keys ?? [],
    );

    useEffect(() {
      return () => controller.dispose();
    }, [controller]);

    return controller;
  }
}

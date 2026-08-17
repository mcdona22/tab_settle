import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
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
          curve: Curves.easeInOutQuad,
          nextIndex,
          duration: const Duration(milliseconds: 1000),
        );
      });

      return () => timer.cancel();
    }, [carouselController, stepsCount]);

    final cardHeight = 450.0;

    final theme = Theme.of(context);
    final slogans = ['No sign up', 'No sign in', 'No installation', 'No fuss'];
    return Scaffold(
      appBar: createAppBar(context, ScreenTitle(label: 'Tab Settle')),
      // appBar: AppBar(title: const Text('Tab Settle'), centerTitle: true),
      body: SafeArea(
        child: MobileFirstContainer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 28.0,
              children: [
                Wrap(
                  spacing: 12.0,
                  runSpacing: 18.0,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    slogans.length,
                    (i) => Slogan(
                      children: [
                        Icon(Icons.check, color: theme.colorScheme.primary),
                        Text(slogans[i]),
                      ],
                    ),
                  ),
                ),
                ActionButton(
                  label: 'Lets Start',
                  onPressed: () => context.pushNamed(AppRoute.addReceipt.name),
                ),
                SizedBox(
                  height: cardHeight,
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      final parentWidth = constraints.maxWidth;
                      return CarouselView(
                        controller: carouselController,
                        itemExtent: parentWidth * .95,
                        shrinkExtent: parentWidth * 0.8,
                        children: cards
                            .map(
                              (card) => ImageCard(
                                title: card['title']!,
                                imageName: card['filename']!,
                                description: card['description']!,
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
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

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ShaderMask(
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
        label,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Colors.white, // Color must be white for ShaderMask
        ),
      ),
    );
  }
}

class Slogan extends StatelessWidget {
  const Slogan({this.children = const [], super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: null,
      // decoration: correctionOutline(context),
      child: Row(
        spacing: 4.0,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

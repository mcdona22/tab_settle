import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/app_config.dart';
import 'package:tab_settle/core/extensions/hardcoded.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/side_drawer.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/home/receipt_capture_controller.dart';
import 'package:tab_settle/features/home/receipt_capture_view.dart';
import 'package:tab_settle/features/receipt_history/data/historical_receipt_list.dart';

class HomePage extends HookConsumerWidget with UiLoggy {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptCaptureController = ref.watch(
      receiptCaptureControllerProvider,
    );

    ref.listen(receiptCaptureControllerProvider, (prev, next) {
      next.whenData((xFile) {
        loggy.debug('The file has changed: ${xFile?.name ?? "Its empty"}');
        if (xFile != null) {
          context.pushNamed(AppRoute.reviewReceipt.name, extra: xFile);
        }
      });
    });

    final slogans = ['No sign up', 'No sign in', 'No installation', 'No fuss'];
    return Scaffold(
      appBar: createAppBar(
        context,
        ScreenTitle(label: 'Welcome to ${AppConfig.appTitle}'),
        // actions: [ThemeToggleActionButton()],
      ),
      endDrawer: SideDrawer(),
      body: SafeArea(
        child: MobileFirstContainer(
          child: Column(
            spacing: 12.0.hardcoded,

            children: [
              _SloganWrap(slogans: slogans),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 180.0,
                        child: Image.asset(
                          'assets/graphics/splash-cool.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _PinnedTitleHeaderDelegate(
                        title: 'Recent Receipts',
                        height: 48.0,
                      ),
                    ),
                    SliverToBoxAdapter(child: HistoricalReceiptList()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AsyncValueWidget<XFile?>(
                  value: receiptCaptureController,
                  data: (_) => ReceiptCaptureView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SloganWrap extends StatelessWidget {
  const _SloganWrap({super.key, required this.slogans});

  final List<String> slogans;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 18.0,
      alignment: WrapAlignment.center,
      children: List.generate(
        slogans.length,
        (i) => _Slogan(
          children: [
            Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
            Text(slogans[i]),
          ],
        ),
      ),
    );
  }
}

class _Slogan extends StatelessWidget {
  const _Slogan({this.children = const [], super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.0,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class _PinnedTitleHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;

  _PinnedTitleHeaderDelegate({required this.title, this.height = 48.0});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      color: theme.colorScheme.surface,
      // Background prevents scrolled content from showing through
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _PinnedTitleHeaderDelegate oldDelegate) {
    return title != oldDelegate.title || height != oldDelegate.height;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/intro_screens/intro_page_view.dart';

import 'page_definition.dart';

class IntroductoryPage extends HookConsumerWidget with UiLoggy {
  const IntroductoryPage({required this.receiptId, super.key});

  final String receiptId;

  static const initialPage = 0;
  static const dotSize = 8.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = usePageController(
      initialPage: initialPage,
      // viewportFraction: 0.75,
    );
    final currentPage = useState(initialPage);
    final colorScheme = Theme.of(context).colorScheme;

    List<IntroPageView> pageList = _createPageList(controller);
    loggy.debug('Current Page: ${currentPage.value}');

    void back() => controller.animateToPage(
      currentPage.value - 1,
      duration: Duration(milliseconds: 450),
      curve: Curves.decelerate,
    );

    void forward() => controller.animateToPage(
      currentPage.value + 1,
      duration: Duration(milliseconds: 450),
      curve: Curves.decelerate,
    );

    loggy.debug('intro receipt id is ${receiptId ?? "Not provided"}');
    return Scaffold(
      appBar: createAppBar(
        context,
        ScreenTitle(label: pages[currentPage.value].title ?? 'Welcome'),
        // ScreenTitle(label: 'Welcome'),
      ),
      body: MobileFirstContainer(
        padding: EdgeInsetsGeometry.all(0.0),
        child: Column(
          children: [
            SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: ExpandingDotsEffect(
                dotColor: colorScheme.onSurface,
                activeDotColor: colorScheme.onPrimaryFixedVariant,
                dotHeight: dotSize,
                dotWidth: dotSize,
                spacing: dotSize * 2,
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (index) => currentPage.value = index,
                children: pageList,
              ),
            ),

            // Divider(),
            Container(
              color: colorScheme.surface.withValues(alpha: 0.65),
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left, size: 40.0),
                    onPressed: currentPage.value == 0 ? null : back,
                  ),
                  ActionButton(
                    label: 'Skip',
                    onPressed: () => _navigate(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right, size: 40.0),
                    onPressed: currentPage.value == pages.length - 1
                        ? null
                        : forward,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<IntroPageView> _createPageList(PageController controller) {
    final pageList = pages
        .map(
          (page) => IntroPageView(
            assetImageFileName: page.filename,
            text: page.text,
            controller: controller,
          ),
        )
        .toList();
    return pageList;
  }

  void _navigate(BuildContext context) {
    receiptId.isEmpty
        ? context.goNamed(AppRoute.home.name)
        : context.goNamed(
            AppRoute.receiptDashboard.name,
            pathParameters: {'id': receiptId},
          );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/app_config.dart';
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
    final receiptCaptureController =
        ref.watch(receiptCaptureControllerProvider);

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
      ),
      endDrawer: SideDrawer(),
      body: SafeArea(
        child: MobileFirstContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 28.0,
            children: [
              _SloganWrap(slogans: slogans),
              Expanded(child: const HistoricalReceiptList()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AsyncValueWidget<XFile?>(
                    value: receiptCaptureController,
                    data: (_) => ReceiptCaptureView()),
              )
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/bill_submit/bill_submission_controller.dart';
import 'package:tab_settle/features/home/home_page.dart';

class BillSubmissionPage extends HookConsumerWidget with UiLoggy {
  const BillSubmissionPage({super.key});

  // final String receiptName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileNameState = ref.watch(billSubmissionControllerProvider);
    loggy.debug('Filename state: "${fileNameState.value}"');
    final qualifiedPathName = useState('');
    // final qualifiedPathName = 'assets/test_receipts/$receiptName';

    return Scaffold(
      appBar: createAppBar(context, ScreenTitle(label: 'Get The Receipt')),
      body: MobileFirstContainer(
        child: Column(
          spacing: kPaddingSmall,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AsyncValueWidget(
              value: fileNameState,
              data: (fileName) => fileName.isEmpty
                  ? SizedBox.shrink()
                  : Expanded(
                      child: SizedBox(
                        height: 400.0,
                        width: double.infinity,
                        child: InteractiveViewer(
                          minScale: 1.0,
                          maxScale: 5.0,
                          clipBehavior: Clip.hardEdge,
                          child: crossPlatformPathImage(fileName)!,
                        ),
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  label: 'Find the Receipt',
                  onPressed: () => ref
                      .read(billSubmissionControllerProvider.notifier)
                      .captureImageFromGallery(),
                ),
                if (fileNameState.value!.isNotEmpty)
                  ActionButton(
                    label: 'Next',
                    onPressed: () => context.pushNamed(
                      AppRoute.checkReceipt.name,
                      extra: fileNameState.value,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

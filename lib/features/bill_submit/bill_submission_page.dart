import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/bill_submit/bill_submission_controller.dart';

class BillSubmissionPage extends HookConsumerWidget with UiLoggy {
  const BillSubmissionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(billSubmissionControllerProvider);
    final fileName = useState('');

    return Scaffold(
      appBar: createAppBar(context, ScreenTitle(label: 'Get The Receipt')),
      body: MobileFirstContainer(
        child: Column(
          spacing: kPaddingSmall,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AsyncValueWidget(
                  value: controller,
                  data: (_) => ActionButton(
                    label: 'Find the Receipt',
                    onPressed: () async {
                      fileName.value =
                          await ref
                              .read(billSubmissionControllerProvider.notifier)
                              .captureImageFromGallery() ??
                          '';
                    },
                  ),
                ),
                if (fileName.value.isNotEmpty)
                  AsyncValueWidget(
                    value: controller,
                    data: (_) => ActionButton(
                      label: 'Next',
                      onPressed: () async {
                        loggy.debug('analysing');
                        final dto = ref
                            .read(billSubmissionControllerProvider.notifier)
                            .analyseImage(fileName.value);
                        loggy.debug(dto);
                      },
                    ),
                  ),
              ],
            ),
            if (fileName.value.isNotEmpty)
              Expanded(
                child: SizedBox(
                  height: 400.0,
                  width: double.infinity,
                  child: InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 4.0,
                    clipBehavior: Clip.hardEdge,
                    child: crossPlatformPathImage(fileName.value)!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

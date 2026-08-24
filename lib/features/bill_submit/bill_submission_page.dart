import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/bill_submit/bill_submission_controller.dart';

class BillSubmissionPage extends HookConsumerWidget with UiLoggy {
  const BillSubmissionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(billSubmissionControllerProvider);
    final fileName = useState('');
    final ValueNotifier<bool> bogusReceipt = useState(false);

    return Scaffold(
      appBar: createAppBar(context, ScreenTitle(label: 'Get The Receipt')),
      body: MobileFirstContainer(
        child: Column(
          spacing: kPaddingSmall,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AsyncValueWidget(
              value: controller,
              data: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionButton(
                    label: 'Find the Receipt',
                    onPressed: () async {
                      await _onCaptureImage(bogusReceipt, fileName, ref);
                    },
                  ),
                  if (fileName.value.isNotEmpty)
                    ActionButton(
                      label: 'Next',
                      onPressed: () => _onAnalyseReceipt(
                        context,
                        ref,
                        fileName.value,
                        bogusReceipt,
                      ),
                    ),
                ],
              ),
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

            if (bogusReceipt.value)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "I cant read any line items in this image - are you sure "
                    "its a receipt?",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCaptureImage(
    ValueNotifier<bool> bogusReceipt,
    ValueNotifier<String> fileName,
    WidgetRef ref,
  ) async {
    bogusReceipt.value = false;
    fileName.value =
        await ref
            .read(billSubmissionControllerProvider.notifier)
            .captureImageFromGallery() ??
        '';
  }

  Future<void> _onAnalyseReceipt(
    BuildContext context,
    WidgetRef ref,
    String path,
    ValueNotifier<bool> bogus,
  ) async {
    loggy.debug('Analysing receipt image');
    try {
      final dto = await ref
          .read(billSubmissionControllerProvider.notifier)
          .analyseImage(path);
      loggy.debug('dto is $dto');
      if (dto == null) {
        loggy.debug('null value for dto');
        return;
      }
      bogus.value = dto.isBogus;
      if (dto.isBogus) return;

      if (!context.mounted) return;
      context.pushNamed(AppRoute.checkReceipt.name, extra: dto);
    } catch (e, st) {
      loggy.error('failed to process image from $path');
      loggy.error(e, st);
    }
  }
}

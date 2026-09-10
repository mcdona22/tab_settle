import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/receipt_review/receipt_review_controller.dart';

final bogusText =
    "I've analysed this image and it has nothing I can "
    "recognise as a receipt.  Are you having  a little joke with me?";

class ReceiptReviewPage extends HookConsumerWidget with UiLoggy {
  final XFile receiptImage;

  const ReceiptReviewPage({required this.receiptImage, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(receiptReviewControllerProvider);
    final ValueNotifier<bool> bogusReceipt = useState(false);

    ref.listen(receiptReviewControllerProvider, (_, next) {
      next.whenData((dto) {
        loggy.debug('analysis complete');
        if (dto != null) {
          bogusReceipt.value = dto.isBogus;
          if (!dto.isBogus) {
            loggy.debug('Dto is good - navigate');
            context.pushNamed(AppRoute.checkReceipt.name, extra: dto);
          }
        }
      });
    });

    return Scaffold(
      appBar: createAppBar(context, ScreenTitle(label: 'Check The Receipt')),
      body: MobileFirstContainer(
        child: Column(
          spacing: kPaddingLarge,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AsyncValueWidget(
            //   value: controller,
            //   data: (_) => Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       ActionButton(
            //         label: 'Find the Receipt',
            //         onPressed: () async {
            //           await _onCaptureImage(bogusReceipt, xFile, ref);
            //         },
            //       ),
            //       if (xFile.value != null)
            //         ActionButton(
            //           label: 'Next',
            //           onPressed: () => _onAnalyseReceipt(
            //             context,
            //             ref,
            //             xFile.value!,
            //             bogusReceipt,
            //           ),
            //         ),
            //     ],
            //   ),
            // ),

            Expanded(
              flex: 3,
              child: SizedBox(
                height: 400.0,
                width: double.infinity,
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  clipBehavior: Clip.hardEdge,
                  child: crossPlatformPathImage(receiptImage)!,
                ),
              ),
            ),
            if (bogusReceipt.value)
              Expanded(
                flex: 1,
                child: Text(
                  bogusText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

            if (!bogusReceipt.value)
              AsyncValueWidget(
                value: controller,
                data: (_) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ActionButton(
                    label: 'Analyse',
                    onPressed: () => ref
                        .read(receiptReviewControllerProvider.notifier)
                        .analyseImage(receiptImage),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

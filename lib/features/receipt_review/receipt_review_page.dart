import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/custom_error_view.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/gemini_service/exceptions/gemini_exception.dart';
import 'package:tab_settle/features/receipt_review/receipt_review_controller.dart';

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
      body: Column(
        spacing: kPaddingLarge,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 400.0,
              width: double.infinity,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                // clipBehavior: Clip.hardEdge,
                child: crossPlatformPathImage(receiptImage, fit: BoxFit.cover)!,
              ),
            ),
          ),
          MobileFirstContainer(
            child: bogusReceipt.value
                ? BogusReceipt()
                : AsyncValueWidget(
                    value: controller,
                    data: (_) => analyseActionButton(ref),
                    error: (e, st) => AnalysisErrorView(
                      error: e,
                      actionButton: analyseActionButton(ref),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  ActionButton analyseActionButton(WidgetRef ref) {
    return ActionButton(
      label: 'Analyse',
      onPressed: () => ref
          .read(receiptReviewControllerProvider.notifier)
          .analyseImage(receiptImage),
    );
  }
}

class BogusReceipt extends HookConsumerWidget with UiLoggy {
  final bogusText =
      "I've analysed this image and it has nothing I can "
      "recognise as a receipt.\n\n  Are you having  a little joke with me?";

  const BogusReceipt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
      child: Text(
        bogusText,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class AnalysisErrorView extends StatelessWidget {
  const AnalysisErrorView({
    required this.error,
    required this.actionButton,
    super.key,
  });

  final Object error;
  final ActionButton actionButton;

  @override
  Widget build(BuildContext context) {
    Widget errorWidget;
    bool retry = false;
    if (error is GeminiException) {
      final ex = error as GeminiException;
      retry = ex.kind.isRetryable;
      final descriptionText =
          '${ex.kind.description} ${ex.kind.isRetryable ? "\n\nPlease Try again in a moment" : ""}';
      errorWidget = CustomErrorView(
        title: ex.kind.title,
        description: descriptionText,
      );
    } else {
      errorWidget = CustomErrorView(
        title: 'Service error has occurred',
        description:
            'There has been a failure in fulfilling this request.  Please try '
            'again  later',
      );
    }
    return Column(children: [errorWidget, if (retry) actionButton]);
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/map.extensions.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/centred_constrained_widget.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/bill_submit/bill_submission_controller.dart';

class BillSubmissionPage extends HookConsumerWidget with UiLoggy {
  const BillSubmissionPage({required this.receiptText, super.key});

  final String receiptText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissionState = ref.watch(billSubmissionControllerProvider);
    loggy.debug('submission state: ${submissionState.value}');

    return Scaffold(
      appBar: createAppBar(context, 'Submit Receipt'),
      body: CentredConstrainedWidget(
        child: Padding(
          padding: EdgeInsetsGeometry.all(18.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20.0,
            children: [
              AsyncValueWidget(
                value: submissionState,
                data: (_) => ActionButton(
                  label: 'Analyse',
                  onPressed: () => ref
                      .read(billSubmissionControllerProvider.notifier)
                      .analyseTextReceipt(receiptText),
                ),
              ),

              Expanded(child: SingleChildScrollView(child: Text(receiptText))),
              if (submissionState.value!.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: AsyncValueWidget(
                      value: submissionState,
                      data: (map) => Text(map.toPrettyJson()),
                    ),
                  ),
                ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: AsyncValueWidget<Map<String, dynamic>>(
              //     value: submissionState,
              //     data: (json) => Text(
              //       json.toPrettyJson(),
              //       textAlign: TextAlign.center,
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //   ),
              // ),

              // Expanded(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Theme.of(
              //         context,
              //       ).colorScheme.surfaceContainerHighest,
              //       borderRadius: BorderRadius.circular(16.0),
              //       border: Border.all(
              //         color: Theme.of(context).colorScheme.outlineVariant,
              //       ),
              //     ),
              //     clipBehavior: Clip.antiAlias,
              //     child: Image.asset(
              //       qualifiedPath,
              //       fit: BoxFit.contain,
              //       errorBuilder: (_, __, ___) => Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(
              //               Icons.broken_image,
              //               size: 48,
              //               color: Theme.of(context).colorScheme.error,
              //             ),
              //             Text('Unable to load $qualifiedPath'),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // ActionButton(
              //   label: 'Analyse',
              //   onPressed: submissionState.isLoading
              //       ? null
              //       : () => ref
              //             .read(billSubmissionControllerProvider.notifier)
              //             .analyseTextReceipt(receiptText),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

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
import 'package:tab_settle/features/bill_analyse/data/text_receipts.dart';
import 'package:tab_settle/features/bill_submit/bill_submission_controller.dart';

import '../../core/routing/router.dart';

class BillSubmissionPage extends HookConsumerWidget with UiLoggy {
  const BillSubmissionPage({super.key});

  // final String receiptName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dtoState = ref.watch(billSubmissionControllerProvider);
    loggy.debug('submission state: ${dtoState.value}');
    final qualifiedPathName = useState('');
    // final qualifiedPathName = 'assets/test_receipts/$receiptName';

    return Scaffold(
      appBar: createAppBar(context, 'Submit Receipt'),
      body: MobileFirstContainer(
        child: Column(
          spacing: kPaddingSmall,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AsyncValueWidget(
              value: dtoState,
              data: (dtoState) => ActionButton(
                label: 'Analyse',
                onPressed: qualifiedPathName.value.isNotEmpty
                    ? () => ref
                          .read(billSubmissionControllerProvider.notifier)
                          .analyseAssetReceipt(qualifiedPathName.value)
                    : null,
              ),
            ),
            if (dtoState.value != null)
              ActionButton(
                label: 'Review Items',
                onPressed: () => context.pushNamed(
                  AppRoute.checkReceipt.name,
                  extra: dtoState.value,
                ),
              ),
            ActionButton(label: 'Capture Receipt'),
            Divider(),
            Text('Or select from existing'),

            if (qualifiedPathName.value.isNotEmpty)
              Expanded(
                child: SizedBox(
                  height: 400.0,
                  width: double.infinity,
                  child: Image.asset(
                    qualifiedPathName.value,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            ...List.generate(imageAssetReceipts.length, (i) {
              final path = imageAssetReceipts[i]['path'] ?? '';
              final label = imageAssetReceipts[i]['name'];
              return ActionButton(
                label: label!,
                onPressed: () {
                  qualifiedPathName.value = 'assets/test_receipts/$path';
                  loggy.debug('Receipt ${qualifiedPathName.value}');
                },
              );
            }),

            // Expanded(
            //   flex: 4,
            //   child: Container(
            //     width: double.infinity,
            //     child: Image.asset(qualifiedPathName, fit: BoxFit.contain),
            //   ),
            // ),
            // if (dtoState.value != null)
            //   Expanded(
            //     flex: 1,
            //     child: Text(
            //       dtoState.value!.toString(),
            //       style: TextStyle(fontSize: 16.0),
            //     ),
            //   ),
          ],
        ),
      ),
      // : CentredConstrainedWidget(
      //     child: Padding(
      //       padding: EdgeInsetsGeometry.all(18.0),
      //       child: Column(
      //         // crossAxisAlignment: CrossAxisAlignment.stretch,
      //         spacing: 20.0,
      //         children: [
      //           AsyncValueWidget(
      //             value: dtoState,
      //             data: (_) => ActionButton(
      //               label: 'Analyse',
      //               onPressed: () => ref
      //                   .read(billSubmissionControllerProvider.notifier)
      //                   .analyseTextReceipt(receiptName),
      //             ),
      //           ),
      //
      //           Expanded(
      //             child: SingleChildScrollView(child: Text(receiptName)),
      //           ),
      //
      //           if (dtoState.value != null)
      //             ActionButton(
      //               label:
      //                   'Check the '
      //                   'Scan',
      //               onPressed: () => context.pushNamed(
      //                 AppRoute.checkReceipt.name,
      //                 extra: dtoState.value,
      //               ),
      //             ),
      //
      //           if (dtoState.value != null)
      //             Expanded(
      //               child: SingleChildScrollView(
      //                 child: AsyncValueWidget(
      //                   value: dtoState,
      //                   data: (dto) {
      //                     return Text(dto.toString());
      //                   },
      //                 ),
      //               ),
      //             ),
      //
      //           // Padding(
      //           //   padding: const EdgeInsets.all(8.0),
      //           //   child: AsyncValueWidget<Map<String, dynamic>>(
      //           //     value: submissionState,
      //           //     data: (json) => Text(
      //           //       json.toPrettyJson(),
      //           //       textAlign: TextAlign.center,
      //           //       style: Theme.of(context).textTheme.bodyLarge,
      //           //     ),
      //           //   ),
      //           // ),
      //
      //           // Expanded(
      //           //   child: Container(
      //           //     decoration: BoxDecoration(
      //           //       color: Theme.of(
      //           //         context,
      //           //       ).colorScheme.surfaceContainerHighest,
      //           //       borderRadius: BorderRadius.circular(16.0),
      //           //       border: Border.all(
      //           //         color: Theme.of(context).colorScheme.outlineVariant,
      //           //       ),
      //           //     ),
      //           //     clipBehavior: Clip.antiAlias,
      //           //     child: Image.asset(
      //           //       qualifiedPath,
      //           //       fit: BoxFit.contain,
      //           //       errorBuilder: (_, __, ___) => Padding(
      //           //         padding: const EdgeInsets.all(8.0),
      //           //         child: Column(
      //           //           mainAxisAlignment: MainAxisAlignment.center,
      //           //           children: [
      //           //             Icon(
      //           //               Icons.broken_image,
      //           //               size: 48,
      //           //               color: Theme.of(context).colorScheme.error,
      //           //             ),
      //           //             Text('Unable to load $qualifiedPath'),
      //           //           ],
      //           //         ),
      //           //       ),
      //           //     ),
      //           //   ),
      //           // ),
      //           // ActionButton(
      //           //   label: 'Analyse',
      //           //   onPressed: submissionState.isLoading
      //           //       ? null
      //           //       : () => ref
      //           //             .read(billSubmissionControllerProvider.notifier)
      //           //             .analyseTextReceipt(receiptText),
      //           // ),
      //         ],
      //       ),
      //     ),
      //   ),
    );
  }
}

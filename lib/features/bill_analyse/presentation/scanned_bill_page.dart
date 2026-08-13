import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/bill_analyse/application/bill_scan_provider.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_item_dto.dart';
import 'package:tab_settle/features/bill_analyse/presentation/receipt_dto_overview.dart';
import 'package:tab_settle/features/home/home_page.dart';

class ScannedBillPage extends HookConsumerWidget with UiLoggy {
  const ScannedBillPage({required this.filePath, super.key});

  final String filePath;

  // final ReceiptDto dto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dtoState = ref.watch(receiptScanProvider(filePath));
    // final file = useMemoized(() => File(filePath), [filePath]);
    return Scaffold(
      appBar: createAppBar(context, ScreenTitle(label: 'Process the Receipt')),

      body: MobileFirstContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kPaddingSmall,
            vertical: kPaddingMedium,
          ),
          child: Column(
            spacing: colSpacingSmall,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                dtoState.hasValue
                    ? 'Please check the scan matches the receipt and correct '
                          'before sharing'
                    : 'processing the receipt',
                textAlign: TextAlign.center,
              ),

              Expanded(
                child: AsyncValueWidget<ReceiptDto>(
                  value: dtoState,
                  data: (dto) => ReceiptDtoView(dto: dto),
                ),
              ),

              if (dtoState.value != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActionButton(label: 'Edit'),
                    ActionButton(label: 'Next'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryLine extends StatelessWidget with UiLoggy {
  const SummaryLine({
    this.fixedWidth = 80.0,
    this.fixed,
    this.remaining,
    super.key,
  });

  final Widget? fixed;
  final Widget? remaining;
  final double fixedWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        spacing: kPaddingMedium,
        children: [
          SizedBox(width: fixedWidth, child: fixed ?? SizedBox.shrink()),
          Expanded(child: remaining ?? SizedBox.shrink()),
        ],
      ),
    );
  }
}

BoxDecoration correctionOutline(BuildContext context) => BoxDecoration(
  // color: Theme.of(context).colorScheme.secondary.withAlpha(30),
  borderRadius: BorderRadius.circular(8.0),
  border: Border.all(
    color: Theme.of(context).colorScheme.secondary.withAlpha(90),
    width: 1.0,
  ),
);

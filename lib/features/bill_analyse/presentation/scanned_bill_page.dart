import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_item_dto.dart';
import 'package:tab_settle/features/bill_analyse/presentation/bill_scan_controller.dart';
import 'package:tab_settle/features/home/home_page.dart';

class ScannedBillPage extends HookConsumerWidget with UiLoggy {
  const ScannedBillPage({required this.filePath, super.key});

  final String filePath;

  // final ReceiptDto dto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dtoState = ref.watch(billScanControllerProvider);
    final file = useMemoized(() => File(filePath), [filePath]);
    return Scaffold(
      // appBar: createAppBar(context, 'Check the Bill'),
      appBar: createAppBar(context, ScreenTitle(label: 'Process the Receipt')),

      body: MobileFirstContainer(
        // maxWidth: mobileWidth,
        // minWidth: mobileWidth,
        // alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kPaddingSmall,
            vertical: kPaddingMedium,
          ),
          child: Column(
            spacing: colSpacingSmall,
            children: [
              Text(
                'Please check the scan matches the receipt and correct '
                'before sharing',
              ),
              ActionButton(
                label: 'Process',
                onPressed: () => ref
                    .read(billScanControllerProvider.notifier)
                    .analyseImageReceipt(filePath),
              ),
              // Text(filePath),
              // if (file.existsSync())
              //   Text('File is good'), // ReceiptSummary(dto: dto),
              Divider(),

              AsyncValueWidget<ReceiptDto?>(
                value: dtoState,
                data: (dto) {
                  return dto == null
                      ? Text('no dto')
                      : Expanded(child: ReceiptItems(items: dto.items));
                },
              ),
              // Expanded(
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: kPaddingMedium),
              //     child: ReceiptItems(items: dto.items),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReceiptSummary extends HookConsumerWidget with UiLoggy {
  final ReceiptDto dto;

  const ReceiptSummary({required this.dto, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: mobileWidth,
      child: Card(
        child: Container(
          decoration: dto.hasFallbackValues ? correctionOutline(context) : null,

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: colSpacingSmall,
              children: [
                Text(
                  dto.merchantName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SummaryLine(
                  fixed: Text(
                    dto.totalAmount.toCurrency(),
                    textAlign: TextAlign.right,
                  ),
                  remaining: Text('Total'),
                ),
                SummaryLine(
                  remaining: Text('Service Charge'),
                  fixed: Text(
                    dto.serviceCharge.toCurrency(),
                    textAlign: TextAlign.right,
                  ),
                ),

                if (dto.serviceCharge > 0.0)
                  SummaryLine(
                    remaining: Text('Service Rate'),
                    fixed: Text(
                      '${dto.serviceChargePercentage.toString()} %',
                      textAlign: TextAlign.right,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReceiptItems extends HookConsumerWidget with UiLoggy {
  const ReceiptItems({required this.items, super.key});

  final List<ReceiptItemDto> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) => Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: kPaddingSmall / 2),
        child: ReceiptItem(dto: items[i]),
      ),
    );
  }
}

class ReceiptItem extends HookConsumerWidget with UiLoggy {
  const ReceiptItem({required this.dto, super.key});

  final ReceiptItemDto dto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Container(
      decoration: dto.hasFallbackValues ? correctionOutline(context) : null,
      child: SummaryLine(
        fixed: Text(
          dto.price.toCurrency(),
          style: style,
          textAlign: TextAlign.right,
        ),
        remaining: SelectableText(
          '${dto.quantity}  x  ${dto.name}',
          style: style,
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

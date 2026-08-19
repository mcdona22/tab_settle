import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/features/receipt/application/receipt_service.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item_extensions.dart';
import 'package:tab_settle/features/receipt/presentation/widgets/receipt_header.dart';

class DashboardSummaryView extends HookConsumerWidget with UiLoggy {
  const DashboardSummaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptId = ref.watch(receiptIdProvider);
    final receiptState = ref.watch(receiptHeaderProvider(receiptId));
    final receiptItems = ref.watch(receiptItemsProvider(receiptId));

    return Column(
      children: [
        AsyncValueWidget(
          value: receiptState,
          data: (receipt) {
            return ReceiptHeader(receipt: receipt);
          },
        ),
        AsyncValueWidget(
          value: receiptItems,
          data: (items) {
            final unclaimedCount = items.unclaimed.length;
            final cost = items.unclaimed.totalPrice;
            return Column(
              children: [
                Text('Unclaimed Items: $unclaimedCount'),
                Text('Balance: ${cost.toCurrency()}'),
              ],
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/features/receipt_history/data/receipt_history_notifier.dart';

class HistoricalReceiptList extends HookConsumerWidget with UiLoggy {
  const HistoricalReceiptList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(receiptHistoryProvider);

    return AsyncValueWidget(
      value: history,
      data: (receipts) {
        return Text(
          receipts.isEmpty
              ? 'No History'
              : '${receipts.length} '
                    'historical receipts',
        );
      },
    );
    return const Center(child: Text('Under Construction'));
  }
}

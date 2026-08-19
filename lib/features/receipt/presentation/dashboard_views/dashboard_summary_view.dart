import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/features/receipt/application/receipt_service.dart';
import 'package:tab_settle/features/receipt/presentation/widgets/receipt_header.dart';

class DashboardSummaryView extends HookConsumerWidget with UiLoggy {
  const DashboardSummaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptId = ref.watch(receiptIdProvider);
    final receiptState = ref.watch(receiptHeaderProvider(receiptId));
    return Column(
      children: [
        AsyncValueWidget(
          value: receiptState,
          data: (receipt) => ReceiptHeader(receipt: receipt),
        ),
      ],
    );
  }
}

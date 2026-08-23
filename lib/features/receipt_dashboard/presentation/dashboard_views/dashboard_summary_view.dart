import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/claimants/consolidated_claimant_view.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/widgets/receipt_header.dart';

import '../../application/receipt_service.dart';

class DashboardSummaryView extends HookConsumerWidget with UiLoggy {
  const DashboardSummaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptId = ref.watch(receiptIdProvider);
    final receiptState = ref.watch(receiptHeaderProvider(receiptId));
    return SingleChildScrollView(
      child: Column(
        children: [
          AsyncValueWidget(
            value: receiptState,
            data: (receipt) {
              return ReceiptHeader(receipt: receipt);
            },
          ),
          ConsolidatedClaimantView(),
        ],
      ),
    );
  }
}

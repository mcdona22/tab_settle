import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/receipt_history/data/receipt_history_notifier.dart';

class HistoricalReceiptList extends HookConsumerWidget with UiLoggy {
  const HistoricalReceiptList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipts = ref.watch(receiptHistoryProvider);
    loggy.debug('history');
    loggy.debug(receipts);

    return SingleChildScrollView(
      child: Column(
        children: receipts
            .map(
              (receipt) => SizedBox(
                width: double.infinity,
                child: ActionButton(
                  label: receipt.title,
                  onPressed: () => context.goNamed(
                    AppRoute.receiptDashboard.name,
                    pathParameters: {'id': receipt.id!},
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/hardcoded.dart';
import 'package:tab_settle/core/preference_notifier.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt.dart';
import 'package:tab_settle/features/receipt_history/data/receipt_history_notifier.dart';

class HistoricalReceiptList extends HookConsumerWidget with UiLoggy {
  const HistoricalReceiptList({super.key});

  static const knownIds = [
    'yVtgwpXONAveEai03FWu',
    'ZvP0n32KHhGVoEemk4AC',
    'PEWdVXRPpFfbvepAsXVT',
    'Pdd1WBIELLfuV3BMty8q',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const indent = 20.0;
    final receipts = ref.watch(receiptHistoryProvider);
    final handle = ref.watch(preferenceProvider).handle;
    final storedIds = handle == 'He Dad' ? knownIds : [];

    return Column(
      spacing: 12.0.hardcoded,
      children: [
        // Divider(indent: indent, endIndent: indent),
        Text('Receipt history', style: Theme.of(context).textTheme.titleLarge),
        ...storedIds.map(
          (id) => ActionButton(
            label: id.substring(0, 5),
            onPressed: () => context.goNamed(
              AppRoute.receiptDashboard.name,
              pathParameters: {'id': id},
            ),
          ),
        ),
        ...receipts.map(
          (receipt) => SizedBox(
            width: double.infinity,
            child: HistoryTile(receipt: receipt),
          ),
        ),
      ],
    );
  }
}

class HistoryTile extends StatelessWidget {
  const HistoryTile({required this.receipt, super.key});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0.hardcoded),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      // color: Colors.black12,
      child: ListTile(
        leading: Icon(Icons.receipt_long),
        title: Text(receipt.title),
        subtitle: Text(formatter().format(receipt.createdAt)),
        onTap: () => context.goNamed(
          AppRoute.receiptDashboard.name,
          pathParameters: {'id': receipt.id!},
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
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
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipts = ref.watch(receiptHistoryProvider);
    loggy.debug('history');
    loggy.debug(receipts);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          spacing: 5.0,
          children: [
            Text(
              'My receipt history',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            // ActionButton(
            //   label: 'Clear Prefs',
            //   onPressed: () async =>
            //       ref.read(receiptHistoryProvider.notifier).clear(),
            // ),
            // Divider(),
            // ...knownIds.map(
            //   (id) => ActionButton(
            //     label: id.substring(0, 5),
            //     onPressed: () => context.goNamed(
            //       AppRoute.receiptDashboard.name,
            //       pathParameters: {'id': id},
            //     ),
            //   ),
            // ),
            ...receipts.map(
              (receipt) => SizedBox(
                width: double.infinity,
                child: HistoryTile(receipt: receipt),
                // child: TextButton(
                //   child: Text(receipt.title),
                //   onPressed: () => context.goNamed(
                //     AppRoute.receiptDashboard.name,
                //     pathParameters: {'id': receipt.id!},
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  const HistoryTile({required this.receipt, super.key});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(receipt.title),
      subtitle: Text(formatter().format(receipt.createdAt)),
      onTap: () => context.goNamed(
        AppRoute.receiptDashboard.name,
        pathParameters: {'id': receipt.id!},
      ),
    );
  }
}

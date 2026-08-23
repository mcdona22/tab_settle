import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item_extensions.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/widgets/receipt_header.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/widgets/receipt_items_list.dart';

import '../../application/receipt_service.dart';

class DashboardSummaryView extends HookConsumerWidget with UiLoggy {
  const DashboardSummaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptId = ref.watch(receiptIdProvider);
    final receiptState = ref.watch(receiptHeaderProvider(receiptId));
    final receiptItems = ref.watch(receiptItemsProvider(receiptId));
    return SingleChildScrollView(
      child: Column(
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
                  // Text('Unclaimed Items: $unclaimedCount'),
                  // Text('Balance: ${cost.toCurrency()}'),
                  ClaimantSummaryLine(
                    claimant: '',
                    items: items.unclaimed,
                    claimantTitle: 'Unclaimed',
                  ),
                  Divider(),

                  // ...items.claimants.map(
                  //   (claimant) => ClaimantSummaryLine(
                  //     claimant: claimant,
                  //     items: items.claimedBy(claimant),
                  //   ),
                  // ),
                  ...items.claimants.map(
                    (claimant) => Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                        ),
                        title: ClaimantSummaryLine(
                          claimant: claimant,
                          items: items.claimedBy(claimant),
                        ),
                        children: [
                          ReceiptItemsList(
                            items: items
                                .claimedBy(claimant)
                                .sortedByPriceDescending(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ClaimantSummaryLine extends HookConsumerWidget {
  const ClaimantSummaryLine({
    required this.claimant,
    required this.items,
    this.claimantTitle,
    super.key,
  });

  final String claimant;
  final List<ReceiptLineItem> items;
  final String? claimantTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              claimantTitle ?? claimant,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: 75.0,
            child: Text(
              items.totalPrice.toCurrency(),
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

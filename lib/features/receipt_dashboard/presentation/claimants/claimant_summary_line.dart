import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item_extensions.dart';

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

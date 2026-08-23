import 'package:flutter/material.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item_extensions.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/claimants/claimant_summary_line.dart';

class ClaimantExpansionView extends StatelessWidget {
  const ClaimantExpansionView({
    required this.claimant,
    required this.items,

    this.claimantTitle,
    super.key,
  });

  final List<ReceiptLineItem> items;
  final String claimant;
  final String? claimantTitle;

  @override
  Widget build(BuildContext context) {
    final claimedItems = items.claimedBy(claimant);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsetsGeometry.symmetric(horizontal: 0.0),
        childrenPadding: EdgeInsetsGeometry.only(left: 10.0),
        title: ClaimantSummaryLine(
          claimant: claimantTitle ?? claimant,
          items: items,
        ),
        enabled: claimedItems.isNotEmpty,
        children: claimedItems
            .sortedByPriceDescending()
            .map((item) => SimpleReceiptItemDisplay(item: item))
            .toList(),
      ),
    );
  }
}

class SimpleReceiptItemDisplay extends StatelessWidget {
  const SimpleReceiptItemDisplay({required this.item, super.key});

  final ReceiptLineItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(item.name)),
        SizedBox(width: 80.0, child: Text(item.price.toCurrency())),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item.dart';
import 'package:tab_settle/features/receipt/presentation/claimable_item.dart';

class ReceiptItemsList extends HookConsumerWidget with UiLoggy {
  const ReceiptItemsList({
    required this.items,
    this.userFilter = '',
    super.key,
  });

  final List<ReceiptLineItem> items;
  final String userFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loggy.debug('we have items, $items');
    final filteredItems = items.where((item) => item.claimant == userFilter);
    loggy.debug('filtered: $filteredItems');

    return Column(
      children: filteredItems.map((item) => ClaimableItem(item: item)).toList(),
    );
  }
}

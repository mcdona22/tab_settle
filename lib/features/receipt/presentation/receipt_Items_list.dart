import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item.dart';
import 'package:tab_settle/features/receipt/presentation/claimable_item.dart';

class ReceiptItemsList extends HookConsumerWidget with UiLoggy {
  const ReceiptItemsList({required this.items, super.key});

  final List<ReceiptLineItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loggy.debug('we have items, $items');
    return Column(
      children: items.map((item) => ClaimableItem(item: item)).toList(),
    );
  }
}

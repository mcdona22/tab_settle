import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/receipt/application/receipt_service.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item.dart';
import 'package:tab_settle/features/receipt/presentation/widgets/claimable_item.dart';

class ReceiptItemsList extends HookConsumerWidget with UiLoggy {
  const ReceiptItemsList({required this.items, super.key});

  final List<ReceiptLineItem> items;

  // final String userFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(receiptIdProvider);

    loggy.debug('we have items, $items for $id');

    return Column(
      children: items
          .map((item) => ClaimableItem(item: item, receiptId: id))
          .toList(),
    );
  }
}

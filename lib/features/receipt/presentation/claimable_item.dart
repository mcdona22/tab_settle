import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item.dart';

class ClaimableItem extends HookConsumerWidget with UiLoggy {
  const ClaimableItem({required this.item, super.key});

  final ReceiptLineItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      minLeadingWidth: 100.0,
      title: Text(item.name),
      subtitle: Text(item.price.toCurrency()),
      leading: item.claimant.isEmpty
          ? Text('Swipe to claim')
          : Text(item.claimant, overflow: TextOverflow.fade),
    );
  }
}

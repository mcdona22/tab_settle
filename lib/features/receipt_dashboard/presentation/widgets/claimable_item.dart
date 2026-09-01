import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/preference_notifier.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/receipt_dashboard_controller.dart';

class ClaimableItem extends HookConsumerWidget with UiLoggy {
  const ClaimableItem({required this.item, required this.receiptId, super.key});

  final ReceiptLineItem item;
  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colourScheme = Theme.of(context).colorScheme;
    final handle = ref.watch(preferenceProvider).handle;

    return ListTile(
      // minLeadingWidth: 100.0,
      onTap: () async {
        final updatedClaimant = item.claimant.isEmpty ? handle : '';
        final updatedItem = item.copyWith(claimant: updatedClaimant);
        await ref
            .read(receiptDashboardControllerProvider.notifier)
            .updateReceiptItem(updatedItem, receiptId);
      },
      title: Text(item.name),
      subtitle: Text(item.price.toCurrency()),
      leading: item.claimant.isEmpty
          ? Icon(Icons.add_circle_outline, color: colourScheme.secondary)
          : CircleAvatar(
              backgroundColor: colourScheme.primaryContainer,
              radius: 14,
              child: Text(item.claimant[0].toUpperCase()),
            ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );
  }
}

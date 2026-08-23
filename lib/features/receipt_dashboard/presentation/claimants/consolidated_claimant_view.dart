import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/features/receipt_dashboard/application/receipt_service.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item_extensions.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/claimants/claimant_expansion_view.dart';

class ConsolidatedClaimantView extends HookConsumerWidget with UiLoggy {
  const ConsolidatedClaimantView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptId = ref.watch(receiptIdProvider);
    final receiptItems = ref.watch(receiptItemsProvider(receiptId));

    final unclaimedIdentifier = ''; // no magic strings

    return AsyncValueWidget(
      value: receiptItems,
      data: (items) {
        final claimants = items.claimants..sort();
        return Column(
          children: [
            ClaimantExpansionView(
              claimant: unclaimedIdentifier,
              items: items.unclaimed,
              claimantTitle: 'Unclaimed Items',
            ),
            Divider(),
            ...claimants.map(
              (name) => ClaimantExpansionView(
                claimant: name,
                items: items.claimedBy(name),
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/application/user_handle_notifier.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/features/receipt_dashboard/application/receipt_service.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item_extensions.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/claimants/claimant_summary_line.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/widgets/receipt_items_list.dart';

class DashboardClaimView extends HookConsumerWidget with UiLoggy {
  const DashboardClaimView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptId = ref.watch(receiptIdProvider);
    final receiptItems = ref.watch(receiptItemsProvider(receiptId));
    final userHandle = ref.watch(userHandleProvider);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: AsyncValueWidget(
        value: receiptItems,
        data: (items) {
          final claimed = items
              .claimedBy(userHandle.value!)
              .sortedByPriceDescending();
          final available = items.unclaimed.sortedByPriceDescending();
          return Column(
            children: [
              if (claimed.isNotEmpty)
                ClaimantSummaryLine(
                  claimant: userHandle.requireValue,
                  items: items,
                  // claimantTitle: 'Your items',
                ),
              if (claimed.isNotEmpty) ...[
                Text(
                  'Your items total: ${claimed.totalPrice.toCurrency()}',
                  style: textTheme.titleLarge,
                ),
                SizedBox(height: 12.0),
              ],
              if (available.isNotEmpty) ...[
                Divider(),
                Text('Available to claim'),
                ReceiptItemsList(items: available),
              ],

              if (claimed.isNotEmpty) ...[
                Divider(),
                Text('Your claimed items'),
                ReceiptItemsList(items: claimed),
              ],
            ],
          );
        },
      ),
    );
  }
}

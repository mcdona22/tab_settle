import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/application/user_handle_notifier.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/features/receipt/application/receipt_service.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item_extensions.dart';
import 'package:tab_settle/features/receipt/presentation/providers.dart';
import 'package:tab_settle/features/receipt/presentation/widgets/receipt_items_list.dart';

class DashboardClaimView extends HookConsumerWidget with UiLoggy {
  const DashboardClaimView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptId = ref.watch(receiptIdProvider);
    final receiptItems = ref.watch(receiptItemsProvider(receiptId));
    final userHandle = ref.watch(userHandleProvider);

    return SingleChildScrollView(
      child: AsyncValueWidget(
        value: receiptItems,
        data: (items) {
          final claimed = items.claimedBy(userHandle.value!);
          final unClaimed = items.unclaimed;
          return Column(
            children: [
              ReceiptItemsList(items: unClaimed),
              Divider(),
              if (claimed.isNotEmpty)
                Text('Claimed Items Total: ${claimed.totalPrice.toCurrency()}'),
              if (claimed.isNotEmpty) ReceiptItemsList(items: claimed),
            ],
          );
        },
      ),
    );
  }
}

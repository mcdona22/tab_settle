import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/bill_analyse/presentation/scanned_bill_page.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt.dart';

class BillPresentationPage extends HookConsumerWidget with UiLoggy {
  const BillPresentationPage({required this.receipt, super.key});

  final Receipt receipt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: createAppBar(context, ScreenTitle(label: 'Ready to Share')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: colSpacingSmall,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              receipt.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SummaryLine(
              remaining: Text('Total'),
              fixed: Text(receipt.totalAmount.toCurrency()),
            ),
            SummaryLine(remaining: Text('Claimed'), fixed: Text('0.0')),

            const Divider(),

            SummaryLine(remaining: Text('Items: ${receipt.items.length}')),
            Expanded(
              child: ListView.builder(
                itemCount: receipt.items.length,
                itemBuilder: (context, index) => SummaryLine(
                  remaining: Text(receipt.items[index].name),
                  fixed: Text(receipt.items[index].price.toCurrency()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';

class ReceiptHeader extends StatelessWidget {
  const ReceiptHeader({required this.receipt, super.key});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            spacing: 12.0,
            children: [
              Text(receipt.title, style: textTheme.titleLarge),
              Text(
                'Total: ${receipt.totalAmount.toCurrency()}',
                style: textTheme.titleSmall,
              ),
              Text(
                'Service: ${receipt.serviceCharge.toCurrency()}',
                style: textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

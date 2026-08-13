import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_item_dto.dart';
import 'package:tab_settle/features/bill_analyse/presentation/scanned_bill_page.dart';

import '../../../core/extensions/double.extensions.dart';

class ReceiptItem extends StatelessWidget with UiLoggy {
  const ReceiptItem({required this.dto, super.key});

  final ReceiptItemDto dto;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Container(
      decoration: dto.hasFallbackValues ? correctionOutline(context) : null,
      child: SummaryLine(
        fixed: Text(
          dto.price.toCurrency(),
          style: style,
          textAlign: TextAlign.right,
        ),
        remaining: SelectableText(
          '${dto.quantity}  x  ${dto.name}',
          style: style,
        ),
      ),
    );
  }
}

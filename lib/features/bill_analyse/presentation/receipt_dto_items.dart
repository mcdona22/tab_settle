import 'package:flutter/cupertino.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_item_dto.dart';
import 'package:tab_settle/features/bill_analyse/presentation/receipt_dto_item.dart';

class ReceiptDtoItems extends StatelessWidget with UiLoggy {
  const ReceiptDtoItems({required this.items, super.key});

  final List<ReceiptItemDto> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) => Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: kPaddingSmall / 2),
        child: ReceiptItem(dto: items[i]),
      ),
    );
  }
}

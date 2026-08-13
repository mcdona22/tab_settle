import 'package:flutter/material.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/presentation/receipt_dto_header.dart';
import 'package:tab_settle/features/bill_analyse/presentation/receipt_dto_items.dart';

class ReceiptDtoView extends StatelessWidget {
  const ReceiptDtoView({required this.dto, super.key});

  final ReceiptDto dto;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: kPaddingMedium,
      children: [
        SizedBox(child: ReceiptDtoHeader(dto: dto)),
        Expanded(child: ReceiptDtoItems(items: dto.items)),
      ],
    );
  }
}

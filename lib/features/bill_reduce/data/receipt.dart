import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_item_dto.dart';
import 'package:tab_settle/features/bill_reduce/data/receipt_line_item.dart';

part 'receipt.freezed.dart';

@freezed
abstract class Receipt with _$Receipt, UiLoggy {
  const Receipt._();

  const factory Receipt({
    String? id,
    required String title,
    required double totalAmount,
    required double totalClaimed,
    required double serviceCharge,
    required List<ReceiptLineItem> items,
  }) = _Receipt;

  factory Receipt.fromDto(ReceiptDto dto) {
    return Receipt(
      title: dto.merchantName,
      totalAmount: dto.totalAmount,
      totalClaimed: 0.0,
      serviceCharge: dto.serviceCharge,
      items: _reduceItems(dto.items),
    );
  }

  static List<ReceiptLineItem> _reduceItems(List<ReceiptItemDto> items) {
    return items.expand((item) => _reduceItem(item)).toList();
  }

  static List<ReceiptLineItem> _reduceItem(ReceiptItemDto dto) {
    final count = dto.quantity;
    final unitCost = dto.price / dto.quantity;
    return List.generate(
      count,
      (_) => ReceiptLineItem(name: dto.name, price: unitCost),
    );
  }
}

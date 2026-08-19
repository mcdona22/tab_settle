import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/application/time_stamp_converter.dart';
import 'package:tab_settle/db/abstract_document.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_item_dto.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item.dart';

part 'receipt.freezed.dart';
part 'receipt.g.dart';

@freezed
abstract class Receipt with _$Receipt, UiLoggy implements AbstractDocument {
  const Receipt._();

  const factory Receipt({
    String? id,
    required String title,
    required double totalAmount,
    required double serviceCharge,
    @TimeStampConverter() required DateTime createdAt,
    @Default([]) List<ReceiptLineItem> items,
  }) = _Receipt;

  @override
  Map<String, dynamic> toFirestoreDocument() {
    final map = toJson();
    map.remove('items');
    return map;
  }

  factory Receipt.fromDto(ReceiptDto dto) {
    return Receipt(
      title: dto.merchantName,
      totalAmount: dto.totalAmount,

      createdAt: DateTime.now(),
      serviceCharge: dto.serviceCharge,
      items: _reduceItems(dto.items),
    );
  }

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);

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

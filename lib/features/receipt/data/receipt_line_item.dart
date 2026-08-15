import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_line_item.freezed.dart';

@freezed
abstract class ReceiptLineItem with _$ReceiptLineItem {
  const ReceiptLineItem._();

  const factory ReceiptLineItem({
    String? id,
    required String name,
    required double price,
    @Default('') String claimant,
  }) = _ReceiptLineItem;
}

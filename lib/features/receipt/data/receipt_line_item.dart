import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tab_settle/db/abstract_document.dart';

part 'receipt_line_item.freezed.dart';
part 'receipt_line_item.g.dart';

@freezed
abstract class ReceiptLineItem
    with _$ReceiptLineItem
    implements AbstractDocument {
  const ReceiptLineItem._();

  const factory ReceiptLineItem({
    String? id,
    required String name,
    required double price,
    @Default('') String claimant,
  }) = _ReceiptLineItem;

  factory ReceiptLineItem.fromJson(Map<String, dynamic> json) =>
      _$ReceiptLineItemFromJson(json);

  @override
  Map<String, dynamic> toFirestoreDocument() => toJson();
}

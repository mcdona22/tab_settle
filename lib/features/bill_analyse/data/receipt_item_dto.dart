import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_item_dto.freezed.dart';

@freezed
abstract class ReceiptItemDto with _$ReceiptItemDto {
  // Required by Freezed when adding custom constructors or methods
  const ReceiptItemDto._();

  const factory ReceiptItemDto({
    required String name,
    required int quantity,
    required double price,
    required bool hasFallbackValues,
  }) = _ReceiptItemDto;

  factory ReceiptItemDto.fromJson(Map<String, dynamic> json) {
    bool defaulted = false;

    final String? rawName = json['name'] as String?;
    final String name = (rawName != null && rawName.trim().isNotEmpty)
        ? rawName.trim()
        : 'Unknown Item';
    if (rawName == null || rawName.trim().isEmpty) defaulted = true;

    final int? rawQty = (json['quantity'] as num?)?.toInt();
    final int quantity = rawQty ?? 1;
    if (rawQty == null) defaulted = true;

    final double? rawPrice = (json['price'] as num?)?.toDouble();
    final double price = rawPrice ?? 0.0;
    if (rawPrice == null) defaulted = true;

    return ReceiptItemDto(
      name: name,
      quantity: quantity,
      price: price,
      hasFallbackValues: defaulted,
    );
  }
}

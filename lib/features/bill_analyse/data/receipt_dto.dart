import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_item_dto.dart';

part 'receipt_dto.freezed.dart';

@freezed
abstract class ReceiptDto with _$ReceiptDto, UiLoggy {
  const ReceiptDto._();

  const factory ReceiptDto({
    required String merchantName,
    required String currency,
    required double? subtotal,
    required double serviceCharge,
    required double totalAmount,
    required List<ReceiptItemDto> items,
    required bool hasFallbackValues,
  }) = _ReceiptDto;

  factory ReceiptDto.fromJson(Map<String, dynamic> json) {
    bool defaulted = false;
    final String? rawMerchant = json['merchantName'] as String?;
    if (rawMerchant == null || rawMerchant.trim().isEmpty) defaulted = true;
    final String merchantName =
        (rawMerchant != null && rawMerchant.trim().isNotEmpty)
        ? rawMerchant.trim()
        : 'Unknown Merchant';

    // 2. Currency
    final String? rawCurrency = json['currency'] as String?;
    if (rawCurrency == null || rawCurrency.trim().isEmpty) defaulted = true;
    final String currency =
        (rawCurrency != null && rawCurrency.trim().isNotEmpty)
        ? rawCurrency.trim()
        : 'GBP';

    final double? subtotal = (json['subtotal'] as num?)?.toDouble();

    // 4. Service Charge
    final double? rawServiceCharge = (json['serviceCharge'] as num?)
        ?.toDouble();
    if (rawServiceCharge == null) defaulted = true;
    final double serviceCharge = rawServiceCharge ?? 0.0;

    // 5. Total Amount
    final double? rawTotal = (json['totalAmount'] as num?)?.toDouble();
    if (rawTotal == null) defaulted = true;
    final double totalAmount = rawTotal ?? 0.0;

    // 6. Line Items & Fallback Aggregation
    final rawItems = json['items'] as List<dynamic>? ?? [];
    if (rawItems.isEmpty) defaulted = true;

    final List<ReceiptItemDto> items = rawItems.map((item) {
      final itemMap = item as Map<String, dynamic>;
      final itemDto = ReceiptItemDto.fromJson(itemMap);

      if (itemDto.hasFallbackValues) defaulted = true;

      return itemDto;
    }).toList();

    final dto = ReceiptDto(
      merchantName: merchantName,
      currency: currency,
      subtotal: subtotal,
      serviceCharge: serviceCharge,
      totalAmount: totalAmount,
      items: items,
      hasFallbackValues: defaulted,
    );
    logDebug('ReceiptDto\n$dto');
    return dto;
  }

  /// Calculated property for effective service charge percentage
  double get serviceChargePercentage {
    if (serviceCharge <= 0.0) return 0.0;

    final baseAmount = subtotal ?? (totalAmount - serviceCharge);
    if (baseAmount <= 0.0) return 0.0;

    return (serviceCharge / baseAmount) * 100;
  }
}

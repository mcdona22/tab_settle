import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';

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
  }) = _Receipt;

  factory Receipt.fromDto(ReceiptDto dto) {
    return Receipt(
      title: dto.merchantName,
      totalAmount: dto.totalAmount,
      totalClaimed: 0.0,
      serviceCharge: dto.serviceCharge,
    );
  }
}

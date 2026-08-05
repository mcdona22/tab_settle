import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_dto.freezed.dart';

@freezed
abstract class ReceiptDto with _$ReceiptDto {
  const ReceiptDto._();

  const factory ReceiptDto({required String merchantName}) = _ReceiptDto;
}

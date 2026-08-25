import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';

part 'receiptdto_edit_controller.g.dart';

@riverpod
class ReceiptDtoEditController extends _$ReceiptDtoEditController with UiLoggy {
  @override
  ReceiptDto? build() => null;

  void init(ReceiptDto dto) => state = dto;

  void saveName(String name) {
    loggy.debug('saving "$name" in the controller');
    if (state != null) state = state!.copyWith(merchantName: name);
  }
}

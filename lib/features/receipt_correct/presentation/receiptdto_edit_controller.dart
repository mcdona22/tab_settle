import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/receipt_correct/data/receipt_dto.dart';
import 'package:tab_settle/features/receipt_correct/data/receipt_item_dto.dart';

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

  void deleteReceiptItemByIndex(int i) {
    if (state == null) {
      loggy.error('Cant perform operation with null dto');
      return;
    }
    if (i >= 0 && i < state!.items.length) {
      loggy.debug('about to delete item at position $i', state!.items[i].name);
      final updatedItems = List<ReceiptItemDto>.from(state!.items);
      final deletedItem = updatedItems.removeAt(i);
      loggy.debug('removed $deletedItem');
      state = state!.copyWith(items: updatedItems);
    }
  }
}

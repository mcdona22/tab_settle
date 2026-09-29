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
    if (_checkIndex(i)) {
      // loggy.debug('about to delete item at position $i', state!.items[i].name);
      final updatedItems = List<ReceiptItemDto>.from(state!.items);
      final deletedItem = updatedItems.removeAt(i);
      // loggy.debug('NOT removed $deletedItem');
      if (state == null) {
        loggy.error('The state for this receipt is null');
      } else {
        final currentDto = state!;

        final dtoToRevise = currentDto.copyWith(items: updatedItems);
        final updatedCost = dtoToRevise.totalAmountCalculated;

        state = dtoToRevise.copyWith(totalAmount: updatedCost);
        // loggy.debug('new items total cost  = ${state!.totalAmountCalculated}');
      }
    }
  }

  void replaceReceiptItemByIndex(ReceiptItemDto dto, int i) {
    loggy.debug('replacing dto at index $i with $dto');
    if (_checkIndex(i)) {
      final listToUpdate = List<ReceiptItemDto>.from(state!.items);
      listToUpdate[i] = dto;
      if (state == null) {
        loggy.error('The state for the receipt is null');
      } else {
        final revisedDto = state!.copyWith(items: listToUpdate);
        final updatedCost = revisedDto.totalAmountCalculated;

        state = revisedDto.copyWith(totalAmount: updatedCost);
      }
    }
  }

  bool _checkIndex(int i) => i >= 0 && i < state!.items.length;
}

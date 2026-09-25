import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/receipt_correct/data/receipt_item_dto.dart';
import 'package:tab_settle/features/receipt_correct/presentation/receiptdto_edit_controller.dart';
import 'package:tab_settle/features/user_feedback/feedback_service.dart';

part 'receipt_item_dto_form_notifier.g.dart';

class ReceiptItemFormState {
  ReceiptItemFormState({
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.qtyController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController qtyController;
}

@riverpod
class ReceiptItemDtoFormNotifier extends _$ReceiptItemDtoFormNotifier
    with UiLoggy {
  ReceiptItemFormState build(int index, ReceiptItemDto dto) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: dto.name);
    final priceController = TextEditingController(text: dto.price.toString());
    final qtyController = TextEditingController(text: dto.quantity.toString());

    ref.onDispose(() {
      nameController.dispose();
      priceController.dispose();
      qtyController.dispose();
    });

    return ReceiptItemFormState(
      formKey: formKey,
      nameController: nameController,
      priceController: priceController,
      qtyController: qtyController,
    );
  }

  // todo These actions must cause the header to be updated also
  void onDelete(VoidCallback onDone) {
    loggy.debug('Deleting ${state.nameController.text}');
    ref
        .read(receiptDtoEditControllerProvider.notifier)
        .deleteReceiptItemByIndex(index);
    ref.read(feedbackServiceProvider.notifier).showInfo('Item deleted');

    onDone();
  }

  void onSave(VoidCallback onDone) {
    loggy.debug('Saving ${state.nameController.text}');
    ref.read(feedbackServiceProvider.notifier).showInfo('Item Saved');
    onDone();
  }
}

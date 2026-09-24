import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/features/receipt_correct/data/receipt_item_dto.dart';
import 'package:tab_settle/features/receipt_correct/presentation/receipt_dto_item.dart';
import 'package:tab_settle/features/receipt_correct/presentation/receiptdto_edit_controller.dart';
import 'package:tab_settle/features/user_feedback/feedback_service.dart';

class ReceiptDtoItems extends HookConsumerWidget with UiLoggy {
  static const _unSelectedIndex = -1;

  const ReceiptDtoItems({required this.items, super.key});

  final List<ReceiptItemDto> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final editIndex = useState<int>(_unSelectedIndex);
    final controller = ref.read(receiptDtoEditControllerProvider.notifier);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) => Container(
        decoration: editIndex.value == i
            ? BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                // border: BoxBorder.all(
                //   width: 1.0,
                //   color: Theme.of(context).colorScheme.onSurface,
                // ),
                borderRadius: BorderRadius.circular(12.0),
              )
            : null,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: kPaddingSmall / 2),
          child: Row(
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () => editIndex.value == i
                        ? editIndex.value = _unSelectedIndex
                        : editIndex.value = i,
                    icon: Icon(editIndex.value == i ? Icons.save : Icons.edit),
                  ),
                  if (editIndex.value == i)
                    IconButton(
                      icon: Icon(Icons.delete, color: colorScheme.error),
                      onPressed: () {
                        controller.deleteReceiptItemByIndex(i);
                        ref
                            .read(feedbackServiceProvider.notifier)
                            .showInfo('Item deleted');
                      },
                    ),
                ],
              ),

              Expanded(
                child: editIndex.value == i
                    ? ReceiptItemForm(dto: items[i])
                    : ReceiptItem(dto: items[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReceiptItemForm extends HookConsumerWidget with UiLoggy {
  const ReceiptItemForm({required this.dto, super.key});

  final ReceiptItemDto dto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController()..text = dto.name;
    final qtyController = useTextEditingController()
      ..text = dto.quantity.toString();
    final priceController = useTextEditingController()
      ..text = dto.price.toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 12.0,
          children: [
            // Divider(),
            TextField(
              controller: nameController,
              decoration: _inputDecoration('Name'),
            ),
            Row(
              spacing: 8.0,
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    decoration: _inputDecoration('Price'),
                  ),
                ),

                Expanded(
                  child: TextField(
                    controller: qtyController,
                    decoration: _inputDecoration('Quantity'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: OutlineInputBorder());
}

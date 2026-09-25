import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/features/receipt_correct/data/receipt_item_dto.dart';
import 'package:tab_settle/features/receipt_correct/presentation/receipt_dto_item.dart';
import 'package:tab_settle/features/receipt_correct/presentation/receipt_dto_item_form.dart';
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
                  if (editIndex.value != i)
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => editIndex.value = i,
                    ),
                  // IconButton(
                  //   onPressed: () => editIndex.value == i
                  //       ? editIndex.value = _unSelectedIndex
                  //       : editIndex.value = i,
                  //   icon: Icon(editIndex.value == i ? Icons.save : Icons.edit),
                  // ),
                  if (editIndex.value == i && false)
                    IconButton(
                      icon: Icon(Icons.delete, color: colorScheme.error),
                      onPressed: () {
                        editIndex.value = _unSelectedIndex;
                        _removeItemAtIndex(i, items, ref);
                      },
                    ),
                ],
              ),

              Expanded(
                child: editIndex.value == i
                    ? ReceiptItemForm(
                        dto: items[i],
                        index: i,
                        onDone: () => editIndex.value = _unSelectedIndex,
                      )
                    : ReceiptItem(dto: items[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeItemAtIndex(
    int index,
    List<ReceiptItemDto> items,
    WidgetRef ref,
  ) {
    final itemName = items[index].name;
    final controller = ref.read(receiptDtoEditControllerProvider.notifier);
    controller.deleteReceiptItemByIndex(index);
    ref
        .read(feedbackServiceProvider.notifier)
        .showInfo(
          'Item deleted',
          description:
              '$itemName '
              'has been successfully removed',
        );
  }
}

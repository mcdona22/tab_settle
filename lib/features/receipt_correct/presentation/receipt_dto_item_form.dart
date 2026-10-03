import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/receipt_correct/data/receipt_item_dto.dart';
import 'package:tab_settle/features/receipt_correct/presentation/form_validators.dart';
import 'package:tab_settle/features/receipt_correct/presentation/receipt_item_dto_form_notifier.dart';

class ReceiptItemForm extends HookConsumerWidget with UiLoggy {
  const ReceiptItemForm({
    required this.dto,
    required this.index,
    required this.onDone,
    super.key,
  });

  final ReceiptItemDto dto;
  final int index;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(receiptItemDtoFormProvider(index, dto));
    final controller = ref.read(
      receiptItemDtoFormProvider(index, dto).notifier,
    );

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 12.0,
          children: [
            Divider(),
            Form(
              key: state.formKey,
              child: Column(
                spacing: 12.0,
                children: [
                  TextFormField(
                    controller: state.nameController,
                    decoration: _inputDecoration('Name'),
                    validator: FormValidators.requiredName,
                  ),
                  Row(
                    spacing: 8.0,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: state.priceController,
                          decoration: _inputDecoration('Price'),
                          validator: FormValidators.nonNegativePrice,
                        ),
                      ),

                      Expanded(
                        child: TextFormField(
                          controller: state.qtyController,
                          decoration: _inputDecoration('Quantity'),
                          validator: FormValidators.nonNegativeInteger,
                        ),
                      ),
                    ],
                  ),

                  const Divider(),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 18.0,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: colorScheme.error),
                  onPressed: () => controller.onDelete(onDone),
                ),
                SizedBox(width: 18.0),
                IconButton(
                  icon: Icon(Icons.cancel, color: colorScheme.primary),
                  onPressed: onDone,
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  color: colorScheme.primary,
                  onPressed: () => controller.onSave(onDone),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label, {
    bool hideErrorText = false,
  }) => InputDecoration(labelText: label, border: OutlineInputBorder());
}

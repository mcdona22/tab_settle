import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/bill_analyse/presentation/receiptdto_edit_controller.dart';

class NameEditControl extends HookConsumerWidget with UiLoggy {
  const NameEditControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dto = ref.watch(receiptDtoEditControllerProvider);
    final merchantName = dto?.merchantName ?? '';
    loggy.debug('dto is', dto);
    final textEditController = useTextEditingController(text: merchantName);
    final editMode = useState(false);
    final focusNode = useFocusNode();

    useEffect(() {
      if (!editMode.value) {
        textEditController.text = merchantName;
      }
      return null;
    }, [merchantName, editMode.value]);

    onSave() {
      loggy.debug("title is '${textEditController.text}");
      ref
          .read(receiptDtoEditControllerProvider.notifier)
          .saveName(textEditController.text);

      editMode.value = false;
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textEditController,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: 'Receipt Name',
              border: editMode.value
                  ? const OutlineInputBorder()
                  : InputBorder.none,
            ),

            style: Theme.of(context).textTheme.titleLarge,
            readOnly: !editMode.value,

            // textAlign: TextAlign.center,
          ),
        ),

        IconButton(
          icon: Icon(editMode.value ? Icons.check : Icons.edit, size: 20.0),
          onPressed: () => editMode.value ? onSave() : editMode.value = true,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }
}

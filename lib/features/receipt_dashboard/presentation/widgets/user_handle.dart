import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/preference_notifier.dart';

class UserHandle extends HookConsumerWidget with UiLoggy {
  const UserHandle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final currentHandle = ref.watch(userHandleProvider).value ?? 'Not Set';
    final handle = ref.watch(preferenceProvider).handle;
    final editMode = useState(false);
    final textController = useTextEditingController(text: handle);
    final focusNode = useFocusNode();
    useEffect(() {
      if (!editMode.value) {
        textController.text = handle;
      }
      return null;
    }, [handle, editMode.value]);

    void handleSave() {
      final newHandle = textController.text.trim();
      loggy.debug('saving $newHandle');
      if (newHandle.isNotEmpty) {
        ref.read(preferenceProvider.notifier).setHandle(newHandle);
        editMode.value = false;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              // enabled: editMode.value,
              readOnly: !editMode.value,
              onSubmitted: (_) => handleSave(),
              decoration: InputDecoration(
                labelText: 'User Handle',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 8.0,
                ),
                border: editMode.value
                    ? const OutlineInputBorder()
                    : InputBorder.none,
              ),
            ),
          ),

          IconButton(
            icon: Icon(editMode.value ? Icons.check : Icons.edit, size: 20.0),
            onPressed: () =>
                editMode.value ? handleSave() : editMode.value = true,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

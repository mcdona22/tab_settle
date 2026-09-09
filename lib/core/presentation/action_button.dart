import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class ActionButton extends HookConsumerWidget with UiLoggy {
  const ActionButton(
      {required this.label, this.onPressed, this.icon, super.key});

  final String label;
  final Icon? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonWidth = 160.0;

    return SizedBox(
      width: buttonWidth,
      child: icon == null
          ? ElevatedButton(
              onPressed: onPressed,
              // icon: Icon(Icons.receipt_long),
              child: Text(label, textAlign: TextAlign.center),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: icon!,
              label: Text(label, textAlign: TextAlign.center),
            ),
    );
  }
}

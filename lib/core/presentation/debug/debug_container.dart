import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/debug/ui_debug.dart';

class DebugContainer extends HookConsumerWidget with UiLoggy {
  const DebugContainer({
    required this.child,
    this.color = Colors.red,
    super.key,
  });

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    decoration: BoxDecoration(border: debugBorder(color: color)),
    child: child,
  );
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class AsyncValueWidget<T> extends StatelessWidget with UiLoggy {
  AsyncValueWidget({
    required this.value,
    required this.data,
    this.errorBuilder,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? Function(Object error, StackTrace stackTrace)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) {
        loggy.debug(e.toString());
        final customErrorWidget = errorBuilder?.call(e, st);
        return customErrorWidget ?? Center(child: SelectableText(e.toString()));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

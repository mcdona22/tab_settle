import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class AsyncValueWidget<T> extends StatelessWidget with UiLoggy {
  const AsyncValueWidget({required this.value, required this.data, super.key});

  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) {
        loggy.debug(e.toString());
        return Center(child: SelectableText(e.toString()));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

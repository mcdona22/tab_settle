import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class AsyncValueWidget<T> extends StatelessWidget with UiLoggy {
  AsyncValueWidget({
    required this.value,
    required this.data,
    this.error,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? Function(Object error, StackTrace stackTrace)? error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      // added this so that I can optionally control the error in the UI more
      // specifically
      error: (e, st) {
        loggy.debug(e.toString());
        final customErrorWidget = error?.call(e, st);
        return customErrorWidget ?? Center(child: SelectableText(e.toString()));
      },
      loading: () => Center(child: CircularProgressIndicator()),

      // adjusted this so that the spinner will fit in the footprint of the
      // usual widget.
      // loading: () {
      //   final T? currentData = value.asData?.value;
      //
      //   return Stack(
      //     alignment: Alignment.center,
      //     children: [
      //       Opacity(
      //         opacity: 0.50,
      //         child: IgnorePointer(child: data(currentData as T)),
      //       ),
      //       Center(
      //         child: SizedBox(
      //           width: 24,
      //           height: 24,
      //           child: CircularProgressIndicator(),
      //         ),
      //       ),
      //     ],
      //   );
      // },
    );
  }
}

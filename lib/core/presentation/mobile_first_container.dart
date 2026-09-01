import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';

const msg =
    'The display is too small for the app to work.  You are most '
    'likely on a mobile device in landscape mode';

class MobileFirstContainer extends StatelessWidget with UiLoggy {
  final Widget child;
  final double maxWidth;
  final double minWidth;
  final double minHeight;
  final EdgeInsetsGeometry padding;

  const MobileFirstContainer({
    super.key,
    required this.child,
    this.maxWidth = mobileWidth,
    this.minWidth = 320.0,
    this.minHeight = 300.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (_, constraints) {
        final effectiveHeight = constraints.maxHeight + keyboardHeight;

        final tooSmall =
            constraints.maxWidth < minWidth || effectiveHeight < minHeight;
        if (tooSmall) loggy.debug('We are too small');
        return tooSmall
            ? Padding(
                padding: padding,
                child: Center(child: Text(msg, textAlign: TextAlign.center)),
              )
            : Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(padding: padding, child: child),
                ),
              );
      },
    );
  }
}

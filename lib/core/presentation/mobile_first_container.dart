import 'package:flutter/material.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';

class MobileFirstContainer extends StatelessWidget {
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
    this.minHeight = 480.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final tooSmall =
            constraints.maxWidth < minWidth ||
            constraints.maxHeight < minHeight;
        return tooSmall
            ? Padding(
                padding: padding,
                child: Center(
                  child: Text(
                    'Your device is too small Tab Settle app to '
                    'work',
                    textAlign: TextAlign.center,
                  ),
                ),
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

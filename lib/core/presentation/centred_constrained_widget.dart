import 'package:flutter/material.dart';

class CentredConstrainedWidget extends StatelessWidget {
  const CentredConstrainedWidget({
    required this.child,
    this.minWidth = 400.0,
    this.maxWidth = 600.0,
    this.alignment = Alignment.center,
    super.key,
  });

  final double minWidth;
  final double maxWidth;
  final Alignment alignment;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

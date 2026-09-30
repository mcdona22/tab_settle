import 'package:flutter/material.dart';

class SliverShrinkingHeader extends SliverPersistentHeaderDelegate {
  const SliverShrinkingHeader({
    required this.child,
    this.expandedHeight = 200.0,
  });

  final double expandedHeight;
  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / maxExtent).clamp(0.0, 1.0);
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final scale = (1.0 - (progress * 0.3)).clamp(0.7, 1.0);
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Center(child: child),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 0.0;

  @override
  bool shouldRebuild(covariant SliverShrinkingHeader oldDelegate) {
    return oldDelegate.expandedHeight != expandedHeight ||
        oldDelegate.child != child;
  }
}

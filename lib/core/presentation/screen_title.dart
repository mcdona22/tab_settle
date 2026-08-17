import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.tertiary,
          theme.colorScheme.secondary,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Colors.white, // Color must be white for ShaderMask
        ),
      ),
    );
  }
}

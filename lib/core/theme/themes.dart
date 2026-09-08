import 'package:flutter/material.dart';

// const Color kSeedColor = Color(0xFF3772FF);
const Color kSeedColor = Color(0xFF00120B);
// const Color kSeedColor = Color(0x8332AC);
const Color kAccentColor = Color(0xFFFF8800);

// Generate the full ColorScheme for the light theme
final ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: kSeedColor,
  secondary: kAccentColor,
  brightness: Brightness.light, // Crucial for light theme generation
);

// Generate the full ColorScheme for the dark theme
final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: kSeedColor,
  secondary: kAccentColor,
  brightness: Brightness.dark, // Crucial for dark theme generation
);

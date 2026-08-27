import 'package:flutter/material.dart';

const Color kSeedColor = Color(0xFF3772FF); // A vibrant bl; // A vibrant blue
// const Color kSeedColor = Color(0x00120B); // A vibrant bl; // A vibrant blue
// const Color kSeedColor = Color(0x8332AC); // A vibrant bl; // A vibrant blue
const Color kAccentColor = Color(0xFFFF8800); // A contrasting orange

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

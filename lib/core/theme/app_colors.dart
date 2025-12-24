import 'package:flutter/material.dart';

class AppColors {
  // Palette provided by user
  // F2EFE7 (Cream/Off-white)
  // 9ACBD0 (Light Blue)
  // 48A6A7 (Teal)
  // 2973B2 (Strong Blue)

  static const Color primary = Color(0xFFF66B0E); // Strong Blue - Primary
  static const Color secondary = Color(0xFF48A6A7); // Teal - Secondary
  static const Color tertiary = Color(
    0xFF9ACBD0,
  ); // Light Blue - Accents/Borders
  static const Color background = Color(0xFFF2EFE7); // Cream - Background

  static const Color accent = secondary;
  static const Color surface =
      Colors.white; // Keep white for cards to pop against cream

  static const Color error = Color(0xFFEF4444);

  // Text Colors
  static const Color textPrimary = Color(
    0xFF1E293B,
  ); // Keep generic dark for readability
  static const Color textSecondary = Color(
    0xFF64748B,
  ); // Slate for secondary text

  static const Color inputBorder = tertiary; // Use Light Blue for borders
}

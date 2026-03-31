import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const teal = Color(0xFF1A7A7A);
  static const tealLight = Color(0xFFE0F2F2);
  static const tealDark = Color(0xFF145F5F);
  static const background = Color(0xFFEEF4F4);
  static const cardBg        = Color(0xFFF5F8F8);
  static const inputBg       = Color(0xFFE4ECEC);
  static const textPrimary = Color(0xFF1A2B2B);
  static const textSecondary = Color(0xFF5A7070);
  static const accentBorder  = Color(0xFF4DBDBD);
  static const borderLeft = Color(0xFF56B8B8);

  static const statusUnderweight = Color(0xFF2196F3);
  static const statusNormal      = Color(0xFF0D6B6B);
  static const statusOverweight  = Color(0xFFFF9800);
  static const statusObese       = Color(0xFFF44336);

  static final light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: teal,
      secondary: tealLight,
      surface: background,
    ),
    fontFamily: 'Georgia', // fallback; swap with Google Fonts if available
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: textPrimary,
    ),
  );
}
import 'package:flutter/material.dart';

class XynthraColors {
  static const Color background = Color(0xFF0a0b1e);
  static const Color cardBg = Color(0xFF1a1b3a);
  static const Color cardBgLight = Color(0xFF252650);
  static const Color primary = Color(0xFF7c3aed);
  static const Color primaryLight = Color(0xFF9f67ff);
  static const Color accent = Color(0xFF06d6a0);
  static const Color accentDark = Color(0xFF05b888);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9ca3af);
  static const Color textMuted = Color(0xFF6b7280);
  static const Color disconnected = Color(0xFF4b5563);
  static const Color connecting = Color(0xFFf59e0b);
  static const Color connected = Color(0xFF06d6a0);
  static const Color error = Color(0xFFef4444);
  static const Color surface = Color(0xFF12132e);
}

final ThemeData xynthraTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: XynthraColors.background,
  primaryColor: XynthraColors.primary,
  colorScheme: const ColorScheme.dark(
    primary: XynthraColors.primary,
    secondary: XynthraColors.accent,
    surface: XynthraColors.cardBg,
    error: XynthraColors.error,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardThemeData(
    color: XynthraColors.cardBg,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: XynthraColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: XynthraColors.cardBg,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: XynthraColors.primary, width: 2),
    ),
    hintStyle: const TextStyle(color: XynthraColors.textMuted),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: XynthraColors.textSecondary),
    bodyMedium: TextStyle(color: XynthraColors.textSecondary),
    bodySmall: TextStyle(color: XynthraColors.textMuted),
  ),
);

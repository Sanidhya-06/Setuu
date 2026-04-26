import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 COLORS (from your design)
  static const Color primaryColor = Color(0xFF5A4EFF);
  static const Color secondaryColor = Color(0xFFEEA0FF);
  static const Color accentGreen = Color(0xFFE2F4A6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color darkColor = Color(0xFF2E2E2E);

  static const Color textPrimary = Color(0xFF1C1C1C);
  static const Color textSecondary = Color(0xFF6B6B6B);

  static const Color cardColor = Colors.white;

  // 🌙 LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',

    scaffoldBackgroundColor: backgroundColor,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: textPrimary,
    ),

    // 🔤 TEXT THEME
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: textSecondary,
      ),
    ),

    // 🔘 BUTTON THEME
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // 🧾 INPUT FIELD THEME
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
      hintStyle: const TextStyle(color: textSecondary),
    ),

    // 🧱 CARD THEME
    cardTheme: CardThemeData(
  color: cardColor,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
),

    // 📍 APP BAR
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    // 🔻 BOTTOM NAV BAR
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondary,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // 🎯 ICONS
    iconTheme: const IconThemeData(
      color: textPrimary,
    ),
  );

  // 🌈 GRADIENT (for hero buttons / headers)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF6A5BFF),
      Color(0xFF5A4EFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
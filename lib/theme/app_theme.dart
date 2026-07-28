import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppPalette.primary,
      secondary: AppPalette.secondary,
      surface: AppPalette.lightCard,
      surfaceVariant: AppPalette.lightBackground,
    ),
    primaryColor: AppPalette.primary,
    scaffoldBackgroundColor: AppPalette.lightBackground,
    dividerColor: cardBorder(false),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppPalette.primary,
      centerTitle: true,
    ),
    fontFamily: 'Cairo',
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.lightCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cardBorder(false)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cardBorder(false)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppPalette.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: AppPalette.primary,
      secondary: AppPalette.secondary,
      surface: AppPalette.darkCard,
      surfaceVariant: AppPalette.darkBackground,
    ),
    primaryColor: AppPalette.primary,
    scaffoldBackgroundColor: AppPalette.darkBackground,
    dividerColor: cardBorder(true),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppPalette.primary,
      centerTitle: true,
    ),
    fontFamily: 'Cairo',
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cardBorder(true)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cardBorder(true)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppPalette.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

/// Centralized app color system with light/dark aware helpers.
/// يحتوي على الألوان الأساسية والدوال لاختيار اللون حسب الوضع النهاري/الليلي.
class AppPalette {
  // Brand primitives - الألوان الأساسية للعلامة التجارية
  static const Color primary = Color(0xFF0A3D62);
  static const Color secondary = Color(0xFF1A4D72);
  static const Color accent = Color(0xFFE58E26);
  static const Color danger = Color(0xFFE84545);
  static const Color badgeBg = Color(0xFFE6EBF3);
  // Metallic accents
  static const Color gold = Color(0xFFD4AF37);
  static const Color silver = Color(0xFFC0C4C8);

  // Semantic base colors - الألوان الدلالية الأساسية
  static const Color success =
  Color(0xFF27AE60); // Green for success - أخضر للنجاح
  static const Color lightBackground = Color(0xFFF4F7F9); // خلفية فاتحة
  static const Color darkBackground = Color(0xFF0F172A); // خلفية داكنة

  // Card colors - ألوان الكروت
  static const Color lightCard = Colors.white;
  static const Color darkCard = Color(0xFF1F2634);
  // Text colors - ألوان النصوص
  static const Color lightTextPrimary = Color(0xFF0A2239);
  static const Color darkTextPrimary = Colors.white;
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  // Alert colors - ألوان التنبيهات
  static const Color lightAlert = Color(0xFFFDE68A);
  static const Color darkAlert = Color(0xFF92400E);

  // Shadows - الظلال
  static const Color lightShadow = Color(0x1A000000); // 10% black
  static const Color darkShadow = Color(0x33000000); // 20% black
}

// دوال لاختيار اللون حسب الوضع النهاري/الليلي
// Background colors - ألوان الخلفيات
Color background(bool isDark) =>
    isDark ? AppPalette.darkBackground : AppPalette.lightBackground;

// Card colors - ألوان الكروت
Color cardBg(bool isDark) =>
    isDark ? AppPalette.darkCard : AppPalette.lightCard;
Color cardBorder(bool isDark) =>
    isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE5E7EB);
Color cardShadow(bool isDark) =>
    isDark ? AppPalette.darkShadow : AppPalette.lightShadow;

// Text colors - ألوان النصوص
Color textPrimary(bool isDark) =>
    isDark ? AppPalette.darkTextPrimary : AppPalette.lightTextPrimary;
Color textSecondary(bool isDark) =>
    isDark ? AppPalette.darkTextSecondary : AppPalette.lightTextSecondary;

// Button colors - ألوان الأزرار
Color buttonBg(bool isDark) =>
    isDark ? AppPalette.secondary : AppPalette.primary;
Color buttonText(bool isDark) => Colors.white; // النص دائمًا أبيض

// Hero Card colors - ألوان الـHero Card
Color heroBg(bool isDark) =>
    isDark ? AppPalette.primary.withOpacity(0.85) : AppPalette.secondary;
Color heroText(bool isDark) => Colors.white; // النص دائمًا أبيض

// Metallic helpers
Color metallicGold(bool isDark) => AppPalette.gold;
Color metallicSilver(bool isDark) => AppPalette.silver;

// Service colors - ألوان الخدمات
Color serviceBg(bool isDark) =>
    isDark ? AppPalette.darkCard : AppPalette.lightCard;
Color serviceIcon(bool isDark) =>
    isDark ? AppPalette.accent : AppPalette.primary;

// Alert colors - ألوان التنبيهات
Color alertBg(bool isDark) =>
    isDark ? AppPalette.darkAlert : AppPalette.lightAlert;
Color alertText(bool isDark) => isDark ? Colors.white : const Color(0xFF92400E);



/*
import 'package:flutter/material.dart';

/// Centralized app color system with light/dark aware helpers.
/// يحتوي على الألوان الأساسية والدوال لاختيار اللون حسب الوضع النهاري/الليلي.
class AppPalette {
  // Brand primitives - الألوان الأساسية للعلامة التجارية
  static const Color primary = Color(0xFF0A3D62);
  static const Color secondary = Color(0xFF1A4D72);
  static const Color accent = Color(0xFFE58E26);
  static const Color danger = Color(0xFFE84545);
  static const Color badgeBg = Color(0xFFE6EBF3);
  // Metallic accents
  static const Color gold = Color(0xFFD4AF37);
  static const Color silver = Color(0xFFC0C4C8);

  // Semantic base colors - الألوان الدلالية الأساسية
  static const Color success =
      Color(0xFF27AE60); // Green for success - أخضر للنجاح
  static const Color lightBackground = Color(0xFFF4F7F9); // خلفية فاتحة
  static const Color darkBackground = Color(0xFF0F172A); // خلفية داكنة

  // Card colors - ألوان الكروت
  static const Color lightCard = Colors.white;
  static const Color darkCard = Color(0xFF1F2634);
  // Text colors - ألوان النصوص
  static const Color lightTextPrimary = Color(0xFF0A2239);
  static const Color darkTextPrimary = Colors.white;
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  // Alert colors - ألوان التنبيهات
  static const Color lightAlert = Color(0xFFFDE68A);
  static const Color darkAlert = Color(0xFF92400E);

  // Shadows - الظلال
  static const Color lightShadow = Color(0x1A000000); // 10% black
  static const Color darkShadow = Color(0x33000000); // 20% black
}

// دوال لاختيار اللون حسب الوضع النهاري/الليلي
// Background colors - ألوان الخلفيات
Color background(bool isDark) =>
    isDark ? AppPalette.darkBackground : AppPalette.lightBackground;

// Card colors - ألوان الكروت
Color cardBg(bool isDark) =>
    isDark ? AppPalette.darkCard : AppPalette.lightCard;
Color cardBorder(bool isDark) =>
    isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE5E7EB);
Color cardShadow(bool isDark) =>
    isDark ? AppPalette.darkShadow : AppPalette.lightShadow;

// Text colors - ألوان النصوص
Color textPrimary(bool isDark) =>
    isDark ? AppPalette.darkTextPrimary : AppPalette.lightTextPrimary;
Color textSecondary(bool isDark) =>
    isDark ? AppPalette.darkTextSecondary : AppPalette.lightTextSecondary;

// Button colors - ألوان الأزرار
Color buttonBg(bool isDark) =>
    isDark ? AppPalette.secondary : AppPalette.primary;
Color buttonText(bool isDark) => Colors.white; // النص دائمًا أبيض

// Hero Card colors - ألوان الـHero Card
Color heroBg(bool isDark) =>
    isDark ? AppPalette.primary.withOpacity(0.85) : AppPalette.secondary;
Color heroText(bool isDark) => Colors.white; // النص دائمًا أبيض

// Metallic helpers
Color metallicGold(bool isDark) => AppPalette.gold;
Color metallicSilver(bool isDark) => AppPalette.silver;

// Service colors - ألوان الخدمات
Color serviceBg(bool isDark) =>
    isDark ? AppPalette.darkCard : AppPalette.lightCard;
Color serviceIcon(bool isDark) =>
    isDark ? AppPalette.accent : AppPalette.primary;

// Alert colors - ألوان التنبيهات
Color alertBg(bool isDark) =>
    isDark ? AppPalette.darkAlert : AppPalette.lightAlert;
Color alertText(bool isDark) => isDark ? Colors.white : const Color(0xFF92400E);

 */
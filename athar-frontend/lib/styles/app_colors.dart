import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// يتم تحديثها من ThemeProvider عند كل تبديل للوضع
  static bool isDark = false;

  // ── الألوان الأساسية (من اللوغو مباشرة) ──────────
  static Color get primaryDark =>
      isDark ? const Color(0xFF10132A) : const Color(0xFF1B1F3A);
  static Color get primary => const Color(0xFF5466AF);
  static Color get primaryLight =>
      isDark ? const Color(0xFF2A2E55) : const Color(0xFFE8EAF6);

  static Color get secondary => const Color(0xFF25BAA2);
  static Color get accent => const Color(0xFF92D9F8);

  // ── التدرج الرئيسي (Header/Splash) ──────────
  static List<Color> get primaryGradient => [primaryDark, primary];

  // ── الخلفيات ──────────────────────────
  static Color get background =>
      isDark ? const Color(0xFF121212) : const Color(0xFFF2F4F7);
  static Color get surface =>
      isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  static Color get cardTint =>
      isDark ? const Color(0xFF262626) : const Color(0xFFF6F7FA);

  // ── النصوص ──────────────────────────
  static Color get textPrimary =>
      isDark ? const Color(0xFFF2F2F2) : const Color(0xFF1A1A2E);
  static Color get textSecondary =>
      isDark ? const Color(0xFFB0B3C0) : const Color(0xFF6B7280);
  static Color get textHint =>
      isDark ? const Color(0xFF787C94) : const Color(0xFFA0A4B8);
  static Color get textOnPrimary => const Color(0xFFFFFFFF);

  // ── الحدود ──────────────────────────
  static Color get border =>
      isDark ? const Color(0xFF33374A) : const Color(0xFFE1E4EC);
  static Color get borderFocus => primary;

  // ── الحالات ──────────────────────────
  static Color get success => const Color(0xFF25BAA2);
  static Color get error => const Color(0xFFE85C5C);
  static Color get warning => const Color(0xFFF5A623);

  // ── ألوان أنواع الإعلانات ──────────
  static Color get typeSell => const Color(0xFF5466AF);
  static Color get typeDonation => const Color(0xFF25BAA2);
  static Color get typeJob =>
      isDark ? const Color(0xFF4A4F7A) : const Color(0xFF1B1F3A);
  static Color get typeOther => const Color(0xFF7C8CC4);
}
import 'package:flutter/material.dart';

class AppColors {
  // ── الألوان الأساسية (من اللوغو مباشرة) ──────────
  static const primaryDark = Color(0xFF1B1F3A);   // أزرق داكن غامق - الهوية الأساسية
  static const primary = Color(0xFF5466AF);        // أزرق-بنفسجي متوسط
  static const primaryLight = Color(0xFFE8EAF6);   // تينت فاتح من primary

  static const secondary = Color(0xFF25BAA2);      // أخضر تركوازي (تبرعات/نجاح)
  static const accent = Color(0xFF92D9F8);         // أزرق سماوي فاتح

  // ── التدرج الرئيسي (Header/Splash) ──────────
  static const List<Color> primaryGradient = [primaryDark, primary];

  // ── الخلفيات ──────────────────────────
  static const background = Color(0xFFF2F4F7);     // نفس خلفية اللوغو بالضبط
  static const surface = Color(0xFFFFFFFF);
  static const cardTint = Color(0xFFF6F7FA);

  // ── النصوص ──────────────────────────
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textHint = Color(0xFFA0A4B8);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // ── الحدود ──────────────────────────
  static const border = Color(0xFFE1E4EC);
  static const borderFocus = primary;

  // ── الحالات ──────────────────────────
  static const success = Color(0xFF25BAA2);        // نفس الأخضر التركوازي
  static const error = Color(0xFFE85C5C);
  static const warning = Color(0xFFF5A623);

  // ── ألوان أنواع الإعلانات (يستخدموا هوية اللوغو بدل ألوان عشوائية) ──
  static const typeSell = Color(0xFF5466AF);       // primary
  static const typeDonation = Color(0xFF25BAA2);   // secondary (الأخضر التركوازي)
  static const typeJob = Color(0xFF1B1F3A);        // primaryDark
  static const typeOther = Color(0xFF7C8CC4);      // درجة أفتح من primary
}
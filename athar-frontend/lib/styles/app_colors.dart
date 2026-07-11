import 'package:flutter/material.dart';

class AppColors {
  // ── Primary (أخضر - رمز الخير والنماء) ─────
  static const primary        = Color(0xFF2E7D32);
  static const primaryDark    = Color(0xFF1B5E20);
  static const primaryLight   = Color(0xFFE8F5E9);

  // ── Secondary / Accent ───────────────────
  static const secondary      = Color(0xFF66BB6A);
  static const accent         = Color(0xFFA5D6A7);

  // ── Background & Surfaces (محدثة لتناسب العناصر النظيفة والعصرية) ───
  static const background     = Color(0xFFF9F9F7); // عاجي ناعم جداً مريح للعين بديل للرمادي المعتاد
  static const cardBackground = Color(0xFFFFFFFF); // أبيض صافي ناصع للكروت لتبرز فوق الخلفية العاجية
  static const surface        = Color(0xFFFAFAFA); // أبيض مكسور خفيف جداً لمنع توهج الشاشة الصافي

  // ── Text (تعديل طفيف لتناسق أفضل) ─────────────────────────
  static const textPrimary    = Color(0xFF1E201E); // أسود كربوني داكن بدلاً من الأسود الحاد
  static const textSecondary  = Color(0xFF686D68); // رمادي مائل للخضرة العشبية الخافتة جداً
  static const textHint       = Color(0xFFB4B8B4);
  static const textOnPrimary  = Color(0xFFFFFFFF);

  // ── Card Decoration (الظلال والعناصر الناعمة للكروت) ────────
  static final cardShadow     = Colors.black.withOpacity(0.04); // الظل العصري الخفيف المريح للعين
  static final arrowColor     = Colors.grey.shade300; // لون سهم التنقل الناعم داخل الكروت

  // ── Border (تم تنعيمها لتتماشى مع الألوان المكسورة) ────────
  static const border         = Color(0xFFE5E8E5); // حدود ناعمة ومدمجة مع الخلفية الجديدة
  static const borderFocus    = Color(0xFF2E7D32);

  // ── Status ───────────────────────────────
  static const success        = Color(0xFF34A853);
  static const error          = Color(0xFFEA4335);
  static const warning        = Color(0xFFFBBC04);

  // ── Gradient (للـ Splash وأي خلفيات مميزة) ─
  static const gradientStart  = Color(0xFF1B5E20);
  static const gradientMid    = Color(0xFF2E7D32);
  static const gradientEnd    = Color(0xFF81C784);

  static const List<Color> primaryGradient = [
    gradientStart,
    gradientMid,
    gradientEnd,
  ];
}
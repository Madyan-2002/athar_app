import 'package:flutter/material.dart';

class AppColors {
  // ── الألوان الأساسية (من اللوغو مباشرة) ──────────
  static const primaryDark = Color(0xFF1B1F3A); 
  static const primary = Color(0xFF5466AF);        
  static const primaryLight = Color(0xFFE8EAF6);  

  static const secondary = Color(0xFF25BAA2);     
  static const accent = Color(0xFF92D9F8);        

  // ── التدرج الرئيسي (Header/Splash) ──────────
  static const List<Color> primaryGradient = [primaryDark, primary];

  // ── الخلفيات ──────────────────────────
  static const background = Color(0xFFF2F4F7);  
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
  static const success = Color(0xFF25BAA2);       
  static const error = Color(0xFFE85C5C);
  static const warning = Color(0xFFF5A623);

  // ── ألوان أنواع الإعلانات (يستخدموا هوية اللوغو بدل ألوان عشوائية) ──
  static const typeSell = Color(0xFF5466AF);       
  static const typeDonation = Color(0xFF25BAA2);   
  static const typeJob = Color(0xFF1B1F3A);       
  static const typeOther = Color(0xFF7C8CC4);    
}





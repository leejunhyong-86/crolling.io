import 'package:flutter/material.dart';

/// TradeWinds 앱 컬러 팔레트
/// 대항해시대 테마에 맞는 빈티지하고 고급스러운 색상
class AppColors {
  AppColors._();

  // Primary - Deep Sea Blue (깊은 바다)
  static const Color primary = Color(0xFF1A365D);
  static const Color primaryLight = Color(0xFF2C5282);
  static const Color primaryDark = Color(0xFF0F2942);

  // Secondary - Gold (황금, 보물)
  static const Color gold = Color(0xFFD69E2E);
  static const Color goldLight = Color(0xFFF6E05E);
  static const Color goldDark = Color(0xFFB7791F);

  // Accent - Coral (산호)
  static const Color coral = Color(0xFFE53E3E);
  static const Color coralLight = Color(0xFFFC8181);

  // Background - Parchment (양피지)
  static const Color parchment = Color(0xFFFAF5E4);
  static const Color parchmentDark = Color(0xFFE8DCC4);

  // Neutral - Wood & Rope (나무, 밧줄)
  static const Color wood = Color(0xFF5D4E37);
  static const Color woodLight = Color(0xFF8B7355);
  static const Color rope = Color(0xFF8B7355);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textTertiary = Color(0xFF718096);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnGold = Color(0xFF1A202C);

  // Status Colors
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFD69E2E);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF3182CE);

  // Gradient - Ocean Depth
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  // Gradient - Golden Sunset
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, gold],
  );

  // Gradient - Splash Background
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primary],
  );
}


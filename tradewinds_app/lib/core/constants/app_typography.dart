import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// TradeWinds 앱 타이포그래피
/// 대항해시대 테마에 맞는 클래식하고 우아한 폰트 사용
class AppTypography {
  AppTypography._();

  // Display - 대형 제목 (앱 이름, 큰 헤드라인)
  static TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
  );

  static TextStyle displaySmall = GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Heading - 섹션 제목
  static TextStyle headingLarge = GoogleFonts.notoSansKr(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle headingMedium = GoogleFonts.notoSansKr(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle headingSmall = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body - 본문
  static TextStyle bodyLarge = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.notoSansKr(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.notoSansKr(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Label - 버튼, 탭 등
  static TextStyle labelLarge = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.notoSansKr(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = GoogleFonts.notoSansKr(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Price - 가격 표시
  static TextStyle priceLarge = GoogleFonts.notoSansKr(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.gold,
  );

  static TextStyle priceMedium = GoogleFonts.notoSansKr(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.gold,
  );

  static TextStyle priceSmall = GoogleFonts.notoSansKr(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
  );

  // Caption - 부가 설명
  static TextStyle caption = GoogleFonts.notoSansKr(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.3,
  );

  // Overline - 상단 작은 레이블
  static TextStyle overline = GoogleFonts.notoSansKr(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
    letterSpacing: 1.2,
  );
}


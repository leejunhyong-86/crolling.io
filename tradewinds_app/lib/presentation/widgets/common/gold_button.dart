import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

/// 골드 버튼 - 주요 CTA 버튼
/// 대항해시대 테마의 황금빛 버튼
class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final double height;

  const GoldButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnGold),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textOnGold,
            ),
          ),
        ],
      ],
    );

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.textOnGold,
          disabledBackgroundColor: AppColors.gold.withOpacity(0.5),
          elevation: 2,
          shadowColor: AppColors.gold.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: buttonChild,
      ),
    );
  }
}

/// 아웃라인 골드 버튼 - 보조 CTA 버튼
class GoldOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;
  final double height;

  const GoldOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isExpanded = true,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 텍스트 골드 버튼 - 작은 액션 버튼
class GoldTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const GoldTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.gold,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}

/// 아이콘 버튼 (원형)
class GoldIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final bool filled;

  const GoldIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.gold : Colors.transparent,
        border: filled ? null : Border.all(color: AppColors.gold, width: 1.5),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: filled ? AppColors.textOnGold : AppColors.gold,
          size: size * 0.5,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}


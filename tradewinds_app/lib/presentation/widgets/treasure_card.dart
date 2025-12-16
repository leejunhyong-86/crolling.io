import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

/// 보물 카드 모델
class TreasureData {
  final String id;
  final String title;
  final String imageUrl;
  final String portName;
  final String portLogoUrl;
  final String country;
  final String category;
  final double price;
  final String currency;
  final int fundingPercentage;
  final int daysLeft;
  final int backerCount;
  final double? rating;
  final bool isWishlisted;

  const TreasureData({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.portName,
    required this.portLogoUrl,
    required this.country,
    required this.category,
    required this.price,
    required this.currency,
    required this.fundingPercentage,
    required this.daysLeft,
    required this.backerCount,
    this.rating,
    this.isWishlisted = false,
  });
}

/// 보물 카드 - 홈 화면 가로 스크롤용 (Small)
class TreasureCardSmall extends StatelessWidget {
  final TreasureData treasure;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;

  const TreasureCardSmall({
    super.key,
    required this.treasure,
    this.onTap,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: treasure.imageUrl,
                    height: 120,
                    width: 160,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.parchmentDark,
                      child: const Center(
                        child: Icon(Icons.image, color: AppColors.textTertiary),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.parchmentDark,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: AppColors.textTertiary),
                      ),
                    ),
                  ),
                ),
                // 찜 버튼
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlistTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        treasure.isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: treasure.isWishlisted ? AppColors.coral : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
                // 마감 임박 태그
                if (treasure.daysLeft <= 7)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.coral,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'D-${treasure.daysLeft}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // 정보 영역
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 항구 태그
                  Row(
                    children: [
                      const Text('🏴', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          treasure.portName,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // 제목
                  Text(
                    treasure.title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // 가격
                  Text(
                    '${treasure.currency}${treasure.price.toStringAsFixed(0)}',
                    style: AppTypography.priceSmall,
                  ),
                  const SizedBox(height: 6),
                  // 펀딩 진행률
                  _FundingProgress(percentage: treasure.fundingPercentage),
                  const SizedBox(height: 4),
                  // 남은 기간 & 후원자
                  Row(
                    children: [
                      Text(
                        'D-${treasure.daysLeft}',
                        style: AppTypography.caption,
                      ),
                      const Text(' | ', style: TextStyle(color: AppColors.textTertiary)),
                      Text(
                        '${_formatNumber(treasure.backerCount)}명',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 보물 카드 - 그리드용 (Medium)
class TreasureCardMedium extends StatelessWidget {
  final TreasureData treasure;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onCartTap;

  const TreasureCardMedium({
    super.key,
    required this.treasure,
    this.onTap,
    this.onWishlistTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: treasure.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 140,
                      color: AppColors.parchmentDark,
                      child: const Center(
                        child: Icon(Icons.image, color: AppColors.textTertiary),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 140,
                      color: AppColors.parchmentDark,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: AppColors.textTertiary),
                      ),
                    ),
                  ),
                ),
                // 찜 버튼
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlistTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        treasure.isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: treasure.isWishlisted ? AppColors.coral : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // 정보 영역
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 항구 & 국가
                  Row(
                    children: [
                      const Text('🏴', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        treasure.portName,
                        style: AppTypography.caption,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        treasure.country,
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 제목
                  Text(
                    treasure.title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // 가격
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💰 ${treasure.currency}${treasure.price.toStringAsFixed(0)}',
                        style: AppTypography.priceMedium,
                      ),
                      Text(
                        '(~₩${_formatNumber((treasure.price * 1330).toInt())})',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 펀딩 진행률
                  _FundingProgress(
                    percentage: treasure.fundingPercentage,
                    showLabel: true,
                  ),
                  const SizedBox(height: 8),
                  // 남은 기간 & 후원자
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text('D-${treasure.daysLeft}', style: AppTypography.bodySmall),
                      const SizedBox(width: 12),
                      const Icon(Icons.people_outline, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text('${_formatNumber(treasure.backerCount)}명', style: AppTypography.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 액션 버튼
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onWishlistTap,
                          icon: const Icon(Icons.map, size: 16),
                          label: const Text('담기'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.gold,
                            side: const BorderSide(color: AppColors.gold),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onCartTap,
                          icon: const Icon(Icons.inventory_2, size: 16),
                          label: const Text('선적'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.textOnGold,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 보물 카드 - 리스트용 (Horizontal)
class TreasureCardHorizontal extends StatelessWidget {
  final TreasureData treasure;
  final VoidCallback? onTap;

  const TreasureCardHorizontal({
    super.key,
    required this.treasure,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: treasure.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.parchmentDark,
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.parchmentDark,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    treasure.title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('🏴', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(treasure.portName, style: AppTypography.caption),
                      const SizedBox(width: 8),
                      Text(
                        '${treasure.currency}${treasure.price.toStringAsFixed(0)}',
                        style: AppTypography.priceSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _FundingProgress(
                          percentage: treasure.fundingPercentage,
                          height: 4,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${treasure.fundingPercentage}%',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 마감 임박 배지
            if (treasure.daysLeft <= 7)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.coral.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.coral),
                ),
                child: Column(
                  children: [
                    Text(
                      'D-${treasure.daysLeft}',
                      style: TextStyle(
                        color: AppColors.coral,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.warning_amber, size: 14, color: AppColors.coral),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 펀딩 진행률 바
class _FundingProgress extends StatelessWidget {
  final int percentage;
  final double height;
  final bool showLabel;

  const _FundingProgress({
    required this.percentage,
    this.height = 6,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (percentage / 100).clamp(0.0, 1.0);
    final color = percentage >= 100 ? AppColors.success : AppColors.gold;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: height,
            backgroundColor: AppColors.parchmentDark,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            '$percentage%',
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}

/// 숫자 포맷팅 헬퍼
String _formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}


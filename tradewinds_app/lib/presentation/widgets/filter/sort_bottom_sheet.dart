import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../bloc/treasure/treasure_event.dart';

/// 정렬 바텀시트
class SortBottomSheet extends StatelessWidget {
  final TreasureSortType currentSort;
  final ValueChanged<TreasureSortType> onSelect;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSelect,
  });

  /// 바텀시트 표시
  static Future<void> show(
    BuildContext context, {
    required TreasureSortType currentSort,
    required ValueChanged<TreasureSortType> onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheet(
        currentSort: currentSort,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.parchmentDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.sort, color: AppColors.gold),
                  const SizedBox(width: 8),
                  Text(
                    '정렬',
                    style: AppTypography.headingMedium,
                  ),
                ],
              ),
            ),
            const Divider(),
            // 정렬 옵션 목록
            _buildSortOption(
              context,
              sortType: TreasureSortType.latest,
              icon: Icons.access_time,
              label: '최신순',
              description: '가장 최근에 등록된 보물',
            ),
            _buildSortOption(
              context,
              sortType: TreasureSortType.popular,
              icon: Icons.trending_up,
              label: '인기순',
              description: '펀딩률이 높은 보물',
            ),
            _buildSortOption(
              context,
              sortType: TreasureSortType.endingSoon,
              icon: Icons.timer,
              label: '마감임박순',
              description: '마감이 임박한 보물',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context, {
    required TreasureSortType sortType,
    required IconData icon,
    required String label,
    required String description,
  }) {
    final isSelected = currentSort == sortType;

    return InkWell(
      onTap: () {
        onSelect(sortType);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected ? AppColors.goldLight.withOpacity(0.1) : null,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.gold.withOpacity(0.2)
                    : AppColors.parchment,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.goldDark : AppColors.textTertiary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.gold,
              ),
          ],
        ),
      ),
    );
  }
}

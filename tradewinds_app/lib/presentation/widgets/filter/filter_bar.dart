import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../bloc/treasure/treasure_event.dart';

/// 필터/정렬/뷰모드 바
class FilterBar extends StatelessWidget {
  final TreasureFilter filter;
  final TreasureSortType sortType;
  final ViewMode viewMode;
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;
  final ValueChanged<ViewMode> onViewModeChanged;
  final VoidCallback? onFilterReset;

  const FilterBar({
    super.key,
    required this.filter,
    required this.sortType,
    required this.viewMode,
    required this.onFilterTap,
    required this.onSortTap,
    required this.onViewModeChanged,
    this.onFilterReset,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter = !filter.isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // 필터 버튼
          _FilterButton(
            icon: Icons.tune,
            label: '필터',
            isActive: hasActiveFilter,
            onTap: onFilterTap,
            badge: hasActiveFilter ? _getActiveFilterCount() : null,
          ),
          const SizedBox(width: 8),
          // 정렬 버튼
          _FilterButton(
            icon: Icons.sort,
            label: _getSortLabel(),
            isActive: sortType != TreasureSortType.latest,
            onTap: onSortTap,
          ),
          // 필터 초기화 버튼
          if (hasActiveFilter && onFilterReset != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onFilterReset,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.coral.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.close,
                      size: 14,
                      color: AppColors.coral,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '초기화',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.coral,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
          // 뷰 모드 토글
          _ViewModeToggle(
            viewMode: viewMode,
            onChanged: onViewModeChanged,
          ),
        ],
      ),
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (filter.minPrice != null || filter.maxPrice != null) count++;
    if (filter.categories.isNotEmpty) count += filter.categories.length;
    if (filter.fundingStatuses.isNotEmpty) count += filter.fundingStatuses.length;
    if (filter.ports.isNotEmpty) count += filter.ports.length;
    return count;
  }

  String _getSortLabel() {
    switch (sortType) {
      case TreasureSortType.latest:
        return '최신순';
      case TreasureSortType.popular:
        return '인기순';
      case TreasureSortType.endingSoon:
        return '마감임박';
    }
  }
}

/// 필터/정렬 버튼
class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int? badge;

  const _FilterButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.gold.withOpacity(0.1) : AppColors.parchment,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.gold : AppColors.parchmentDark,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.goldDark : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: isActive ? AppColors.goldDark : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 뷰 모드 토글
class _ViewModeToggle extends StatelessWidget {
  final ViewMode viewMode;
  final ValueChanged<ViewMode> onChanged;

  const _ViewModeToggle({
    required this.viewMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.parchmentDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewModeButton(
            icon: Icons.view_list,
            isSelected: viewMode == ViewMode.list,
            onTap: () => onChanged(ViewMode.list),
            isLeft: true,
          ),
          _ViewModeButton(
            icon: Icons.grid_view,
            isSelected: viewMode == ViewMode.grid,
            onTap: () => onChanged(ViewMode.grid),
            isLeft: false,
          ),
        ],
      ),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLeft;

  const _ViewModeButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(7) : Radius.zero,
            right: isLeft ? Radius.zero : const Radius.circular(7),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : AppColors.textTertiary,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../bloc/treasure/treasure_bloc.dart';
import '../../bloc/treasure/treasure_event.dart';
import '../common/gold_button.dart';

/// 필터 바텀시트
class FilterBottomSheet extends StatefulWidget {
  final TreasureFilter currentFilter;
  final ValueChanged<TreasureFilter> onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  /// 바텀시트 표시
  static Future<void> show(
    BuildContext context, {
    required TreasureFilter currentFilter,
    required ValueChanged<TreasureFilter> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilter: currentFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TreasureFilter _filter;
  late RangeValues _priceRange;

  static const double _minPrice = 0;
  static const double _maxPrice = 500;

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _priceRange = RangeValues(
      _filter.minPrice ?? _minPrice,
      _filter.maxPrice ?? _maxPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '필터',
                      style: AppTypography.headingMedium,
                    ),
                    TextButton(
                      onPressed: _resetFilter,
                      child: Text(
                        '초기화',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.coral,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // 필터 내용
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // 가격대 필터
                    _buildSectionTitle('💰 가격대 (USD 기준)'),
                    const SizedBox(height: 8),
                    _buildPriceRangeSlider(),
                    const SizedBox(height: 24),

                    // 카테고리 필터
                    _buildSectionTitle('🏷️ 카테고리 (항로)'),
                    const SizedBox(height: 8),
                    _buildCategoryChips(),
                    const SizedBox(height: 24),

                    // 펀딩 상태 필터
                    _buildSectionTitle('📊 펀딩 상태'),
                    const SizedBox(height: 8),
                    _buildFundingStatusChips(),
                    const SizedBox(height: 24),

                    // 항구 필터
                    _buildSectionTitle('⚓ 항구 (사이트)'),
                    const SizedBox(height: 8),
                    _buildPortChips(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              // 적용 버튼
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: GoldOutlinedButton(
                          text: '취소',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: GoldButton(
                          text: '적용하기',
                          onPressed: _applyFilter,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.bodyLarge.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: _minPrice,
          max: _maxPrice,
          divisions: 50,
          activeColor: AppColors.gold,
          inactiveColor: AppColors.parchmentDark,
          labels: RangeLabels(
            '\$${_priceRange.start.toInt()}',
            _priceRange.end >= _maxPrice
                ? '\$${_maxPrice.toInt()}+'
                : '\$${_priceRange.end.toInt()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
              _filter = _filter.copyWith(
                minPrice: values.start > _minPrice ? values.start : null,
                maxPrice: values.end < _maxPrice ? values.end : null,
              );
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_priceRange.start.toInt()}',
                style: AppTypography.bodySmall,
              ),
              Text(
                _priceRange.end >= _maxPrice
                    ? '\$${_maxPrice.toInt()}+'
                    : '\$${_priceRange.end.toInt()}',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TreasureBloc.availableCategories.map((category) {
        final isSelected = _filter.categories.contains(category);
        return FilterChip(
          label: Text(_getCategoryLabel(category)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final categories = List<String>.from(_filter.categories);
              if (selected) {
                categories.add(category);
              } else {
                categories.remove(category);
              }
              _filter = _filter.copyWith(categories: categories);
            });
          },
          selectedColor: AppColors.goldLight.withOpacity(0.3),
          checkmarkColor: AppColors.goldDark,
          backgroundColor: AppColors.parchment,
          side: BorderSide(
            color: isSelected ? AppColors.gold : AppColors.parchmentDark,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFundingStatusChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TreasureBloc.fundingStatuses.map((status) {
        final isSelected = _filter.fundingStatuses.contains(status);
        return FilterChip(
          label: Text(_getFundingStatusLabel(status)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final statuses = List<String>.from(_filter.fundingStatuses);
              if (selected) {
                statuses.add(status);
              } else {
                statuses.remove(status);
              }
              _filter = _filter.copyWith(fundingStatuses: statuses);
            });
          },
          selectedColor: _getFundingStatusColor(status).withOpacity(0.2),
          checkmarkColor: _getFundingStatusColor(status),
          backgroundColor: AppColors.parchment,
          side: BorderSide(
            color: isSelected
                ? _getFundingStatusColor(status)
                : AppColors.parchmentDark,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPortChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TreasureBloc.availablePorts.map((port) {
        final isSelected = _filter.ports.contains(port);
        return FilterChip(
          label: Text(port),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final ports = List<String>.from(_filter.ports);
              if (selected) {
                ports.add(port);
              } else {
                ports.remove(port);
              }
              _filter = _filter.copyWith(ports: ports);
            });
          },
          selectedColor: AppColors.primaryLight.withOpacity(0.2),
          checkmarkColor: AppColors.primary,
          backgroundColor: AppColors.parchment,
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.parchmentDark,
          ),
        );
      }).toList(),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'Tech':
        return '🔧 테크';
      case 'Audio':
        return '🎧 오디오';
      case 'Lifestyle':
        return '✨ 라이프스타일';
      case 'Home':
        return '🏠 홈';
      case 'Outdoor':
        return '⛺ 아웃도어';
      case 'Travel':
        return '✈️ 여행';
      case 'Fashion':
        return '👔 패션';
      default:
        return category;
    }
  }

  String _getFundingStatusLabel(String status) {
    switch (status) {
      case 'inProgress':
        return '🚀 진행중';
      case 'success':
        return '🎉 성공';
      case 'ended':
        return '⏰ 마감';
      default:
        return status;
    }
  }

  Color _getFundingStatusColor(String status) {
    switch (status) {
      case 'inProgress':
        return AppColors.gold;
      case 'success':
        return AppColors.success;
      case 'ended':
        return AppColors.textTertiary;
      default:
        return AppColors.textSecondary;
    }
  }

  void _resetFilter() {
    setState(() {
      _filter = const TreasureFilter();
      _priceRange = const RangeValues(_minPrice, _maxPrice);
    });
  }

  void _applyFilter() {
    widget.onApply(_filter);
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../bloc/treasure/treasure_bloc.dart';
import '../../bloc/treasure/treasure_event.dart';
import '../../bloc/treasure/treasure_state.dart';
import '../../widgets/treasure_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/skeleton_loader.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/filter/filter_bar.dart';
import '../../widgets/filter/filter_bottom_sheet.dart';
import '../../widgets/filter/sort_bottom_sheet.dart';

/// 홈 화면 (항해 본부)
/// 오늘 발견된 유물, 떠오르는 보물, 선장들의 선택, 마감 임박 항해 섹션
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // 초기 데이터 로드
    context.read<TreasureBloc>().add(const TreasureLoadRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TreasureBloc>().add(const TreasureLoadMoreRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onRefresh() async {
    context.read<TreasureBloc>().add(const TreasureRefreshRequested());
    // RefreshIndicator가 완료될 때까지 대기
    await Future.delayed(const Duration(milliseconds: 800));
  }

  void _showFilterBottomSheet(TreasureState state) {
    FilterBottomSheet.show(
      context,
      currentFilter: state.filter,
      onApply: (filter) {
        context.read<TreasureBloc>().add(TreasureFilterChanged(filter));
      },
    );
  }

  void _showSortBottomSheet(TreasureState state) {
    SortBottomSheet.show(
      context,
      currentSort: state.sortType,
      onSelect: (sortType) {
        context.read<TreasureBloc>().add(TreasureSortChanged(sortType));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: BlocBuilder<TreasureBloc, TreasureState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.gold,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // AppBar
                  _buildAppBar(),
                  // 검색 바
                  _buildSearchBar(),
                  // 필터/정렬 바
                  SliverToBoxAdapter(
                    child: FilterBar(
                      filter: state.filter,
                      sortType: state.sortType,
                      viewMode: state.viewMode,
                      onFilterTap: () => _showFilterBottomSheet(state),
                      onSortTap: () => _showSortBottomSheet(state),
                      onViewModeChanged: (viewMode) {
                        context.read<TreasureBloc>().add(
                              TreasureViewModeChanged(viewMode),
                            );
                      },
                      onFilterReset: state.hasActiveFilter
                          ? () {
                              context.read<TreasureBloc>().add(
                                    const TreasureFilterReset(),
                                  );
                            }
                          : null,
                    ),
                  ),
                  // 콘텐츠 영역
                  ..._buildContent(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.parchment,
      elevation: 0,
      title: Row(
        children: [
          const Icon(
            Icons.explore,
            color: AppColors.gold,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            AppStrings.appName,
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // TODO: 알림 화면 이동
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.coral,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: GestureDetector(
          onTap: () {
            // TODO: 검색 화면 이동
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.parchmentDark),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 12),
                Text(
                  AppStrings.searchHint,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(TreasureState state) {
    // 초기 로딩 상태
    if (state.isInitialLoading) {
      return [
        const SliverToBoxAdapter(
          child: HomePageSkeleton(),
        ),
      ];
    }

    // 에러 상태
    if (state.status == TreasureStatus.error && state.treasures.isEmpty) {
      return [
        SliverFillRemaining(
          child: ErrorState(
            message: state.errorMessage,
            onRetry: () {
              context.read<TreasureBloc>().add(const TreasureLoadRequested());
            },
          ),
        ),
      ];
    }

    // 빈 결과 (필터 적용 시)
    if (state.isEmpty && state.hasActiveFilter) {
      return [
        SliverFillRemaining(
          child: EmptyState(
            emoji: '🔍',
            title: AppStrings.emptyFilterResult,
            description: AppStrings.emptyFilterResultDesc,
            buttonText: AppStrings.reset,
            onButtonTap: () {
              context.read<TreasureBloc>().add(const TreasureFilterReset());
            },
          ),
        ),
      ];
    }

    // 빈 결과 (일반)
    if (state.isEmpty) {
      return [
        SliverFillRemaining(
          child: EmptyState(
            emoji: '🏝️',
            title: AppStrings.emptyTreasureList,
            description: AppStrings.emptyTreasureListDesc,
            buttonText: AppStrings.retry,
            onButtonTap: () {
              context.read<TreasureBloc>().add(const TreasureRefreshRequested());
            },
          ),
        ),
      ];
    }

    // 뷰 모드에 따른 콘텐츠 표시
    if (state.viewMode == ViewMode.grid) {
      return _buildGridView(state);
    } else {
      return _buildListView(state);
    }
  }

  /// 그리드 뷰 빌드
  List<Widget> _buildGridView(TreasureState state) {
    return [
      SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.55,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= state.treasures.length) {
                return null;
              }
              return TreasureCardMedium(
                treasure: state.treasures[index],
                onTap: () {
                  // TODO: 상세 페이지 이동
                },
                onWishlistTap: () {
                  // TODO: 찜하기 토글
                },
                onCartTap: () {
                  // TODO: 장바구니 추가
                },
              );
            },
            childCount: state.treasures.length,
          ),
        ),
      ),
      // 로딩 인디케이터
      if (state.isLoadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
          ),
        ),
      // 끝 표시
      if (state.hasReachedMax && state.treasures.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                '모든 보물을 확인했습니다 ⚓',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ),
      // 하단 여백
      const SliverToBoxAdapter(
        child: SizedBox(height: 80),
      ),
    ];
  }

  /// 리스트 뷰 빌드
  List<Widget> _buildListView(TreasureState state) {
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= state.treasures.length) {
                return null;
              }
              return TreasureCardHorizontal(
                treasure: state.treasures[index],
                onTap: () {
                  // TODO: 상세 페이지 이동
                },
              );
            },
            childCount: state.treasures.length,
          ),
        ),
      ),
      // 로딩 인디케이터
      if (state.isLoadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
          ),
        ),
      // 끝 표시
      if (state.hasReachedMax && state.treasures.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                '모든 보물을 확인했습니다 ⚓',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ),
      // 하단 여백
      const SliverToBoxAdapter(
        child: SizedBox(height: 80),
      ),
    ];
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../widgets/treasure_card.dart';
import '../../widgets/common/section_header.dart';

/// 홈 화면 (항해 본부)
/// 오늘 발견된 유물, 떠오르는 보물, 선장들의 선택, 마감 임박 항해 섹션
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 샘플 데이터
  final List<TreasureData> _sampleTreasures = [
    TreasureData(
      id: '1',
      title: 'Revolutionary Smart Watch with AI Assistant',
      imageUrl: 'https://picsum.photos/seed/treasure1/400/300',
      portName: 'Kickstarter',
      portLogoUrl: '',
      country: '🇺🇸',
      category: 'Tech',
      price: 149,
      currency: '\$',
      fundingPercentage: 285,
      daysLeft: 15,
      backerCount: 2847,
      rating: 4.8,
    ),
    TreasureData(
      id: '2',
      title: 'Portable Solar-Powered Projector',
      imageUrl: 'https://picsum.photos/seed/treasure2/400/300',
      portName: 'Indiegogo',
      portLogoUrl: '',
      country: '🇺🇸',
      category: 'Tech',
      price: 299,
      currency: '\$',
      fundingPercentage: 520,
      daysLeft: 8,
      backerCount: 1523,
    ),
    TreasureData(
      id: '3',
      title: '最先端ワイヤレスイヤホン',
      imageUrl: 'https://picsum.photos/seed/treasure3/400/300',
      portName: 'Makuake',
      portLogoUrl: '',
      country: '🇯🇵',
      category: 'Audio',
      price: 29800,
      currency: '¥',
      fundingPercentage: 1850,
      daysLeft: 22,
      backerCount: 892,
    ),
    TreasureData(
      id: '4',
      title: 'Eco-Friendly Smart Backpack',
      imageUrl: 'https://picsum.photos/seed/treasure4/400/300',
      portName: 'Kickstarter',
      portLogoUrl: '',
      country: '🇩🇪',
      category: 'Lifestyle',
      price: 89,
      currency: '\$',
      fundingPercentage: 156,
      daysLeft: 3,
      backerCount: 567,
      isWishlisted: true,
    ),
    TreasureData(
      id: '5',
      title: '스마트 공기청정기 2세대',
      imageUrl: 'https://picsum.photos/seed/treasure5/400/300',
      portName: 'Wadiz',
      portLogoUrl: '',
      country: '🇰🇷',
      category: 'Home',
      price: 159000,
      currency: '₩',
      fundingPercentage: 890,
      daysLeft: 5,
      backerCount: 1234,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: 데이터 새로고침
            await Future.delayed(const Duration(seconds: 1));
          },
          color: AppColors.gold,
          child: CustomScrollView(
            slivers: [
              // AppBar
              SliverAppBar(
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
              ),
              // 검색 바
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
              ),
              // 오늘 발견된 유물
              SliverToBoxAdapter(
                child: SectionHeader(
                  emoji: '🆕',
                  title: AppStrings.todayDiscoveries,
                  onSeeMoreTap: () {
                    // TODO: 더보기 페이지 이동
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _sampleTreasures.length,
                    itemBuilder: (context, index) {
                      return TreasureCardSmall(
                        treasure: _sampleTreasures[index],
                        onTap: () {
                          // TODO: 상세 페이지 이동
                        },
                        onWishlistTap: () {
                          // TODO: 찜하기 토글
                        },
                      );
                    },
                  ),
                ),
              ),
              // 떠오르는 보물
              SliverToBoxAdapter(
                child: SectionHeader(
                  emoji: '🔥',
                  title: AppStrings.risingTreasures,
                  onSeeMoreTap: () {},
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _sampleTreasures.length,
                    itemBuilder: (context, index) {
                      return TreasureCardSmall(
                        treasure: _sampleTreasures[
                            (_sampleTreasures.length - 1 - index) %
                                _sampleTreasures.length],
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ),
              // 선장들의 선택
              SliverToBoxAdapter(
                child: SectionHeader(
                  emoji: '⭐',
                  title: AppStrings.captainsChoice,
                  onSeeMoreTap: () {},
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.55,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= 4) return null;
                      return TreasureCardMedium(
                        treasure: _sampleTreasures[index % _sampleTreasures.length],
                        onTap: () {},
                        onWishlistTap: () {},
                        onCartTap: () {},
                      );
                    },
                    childCount: 4,
                  ),
                ),
              ),
              // 마감 임박 항해
              SliverToBoxAdapter(
                child: SectionHeader(
                  emoji: '⏰',
                  title: AppStrings.endingSoon,
                  onSeeMoreTap: () {},
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= 3) return null;
                      return TreasureCardHorizontal(
                        treasure: _sampleTreasures
                            .where((t) => t.daysLeft <= 10)
                            .toList()[index % 2],
                        onTap: () {},
                      );
                    },
                    childCount: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


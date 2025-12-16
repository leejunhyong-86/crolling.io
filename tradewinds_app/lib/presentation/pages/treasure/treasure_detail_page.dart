import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../widgets/common/gold_button.dart';

/// 보물 상세 화면 (보물 감정서)
class TreasureDetailPage extends StatefulWidget {
  final String treasureId;

  const TreasureDetailPage({
    super.key,
    required this.treasureId,
  });

  @override
  State<TreasureDetailPage> createState() => _TreasureDetailPageState();
}

class _TreasureDetailPageState extends State<TreasureDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentImageIndex = 0;
  int _selectedRewardIndex = 0;
  bool _isWishlisted = false;

  // 샘플 데이터
  final _treasure = TreasureDetailData(
    id: '1',
    title: 'Revolutionary Smart Watch with AI Assistant',
    description: '혁신적인 AI 기술이 탑재된 스마트워치입니다. 건강 모니터링, 음성 비서, GPS 등 다양한 기능을 제공합니다.',
    images: [
      'https://picsum.photos/seed/detail1/800/600',
      'https://picsum.photos/seed/detail2/800/600',
      'https://picsum.photos/seed/detail3/800/600',
    ],
    portName: 'Kickstarter',
    country: '🇺🇸 미국',
    currentAmount: 284750,
    goalAmount: 100000,
    fundingPercentage: 285,
    daysLeft: 15,
    backerCount: 2847,
    avgPledge: 100,
    currency: '\$',
    rewards: [
      RewardData(
        id: '1',
        name: 'Early Bird Special',
        price: 149,
        description: '스마트워치 본품 1개, 전용 무선 충전기, 사용 설명서',
        deliveryDate: '2024년 6월',
        backerCount: 1234,
        isPopular: true,
      ),
      RewardData(
        id: '2',
        name: 'Standard Pack',
        price: 199,
        description: '스마트워치 본품 1개, 전용 무선 충전기, 추가 스트랩 2개, 사용 설명서',
        deliveryDate: '2024년 6월',
        backerCount: 892,
        isPopular: false,
      ),
      RewardData(
        id: '3',
        name: 'Premium Bundle',
        price: 299,
        description: '스마트워치 본품 2개, 전용 무선 충전기 2개, 추가 스트랩 4개, 프리미엄 케이스',
        deliveryDate: '2024년 6월',
        backerCount: 456,
        isPopular: false,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        slivers: [
          // 앱바
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.parchment,
            title: Text(AppStrings.treasureDetail),
            actions: [
              IconButton(
                icon: Icon(
                  _isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: _isWishlisted ? AppColors.coral : null,
                ),
                onPressed: () {
                  setState(() => _isWishlisted = !_isWishlisted);
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: 공유 기능
                },
              ),
            ],
          ),
          // 이미지 캐러셀
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.75,
                  child: PageView.builder(
                    itemCount: _treasure.images.length,
                    onPageChanged: (index) {
                      setState(() => _currentImageIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: _treasure.images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.parchmentDark,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.parchmentDark,
                          child: const Icon(Icons.broken_image, size: 48),
                        ),
                      );
                    },
                  ),
                ),
                // 인디케이터
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _treasure.images.length,
                      (index) => Container(
                        width: _currentImageIndex == index ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _currentImageIndex == index
                              ? AppColors.gold
                              : AppColors.parchmentDark,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 기본 정보
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 항구 정보
                  Row(
                    children: [
                      const Text('🏴', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        _treasure.portName,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _treasure.country,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 제목
                  Text(
                    _treasure.title,
                    style: AppTypography.headingLarge,
                  ),
                ],
              ),
            ),
          ),
          // 펀딩 정보 카드
          SliverToBoxAdapter(
            child: _buildFundingCard(),
          ),
          // 리워드 섹션
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💎', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.rewardOptions,
                        style: AppTypography.headingMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._treasure.rewards.asMap().entries.map((entry) {
                    return _RewardCard(
                      reward: entry.value,
                      isSelected: _selectedRewardIndex == entry.key,
                      onSelect: () {
                        setState(() => _selectedRewardIndex = entry.key);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          // 탭 영역
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Divider(),
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textTertiary,
                  indicatorColor: AppColors.gold,
                  tabs: const [
                    Tab(text: '상세정보'),
                    Tab(text: '제작자'),
                    Tab(text: '후기'),
                    Tab(text: 'FAQ'),
                  ],
                ),
              ],
            ),
          ),
          // 탭 콘텐츠
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _DescriptionTab(description: _treasure.description),
                  const _CreatorTab(),
                  const _ReviewsTab(),
                  const _FAQTab(),
                ],
              ),
            ),
          ),
          // 하단 여백
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      // 하단 고정 버튼
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
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
                  text: AppStrings.addToWishlist,
                  icon: Icons.map,
                  onPressed: () {
                    setState(() => _isWishlisted = !_isWishlisted);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GoldButton(
                  text: AppStrings.addToCart,
                  icon: Icons.inventory_2,
                  onPressed: () {
                    // TODO: 장바구니 추가
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('선적 화물에 추가되었습니다 ⚓'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFundingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('현재 금액', style: AppTypography.caption),
                  Text(
                    '${_treasure.currency}${_formatNumber(_treasure.currentAmount)}',
                    style: AppTypography.priceLarge,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('목표 금액', style: AppTypography.caption),
                  Text(
                    '${_treasure.currency}${_formatNumber(_treasure.goalAmount)}',
                    style: AppTypography.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (_treasure.fundingPercentage / 100).clamp(0, 1),
              minHeight: 12,
              backgroundColor: AppColors.parchmentDark,
              valueColor: AlwaysStoppedAnimation<Color>(
                _treasure.fundingPercentage >= 100
                    ? AppColors.success
                    : AppColors.gold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_treasure.fundingPercentage}%',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.gold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                icon: '⏰',
                value: 'D-${_treasure.daysLeft}',
                label: '남은일수',
              ),
              _StatItem(
                icon: '👥',
                value: _formatNumber(_treasure.backerCount),
                label: '후원자',
              ),
              _StatItem(
                icon: '💵',
                value: '${_treasure.currency}${_treasure.avgPledge}',
                label: '평균후원',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.labelLarge),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final RewardData reward;
  final bool isSelected;
  final VoidCallback onSelect;

  const _RewardCard({
    required this.reward,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.parchmentDark,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('🏅', style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reward.name,
                    style: AppTypography.headingSmall,
                  ),
                ),
                if (reward.isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '⭐ 인기',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.coral,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '\$${reward.price}',
              style: AppTypography.priceMedium,
            ),
            Text(
              '(~₩${(reward.price * 1330).toStringAsFixed(0)})',
              style: AppTypography.caption,
            ),
            const SizedBox(height: 12),
            Text(
              '포함 항목:',
              style: AppTypography.labelSmall,
            ),
            const SizedBox(height: 4),
            Text(
              reward.description,
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.local_shipping, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  '배송 예정: ${reward.deliveryDate}',
                  style: AppTypography.caption,
                ),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  '${reward.backerCount}명 선택',
                  style: AppTypography.caption,
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '✓ 선택됨',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
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

class _DescriptionTab extends StatelessWidget {
  final String description;

  const _DescriptionTab({required this.description});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        description,
        style: AppTypography.bodyMedium,
      ),
    );
  }
}

class _CreatorTab extends StatelessWidget {
  const _CreatorTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('제작자 정보'));
  }
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('후기'));
  }
}

class _FAQTab extends StatelessWidget {
  const _FAQTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('FAQ'));
  }
}

// 데이터 모델
class TreasureDetailData {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String portName;
  final String country;
  final int currentAmount;
  final int goalAmount;
  final int fundingPercentage;
  final int daysLeft;
  final int backerCount;
  final int avgPledge;
  final String currency;
  final List<RewardData> rewards;

  TreasureDetailData({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.portName,
    required this.country,
    required this.currentAmount,
    required this.goalAmount,
    required this.fundingPercentage,
    required this.daysLeft,
    required this.backerCount,
    required this.avgPledge,
    required this.currency,
    required this.rewards,
  });
}

class RewardData {
  final String id;
  final String name;
  final double price;
  final String description;
  final String deliveryDate;
  final int backerCount;
  final bool isPopular;

  RewardData({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.deliveryDate,
    required this.backerCount,
    required this.isPopular,
  });
}


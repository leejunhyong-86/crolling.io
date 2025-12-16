import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';

/// 프로필 화면 (선장실)
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 샘플 사용자 데이터
  final _user = UserData(
    nickname: '홍길동',
    username: 'captain_hong',
    avatarEmoji: '🧔',
    level: 3,
    rankTitle: '숙련 항해사',
    currentXp: 765,
    nextLevelXp: 1000,
    discoveredCount: 127,
    orderCount: 45,
    reviewCount: 32,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        title: Text(AppStrings.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 설정 화면 이동
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 카드
            _buildProfileCard(),
            const SizedBox(height: 16),
            // 선장 등급 카드
            _buildRankCard(),
            const SizedBox(height: 24),
            // 메뉴 리스트
            _buildMenuSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 아바타
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 3),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    _user.avatarEmoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_user.nickname} ${AppStrings.captain}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('⚓', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '${_user.rankTitle} (Lv.${_user.level})',
                          style: TextStyle(color: AppColors.goldLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${_user.username}',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // 편집 버튼
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white70),
                onPressed: () {
                  // TODO: 프로필 편집 화면 이동
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          // 통계
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                emoji: '🗺️',
                value: '${_user.discoveredCount}',
                label: AppStrings.discovered,
              ),
              _StatItem(
                emoji: '📦',
                value: '${_user.orderCount}',
                label: AppStrings.shipped,
              ),
              _StatItem(
                emoji: '⭐',
                value: '${_user.reviewCount}',
                label: AppStrings.reviewed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankCard() {
    final progress = _user.currentXp / _user.nextLevelXp;
    final remainingXp = _user.nextLevelXp - _user.currentXp;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🏅', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(AppStrings.captainRank, style: AppTypography.headingSmall),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '현재: ${_user.rankTitle} (Lv.${_user.level})',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.parchmentDark,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_user.currentXp}/${_user.nextLevelXp} XP',
                style: AppTypography.caption,
              ),
              Text(
                '다음 등급까지 $remainingXp XP 필요',
                style: AppTypography.caption.copyWith(color: AppColors.gold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              _showRankBenefitsSheet(context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '등급 혜택 보기 >',
              style: TextStyle(color: AppColors.gold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text('📜', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text('메뉴', style: AppTypography.headingSmall),
            ],
          ),
        ),
        // 내 활동
        _MenuItem(
          icon: '🗺️',
          title: AppStrings.wishlistMenu,
          subtitle: '${_user.discoveredCount}개 보물',
          onTap: () {},
        ),
        _MenuItem(
          icon: '📜',
          title: AppStrings.orderHistoryMenu,
          subtitle: '${_user.orderCount}건',
          onTap: () {},
        ),
        _MenuItem(
          icon: '⭐',
          title: AppStrings.myReviewsMenu,
          subtitle: '${_user.reviewCount}개',
          onTap: () {},
        ),
        const Divider(height: 32),
        // 설정
        _MenuItem(
          icon: '🔔',
          title: AppStrings.notificationSettings,
          onTap: () {},
        ),
        _MenuItem(
          icon: '❓',
          title: AppStrings.customerSupport,
          onTap: () {},
        ),
        _MenuItem(
          icon: 'ℹ️',
          title: AppStrings.appInfo,
          subtitle: 'v1.0.0',
          onTap: () {},
        ),
        const Divider(height: 32),
        // 로그아웃
        _MenuItem(
          icon: '🚪',
          title: AppStrings.logout,
          isDestructive: true,
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  void _showRankBenefitsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.parchmentDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('🏅 선장 등급 혜택', style: AppTypography.headingMedium),
            const SizedBox(height: 16),
            _RankBenefitRow(
              rank: '신입 선원 (Lv.1)',
              benefit: '기본 기능',
            ),
            _RankBenefitRow(
              rank: '견습 항해사 (Lv.2)',
              benefit: '보물 지도 5개 저장',
            ),
            _RankBenefitRow(
              rank: '숙련 항해사 (Lv.3)',
              benefit: '보물 지도 20개, 얼리버드 알림',
              isCurrentRank: true,
            ),
            _RankBenefitRow(
              rank: '전문 항해사 (Lv.4)',
              benefit: '보물 지도 50개, 프리미엄 정보',
            ),
            _RankBenefitRow(
              rank: '마스터 항해사 (Lv.5)',
              benefit: '무제한, VIP 혜택',
            ),
            _RankBenefitRow(
              rank: '제독 (Lv.6)',
              benefit: '전용 뱃지, 커뮤니티 리더',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('🚪', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            const Text('로그아웃'),
          ],
        ),
        content: const Text('정말 로그아웃 하시겠습니까?\n\n로그아웃해도 보물 지도와 항해 일지는 저장됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 로그아웃 처리
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
            ),
            child: Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _StatItem({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 24)),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          color: isDestructive ? AppColors.coral : null,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: AppColors.textTertiary))
          : null,
      trailing: isDestructive
          ? null
          : Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}

class _RankBenefitRow extends StatelessWidget {
  final String rank;
  final String benefit;
  final bool isCurrentRank;

  const _RankBenefitRow({
    required this.rank,
    required this.benefit,
    this.isCurrentRank = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isCurrentRank ? AppColors.gold.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (isCurrentRank)
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rank,
                  style: AppTypography.labelMedium.copyWith(
                    color: isCurrentRank ? AppColors.gold : null,
                  ),
                ),
                Text(benefit, style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 데이터 모델
class UserData {
  final String nickname;
  final String username;
  final String avatarEmoji;
  final int level;
  final String rankTitle;
  final int currentXp;
  final int nextLevelXp;
  final int discoveredCount;
  final int orderCount;
  final int reviewCount;

  UserData({
    required this.nickname,
    required this.username,
    required this.avatarEmoji,
    required this.level,
    required this.rankTitle,
    required this.currentXp,
    required this.nextLevelXp,
    required this.discoveredCount,
    required this.orderCount,
    required this.reviewCount,
  });
}


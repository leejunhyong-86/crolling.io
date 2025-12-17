import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// 스켈레톤 로더 기본 위젯
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                AppColors.parchmentDark,
                AppColors.parchment,
                AppColors.parchmentDark,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 보물 카드 스켈레톤 - Small (가로 스크롤용)
class TreasureCardSkeletonSmall extends StatelessWidget {
  const TreasureCardSkeletonSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: SkeletonLoader(width: 160, height: 120, borderRadius: 0),
          ),
          // 정보 영역
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonLoader(width: 80, height: 12, borderRadius: 4),
                SizedBox(height: 8),
                SkeletonLoader(width: 140, height: 14, borderRadius: 4),
                SizedBox(height: 4),
                SkeletonLoader(width: 100, height: 14, borderRadius: 4),
                SizedBox(height: 8),
                SkeletonLoader(width: 60, height: 16, borderRadius: 4),
                SizedBox(height: 8),
                SkeletonLoader(width: 140, height: 6, borderRadius: 3),
                SizedBox(height: 6),
                SkeletonLoader(width: 100, height: 12, borderRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 보물 카드 스켈레톤 - Medium (그리드용)
class TreasureCardSkeletonMedium extends StatelessWidget {
  const TreasureCardSkeletonMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 영역
          const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: SkeletonLoader(
              width: double.infinity,
              height: 140,
              borderRadius: 0,
            ),
          ),
          // 정보 영역
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonLoader(width: 100, height: 12, borderRadius: 4),
                SizedBox(height: 10),
                SkeletonLoader(width: double.infinity, height: 14, borderRadius: 4),
                SizedBox(height: 4),
                SkeletonLoader(width: 120, height: 14, borderRadius: 4),
                SizedBox(height: 10),
                SkeletonLoader(width: 80, height: 18, borderRadius: 4),
                SizedBox(height: 4),
                SkeletonLoader(width: 100, height: 12, borderRadius: 4),
                SizedBox(height: 10),
                SkeletonLoader(width: double.infinity, height: 6, borderRadius: 3),
                SizedBox(height: 10),
                SkeletonLoader(width: 120, height: 12, borderRadius: 4),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 36,
                        borderRadius: 8,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 36,
                        borderRadius: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 보물 카드 스켈레톤 - Horizontal (리스트용)
class TreasureCardSkeletonHorizontal extends StatelessWidget {
  const TreasureCardSkeletonHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: SkeletonLoader(width: 80, height: 80, borderRadius: 8),
          ),
          const SizedBox(width: 12),
          // 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonLoader(width: double.infinity, height: 14, borderRadius: 4),
                SizedBox(height: 6),
                SkeletonLoader(width: 150, height: 12, borderRadius: 4),
                SizedBox(height: 8),
                SkeletonLoader(width: double.infinity, height: 4, borderRadius: 2),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const SkeletonLoader(width: 50, height: 50, borderRadius: 4),
        ],
      ),
    );
  }
}

/// 가로 스크롤 리스트 스켈레톤
class HorizontalListSkeleton extends StatelessWidget {
  final int itemCount;

  const HorizontalListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) => const TreasureCardSkeletonSmall(),
      ),
    );
  }
}

/// 그리드 스켈레톤
class GridSkeleton extends StatelessWidget {
  final int itemCount;

  const GridSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.55,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const TreasureCardSkeletonMedium(),
    );
  }
}

/// 세로 리스트 스켈레톤
class VerticalListSkeleton extends StatelessWidget {
  final int itemCount;

  const VerticalListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: itemCount,
      itemBuilder: (context, index) => const TreasureCardSkeletonHorizontal(),
    );
  }
}

/// 홈 화면 전체 스켈레톤
class HomePageSkeleton extends StatelessWidget {
  const HomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 헤더 스켈레톤
          _buildSectionHeaderSkeleton(),
          const HorizontalListSkeleton(),
          const SizedBox(height: 16),
          _buildSectionHeaderSkeleton(),
          const HorizontalListSkeleton(),
          const SizedBox(height: 16),
          _buildSectionHeaderSkeleton(),
          const GridSkeleton(),
          const SizedBox(height: 16),
          _buildSectionHeaderSkeleton(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: VerticalListSkeleton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeaderSkeleton() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SkeletonLoader(width: 24, height: 24, borderRadius: 4),
          SizedBox(width: 8),
          SkeletonLoader(width: 120, height: 20, borderRadius: 4),
          Spacer(),
          SkeletonLoader(width: 50, height: 16, borderRadius: 4),
        ],
      ),
    );
  }
}

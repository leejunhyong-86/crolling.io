import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../widgets/common/gold_button.dart';

/// 온보딩 화면
/// 앱 소개 튜토리얼 (3페이지)
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      emoji: '🌍',
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Description,
      backgroundColor: AppColors.primary,
    ),
    OnboardingData(
      emoji: '💎',
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Description,
      backgroundColor: AppColors.primaryLight,
    ),
    OnboardingData(
      emoji: '⚓',
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Description,
      backgroundColor: AppColors.gold,
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToProfileSetup();
    }
  }

  void _skip() {
    _navigateToProfileSetup();
  }

  void _navigateToProfileSetup() {
    // TODO: Navigator 또는 GoRouter로 프로필 설정 화면 이동
    // context.go('/profile-setup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: Column(
          children: [
            // 건너뛰기 버튼
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    AppStrings.skip,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
            // 페이지 뷰
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _OnboardingPageContent(data: _pages[index]);
                },
              ),
            ),
            // 페이지 인디케이터
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildIndicator(index),
                ),
              ),
            ),
            // 다음/시작 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: GoldButton(
                text: _currentPage == _pages.length - 1
                    ? AppStrings.start
                    : AppStrings.next,
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.gold : AppColors.parchmentDark,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingData {
  final String emoji;
  final String title;
  final String description;
  final Color backgroundColor;

  const OnboardingData({
    required this.emoji,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });
}

class _OnboardingPageContent extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPageContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 일러스트 영역 (이모지로 대체)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: data.backgroundColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                data.emoji,
                style: const TextStyle(fontSize: 80),
              ),
            ),
          ),
          const SizedBox(height: 48),
          // 제목
          Text(
            data.title,
            style: AppTypography.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 설명
          Text(
            data.description,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}



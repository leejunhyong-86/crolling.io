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

/// 프로필 설정 화면
class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nicknameController = TextEditingController();
  int _selectedAvatar = 0;
  
  final List<String> _avatars = ['🧔', '👨', '👩', '🧑', '👴', '🏴‍☠️', '⚓', '🚢', '🧭', '🦜'];

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _selectAvatar() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AvatarSelectorSheet(
        avatars: _avatars,
        selectedIndex: _selectedAvatar,
        onSelect: (index) {
          setState(() => _selectedAvatar = index);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _startVoyage() {
    if (_nicknameController.text.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임은 2자 이상 입력해주세요')),
      );
      return;
    }
    // TODO: 프로필 저장 후 홈 화면으로 이동
    // context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.profileSetupTitle,
                style: AppTypography.headingLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // 아바타 선택
              GestureDetector(
                onTap: _selectAvatar,
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          _avatars[_selectedAvatar],
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // 닉네임 입력
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: AppStrings.nicknameLabel,
                  hintText: AppStrings.nicknameHint,
                  helperText: AppStrings.nicknameValidation,
                ),
                maxLength: 12,
              ),
              const Spacer(),
              // 시작 버튼
              GoldButton(
                text: AppStrings.startVoyage,
                icon: Icons.sailing,
                onPressed: _startVoyage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarSelectorSheet extends StatelessWidget {
  final List<String> avatars;
  final int selectedIndex;
  final Function(int) onSelect;

  const _AvatarSelectorSheet({
    required this.avatars,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.parchmentDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.selectAvatar,
            style: AppTypography.headingMedium,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(avatars.length, (index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () => onSelect(index),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.gold.withOpacity(0.2)
                        : AppColors.parchmentDark.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: AppColors.gold, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      avatars[index],
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}


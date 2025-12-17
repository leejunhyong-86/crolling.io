import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/common/gold_button.dart';

/// 선장 프로필 설정 화면
/// 소셜 로그인 후 닉네임과 아바타를 설정하는 화면
class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedAvatarIndex = 0;

  // 선장 아바타 옵션들
  final List<_AvatarOption> _avatarOptions = [
    _AvatarOption(icon: Icons.face, label: '탐험가', color: AppColors.gold),
    _AvatarOption(icon: Icons.sailing, label: '항해사', color: AppColors.coral),
    _AvatarOption(icon: Icons.anchor, label: '선장', color: AppColors.primary),
    _AvatarOption(icon: Icons.star, label: '제독', color: AppColors.goldLight),
    _AvatarOption(icon: Icons.military_tech, label: '전설', color: AppColors.wood),
    _AvatarOption(icon: Icons.auto_awesome, label: '발견자', color: AppColors.primaryLight),
  ];

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final avatar = _avatarOptions[_selectedAvatarIndex];
      context.read<AuthBloc>().add(ProfileSetupCompleted(
        nickname: _nicknameController.text.trim(),
        avatarUrl: 'avatar_${avatar.label}', // 실제로는 Storage URL 사용
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go('/home');
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? '오류가 발생했습니다'),
              backgroundColor: AppColors.coral,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.parchment,
        appBar: AppBar(
          backgroundColor: AppColors.parchment,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // 로그아웃하고 로그인 화면으로
              context.read<AuthBloc>().add(const SignOutRequested());
              context.go('/login');
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤더
                  _buildHeader(),
                  
                  const SizedBox(height: 40),
                  
                  // 아바타 선택
                  _buildAvatarSection(),
                  
                  const SizedBox(height: 32),
                  
                  // 닉네임 입력
                  _buildNicknameSection(),
                  
                  const SizedBox(height: 48),
                  
                  // 완료 버튼
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return GoldButton(
                        text: '항해 시작하기',
                        onPressed: state.isLoading ? null : _onSubmit,
                        isLoading: state.isLoading,
                        icon: Icons.sailing,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 아이콘
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.person_add,
            size: 32,
            color: AppColors.gold,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          '선장님, 환영합니다!',
          style: AppTypography.headingLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          '항해를 시작하기 전,\n선장님의 프로필을 설정해 주세요.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.badge,
              color: AppColors.gold,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '선장 칭호',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 아바타 그리드
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: _avatarOptions.length,
          itemBuilder: (context, index) {
            final avatar = _avatarOptions[index];
            final isSelected = _selectedAvatarIndex == index;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAvatarIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? avatar.color.withOpacity(0.2) 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? avatar.color : AppColors.parchmentDark,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: avatar.color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      avatar.icon,
                      size: 32,
                      color: isSelected ? avatar.color : AppColors.textTertiary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      avatar.label,
                      style: AppTypography.labelSmall.copyWith(
                        color: isSelected 
                            ? avatar.color 
                            : AppColors.textTertiary,
                        fontWeight: isSelected 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNicknameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.edit,
              color: AppColors.gold,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '선장 이름',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _nicknameController,
          maxLength: 12,
          decoration: InputDecoration(
            hintText: '2-12자 사이의 닉네임을 입력하세요',
            counterText: '',
            prefixIcon: const Icon(Icons.person_outline),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _nicknameController,
              builder: (context, value, child) {
                if (value.text.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _nicknameController.clear(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '닉네임을 입력해 주세요';
            }
            if (value.trim().length < 2) {
              return '닉네임은 2자 이상이어야 합니다';
            }
            if (value.trim().length > 12) {
              return '닉네임은 12자 이하여야 합니다';
            }
            // 특수문자 체크
            final specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
            if (specialChars.hasMatch(value)) {
              return '특수문자는 사용할 수 없습니다';
            }
            return null;
          },
          onFieldSubmitted: (_) => _onSubmit(),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          '닉네임은 나중에 선장실에서 변경할 수 있습니다.',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _AvatarOption {
  final IconData icon;
  final String label;
  final Color color;

  _AvatarOption({
    required this.icon,
    required this.label,
    required this.color,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

/// 로그인 화면
/// 대항해시대 테마의 로그인 UI
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _compassController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    
    _compassController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _compassController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go('/home');
        } else if (state.status == AuthStatus.authenticatedNeedsProfile) {
          context.go('/profile-setup');
        } else if (state.status == AuthStatus.guest) {
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
        body: Stack(
          children: [
            // 배경
            _buildBackground(),
            
            // 메인 콘텐츠
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    
                    // 로고 및 타이틀
                    _buildHeader(),
                    
                    const Spacer(flex: 1),
                    
                    // 로그인 버튼들
                    _buildLoginButtons(),
                    
                    const SizedBox(height: 24),
                    
                    // 게스트 모드
                    _buildGuestOption(),
                    
                    const Spacer(flex: 2),
                    
                    // 하단 텍스트
                    _buildFooter(),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // 로딩 오버레이
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return _buildLoadingOverlay();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F2038), // 깊은 밤바다
            Color(0xFF1A365D), // 진한 바다색
            Color(0xFF2C5282), // 바다색
          ],
        ),
      ),
      child: Stack(
        children: [
          // 별들
          ...List.generate(30, (index) => _buildStar(index)),
          
          // 물결 효과
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 150),
                  painter: _WavePainter(
                    wavePhase: _waveController.value * 2 * math.pi,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStar(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 2 + 1;
    final opacity = random.nextDouble() * 0.5 + 0.3;
    
    return Positioned(
      left: random.nextDouble() * 400,
      top: random.nextDouble() * 300,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // 나침반 아이콘
        AnimatedBuilder(
          animation: _compassController,
          builder: (context, child) {
            return Transform.rotate(
              angle: math.sin(_compassController.value * 2 * math.pi) * 0.1,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.gold,
                      AppColors.goldLight,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.explore,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // 앱 이름
        Text(
          'TradeWinds',
          style: AppTypography.displayMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 슬로건
        Text(
          '미지의 보물을 찾아 떠나는\n당신의 항해',
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge.copyWith(
            color: Colors.white.withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButtons() {
    return Column(
      children: [
        // Google 로그인
        _SocialLoginButton(
          onPressed: () {
            context.read<AuthBloc>().add(const GoogleSignInRequested());
          },
          icon: _buildGoogleIcon(),
          label: 'Google로 시작하기',
          backgroundColor: Colors.white,
          textColor: Colors.black87,
        ),
        
        const SizedBox(height: 12),
        
        // Kakao 로그인
        _SocialLoginButton(
          onPressed: () {
            context.read<AuthBloc>().add(const KakaoSignInRequested());
          },
          icon: _buildKakaoIcon(),
          label: '카카오로 시작하기',
          backgroundColor: const Color(0xFFFEE500),
          textColor: Colors.black87,
        ),
      ],
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildKakaoIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFF3C1E1E),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Icon(
          Icons.chat_bubble,
          size: 14,
          color: Color(0xFFFEE500),
        ),
      ),
    );
  }

  Widget _buildGuestOption() {
    return TextButton(
      onPressed: () {
        context.read<AuthBloc>().add(const GuestModeRequested());
      },
      child: Text(
        '게스트로 둘러보기',
        style: AppTypography.labelLarge.copyWith(
          color: Colors.white.withOpacity(0.7),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          '로그인 시 서비스 이용약관 및 개인정보처리방침에\n동의하는 것으로 간주됩니다.',
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.5),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _compassController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _compassController.value * 2 * math.pi,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold,
                    ),
                    child: const Icon(
                      Icons.explore,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              '항해 준비 중...',
              style: AppTypography.bodyLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 소셜 로그인 버튼
class _SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _SocialLoginButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 물결 페인터
class _WavePainter extends CustomPainter {
  final double wavePhase;

  _WavePainter({required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height - 50 + 
          math.sin((x / size.width * 2 * math.pi) + wavePhase) * 20 +
          math.sin((x / size.width * 4 * math.pi) + wavePhase * 1.5) * 10;
      path.lineTo(x, y);
    }

    path
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // 두 번째 물결
    final paint2 = Paint()
      ..color = AppColors.primary.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path2 = Path()
      ..moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height - 30 + 
          math.sin((x / size.width * 2 * math.pi) + wavePhase + 1) * 15 +
          math.sin((x / size.width * 3 * math.pi) + wavePhase * 2) * 8;
      path2.lineTo(x, y);
    }

    path2
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase;
  }
}


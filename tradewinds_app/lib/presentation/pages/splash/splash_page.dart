import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';

/// 스플래시 화면
/// 앱 시작 시 나침반 애니메이션과 함께 로고 표시
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _compassController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // 나침반 회전 애니메이션
    _compassController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // 페이드인 애니메이션
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _fadeController.forward();

    // 3초 후 다음 화면으로 이동
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // 홈 화면으로 이동 (온보딩은 첫 실행 시에만)
        context.go('/');
      }
    });
  }

  @override
  void dispose() {
    _compassController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 나침반 로고
                AnimatedBuilder(
                  animation: _compassController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _compassController.value * 2 * math.pi,
                      child: child,
                    );
                  },
                  child: _buildCompassLogo(),
                ),
                const SizedBox(height: 32),
                // 앱 이름
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        AppStrings.appName,
                        style: AppTypography.displayLarge.copyWith(
                          color: AppColors.gold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppStrings.appSlogan,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.parchment.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                // 로딩 바
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: child,
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColors.primary.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompassLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 외곽 눈금
          ...List.generate(12, (index) {
            return Transform.rotate(
              angle: index * math.pi / 6,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 2,
                  height: index % 3 == 0 ? 14 : 8,
                  margin: const EdgeInsets.only(top: 6),
                  color: AppColors.gold.withOpacity(index % 3 == 0 ? 1 : 0.5),
                ),
              ),
            );
          }),
          // 방향 표시 (N, E, S, W)
          Positioned(
            top: 22,
            child: Text(
              'N',
              style: TextStyle(
                color: AppColors.coral,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 중앙 점
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold,
            ),
          ),
          // 나침반 바늘
          _buildNeedle(),
        ],
      ),
    );
  }

  Widget _buildNeedle() {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _CompassNeedlePainter(),
      ),
    );
  }
}

class _CompassNeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // 북쪽 바늘 (빨간색)
    final northPath = Path()
      ..moveTo(center.dx, center.dy - 35)
      ..lineTo(center.dx - 6, center.dy)
      ..lineTo(center.dx + 6, center.dy)
      ..close();
    
    canvas.drawPath(
      northPath,
      Paint()..color = AppColors.coral,
    );

    // 남쪽 바늘 (골드)
    final southPath = Path()
      ..moveTo(center.dx, center.dy + 35)
      ..lineTo(center.dx - 6, center.dy)
      ..lineTo(center.dx + 6, center.dy)
      ..close();
    
    canvas.drawPath(
      southPath,
      Paint()..color = AppColors.gold,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


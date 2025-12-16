import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

/// 나침반 로딩 인디케이터
/// 스플래시 화면 및 로딩 상태에서 사용
class CompassLoading extends StatefulWidget {
  final double size;
  final String? message;
  final Color? color;

  const CompassLoading({
    super.key,
    this.size = 80,
    this.message,
    this.color,
  });

  @override
  State<CompassLoading> createState() => _CompassLoadingState();
}

class _CompassLoadingState extends State<CompassLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.gold;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: child,
            );
          },
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
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
                        height: index % 3 == 0 ? 12 : 6,
                        margin: const EdgeInsets.only(top: 4),
                        color: color.withOpacity(index % 3 == 0 ? 1 : 0.5),
                      ),
                    ),
                  );
                }),
                // 중앙 점
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                // 나침반 바늘
                Transform.rotate(
                  angle: -math.pi / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 북쪽 바늘 (빨간색)
                      CustomPaint(
                        size: Size(12, widget.size * 0.35),
                        painter: _NeedlePainter(
                          color: AppColors.coral,
                        ),
                      ),
                      // 남쪽 바늘
                      Transform.rotate(
                        angle: math.pi,
                        child: CustomPaint(
                          size: Size(12, widget.size * 0.35),
                          painter: _NeedlePainter(
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _NeedlePainter extends CustomPainter {
  final Color color;

  _NeedlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height * 0.8)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 간단한 원형 나침반 로딩 (더 작은 크기용)
class CompassLoadingSmall extends StatefulWidget {
  final double size;
  final Color? color;

  const CompassLoadingSmall({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  State<CompassLoadingSmall> createState() => _CompassLoadingSmallState();
}

class _CompassLoadingSmallState extends State<CompassLoadingSmall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Icon(
            Icons.explore,
            size: widget.size,
            color: widget.color ?? AppColors.gold,
          ),
        );
      },
    );
  }
}


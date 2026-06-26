import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sellclip_ai_app/components/brand/sellclip_logo.dart';
import 'package:sellclip_ai_app/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinnerController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationTimer = Timer(const Duration(seconds: 5), openDashboard);
    });
  }

  void openDashboard() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020719),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: _SplashBackground()),
          Positioned.fill(
            child: _SplashContent(spinnerController: _spinnerController),
          ),
        ],
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent({required this.spinnerController});

  final AnimationController spinnerController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final shortestSide = math.min(width, height);
          final horizontalPadding = (width * 0.07).clamp(20.0, 32.0);
          final logoWidth = (width * 0.58).clamp(150.0, 300.0);
          final spinnerSize = (shortestSide * 0.16).clamp(48.0, 72.0);
          final statusTextSize = (width * 0.052).clamp(18.0, 28.0);
          final versionTextSize = (width * 0.038).clamp(14.0, 19.0);
          final logoCenterY = height * 0.36;
          final spinnerCenterY = height * 0.59;
          final statusTop = spinnerCenterY + spinnerSize * 0.72;
          final versionBottom = (height * 0.075).clamp(24.0, 64.0);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: (logoCenterY - logoWidth * 0.30).clamp(
                    28.0,
                    math.max(28.0, height - logoWidth * 0.62),
                  ),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SellClipLogo(width: logoWidth),
                  ),
                ),
                Positioned(
                  top: (spinnerCenterY - spinnerSize / 2).clamp(
                    0.0,
                    math.max(0.0, height - spinnerSize),
                  ),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: spinnerController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: spinnerController.value * math.pi * 2,
                          child: child,
                        );
                      },
                      child: _GradientSpinner(size: spinnerSize),
                    ),
                  ),
                ),
                Positioned(
                  top: statusTop.clamp(
                    spinnerSize,
                    math.max(spinnerSize, height - 132),
                  ),
                  left: 0,
                  right: 0,
                  child: Text(
                    'Checking login status...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: statusTextSize,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: versionBottom,
                  child: Text(
                    'Version 1.0.0',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.58),
                          fontSize: versionTextSize,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF09021C), Color(0xFF020719), Color(0xFF050018)],
        ),
      ),
      child: CustomPaint(
        painter: _SplashBackgroundPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _SplashBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF09021C), Color(0xFF020719), Color(0xFF050018)],
        ).createShader(Offset.zero & size),
    );

    _paintGlow(
      canvas,
      Offset(size.width * -0.04, size.height * 0.02),
      size.width * 0.44,
      const Color(0xFFD92EFF),
    );
    _paintGlow(
      canvas,
      Offset(size.width * 0.06, size.height * 0.96),
      size.width * 0.44,
      const Color(0xFF006DFF),
    );

    _paintArcSet(
      canvas,
      Offset(size.width * 0.02, size.height * -0.12),
      size.width * 0.42,
      const Color(0xFFC044FF),
      0.1,
    );
    _paintArcSet(
      canvas,
      Offset(size.width * 0.03, size.height * 1.01),
      size.width * 0.42,
      const Color(0xFF1682FF),
      0.18,
    );

    _paintDots(canvas, Offset(size.width * 0.02, size.height * 0.32), true);
  }

  void _paintGlow(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.38),
          color.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  void _paintArcSet(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double opacity,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color.withValues(alpha: opacity);

    for (var index = 0; index < 4; index++) {
      canvas.drawCircle(center, radius + (index * 34), paint);
    }
  }

  void _paintDots(Canvas canvas, Offset start, bool leftSide) {
    final paint = Paint()
      ..color = const Color(0xFFB33DFF).withValues(alpha: 0.42);
    const gap = 18.0;
    for (var row = 0; row < 12; row++) {
      for (var col = 0; col < 7; col++) {
        final dx = start.dx + (leftSide ? col : -col) * gap;
        final dy = start.dy + row * gap;
        canvas.drawCircle(Offset(dx, dy), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GradientSpinner extends StatelessWidget {
  const _GradientSpinner({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _GradientSpinnerPainter(),
    );
  }
}

class _GradientSpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = size.width * 0.08;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..shader = const SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [Color(0xFF1A7BFF), Color(0xFFCF39FF), Color(0xFF1A7BFF)],
      ).createShader(rect);

    canvas.drawArc(
      rect.deflate(strokeWidth),
      math.pi * 0.12,
      math.pi * 1.55,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

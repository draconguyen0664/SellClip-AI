import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomeBackground extends StatefulWidget {
  const HomeBackground({super.key});

  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF01020B), Color(0xFF020617), Color(0xFF01020B)],
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _HomeBackgroundPainter(progress: _controller.value),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _HomeBackgroundPainter extends CustomPainter {
  const _HomeBackgroundPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final wave = math.sin(progress * math.pi * 2);
    final wave2 = math.sin((progress + 0.35) * math.pi * 2);
    final wave3 = math.sin((progress + 0.7) * math.pi * 2);

    _glow(
      canvas,
      Offset(size.width * (0.12 + wave * 0.035), size.height * (0.40 + wave2 * 0.025)),
      size.width * (0.42 + wave.abs() * 0.06),
      const Color(0xFF1F41FF),
      0.18 + wave.abs() * 0.08,
    );
    _glow(
      canvas,
      Offset(size.width * (1.02 - wave2 * 0.035), size.height * (0.18 + wave * 0.02)),
      size.width * (0.48 + wave2.abs() * 0.07),
      const Color(0xFF7B2DFF),
      0.14 + wave2.abs() * 0.08,
    );
    _glow(
      canvas,
      Offset(size.width * (0.82 + wave3 * 0.025), size.height * (0.70 - wave * 0.025)),
      size.width * (0.40 + wave3.abs() * 0.06),
      const Color(0xFF008CFF),
      0.09 + wave3.abs() * 0.07,
    );

    _sparkle(canvas, size, progress);
  }

  void _glow(Canvas canvas, Offset center, double radius, Color color, double opacity) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color.withValues(alpha: opacity), Colors.transparent],
      ).createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  void _sparkle(Canvas canvas, Size size, double value) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 7; i++) {
      final phase = (value + i * 0.17) % 1;
      final opacity = math.sin(phase * math.pi).clamp(0.0, 1.0) * 0.35;
      final x = size.width * (0.12 + (i * 0.13) % 0.78);
      final y = size.height * (0.18 + (i * 0.19) % 0.58);
      paint.color = (i.isEven ? const Color(0xFF12B8FF) : const Color(0xFFB735FF)).withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), 1.4 + opacity * 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HomeBackgroundPainter oldDelegate) => oldDelegate.progress != progress;
}
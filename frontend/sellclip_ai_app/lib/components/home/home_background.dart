import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

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
      child: CustomPaint(
        painter: _HomeBackgroundPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _HomeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _glow(canvas, Offset(size.width * 0.14, size.height * 0.40),
        size.width * 0.42, const Color(0xFF1F41FF), 0.22);
    _glow(canvas, Offset(size.width * 1.02, size.height * 0.18),
        size.width * 0.48, const Color(0xFF7B2DFF), 0.18);
    _glow(canvas, Offset(size.width * 0.82, size.height * 0.70),
        size.width * 0.42, const Color(0xFF008CFF), 0.11);
  }

  void _glow(Canvas canvas, Offset center, double radius, Color color,
      double opacity) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color.withValues(alpha: opacity), Colors.transparent],
      ).createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

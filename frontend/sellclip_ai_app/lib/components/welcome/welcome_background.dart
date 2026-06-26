import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF01020B), Color(0xFF020514), Color(0xFF02030C)],
        ),
      ),
      child: CustomPaint(
        painter: _WelcomeBackgroundPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _WelcomeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _paintSideGlow(
      canvas,
      Rect.fromLTWH(-size.width * 0.20, size.height * 0.31, 90, size.height),
      const Color(0xFF8637FF),
    );
    _paintLargeMark(canvas, size);
    _paintDot(canvas, Offset(size.width * 0.21, size.height * 0.25));
    _paintDot(canvas, Offset(size.width * 0.83, size.height * 0.24));
  }

  void _paintSideGlow(Canvas canvas, Rect rect, Color color) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color.withValues(alpha: 0.7),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawOval(rect, paint);
  }

  void _paintLargeMark(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF1B2EFF).withValues(alpha: 0.15);
    final path = Path()
      ..moveTo(size.width * -0.10, size.height * 0.02)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.18,
        size.width * 0.12,
        size.height * 0.27,
      )
      ..lineTo(size.width * 0.04, size.height * 0.33);
    canvas.drawPath(path, paint);
  }

  void _paintDot(Canvas canvas, Offset center) {
    canvas.drawCircle(
      center,
      4,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF38A8FF), Color(0xFF214FFF)],
        ).createShader(Rect.fromCircle(center: center, radius: 6)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
